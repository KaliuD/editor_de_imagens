import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class TelaBuscarFoto extends StatefulWidget {
  const TelaBuscarFoto({Key? key}) : super(key: key);

  @override
  State<TelaBuscarFoto> createState() => _TelaBuscarFoto();
}

class _TelaBuscarFoto extends State<TelaBuscarFoto> {
  File? _image;
  final _picker = ImagePicker();
  bool _isFiltered = false;
  ColorFilter? _colorFilter;

  static const _sepia = ColorFilter.matrix(
    <double>[
      0.393, 0.769, 0.189, 0, 0, // Red channel
      0.349, 0.686, 0.168, 0, 0, // Green channel
      0.272, 0.534, 0.131, 0, 0, // Blue channel
      0, 0, 0, 1, 0, // Alpha channel
    ],
  );
  static const _pretoBranco = ColorFilter.matrix(
    <double>[
      0.2126, 0.7152, 0.0722, 0, 0, // Red channel
      0.2126, 0.7152, 0.0722, 0, 0, // Green channel
      0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
      0, 0, 0, 1, 0, // Alpha channel
    ],
  );
  static const _negativo = ColorFilter.matrix(
    <double>[
      -1, 0, 0, 0, 255, // Red channel
      0, -1, 0, 0, 255, // Green channel
      0, 0, -1, 0, 255, // Blue channel
      0, 0, 0, 1, 0, // Alpha channel
    ],
  );

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _cropImage() async {
    if (_image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Recortar Imagem',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path);
        });
      }
    }
  }

  Future<void> _salvarImagem() async {
    if (_image == null) return;

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/image_to_save.png';

    // Salvar a imagem temporariamente
    final File tempFile = File(path);
    await tempFile.writeAsBytes(await _image!.readAsBytes());

    // Salvar na galeria
    final result = await ImageGallerySaver.saveFile(tempFile.path);
    if (result['isSuccess']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagem salva na galeria!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao salvar a imagem')),
      );
    }
  }

  _aplicarFiltro(ColorFilter filter) {
    setState(() {
      if (!_isFiltered) {
        _isFiltered = !_isFiltered;
      }
      _colorFilter = filter;
    });
  }

  _limparFiltro() {
    setState(() {
      if (_isFiltered = true) _isFiltered = !_isFiltered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isFiltered
                  ? ColorFiltered(
                      colorFilter: _colorFilter!,
                      child: _image != null
                          ? Image.file(_image!)
                          : Text('Selecione uma imagem'),
                    )
                  : _image != null
                      ? Image.file(_image!)
                      : Text('Selecione uma imagem'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        _aplicarFiltro(_pretoBranco);
                      },
                      child: Text('PB')),
                  OutlinedButton(
                      onPressed: () {
                        _aplicarFiltro(_sepia);
                      },
                      child: Text('Sepia')),
                  OutlinedButton(
                      onPressed: () {
                        _aplicarFiltro(_negativo);
                      },
                      child: Text('Negativo')),
                  OutlinedButton(
                      onPressed: () {
                        _limparFiltro();
                      },
                      child: Text('Limpar')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Voltar')),
                  OutlinedButton(
                      onPressed: () {
                        _cropImage();
                      },
                      child: Text('Editar')),
                  OutlinedButton(
                      onPressed: () {
                        _openImagePicker();
                      },
                      child: Text('Buscar Imagem')),
                  OutlinedButton(
                      onPressed: () {
                        _salvarImagem();
                      },
                      child: Text('Salvar')),
                ],
              ),
            ],
          )
      ),
    );
  }
}
