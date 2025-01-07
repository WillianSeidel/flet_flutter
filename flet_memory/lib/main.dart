import 'package:flet_memory/telas/game_screen.dart';
import 'package:flet_memory/telas/home_screen.dart';
import 'package:flutter/material.dart';

//import 'ranking_screen.dart';
//import 'store_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo de Memória',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/game': (context) => GameScreen(
              userName: '',
            ),
        //'/ranking': (context) => RankingScreen(),
        //'/store': (context) => StoreScreen(),
      },
    );
  }
}
