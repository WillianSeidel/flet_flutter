import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'game_over.dart';

class GameScreen extends StatefulWidget {
  final String username;
  final String userId; // Adicionamos o userId para salvar a pontuação

  const GameScreen({Key? key, required this.username, required this.userId})
      : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int gridSize = 8;
  static const int numberOfSquares = 3;
  static const int timePerLevel = 30; // 30 segundos por fase.

  List<int> highlightedSquares = [];
  List<int> selectedSquares = [];
  int score = 0;
  int phase = 1;
  int timeLeft = timePerLevel;
  int errors = 0;
  Timer? timer;
  bool isRevealing = true; // Controle para mostrar os quadrados no início.

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      score = 0;
      phase = 1;
      errors = 0;
      timeLeft = timePerLevel;
      startNewLevel();
    });
  }

  void startNewLevel() {
    timer?.cancel(); // Para o tempo da fase anterior.
    setState(() {
      timeLeft = timePerLevel;
      selectedSquares.clear();
      highlightedSquares = _generateRandomSquares();
      isRevealing = true;
    });

    // Mostra os quadrados por 2 segundos antes de escondê-los.
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isRevealing = false;
      });
      startTimer();
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          showGameOver();
        }
      });
    });
  }

  void checkSquare(int index) {
    if (highlightedSquares.contains(index)) {
      setState(() {
        selectedSquares.add(index);
        score += 3;
      });

      // Verifica se o jogador acertou todos os quadrados.
      if (selectedSquares.toSet().containsAll(highlightedSquares)) {
        timer?.cancel();
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            phase++;
            startNewLevel();
          });
        });
      }
    } else {
      setState(() {
        errors++;
      });

      // Marca o quadrado como vermelho.
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          selectedSquares.add(index);
        });
      });

      if (errors >= 2) {
        timer?.cancel();
        Future.delayed(const Duration(milliseconds: 500), showGameOver);
      }
    }
  }

  void showGameOver() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameOverScreen(
          score: score,
          onRetry: () {
            Navigator.pop(context); // Fecha GameOverScreen
            startGame(); // Reinicia o jogo
          },
          onReturn: () {
            Navigator.pop(context); // Fecha GameOverScreen
            Navigator.pop(context); // Retorna à tela inicial
          },
          userId: widget.userId, // Passa o userId para salvar a pontuação
        ),
      ),
    );
  }

  List<int> _generateRandomSquares() {
    Random random = Random();
    List<int> squares = [];
    while (squares.length < numberOfSquares) {
      int square = random.nextInt(gridSize * gridSize);
      if (!squares.contains(square)) {
        squares.add(square);
      }
    }
    return squares;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header com Username, Score e Tempo.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Usuário: ${widget.username}\nScore: $score',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Time Left: ${timeLeft}s',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Text(
            'Fase $phase',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Grid de quadrados.
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                bool isHighlighted = highlightedSquares.contains(index);
                bool isSelected = selectedSquares.contains(index);

                return GestureDetector(
                  onTap: !isRevealing && !isSelected
                      ? () => checkSquare(index)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isRevealing
                          ? (isHighlighted ? Colors.yellow : Colors.blue)
                          : (isSelected
                              ? (highlightedSquares.contains(index)
                                  ? Colors.green
                                  : Colors.red)
                              : Colors.blue),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
