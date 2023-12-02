import 'package:flutter/material.dart';
import 'package:planets/db/database_helper.dart'; 
import 'package:planets/models/cuerpo_celeste.dart';
import 'package:planets/models/sistem.dart';
import 'package:planets/screens/add_cuerpo_celeste_screen.dart';
import 'package:planets/screens/add_sistema_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registry of Celestial Bodies',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // Método para imprimir los datos en consola
  void _mostrarDatos() async {
    List<CuerpoCeleste> cuerpos =
        await DatabaseHelper.instance.getCuerposCelestes();
    List<Sistema> sistemas = await DatabaseHelper.instance.getSistemas();

    print('Celestial bodies:');
    cuerpos.forEach(
        (cuerpo) => print('${cuerpo.nombre}, ${cuerpo.descripcion}, ...'));

    print('Systems:');
    sistemas.forEach(
        (sistema) => print('${sistema.nombre}, ${sistema.descripcion}, ...'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Add Celestial Body'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => AddCuerpoCelesteScreen()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Add System'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddSistemaScreen()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Show Saved Data'),
              onPressed: _mostrarDatos,
            ),
          ],
        ),
      ),
    );
  }
}
