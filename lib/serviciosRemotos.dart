import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  static Future<List> getEventoById(String ID) async{
    List temp = [];
    var documento = await baseRemota.collection("events").doc(ID).get();
    Map<String, dynamic>? dato = documento.data();
    temp.add(dato);
    return temp;
  }

  static Future insertarEvento(Map<String, dynamic> evento){
    return baseRemota.collection("events").add(evento);
  }

  static Future insertar(Map<String, dynamic> user) async {
    return baseRemota.collection("users").add(user);
  }

  // Ejemplo de cómo podrías utilizar las funciones para obtener UID y email
  static String? obtenerUsuarioUID() {
    return AuthService.getCurrentUserUID();
  }

  static String? obtenerUsuarioEmail() {
    return AuthService.getCurrentUserEmail();
  }
}
