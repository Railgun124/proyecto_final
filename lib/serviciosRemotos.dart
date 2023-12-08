import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';

var _auth = FirebaseAuth.instance;

class AuthService {
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
  static Future<List> mostrarEventos()async{
    List temp = [];
    var query = await baseRemota.collection("events").get();

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

  static Future insertarEvento(Map<String, dynamic> evento){
    return baseRemota.collection("events").add(evento);
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

  static String? obtenerUsuarioEmail() {
    return AuthService.getCurrentUserEmail();
  }
  // Agregar evento a invitaciones
  static Future agregarEventoInvitacion(Map<String,dynamic> event) async{
    return baseRemota.collection("invitations").add(event);
  }
  // Verificar que al agregar no se repita el evento en invitaciones
  static Future verificarRepeticionInvitacion(String IDevento, String IDUser) async{
    var query = await baseRemota.collection("invitations").where('idUser',isEqualTo: IDUser).where("idEvento").get();
    if(query.size>0)return true;
    return false;
  }
 //Eliminar
  static Future deleteImageFromStorage(String URL) async{
    final String path = URL.split("?")[0];
    final String fileName = path.split("%2F").last;
    final Reference refe = fireStorage.ref().child("productos").child(fileName);
    return await refe.delete();
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
    final Reference refe = fireStorage.ref().child("eventos").child("${userID}").child(uploadNameFile);
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



}
