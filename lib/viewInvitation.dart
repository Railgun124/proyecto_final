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
  var addFAE;
  var fechaFin;

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
              addFAE = JSON.data?[0]['addFAE'];
              fechaFin = JSON.data?[0]['fechaFin'];
              if(JSON.data?[0]['imagenesURL']==null)
                return Center(child: Container(
                  margin: EdgeInsets.all(10),
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  color: Colors.grey,
                  child: Icon(Icons.photo),
                ),);
              return GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                children: List.generate(JSON.data?[0]['imagenesURL'].length, (index){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(child: Image.network(JSON.data?[0]['imagenesURL'][index]),flex: 10,),
                    ],
                  );
                }),
              );
            }
            return Center(child: CircularProgressIndicator());
      }),

      floatingActionButton: FloatingActionButton(onPressed: () async{
        if(addFAE==true){
        await Navigator.push(context,
        MaterialPageRoute(builder: (context) => addImageToEvent(
          eventID: '$eventID', invitationID: '$invitationID'
        ))).then((value){
          //Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder){return viewInvitation(eventID: eventID, invitationID: invitationID);}));
        });
        }
        else
          {
            if(DateTime.now().isAfter(fechaFin.toDate())){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ya no puedes subir imagenes")));
            }else{
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addImageToEvent(
                      eventID: '$eventID', invitationID: '$invitationID'
                  ))).then((value){
                //Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder){return viewInvitation(eventID: eventID, invitationID: invitationID);}));
              });
            }
          }
      },child: Icon(Icons.upload),),
    );
  }
}
