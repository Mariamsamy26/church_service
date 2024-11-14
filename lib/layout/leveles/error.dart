import 'package:flutter/material.dart';

class ErrorPart extends StatelessWidget {
  final void Function()? onPressed;

  ErrorPart({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Something went wrong "),
          ElevatedButton(
            onPressed: onPressed,
            child: Text("Try again"),
          ),
        ],
      ),
    );
  }
}
