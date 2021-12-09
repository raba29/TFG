import 'package:flutter/material.dart';
import 'views/cuenta_atras.dart';

/*
La parte Main ejecuta la aplicación, estableciendo el nombre que aparece
//como titulo en la ejecución en telefono móvil
y como nombre de pestaña en ejecución web
*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cronometro - App TFG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CuentaAtras(),
    );
  }
}
