import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final VoidCallback onRetry;
  final VoidCallback onReturn;
  final String userId;

  const GameOverScreen({
    Key? key,
    required this.score,
    required this.onRetry,
    required this.onReturn,
    required this.userId,
  }) : super(key: key);

  void _saveScore() async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'score': FieldValue.increment(score),
    });
  }

  @override
  Widget build(BuildContext context) {
    _saveScore(); // Salva a pontuação quando a tela é exibida

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
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Jogar Novamente'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onReturn,
                child: const Text('Retornar para a Tela Inicial'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
