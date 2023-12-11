import 'package:flutter/material.dart';
import 'menuUsuario.dart';
import 'newUser.dart';
import 'serviciosRemotos.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final correo = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Inicia sesión"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(height: 10),
            TextField(
              controller: correo,
              decoration: InputDecoration(
                labelText: "Correo",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: password,
              decoration: InputDecoration(
                labelText: "Contraseña",
                prefixIcon: Icon(Icons.key),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await AuthService.signInWithEmailAndPassword(correo.text, password.text).then((value) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuUsuario()));
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No se encontró el usuario: $e")));
                    }
                  },
                  child: Text("Ingresar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => newUser()));
                  },
                  child: Text("Registrarse"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
