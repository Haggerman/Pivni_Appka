import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2.0)
    )
);

const textShadow = <Shadow>[
    Shadow(
        offset: Offset(0.0, 0.0),
        blurRadius: 2.0,
        color: Color.fromARGB(255, 0, 0, 0),
    ),
];