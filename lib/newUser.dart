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
      body: ListView(
        children: [
          Text("Registrate"),
          TextField(controller: correo,
            decoration: InputDecoration(
                labelText: "Correo de usuario:"
            ),),
          TextField(controller: pass,
            decoration: InputDecoration(
                labelText: "Contraseña:"
            ),),
          Row(
            children: [
              ElevatedButton(onPressed: () async{
                var JTemp = {
                  "correo": correo.text,
                  "password": pass.text
                };
                try{
                  DB.insertar(JTemp);
                   await AuthService.createUserWithEmailAndPassword(correo.text, pass.text).then((value) => {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se registro con exito")))
                  });
                  Navigator.pop(context);
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ocurrio un error: la contraseña debe de ser de 6 caracteres minimo")));
                  Navigator.pop(context);
                }
              }, child: Text("Registrarse")),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Volver"))
            ],
          )
        ],
      ),
    );
  }
}
