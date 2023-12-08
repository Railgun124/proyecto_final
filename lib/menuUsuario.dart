import 'package:flutter/material.dart';
import 'package:proyecto_final/addEvento.dart';
import 'package:proyecto_final/addImage.dart';
import 'package:proyecto_final/serviciosRemotos.dart';
import 'package:proyecto_final/viewInvitation.dart';

class MenuUsuario extends StatefulWidget {
  const MenuUsuario({super.key});

  @override
  State<MenuUsuario> createState() => _MenuUsuarioState();
}

class _MenuUsuarioState extends State<MenuUsuario> {
  int _indice = 0;
  List<String> eventos=["Bautizo","Boda"];
  final nombreEvento = TextEditingController();
  final descEvento = TextEditingController();
  final fechaInicioEvento = TextEditingController();
  final fechaFinEvento = TextEditingController();
  final agregarFotosFF = TextEditingController();
  bool addFAE = false;
  String? eventoSeleccionado;

  String usuarioID = "";

  final IDinvitacion = TextEditingController();
  String invitacionID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu Principal"),),
      body: dinamico(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Text("GX"),
                ),
                SizedBox(height: 10,),
                Text("Usuario",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25
                  ),),
              ],
            ),decoration: BoxDecoration(color: Colors.lightBlue),),
            SizedBox(height: 40,),
            _item(Icons.account_box,"Mis Eventos",0),
            SizedBox(height: 10,),
            _item(Icons.account_box,"Invitaciones",1),
            SizedBox(height: 10,),
            _item(Icons.account_box,"Crear Evento",2),
            SizedBox(height: 10,),
            _item(Icons.account_box,"Configuracion",3),
            SizedBox(height: 10,),
            _item(Icons.account_box,"Salir",4),
          ],
        ),
      ),
    );
  }

  dinamico(){
    switch(_indice){
      //Eventos
      case 0: {
        return FutureBuilder(
          future: DB.getEventosByUser("${DB.obtenerUsuarioUID()}"),
          builder: (context, eventosJSON) {
            if (eventosJSON.hasData) {
              return ListView.builder(
                itemCount: eventosJSON.data?.length,
                itemBuilder: (context, indice) {
                  return ListTile(
                    title: Text("${eventosJSON.data?[indice]['nombre']}"),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      }
    //Invitaciones
      case 1:{
        return Scaffold(
          body: FutureBuilder(
            future: DB.mostrarInvitaciones("${DB.obtenerUsuarioUID()}"),
            builder: (context, eventosJSON) {
              if (eventosJSON.hasData) {
                return ListView.builder(
                  itemCount: eventosJSON.data?.length,
                  itemBuilder: (context, indice) {
                    return ListTile(
                      title: Column(
                        children: [
                          (eventosJSON.data?[indice]['imagenesURL']==null)?
                          Container(
                            margin: EdgeInsets.all(10),
                            height: 200,
                            width: MediaQuery.sizeOf(context).width,
                            color: Colors.grey,
                            child: Icon(Icons.photo),
                          )
                              :
                          Image.network("${eventosJSON.data?[indice]['imagenesURL'][0]}"),
                          Text("${eventosJSON.data?[indice]['tipo']} - ${eventosJSON.data?[indice]['nombre']}")
                        ],
                      ),
                      onTap: () async{
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => viewInvitation(
                              eventID: '${eventosJSON.data?[indice]['idEvento']}',
                              invitationID: '${eventosJSON.data?[indice]['id']}',
                            )));
                        setState(() {
                          _indice = 1;
                        });
                      },
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          floatingActionButton: FloatingActionButton(onPressed: ()async{
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => addEvent()));
            setState(() {
              _indice = 1;
            });
          },child: Icon(Icons.search)),
        );
      }
    //Crear evento
      case 2:{
        return ListView(
          children: [
            TextField(
              controller: nombreEvento,
              decoration: InputDecoration(
                  labelText: "Nombre del Evento"
              ),),
            TextField(
              controller: descEvento,
              decoration: InputDecoration(
                  labelText: "Descripcion del evento"
              ),),
            DropdownButton<String>(
              hint: Text("Seleccionar el tipo de evento"),
              value: eventoSeleccionado, // Valor actualmente seleccionado
              onChanged: (String? value) {
                setState(() {
                  eventoSeleccionado = value; // Actualiza la materia seleccionada
                });
              },
              items: eventos.map((evento) {
                return DropdownMenuItem<String>(
                  value: evento, // Puedes usar el ID de la materia como valor
                  child: Text(evento),
                  onTap: () {},
                );
              }).toList(),
            ),
            TextFormField(
              readOnly: true,
              controller: fechaInicioEvento,
              onTap: () {
                _selectDate2(context);
              },
              decoration: InputDecoration(
                labelText: 'Fecha Inicio',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate2(context);
                  },
                ),
              ),
            ),
            TextFormField(
              readOnly: true,
              controller: fechaFinEvento,
              onTap: () {
                _selectDate(context);
              },
              decoration: InputDecoration(
                labelText: 'Fecha Fin',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ),
            ),
            Text("Agregar imagenes despues de la fecha final?"),
            Switch(
              value: addFAE,
              activeColor: Colors.red,
              onChanged: (bool value) {
                setState(() {
                  addFAE = value;
                });},
            ),
            ElevatedButton(onPressed: (){
              String? codigoEvento=DB.obtenerUsuarioUID();
              if (codigoEvento != null && codigoEvento.length >= 6) {
                String primerosTres = codigoEvento.substring(0, 3);
                String ultimosTres = codigoEvento.substring(codigoEvento.length - 3);
                codigoEvento='${primerosTres}${ultimosTres}${nombreEvento.text}';
              }

              usuarioID = DB.obtenerUsuarioUID()!;

              var tJson = {
                "nombre": nombreEvento.text,
                "descripcion": descEvento.text,
                "tipo":eventoSeleccionado,
                "fechaInicio": fechaInicio,
                "fechaFin": fechaFin,
                "addFAE": addFAE,
                "idInv": codigoEvento,
                "idUser": usuarioID,
              };
              DB.insertarEvento(tJson).then((value) => {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se creo el evento con exito")))
              });

              codigoEvento = "";
              nombreEvento.text = "";
              descEvento.text = "";
              eventoSeleccionado = "";
              fechaInicioEvento.text = "";
              fechaFinEvento.text = "";
              addFAE = false;
              usuarioID = "";

            }, child: Text("Guardar evento"))
          ],
        );
      }
      //configuracion
      case 3:{
        return Center();
      }
      //Cerrar sesion
      case 4:{
        AuthService.signOut();
        return Navigator.pop(context);
      }
      default:{
        AuthService.signOut();
        return Navigator.pop(context);
      }
    }
  }

  _item(IconData icono, String titulo, int i) {
    return ListTile(
      onTap: (){
        setState(() {
          _indice = i;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [
          Expanded(child: Icon(icono, size: 30,)),
          Expanded(child: Text(titulo,style: TextStyle(fontSize: 20),), flex: 2,),
        ],
      ),
    );
  }

  DateTime fechaInicio = DateTime.now();
  DateTime fechaFin = DateTime.now();

  void _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaInicio,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fechaInicio) {
      if (picked.isAfter(fechaInicio)) {
        setState(() {
          fechaInicio = picked;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('La fecha de inicio debe ser anterior a la fecha de fin.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaFin,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fechaFin) {
      if (picked.isAfter(fechaInicio)) {
        setState(() {
          fechaFin = picked;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('La fecha de fin debe ser posterior a la fecha de inicio.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }
  }


}
