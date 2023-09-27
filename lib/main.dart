import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Reduce an iterable to values removing null if a transform func is not passed!!

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

const url =
    'https://images.unsplash.com/photo-1495107334309-fcf20504a5ab?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTIyfHxuYXR1cmV8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    late final StreamController<double> controller;

    controller = useStreamController(onListen: () {
      controller.sink.add(0.0);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
      ),
      body: StreamBuilder<double>(
          stream: controller.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              final rotation = snapshot.data ?? 0.0;
              return GestureDetector(
                onTap: () {
                  controller.sink.add(rotation + 10);
                },
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(rotation / 360.0),
                  child: Center(
                    child: Image.network(url),
                  ),
                ),
              );
            }
          }),
    );
  }
}
