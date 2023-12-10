import 'package:flutter/material.dart';
import 'package:proyecto_final/serviciosRemotos.dart';

class cambiarEmail extends StatefulWidget {
  const cambiarEmail({super.key});

  @override
  State<cambiarEmail> createState() => _cambiarEmailState();
}

class _cambiarEmailState extends State<cambiarEmail> {
  final nuevoEmail = TextEditingController();

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
            Text("Introduce el Nuevo Email"),
            SizedBox(height: 10),
            TextField(
              controller: nuevoEmail,
              decoration: InputDecoration(
                labelText: "Nuevo Email",
                prefixIcon: Icon(Icons.email),
              )),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      bool actualizado = await AuthService.verificarEmailNuevo(nuevoEmail.text);
                      if (actualizado == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Se ha enviado un email a esta cuenta para verificar el cambio")));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Email inválido")));
                      }
                    } catch(e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email inválido: ${e}")));
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
