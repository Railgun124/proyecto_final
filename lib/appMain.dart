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
      body: ListView(
        children: [
          Text("titulo app"),
          Text("inicia sesion"),
          TextField(
            controller: correo,
            decoration: InputDecoration(
                labelText: "Correo"
            ),),
          TextField(
            controller: password,
            decoration: InputDecoration(
                labelText: "Contraseña"
            ),),
          Row(
            children: [
              ElevatedButton(onPressed: () async{
                try{
                  await AuthService.signInWithEmailAndPassword(correo.text, password.text).then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MenuUsuario()));
                  });
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No se encontro el usuario: ${e}")));
                }
              }, child: Text("Ingresar")),
              ElevatedButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => newUser()));
              }, child: Text("Registrarse"))
            ],
          ),
        ],
      ),
    );
  }
}
