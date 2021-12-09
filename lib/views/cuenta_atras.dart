import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/circulo_tiempo.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';


/*
* La clase Cuenta Atras se encarga de establecer el temporizador
* Cuenta con los siguientes puntos:
* - Texto: establece el tiempo (HH/MM/SS)
* - Notificación: establece un sonido a modo de alarma cuanto el temporizador acabe
* - Animador: se encarga en establecer el tiempo del temporizador e ir restando el progreso
* - Contexto: es el más costoso. Se encarga de dar funcionalidad a los iconos Play, Pausa y Reinicio,
*             del cambio de color del circulo una vez vaya bajando el tiempo y de la parada del cronometro
* */

class CuentaAtras extends StatefulWidget {
  const CuentaAtras({Key? key}) : super(key: key);

  @override
  _CuentaAtras createState() => _CuentaAtras();
}

class _CuentaAtras extends State<CuentaAtras>
    with TickerProviderStateMixin {
  late AnimationController controlador;

  bool play = false;

  String get texto {
    Duration cuenta = controlador.duration! * controlador.value;
    return controlador.isDismissed
        ? '${controlador.duration!.inHours}:${(controlador.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controlador.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${cuenta.inHours}:${(cuenta.inMinutes % 60).toString().padLeft(2, '0')}:${(cuenta.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progreso = 1.0;

  void notify() {
    if (texto == '0:00:00') {
      FlutterRingtonePlayer.playNotification();
    }
  }

  @override
  void initState() {
    super.initState();
    controlador = AnimationController(
      vsync: this,
      duration: Duration(minutes: 15),
    );

    controlador.addListener(() {
      notify();
      if (controlador.isAnimating) {
        setState(() {
          progreso = controlador.value;
        });
      } else {
        setState(() {
          progreso = 1.0;
          play = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5fbff),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey.shade200,
                    value: progreso,
                    strokeWidth: 5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (controlador.isDismissed) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 300,
                          child: CupertinoTimerPicker(
                            initialTimerDuration: controlador.duration!,
                            onTimerDurationChanged: (time) {
                              setState(() {
                                controlador.duration = time;
                              });
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: controlador,
                    builder: (context, child) => Text(
                      texto,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (controlador.isAnimating) {
                      controlador.stop();
                      setState(() {
                        play = false;
                      });
                    } else {
                      controlador.reverse(
                          from: controlador.value == 0 ? 1.0 : controlador.value);
                      setState(() {
                        play = true;
                      });
                    }
                  },
                  child: CirculoTiempo(
                    icono: play == true
                        ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controlador.reset();
                    setState(() {
                      play = false;
                    });
                  },
                  child: CirculoTiempo(
                    icono: Icons.stop,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
