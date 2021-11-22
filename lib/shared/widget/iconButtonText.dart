import 'package:flutter/material.dart';

class IconButtonText extends StatelessWidget {
  const IconButtonText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.ac_unit_outlined,
              color: Colors.white,
            )),
        Text('', style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
