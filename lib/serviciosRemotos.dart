import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';

var _auth = FirebaseAuth.instance;

class AuthService {

  static Future<bool> changePassword(String pass) async {
    try {
      await _auth.currentUser?.updatePassword(pass);
      return true; // La operación fue exitosa
    } catch (e) {
      print("Error al cambiar la contraseña: $e");
      return false; // Ocurrió un error
    }
  }

  // Cambiar correo electrónico
  static Future<bool> verificarEmailNuevo(String email) async {
    try {
      await _auth.currentUser!.verifyBeforeUpdateEmail(email);
      return true; // La operación fue exitosa
    } catch (e) {
      print("Error al cambiar el correo electrónico: $e");
      return false; // Ocurrió un error
    }
  }


  // Crea usuario
  static  Future createUserWithEmailAndPassword(String email, String password) async {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Inicia sesión
  static Future signInWithEmailAndPassword(String email, String password) async {

    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Cierra sesión
  static Future<void> signOut() async {
    return _auth.signOut();
  }

  // Obtener UID del usuario actual
  static String? getCurrentUserUID() {
    User? currentUser = _auth.currentUser;
    return currentUser?.uid;
  }

  // Obtener email del usuario actual
  static String? getCurrentUserEmail() {
    User? currentUser = _auth.currentUser;
    return currentUser?.email;
  }

}


var baseRemota = FirebaseFirestore.instance;
var fireStorage = FirebaseStorage.instance;
class DB {
  static Future<List> mostrarEventos(String UID)async{
    List temp = [];
    var query = await baseRemota.collection("events").where("idUser",isEqualTo: UID).get();
    query.docs.forEach((element) {
      Map<String,dynamic> dato = element.data();
      dato.addAll({
        'id':element.id
      });
      temp.add(dato);
    });
    return temp;
  }
  //Buscar evento por ID de documento
  static Future<List> getEventoById(String ID) async{
    List temp = [];
    var documento = await baseRemota.collection("events").doc(ID).get();
    Map<String, dynamic>? dato = documento.data();
    dato?.addAll(({'id':documento.id}));
    temp.add(dato);
    return temp;
  }
  // Buscar invitación por ID
  static Future<List> getInvitacionById(String ID) async{
    List temp = [];
    var documento = await baseRemota.collection("invitations").doc(ID).get();
    Map<String, dynamic>? dato = documento.data();
    dato?.addAll(({'id':documento.id}));
    temp.add(dato);
    return temp;
  }
  static Future<List> getInvitacionsById(String ID) async{
    List temp = [];
    var query = await baseRemota.collection("invitations").where("idEvent",isEqualTo: ID).get();
    query.docs.forEach((element) {
      Map<String,dynamic> dato = element.data();
      dato.addAll({
        'id':element.id
      });
      temp.add(dato);
    });
    return temp;
  }
  //Mostrar invitaciones por UID de usuario
  static Future<List> mostrarInvitaciones(String idUser)async{
    List temp = [];
    var query = await baseRemota.collection("invitations").where('idUser',isEqualTo: idUser).get();

    query.docs.forEach((element) {
      Map<String,dynamic> dato = element.data();
      dato.addAll({
        'id':element.id
      });
      temp.add(dato);
    });
    return temp;
  }

  //Mostrar invitaciones por UID de usuario
  static Future<List> mostrarInvitacionesPro(String idUser)async{
    List temp = [];
    var query = await baseRemota.collection("invitationsPro").where('idUser',isEqualTo: idUser).get();
    query.docs.forEach((element) {
      Map<String,dynamic> dato = element.data();
      dato.addAll({
        'id':element.id
      });
      temp.add(dato);
    });
    return temp;
  }

  static Future insertarEvento(Map<String, dynamic> evento) async{
     var documentReference = await baseRemota.collection("events").add(evento);
     return documentReference.id;
  }

  static Future insertar(Map<String, dynamic> user) async {
    return baseRemota.collection("users").add(user);
  }
  static Future updateEvento(Map<String, dynamic> event) async {
    //Se recupera desde la consulta
    String id = event['id'];
    event.remove('id');
    return await baseRemota.collection("events").doc(id).update(event);
  }
  static Future updateInvitacion(Map<String, dynamic> invitacion) async {
    //Se recupera desde la consulta
    String id = invitacion['id'];
    invitacion.remove('id');
    return await baseRemota.collection("invitations").doc(id).update(invitacion);
  }

  // Ejemplo de cómo podrías utilizar las funciones para obtener UID y email
  static String? obtenerUsuarioUID() {
    return AuthService.getCurrentUserUID();
  }

  static String? obtenerUsuarioEmail(){
    return AuthService.getCurrentUserEmail();
  }
  // Agregar evento a invitaciones
  static Future agregarEventoInvitacion(Map<String,dynamic> event) async{
    return baseRemota.collection("invitations").add(event);
  }
  // Agregar evento a invitaciones
  static Future agregarEventoPropietario(Map<String,dynamic> event) async{
    return baseRemota.collection("invitationsPro").add(event);
  }
  // Verificar que al agregar no se repita el evento en invitaciones
  static Future verificarRepeticionInvitacion(String IDevento, String IDUser) async{
    var query = await baseRemota.collection("invitations").where('idUser',isEqualTo: IDUser).where("idEvento", isEqualTo: IDevento).get();
    if(query.size>0)return true;
    return false;
  }
  // Verificar que no agregues tu propio evento
  static Future verificarAgregarEventoPropio(String IDevento, String IDUser) async{
    var evento = await baseRemota.collection("events").where("idUser",isEqualTo: IDUser).get();
    String eventid = evento.docs.first.id;
    if (evento.size>0) {
      if (eventid == IDevento) {
        print(true);
        return true;
      }
    }
    return false;
  }
 //Eliminar
  static Future deleteImageFromStorage(String URL) async{
    final String url = URL.split("?")[0];
    final String path = url.split("/").last;
    final String fileName = path.split("%2F").last;
    final String carpeta = path.split("%2F")[1];
    final Reference refe = fireStorage.ref().child("eventos").child(carpeta).child(fileName);
    return await refe.delete();
  }
  static Future deleteImageFromDatabase(Map<String,dynamic> event,String URL) async {
    //Se recupera desde la consulta
    String id = event['id'];
    event.remove('id');
    if(event['imagenesURL'].length==1)
      return await baseRemota.collection("events").doc(id).update({'imagenesURL':FieldValue.delete()});
    else
      return await baseRemota.collection("events").doc(id).update({'imagenesURL':FieldValue.arrayRemove([URL])});
  }
  static Future<XFile> getImageXFileByUrl(String url) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    XFile result = await XFile(file.path);
    return result;
  }
  static String generateID() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        10, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  static String getIdImage(String URL){
    final String path = URL.split("?")[0];
    final String fileName = path.split("%2F").last;
    final String id = fileName.split(".")[0];
    return id;
  }
  static Future<String?> uploadImage(File image,String eventID,String userID) async {
    //final String nameFile = image.path.split("/").last;
    var id = generateID();
    final String imageType = image.path.split(".").last;
    final String uploadNameFile = "${id}.${imageType}";
    final Reference refe = fireStorage.ref().child("eventos").child("${eventID}").child(uploadNameFile);
    final UploadTask uploadTask = refe.putFile(image);
    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
    final String url = await snapshot.ref.getDownloadURL();
    return url;
  }
  //Recuperar imagen desde galería
  static Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 30);
    return image;
  }

  //Recuperar todos los eventos de un solo usuario
  static Future<List> getEventosByUser(String idUser) async{
    List temp = [];
    var query = await baseRemota.collection("events").where('idUser',isEqualTo: idUser).get();
    query.docs.forEach((element) {
      Map<String,dynamic> dato = element.data();
      dato.addAll({
        'id':element.id
      });
      temp.add(dato);
    });
    return temp;
  }

  //obtener Evento recien insertado
  static Future<Map<String, dynamic>?> getEventoInsertado(String idUser, String nombre, String descripcion, String? tipo, DateTime fechaInicio, DateTime fechaFin, bool addFAE, String? idInv) async {
    var query = await baseRemota.collection("events").where('idUser', isEqualTo: idUser).where('nombre', isEqualTo: nombre)
        .where('descripcion', isEqualTo: descripcion).where('tipo', isEqualTo: tipo).where('fechaInicio', isEqualTo: fechaInicio)
        .where('fechaFin', isEqualTo: fechaFin).where('addFAE', isEqualTo: addFAE).where('idInv', isEqualTo: idInv).get();

    if (query.docs.isNotEmpty) {
      var element = query.docs.first;
      Map<String, dynamic> dato = element.data();
      dato.addAll({
        'id': element.id
      });
      return dato;
    } else {
      return null; // No se encontró ningún evento con los parámetros proporcionados
    }
  }


}
