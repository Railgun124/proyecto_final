import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proyecto_final/serviciosRemotos.dart';

class addImageToEvent extends StatefulWidget {
  final String eventID;
  final String invitationID;
  const addImageToEvent({super.key, required String this.eventID,required String this.invitationID});

  @override
  State<addImageToEvent> createState() => _addImageToEventState();
}

class _addImageToEventState extends State<addImageToEvent> {
  var eventID;
  var invitationID;

  @override
  void initState() {
    super.initState();
    eventID = widget.eventID;
    invitationID = widget.invitationID;
  }

  File? imagen_to_upload;
  var subido = false;
  var imagen = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Imagen"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                final imagen = await DB.getImage();
                setState(() {
                  imagen_to_upload = File(imagen!.path);
                });
              },
              child: Column(
                children: [Text("Abrir Galería"), Icon(Icons.photo)],
              )),
          imagen_to_upload != null
              ? Image.file(imagen_to_upload!)
              : Container(
                  margin: EdgeInsets.all(10),
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  color: Colors.grey,
                  child: Icon(Icons.photo),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (imagen_to_upload == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(milliseconds: 1000),
                content: Text("Selecciona una imagen!")));
            return;
          }
          if (subido == false) {
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
            imagen = await DB.uploadImage(imagen_to_upload!, eventID,"${await DB.obtenerUsuarioUID()}").then((value) async {
              var evento = await DB.getEventoById(eventID);
              var imagenesURL = evento[0]['imagenesURL'];
              if(imagenesURL == null) {
                imagenesURL = ["$value"];
              } else {
                imagenesURL.add("$value");
              }
              var tempJSON = {
                'id': "${evento[0]['id']}",
                'nombre': "${evento[0]['nombre']}",
                'descripcion': "${evento[0]['descripcion']}",
                'tipo': "${evento[0]['tipo']}",
                'addFAE': evento[0]['addFAE'],
                'fechaFin': evento[0]['fechaFin'],
                'fechaInicio': evento[0]['fechaInicio'],
                'idInv': "${evento[0]['idInv']}",
                'imagenesURL': imagenesURL,
              };
              await DB.updateEvento(tempJSON).then((value) {
                imagen_to_upload = null;
                setState(() {
                  subido = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Imagen subida!")));
              });
              //Quitar circular
              Navigator.pop(context);
              //Volver a pagina principal
              Navigator.pop(context);
              /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder){return App();}));
            Navigator.push(context, MaterialPageRoute(builder: (builder){return subAgregar();}));
            Navigator.pop(context);*/
            });
          }
          setState(() {
            subido = false;
          });
        },
        child: Icon(Icons.upload),
      ),
    );
  }
}
