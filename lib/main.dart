// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const names = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eve',
  'Fred',
  'Ginny',
  'Harriet',
  'Ileana',
  'Joseph',
  'Kincaid',
  'Larry',
];

extension RandomElement<T> on Iterable<T> {
  T randomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() {
    emit(names.randomElement());
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('Not connected.');
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    // CircularProgressIndicator(),
                    RaisedButton(
                      child: const Text('Pick a name'),
                      onPressed: cubit.pickRandomName,
                    ),
                  ],
                ),
              );
            case ConnectionState.active:
              return Center(
                child: Column(
                  children: [
                    Text(
                      snapshot.data ?? 'No name picked yet',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    RaisedButton(
                      child: const Text('Pick a name'),
                      onPressed: cubit.pickRandomName,
                    ),
                  ],
                ),
              );
            case ConnectionState.done:
              return Center(
                child: Text(
                  'No more names',
                  style: Theme.of(context).textTheme.headline4,
                ),
              );
          }
        },
      ),
    );
  }
}
