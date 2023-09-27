import 'dart:math';

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

enum Action {
  rotateLeft,
  rotateRight,
  moreVisible,
  lessVisible,
}

@immutable
class State {
  final double rotateDeg;
  final double alpha;

  const State({required this.rotateDeg, required this.alpha});

  const State.zero()
      : rotateDeg = 0.0,
        alpha = 1.0;

  State rotateRight() => State(
        rotateDeg: rotateDeg + 10.0,
        alpha: alpha,
      );

  State rotateLeft() => State(
        rotateDeg: rotateDeg - 10.0,
        alpha: alpha,
      );

  State increaseAlpha() => State(
        rotateDeg: rotateDeg,
        alpha: min(alpha + 0.1, 1.0),
      );

  State decreaseAlpha() => State(
        rotateDeg: rotateDeg,
        alpha: max(alpha - 0.1, 0.0),
      );
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              RotateLeftWidget(store: store),
              RotateRightWidget(store: store),
              MoreVisibleWidget(store: store),
              LessVisibleWidget(store: store),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
                turns: AlwaysStoppedAnimation(store.state.rotateDeg / 360.0),
                child: Image.network(url)),
          ),
        ],
      ),
    );
  }
}

class LessVisibleWidget extends StatelessWidget {
  const LessVisibleWidget({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.lessVisible);
      },
      child: const Text('Less Visible'),
    );
  }
}

class MoreVisibleWidget extends StatelessWidget {
  const MoreVisibleWidget({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.moreVisible);
      },
      child: const Text('More Visible'),
    );
  }
}

class RotateRightWidget extends StatelessWidget {
  const RotateRightWidget({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.rotateRight);
      },
      child: const Text('Rotate Right'),
    );
  }
}

class RotateLeftWidget extends StatelessWidget {
  const RotateLeftWidget({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.rotateLeft);
      },
      child: const Text('Rotate Left'),
    );
  }
}
