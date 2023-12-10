import 'package:flutter/material.dart';
import 'package:proyecto_final/serviciosRemotos.dart';
class addEvent extends StatefulWidget {
  const addEvent({super.key});

  @override
  State<addEvent> createState() => _addEventState();
}

class _addEventState extends State<addEvent> {
  final IDinvitacion = TextEditingController();
  String invitacionID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Evento"),
      ),
      body: Column(
        children: [
          TextField(
              controller: IDinvitacion,
              decoration: InputDecoration(labelText: "Código de evento")),
          ElevatedButton(onPressed: (){
            setState(() {
              invitacionID = IDinvitacion.text;
            });
            IDinvitacion.clear();
          }, child: Text("Buscar")),
          SizedBox(height: 20,),
          if(invitacionID!="")
            Expanded(
                child: FutureBuilder(
                  future: DB.getEventoById(invitacionID),
                  builder: (context, eventosJSON) {
                    if (eventosJSON.hasData) {
                      return ListView.builder(
                        itemCount: eventosJSON.data?.length,
                        itemBuilder: (context, indice) {
                          return Column(
                            children: [
                              ListTile(
                                title: Column(
                                  children: [
                                    Text("Código: ${eventosJSON.data?[indice]['id']}"),
                                    Text("Nombre: ${eventosJSON.data?[indice]['nombre']}"),
                                    Text("Tipo: ${eventosJSON.data?[indice]['tipo']}"),
                                    Text("Descripción: ${eventosJSON.data?[indice]['descripcion']}"),
                                  ],
                                ),

                              ),
                              ElevatedButton(onPressed: ()async{
                                var JSONTemp = {
                                  'nombre':"${eventosJSON.data?[indice]['nombre']}",
                                  'tipo': "${eventosJSON.data?[indice]['tipo']}",
                                  'descripcion': "${eventosJSON.data?[indice]['descripcion']}",
                                  'idEvento': "${eventosJSON.data?[indice]['id']}",
                                  'idUser': "${await DB.obtenerUsuarioUID()}",
                                  'owner': ""
                                };

                                await DB.verificarRepeticionInvitacion("${eventosJSON.data?[indice]['id']}","${await DB.obtenerUsuarioUID()}").then((value) async{
                                  if(value==true){
                                    showDialog(context: context, builder: (builder){
                                      return AlertDialog(
                                        title: Text("Ya haz agregado este evento"),
                                        actions: [
                                          ElevatedButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: Text("Cancelar")),
                                          ElevatedButton(onPressed: (){
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }, child: Text("Aceptar y volver")),
                                        ],
                                      );
                                    });
                                  }else {
                                    await DB.verificarAgregarEventoPropio("${eventosJSON.data?[indice]['id']}","${await DB.obtenerUsuarioUID()}").then((value)async{
                                      if(value==true){
                                        showDialog(context: context, builder: (builder){
                                          return AlertDialog(
                                            title: Text("No puedes agregar tu propio evento"),
                                            actions: [
                                              ElevatedButton(onPressed: (){
                                                Navigator.pop(context);
                                              }, child: Text("Cancelar")),
                                              ElevatedButton(onPressed: (){
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              }, child: Text("Aceptar y volver")),
                                            ],
                                          );
                                        });
                                      }
                                      else{
                                        await DB.agregarEventoInvitacion(JSONTemp).then((value){
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invitación agregada")));
                                        });
                                      }
                                  });
                                  }

                                });

                              }, child: Text("Agregar"))
                            ],
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ))
        ],
      ),
    );
  }
}