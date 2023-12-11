import 'package:flutter/material.dart';
import 'package:proyecto_final/serviciosRemotos.dart';

class newUser extends StatefulWidget {
  const newUser({super.key});

  @override
  State<newUser> createState() => _newUserState();
}

class _newUserState extends State<newUser> {
  final usuario = TextEditingController();
  final correo = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Regístrate"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20), // Ajusta según sea necesario
        child: ListView(
          children: [
            SizedBox(height: 10),
            TextField(
              controller: correo,
              decoration: InputDecoration(
                labelText: "Correo de usuario",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: pass,
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
                    var JTemp = {
                      "correo": correo.text,
                      "password": pass.text
                    };
                    try {
                      DB.insertar(JTemp);
                      await AuthService.createUserWithEmailAndPassword(correo.text, pass.text).then((value) => {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se registró con éxito")))
                      });
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ocurrió un error: la contraseña debe tener al menos 6 caracteres")));
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Registrarse"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Volver"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
