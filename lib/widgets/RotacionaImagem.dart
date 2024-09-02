import 'dart:io';

import 'package:flutter/material.dart';

class RotacionaImagem extends StatelessWidget{
  final Widget img;
  const RotacionaImagem({required this.img});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.5,
      child: img,
    );
  }

}