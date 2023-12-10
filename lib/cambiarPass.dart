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
      body: ListView(
        children: [
          Text("Introduce la nueva contraseña"),
          TextField(controller: nuevoPass,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () async{
                try{
                  bool actualizado = await AuthService.changePassword(nuevoPass.text);
                  if (actualizado == true) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Password actualizado, inicia sesion de nuevo")));
                AuthService.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
                }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Password invalido, debe contener 6 caracteres minimo")));
                }
                } catch(e){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password invalido, debe contener 6 caracteres minimo ${e}")));
                }
              }, child: Text("Guardar")),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Volver")),
            ],
          )
        ],
      ),
    );
  }
}
