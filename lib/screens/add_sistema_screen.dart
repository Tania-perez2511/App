import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planets/db/database_helper.dart';
import 'dart:io';

import 'package:planets/models/sistem.dart';

class AddSistemaScreen extends StatefulWidget {
  @override
  _AddSistemaScreenState createState() => _AddSistemaScreenState();
}

class _AddSistemaScreenState extends State<AddSistemaScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  File? _foto;
  String _descripcion = '';
  double _tamano = 0.0;
  double _distancia = 0.0;

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

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
        title: Text('Add System'),
        backgroundColor: Color.fromARGB(255, 188, 54, 172),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/5.png', // Asegúrate de tener la ruta correcta
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  if (_foto != null) Image.file(_foto!),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => getImage(ImageSource.camera),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 188, 54, 172),
                        ),
                        child: Text('Take photo'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => getImage(ImageSource.gallery),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 188, 54, 172),
                        ),
                        child: Text('From gallery'),
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
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Size in km'),
                    onSaved: (value) => _tamano = double.parse(value!),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Distance from Earth'),
                    onSaved: (value) => _distancia = double.parse(value!),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            Sistema nuevoSistema = Sistema(
              nombre: _nombre,
              foto: _foto?.path ?? '',
              descripcion: _descripcion,
              tamano: _tamano,
              distancia: _distancia,
            );

            await DatabaseHelper.instance.insertSistema(nuevoSistema);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('System saved successfully')),
            );

            Navigator.of(context).pop(true);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Color.fromARGB(255, 188, 54, 172),
      ),
    );
  }
}
