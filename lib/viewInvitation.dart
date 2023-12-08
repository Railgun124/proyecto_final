import 'package:flutter/material.dart';
import 'package:proyecto_final/addImage.dart';
import 'package:proyecto_final/serviciosRemotos.dart';
class viewInvitation extends StatefulWidget {
  final String eventID;
  final String invitationID;
  const viewInvitation({super.key, required String this.eventID,required String this.invitationID});

  @override
  State<viewInvitation> createState() => _viewInvitationState();
}

class _viewInvitationState extends State<viewInvitation>{
  var eventID;
  var invitationID;
  var tipoEvento;
  var propiedad;
  var descripcion;
  var imagenesURL;

  @override
  void initState(){
    super.initState();
    eventID = widget.eventID;
    invitationID = widget.invitationID;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Albúm Evento"),
      ),
      body: FutureBuilder(
          future: DB.getEventoById(eventID),
          builder: (context,JSON){
            if (JSON.hasData) {
              return GridView.count(
                crossAxisCount: 3,
                children: List.generate(JSON.data?[0]['imagenesURL'].length, (index){
                  return Image.network(JSON.data?[0]['imagenesURL'][index]);
                }),
              );
            }
            return Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        await Navigator.push(context,
        MaterialPageRoute(builder: (context) => addImageToEvent(
          eventID: '$eventID', invitationID: '$invitationID'
        ))).then((value){
          //Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder){return viewInvitation(eventID: eventID, invitationID: invitationID);}));
        });
      },child: Icon(Icons.upload),),
    );
  }
}