import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final VoidCallback onRetry;
  final VoidCallback onReturn;

  const GameOverScreen({
    Key? key,
    required this.score,
    required this.onRetry,
    required this.onReturn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Você perdeu!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Seu score foi de $score pontos.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: onRetry,
                child: Text('Jogar Novamente'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: onReturn,
                child: Text('Retornar para a Tela Inicial'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
