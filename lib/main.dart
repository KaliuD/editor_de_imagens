import 'package:editor_de_imagens/screens/tela_inicial.dart';
import 'package:flutter/material.dart';

void main() => runApp(ImageEditor());

class ImageEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//Esconde a Faixa de Debugger
      title: 'Editor de Imagens',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: TelaInicial(),
    );
  }

}