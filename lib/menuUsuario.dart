import 'package:flutter/material.dart';
import 'package:proyecto_final/serviciosRemotos.dart';

class MenuUsuario extends StatefulWidget {
  const MenuUsuario({super.key});

  @override
  State<MenuUsuario> createState() => _MenuUsuarioState();
}

class _MenuUsuarioState extends State<MenuUsuario> {
  int _indice = 0;
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
      case 0:{
        return Center(child: ElevatedButton(onPressed: (){
          DB.obtenerInformacionUsuarioActual();
        }, child: Text("ola")),);
      }
      case 1:{
        return Center();
      }
      case 2:{
        return Center();
      }
      case 3:{
        return Center();
      }
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
}
