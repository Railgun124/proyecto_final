import 'package:flutter/material.dart';
import 'package:proyecto_final/addImage.dart';
import 'package:proyecto_final/serviciosRemotos.dart';
class viewEvent extends StatefulWidget {
  final String eventID;
  final String invitationID;
  const viewEvent({super.key, required String this.eventID,required String this.invitationID});

  @override
  State<viewEvent> createState() => _viewEventState();
}

class _viewEventState extends State<viewEvent>{
  var eventID;
  var invitationID;

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
                      Expanded(child: Image.network(JSON.data?[0]['imagenesURL'][index]),flex: 9,),
                      Expanded(flex: 3,child: IconButton(onPressed: () async{
                        showDialog(context: context, builder: (builder){
                          return AlertDialog(
                            title: Text("¿Eliminar?"),
                            content: Text("¿Seguro que quieres eliminar esta imagen?"),
                            actions: [
                              ElevatedButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text("Cancelar")),
                              ElevatedButton(onPressed: () async{
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (builder) {
                                      return WillPopScope(
                                        onWillPop: () async => false,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    });
                                await DB.deleteImageFromStorage(JSON.data?[0]['imagenesURL'][index]).then((value)async{
                                  await DB.deleteImageFromDatabase(JSON.data?[0],JSON.data?[0]['imagenesURL'][index]).then((value){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Imagen Eliminada!")));
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder){return viewEvent(eventID: eventID, invitationID: invitationID);}));
                                  });
                                }
                                );
                              }, child: Text("Borrar"))
                            ],
                          );
                        });
                      }, icon: Icon(Icons.cancel)),),
                    ],
                  );
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder){return viewEvent(eventID: eventID, invitationID: invitationID);}));
        });
      },child: Icon(Icons.upload),),
    );
  }
}
