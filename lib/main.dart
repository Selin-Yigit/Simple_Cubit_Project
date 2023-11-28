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

class NamesCubits extends Cubit<String?>{
  // Cubit bir initial state almak zorundadır. Yani başlangıçta bir değerin olup olmadığı
  // Burada konrol edilmelidir. Bizim başlangıçta bir değerimiz olmayacağı için 
  // Super içine "null" verdik.
  NamesCubits() : super(null);
  
  void pickRandomName(){
    // Burada state'in sadece getter'ı bulunur ve Cubit'in o anki durumunu getirir.
    // Yani state'e yeni bir durum verilemez Çünkü setter bulunmaz. 
    // Yeni bir state üretmek için emit fonksiyonu kullanılır. Bu sayede yeni durumlar
    // ve değerler üretilebilir.
    emit(names.getRandomElement());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Container(),
    );
  }
}
