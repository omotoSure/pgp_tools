import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String textName;
  final Function onPress;
  const ButtonWidget({Key? key, required this.textName, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPress(),
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        width: 300,
        height: 50,
        child: Center(
          child: Text(
            textName,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Lato',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
