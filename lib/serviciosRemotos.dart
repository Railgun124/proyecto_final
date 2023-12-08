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
  static Future insertar(Map<String, dynamic> user) async {
    return baseRemota.collection("users").add(user);
  }

  // Ejemplo de cómo podrías utilizar las funciones para obtener UID y email
  static void obtenerInformacionUsuarioActual() {
    String? uid = AuthService.getCurrentUserUID();
    String? email = AuthService.getCurrentUserEmail();

    print("UID del usuario actual: $uid");
    print("Email del usuario actual: $email");
  }
}
