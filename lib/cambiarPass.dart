import 'package:flutter/material.dart';
import 'package:proyecto_final/serviciosRemotos.dart';

class cambiarPass extends StatefulWidget {
  const cambiarPass({super.key});

  @override
  State<cambiarPass> createState() => _cambiarPassState();
}

class _cambiarPassState extends State<cambiarPass> {
  final nuevoPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text("Introduce la nueva contraseña"),
            SizedBox(height: 10),
            TextField(
                obscureText: true,
                controller: nuevoPass,
                decoration: InputDecoration(
                    labelText: "Nueva contraseña",
                    prefixIcon: Icon(Icons.key),
                )
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      bool actualizado = await AuthService.changePassword(nuevoPass.text);
                      if (actualizado == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Contraseña actualizada, inicia sesión de nuevo")));
                        AuthService.signOut();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Contraseña inválida, debe contener al menos 6 caracteres")));
                      }
                    } catch(e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Contraseña inválida, debe contener al menos 6 caracteres ${e}")));
                    }
                  },
                  child: Text("Guardar"),
                ),
                SizedBox(width: 10),
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
