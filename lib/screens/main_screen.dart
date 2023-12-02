import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'package:planets/db/database_helper.dart';
import 'package:planets/models/cuerpo_celeste.dart';
import 'package:planets/models/sistem.dart';
import 'package:planets/screens/add_cuerpo_celeste_screen.dart';
import 'package:planets/screens/add_sistema_screen.dart';
import 'package:planets/screens/cuerpo_celeste_descripcion_screen.dart';
import 'package:planets/screens/sistema_descripcion_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Sistema> _sistemas = [];
  List<CuerpoCeleste> _cuerposCelestes = [];
  List<CuerpoCeleste> _cuerposFiltrados = [];
  String _filtroTipo = 'All';

  PageController _cuerposPageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    _sistemas = await DatabaseHelper.instance.getSistemas();
    _cuerposCelestes = await DatabaseHelper.instance.getCuerposCelestes();
    _filtrarCuerpos();
  }

  void _filtrarCuerpos() {
    setState(() {
      if (_filtroTipo == 'All') {
        _cuerposFiltrados = _cuerposCelestes;
      } else {
        _cuerposFiltrados = _cuerposCelestes
            .where((cuerpo) => cuerpo.tipo == _filtroTipo)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Planets',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            height: 0,
            fontSize: 38,
          ),
        ),
        backgroundColor: Color.fromARGB(0, 241, 223, 207),
        elevation: 0,
        actions: <Widget>[
        Container(
  decoration: BoxDecoration(),
  child: IconButton(
    icon: Image.asset(
      'assets/images/jupi.png',  // Cambia la ruta según sea necesario
      height: 84,  // Ajusta el tamaño según tus necesidades
      width: 84,
    ),
    onPressed: () => _navegarYActualizar(AddSistemaScreen()),
  ),
),

          SizedBox(width: 2),
          Container(
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(),
            child: IconButton(
              icon: Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {
                // Implementa la funcionalidad de búsqueda si es necesario
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _crearCarruselSistemas(),
            _crearFiltros(),  // Agregamos el método _crearFiltros
            _crearGridCuerposCelestes(),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => _navegarYActualizar(AddCuerpoCelesteScreen()),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/ros.png',  
              height: 96,
              width: 96,
            ),
            Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navegarYActualizar(Widget pantalla) async {
    final resultado = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => pantalla),
    );

    if (resultado == true) {
      _cargarDatos();
    }
  }

 Widget _crearCarruselSistemas() {
  return CarouselSlider(
    options: CarouselOptions(height: 325.0, autoPlay: false),
    items: _sistemas.map((sistema) {
      return Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SistemaDescripcionScreen(sistema: sistema),
              ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 247, 185, 2),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.file(
                  File(sistema.foto),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error);
                  },
                ),
              ),
            ),
          );
        },
      );
    }).toList(),
  );
}


Widget _crearFiltros() {
  List<Map<String, String>> tiposConImagenes = [
    {'tipo': 'All', 'imagen': 'starr.png'},
    {'tipo': 'Star', 'imagen': 'st.png'},
    {'tipo': 'Planet', 'imagen': 'jup.png'},
    {'tipo': 'Asteroid', 'imagen': 'venu.png'},
    {'tipo': 'Kite', 'imagen': 'aster.png'},
    {'tipo': 'Unidentified', 'imagen': 'nept.png'},
  ];

  return Container(
    height: 290,
    margin: EdgeInsets.only(top: 10),  // Ajusta el valor según sea necesario
    padding: EdgeInsets.symmetric(horizontal: 1),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: tiposConImagenes.length,
      itemBuilder: (context, index) {
        String tipo = tiposConImagenes[index]['tipo']!;
        String imagen = tiposConImagenes[index]['imagen']!;
        String imagenPath = 'assets/images/$imagen';

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(imagenPath),
              ),
              SizedBox(height: 3),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _filtroTipo = tipo;
                    _filtrarCuerpos();
                  });
                },
                child: Text(
                  tipo,
                  style: TextStyle(
                    color: _filtroTipo == tipo ? Colors.blue : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _crearGridCuerposCelestes() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: _cuerposFiltrados.map((cuerpo) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  CuerpoCelesteDescripcionScreen(cuerpoCeleste: cuerpo),
            ));
          },
          child: Column(
            children: <Widget>[
              ClipOval(
                child: Container(
                  width: 120, // Ajusta el ancho según tus necesidades
                  height: 120, // Ajusta la altura según tus necesidades
                  child: Image.file(
                    File(cuerpo.foto),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                ),
              ),
              SizedBox(height: 2),  // Ajusta el valor según tus necesidades
              Text(
                cuerpo.nombre,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
}