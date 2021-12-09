import 'package:flutter/material.dart';

/*
La clase CirculoTiempo sirve para visualizar como va transcurriendo
el tiempo del temporizador de forma cómoda para el usuario

En ella estalecemos el margen para centrar el circulo
También especificamos el radio de acción del circulo y el tamaño del icono
*/
class CirculoTiempo extends StatelessWidget {
  const CirculoTiempo({
    Key? key,
    required this.icono,
  }) : super(key: key);
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: CircleAvatar(
        radius: 30,
        child: Icon(
          icono,
          size: 36,
        ),
      ),
    );
  }
}
