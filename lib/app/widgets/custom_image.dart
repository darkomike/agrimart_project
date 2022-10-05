import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final bool isLocal;
  final String path;
  const CustomImage({Key? key, required this.isLocal, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  isLocal ? AssetImage(path) as Widget: NetworkImage(path) as Widget;
  }
}
