import 'package:flutter/material.dart';
import 'package:proyecto_final/addEvento.dart';
import 'package:proyecto_final/cambiarEmail.dart';
import 'package:proyecto_final/cambiarPass.dart';
import 'package:proyecto_final/serviciosRemotos.dart';
import 'package:proyecto_final/updateEvent.dart';
import 'package:proyecto_final/viewInvitation.dart';

class MenuUsuario extends StatefulWidget {
  const MenuUsuario({super.key});

  @override
  State<MenuUsuario> createState() => _MenuUsuarioState();
}

class _MenuUsuarioState extends State<MenuUsuario> {
  int _indice = 0;

  List<String> eventos=[
    'Cumpleaños',
    'Boda',
    'Aniversario',
    'Despedida de soltero/a',
    'Baby shower',
    'Graduación',
    'Reunión familiar',
    'Fiesta temática',
    'Evento corporativo',
    'Fiesta de inauguración',
    'Fiesta de compromiso',
    'Fiesta de bienvenida',
    'Noche de juegos',
    'Cena elegante',
    'Karaoke',
    'Fiesta en la piscina',
    'Fiesta de disfraces',
    'Concierto privado',
    'Fiesta de Navidad',
    'Fiesta de Año Nuevo',];

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

  String obtenerPrimeraLetra() {
    String correo = DB.obtenerUsuarioEmail()!;
    return correo.isNotEmpty ? correo.substring(0, 1).toUpperCase() : '';
  }

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
                  child: Text(
                    obtenerPrimeraLetra(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text("${DB.obtenerUsuarioEmail()}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25
                  ),),
              ],
            ),decoration: BoxDecoration(color: Colors.lightBlue),),
            SizedBox(height: 40,),
            _item(Icons.people_alt,"Mis Eventos",0),
            SizedBox(height: 10,),
            _item(Icons.table_rows_outlined,"Invitaciones",1),
            SizedBox(height: 10,),
            _item(Icons.event,"Crear Evento",2),
            SizedBox(height: 10,),
            _item(Icons.settings,"Configuracion",3),
            SizedBox(height: 10,),
            _item(Icons.reply_all_sharp,"Salir",4),
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
          future: DB.mostrarEventos("${DB.obtenerUsuarioUID()}"),
          builder: (context, eventosJSON) {
            if (eventosJSON.hasData) {
              return GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  children: List.generate(eventosJSON.data!.length, (indice){
                  return ListTile(
                      title: Column(
                        children: [
                          (eventosJSON.data?[indice]['imagenesURL']==null)?
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 200,
                              width: MediaQuery.sizeOf(context).width,
                              color: Colors.grey,
                              child: Icon(Icons.photo),
                            ),flex: 2,
                          )
                              :
                          Expanded(child: Image.network("${eventosJSON.data?[indice]['imagenesURL'][0]}",),flex:2),
                          Expanded(child: Text("${eventosJSON.data?[indice]['tipo']} - ${eventosJSON.data?[indice]['nombre']}"),flex: 0,)
                        ],
                      ),
                      onTap: () async{
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => updateEvent(
                              eventID: '${eventosJSON.data?[indice]['id']}',
                              invitationID: '${eventosJSON.data?[indice]['id']}',
                              albumAbierto: eventosJSON.data?[indice]['albumAbierto'],
                            )));
                        setState(() {
                          _indice = 0;
                        });
                      }
                  );
                },
              ));
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
                return GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    children: List.generate(eventosJSON.data!.length, (indice){
                    return FutureBuilder(
                      future: DB.getEventoById(eventosJSON.data?[indice]['idEvento']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if(snapshot.hasData){
                          var imagenURL;
                          if (snapshot.data != null &&
                              snapshot.data?[0]['imagenesURL'] != null &&
                              snapshot.data?[0]['imagenesURL'].isNotEmpty) {
                            imagenURL = snapshot.data?[0]['imagenesURL'][0];
                          }
                          return ListTile(
                            title: Column(
                              children: [
                                (imagenURL==null)?
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey,
                                    child: Icon(Icons.photo),
                                  ),flex: 2,
                                )
                                    :
                                Expanded(child: Image.network(imagenURL,),flex: 2,),
                                Expanded(child: Text("${eventosJSON.data?[indice]['tipo']} - ${eventosJSON.data?[indice]['nombre']}"),flex: 0,)
                              ],
                            ),
                            onTap: () async{
                              await DB.getEventoById(eventosJSON.data?[indice]['idEvento']).then((value) async{
                                if(value[0]['albumAbierto'] == false){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("El albúm está cerrado")));
                                }else{
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => viewInvitation(
                                        eventID: '${eventosJSON.data?[indice]['idEvento']}',
                                        invitationID: '${eventosJSON.data?[indice]['id']}',
                                      )));
                                  setState(() {
                                    _indice = 1;
                                  });
                                }
                              });

                            },
                          );
                        }
                        return Center(child: CircularProgressIndicator(),);
                      },
                    );
                  },
                )
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
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              TextField(
                controller: nombreEvento,
                decoration: InputDecoration(
                    labelText: "Nombre del Evento"
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descEvento,
                decoration: InputDecoration(
                    labelText: "Descripcion del Evento"
                ),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                hint: Text("Seleccionar el Tipo de Evento                           "),
                value: eventoSeleccionado,
                onChanged: (String? value) {
                  setState(() {
                    eventoSeleccionado = value;
                  });
                },
                items: eventos.map((evento) {
                  return DropdownMenuItem<String>(
                    value: evento,
                    child: Text(evento),
                    onTap: () {},
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
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
              SizedBox(height: 10),
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
              SizedBox(height: 20),
              Text("Agregar imágenes después de la fecha final?"),
              Switch(
                value: addFAE,
                activeColor: Colors.red,
                onChanged: (bool value) {
                  setState(() {
                    addFAE = value;
                  });
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async{

                    if(nombreEvento.text.isEmpty || descEvento.text.isEmpty || eventoSeleccionado == null || fechaInicioEvento.text.isEmpty || fechaFinEvento.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Faltan campos por llenar")));
                      return;
                    }
                    try {
              usuarioID = DB.obtenerUsuarioUID()!;

              var tJson = {
                "nombre": nombreEvento.text,
                "descripcion": descEvento.text,
                "tipo":eventoSeleccionado,
                "fechaInicio": fechaInicio,
                "fechaFin": fechaFin,
                "addFAE": addFAE,
                "idUser": usuarioID,
                "albumAbierto": true
              };

              await DB.insertarEvento(tJson);
                      nombreEvento.text = "";
                      descEvento.text = "";
                      eventoSeleccionado = "";
                      fechaInicioEvento.text = "";
                      fechaFinEvento.text = "";
                      addFAE = false;
                      usuarioID = "";

                      setState(() {
                        _indice = 0;
                      });
                    } catch(e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ocurrió un error, inténtalo de nuevo")));
                    }
                  },
                  child: Text("Guardar evento")
              ),
            ],
          ),
        );
      }
    //configuracion
      case 3: {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Actualizar Contraseña'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cambiarPass()),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Actualizar Correo Electrónico'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cambiarEmail()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
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
      firstDate: DateTime(2001),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fechaInicio) {
      if (picked.isBefore(fechaFin)) {
        setState(() {
          fechaInicio = picked;
          fechaInicioEvento.text = "${fechaInicio.day}/${fechaInicio.month}/${fechaInicio.year}";
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
      firstDate: DateTime(2001),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fechaFin) {
      if (picked.isAfter(fechaInicio)) {
        setState(() {
          fechaFin = picked;
          fechaFinEvento.text = "${fechaFin.day}/${fechaFin.month}/${fechaFin.year}";
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
