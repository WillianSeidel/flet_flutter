import 'package:flet_memory/telas/cadastro_user.dart';
import 'package:flet_memory/telas/game_over.dart';
import 'package:flet_memory/telas/game_screen.dart';
import 'package:flet_memory/telas/home_screen.dart';
import 'package:flet_memory/telas/tela_ranking.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo de Memória',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) =>
            ChooseNicknameScreen(userId: 'userId'), // Passar o userId correto
        '/game': (context) => GameScreen(
              username: 'username',
              userId: 'IdDoUsuario',
            ), // Passar o username correto
        '/ranking': (context) => RankingScreen(),
        '/game_over': (context) => GameOverScreen(
              score: 0,
              onRetry: () {},
              onReturn: () {},
              userId: 'userId', // Passar o userId correto
            ),
      },
    );
  }
}
