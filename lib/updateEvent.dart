import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_final/serviciosRemotos.dart';
import 'package:proyecto_final/viewEvent.dart';
class updateEvent extends StatefulWidget {
  final eventID;
  final invitationID;
  final albumAbierto;
  const updateEvent({super.key, required this.eventID, required this.invitationID, required this.albumAbierto});

  @override
  State<updateEvent> createState() => _updateEventState();
}

class _updateEventState extends State<updateEvent> {
  var eventID;
  var invitationID;
  var album;

  @override
  void initState(){
    super.initState();
    eventID = widget.eventID;
    invitationID = widget.invitationID;
    album = widget.albumAbierto;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Administrar evento"),
      ),
      body: ListView(
        children: [
          Card(
            child: Column(
              children: [
                Text("Código de invitación: "),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(eventID),
                    IconButton(onPressed: (){
                      Clipboard.setData(ClipboardData(text: eventID)).then((value){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se copió el código al portapapeles")));
                      });
                    }, icon: Icon(Icons.copy)),
                  ],
                ),
                ListTile(
                  title: Text('Ver albúm'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => viewEvent(eventID: eventID, invitationID: invitationID)),
                    );
                  },
                ),
                Text("Cerrar albúm - Abrir albúm"),
                Switch(
                  value: album,
                  activeColor: Colors.red,
                  onChanged: (bool value) async{
                    setState(() {
                      album = value;
                    });
                    await DB.updateAlbumStatus(eventID,album).then((value){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se cambió el estatus del albúm")));
                    });
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
