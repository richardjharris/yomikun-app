import 'package:flutter/material.dart';

/// Simple loading placeholder widget.
class LoadingBox extends StatelessWidget {
  const LoadingBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
