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
      body: ListView(
        children: [
          Text("Introduce el nuevo email"),
          TextField(controller: nuevoEmail,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () async{
                try{
                  bool actualizado = await AuthService.verificarEmailNuevo(nuevoEmail.text);
                  if (actualizado == true) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Se ha enviado un email a esta cuenta para verificar el cambio")));
                    Navigator.pop(context);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Email invalido")));
                  }
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("email invalido ${e}")));
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
