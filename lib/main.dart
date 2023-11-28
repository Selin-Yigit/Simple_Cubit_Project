import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

const names = ['Foo', 'Bar', 'Baz'];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        math.Random().nextInt(length),
      );
}

class NamesCubits extends Cubit<String?> {
  // Cubit bir initial state almak zorundadır. Yani başlangıçta bir değerin olup olmadığı
  // Burada konrol edilmelidir. Bizim başlangıçta bir değerimiz olmayacağı için
  // Super içine "null" verdik.
  NamesCubits() : super(null);

  void pickRandomName() {
    // Burada state'in sadece getter'ı bulunur ve Cubit'in o anki durumunu getirir.
    // Yani state'e yeni bir durum verilemez Çünkü setter bulunmaz.
    // Yeni bir state üretmek için emit fonksiyonu kullanılır. Bu sayede yeni durumlar
    // ve değerler üretilebilir.
    emit(names.getRandomElement());
  }
}

class HomePage extends StatefulWidget {
  // Normalde Stateless olarak oluşturduğumuz HomePage'i Statefull hale getirdik.
  // Çünkü Cubit dispose edilmesi gereken bir yapıdır. Stateful ile birlikte
  // initialize ve dispose işlemlerini yapabiliriz.
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubits cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubits();
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
        backgroundColor: Colors.lightGreen.shade400,
        title: const Text(
          "Simple Bloc Project",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder<String?>(
          stream: cubit.stream,
          builder: (context, snapshot) {
            final button = TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Colors.lightGreen.shade400),
              ),
              onPressed: () {
                cubit.pickRandomName();
              },
              child: const Text(
                "Pick a random name!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return button;
              case ConnectionState.waiting:
                return button;
              case ConnectionState.active:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data ?? ''),
                    button,
                  ],
                );
              case ConnectionState.done:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
