import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planets/db/database_helper.dart';
import 'dart:io';
import 'dart:async';

import 'package:planets/models/cuerpo_celeste.dart';
import 'package:planets/models/sistem.dart';

class AddCuerpoCelesteScreen extends StatefulWidget {
  @override
  _AddCuerpoCelesteScreenState createState() =>
      _AddCuerpoCelesteScreenState();
}

class _AddCuerpoCelesteScreenState extends State<AddCuerpoCelesteScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  File? _foto;
  String _descripcion = '';
  String _tipo = 'Star';
  String _naturaleza = 'Gas';
  double _tamano = 0.0;
  double _distancia = 0.0;
  int? _sistemaId;
  List<Sistema> _sistemas = [];

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _cargarSistemas();
  }

  Future<void> _cargarSistemas() async {
    List<Sistema> sistemasRecuperados =
        await DatabaseHelper.instance.getSistemas();
    setState(() {
      _sistemas = sistemasRecuperados;
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _foto = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _foto = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Celestial Body'),
        backgroundColor: Color.fromARGB(255, 188, 54, 172),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/5.png'), // Ruta de tu imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(26.0),
            children: <Widget>[
              if (_foto != null) Image.file(_foto!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: getImageFromCamera,
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 188, 54, 172),
                    ),
                    child: Text('Take photo'),
                  ),
                  ElevatedButton(
                    onPressed: getImageFromGallery,
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 188, 54, 172),
                    ),
                    child: Text('Select from gallery'),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _nombre = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _descripcion = value!,
              ),
              DropdownButtonFormField<String>(
                value: _tipo,
                items: <String>[
                  'Star',
                  'Planet',
                  'Asteroid',
                  'Kite',
                  'Unidentified'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _tipo = newValue!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _naturaleza,
                items: <String>['Gas', 'Liquid', 'Solid', 'Rocky']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _naturaleza = newValue!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Size in km'),
                onSaved: (value) => _tamano = double.parse(value!),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Distance from Earth'),
                onSaved: (value) => _distancia = double.parse(value!),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<int?>(
                value: _sistemaId,
                items: _sistemas.map<DropdownMenuItem<int?>>((Sistema sistema) {
                  return DropdownMenuItem<int?>(
                    value: sistema.id,
                    child: Text(sistema.nombre),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _sistemaId = newValue;
                  });
                },
                decoration: InputDecoration(labelText: 'System'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            CuerpoCeleste nuevoCuerpoCeleste = CuerpoCeleste(
              nombre: _nombre,
              foto: _foto?.path ?? '',
              descripcion: _descripcion,
              tipo: _tipo,
              naturaleza: _naturaleza,
              tamano: _tamano,
              distancia: _distancia,
              sistemaId: _sistemaId,
            );

            await DatabaseHelper.instance
                .insertCuerpoCeleste(nuevoCuerpoCeleste);

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Celestial Body successfully saved')));

            Navigator.of(context).pop(true);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Color.fromARGB(255, 188, 54, 172),
      ),
    );
  }
}
