import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(MaterialApp(
    title: 'Home page',
    darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.dark,
    home: const HomePage(),
  ));
}

class State {
  final double alpha;
  final double rotation;

  State({
    required this.alpha,
    required this.rotation,
  });
  State.zero()
      : alpha = 1.0,
        rotation = 0.0;

  State left() => State(
        alpha: alpha,
        rotation: rotation - 20,
      );

  State right() => State(
        alpha: alpha,
        rotation: rotation + 20,
      );
  State less() => State(
        alpha: max(alpha - 0.1, 0),
        rotation: rotation,
      );
  State more() => State(
        alpha: min(alpha + 0.1, 1),
        rotation: rotation,
      );
}

enum Action {
  rotateLeft,
  rotateRight,
  lessVisible,
  moreVisible,
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case null:
      return oldState;
    case Action.rotateLeft:
      return oldState.left();

    case Action.rotateRight:
      return oldState.right();

    case Action.lessVisible:
      return oldState.less();

    case Action.moreVisible:
      return oldState.more();
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(
      reducer,
      initialState: State.zero(),
      initialAction: null,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage')),
      body: Column(
        children: [
          Center(
            widthFactor: 200,
            child: Row(children: [
              RotateLeftButton(store: store),
              RotateRightButton(store: store),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.lessVisible);
                },
                child: const Text('lessVisible'),
              ),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.moreVisible);
                },
                child: const Text('moreVisible'),
              ),
            ]),
          ),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(store.state.rotation / 360),
              child: const Center(
                  heightFactor: 10,
                  child: Text('body is the part of our body')),
            ),
          ),
        ],
      ),
    );
  }
}

class RotateRightButton extends StatelessWidget {
  const RotateRightButton({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.rotateRight);
      },
      child: const Text('rotate right'),
    );
  }
}

class RotateLeftButton extends StatelessWidget {
  const RotateLeftButton({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.rotateLeft);
      },
      child: const Text('rotate left'),
    );
  }
}
