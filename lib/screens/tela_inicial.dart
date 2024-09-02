import 'package:editor_de_imagens/screens/tela_buscar_foto.dart';
import 'package:flutter/material.dart';

import '../widgets/CustomButton.dart';

class TelaInicial extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CustomButton(
            label: 'Buscar',
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TelaBuscarFoto())
              );
            },
          ),
        )
      )
    );
  }
}