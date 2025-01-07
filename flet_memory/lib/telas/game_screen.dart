import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final String userName;

  GameScreen({required this.userName});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0; // Pontuação do jogador
  int timeLeft = 30; // Tempo restante em segundos
  int phase = 1; // Fase do jogo
  int mistakes = 0; // Contador de erros
  late Timer _timer; // Timer para contagem regressiva
  List<int> highlightedSquares = []; // Índices dos quadrados destacados
  List<int> selectedSquares = []; // Índices selecionados pelo usuário

  @override
  void initState() {
    super.initState();
    startTimer();
    highlightRandomSquares();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          navigateToGameOver();
        }
      });
    });
  }

  void highlightRandomSquares() {
    // Sorteia 3 índices aleatórios no grid (sem repetir)
    Random random = Random();
    Set<int> uniqueIndexes = {};
    while (uniqueIndexes.length < 3) {
      uniqueIndexes.add(random.nextInt(64));
    }
    highlightedSquares = uniqueIndexes.toList();

    // Destaca os quadrados por 2 segundos e depois "esconde"
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        highlightedSquares = []; // Esconde os destaques
      });
    });
  }

  void handleSquareTap(int index) {
    if (selectedSquares.contains(index))
      return; // Evita cliques repetidos no mesmo quadrado

    setState(() {
      if (highlightedSquares.contains(index)) {
        // Acerto
        selectedSquares.add(index);
        score += 3;
      } else {
        // Erro
        mistakes++;
        if (mistakes == 2) {
          navigateToGameOver();
        }
      }

      // Avança de fase se todos os 3 quadrados forem acertados
      if (selectedSquares.length == 3) {
        nextPhase();
      }
    });
  }

  void nextPhase() {
    setState(() {
      phase++;
      selectedSquares.clear();
      mistakes = 0; // Reinicia os erros
      timeLeft = 30; // Reinicia o timer
      highlightRandomSquares();
    });
  }

  void navigateToGameOver() {
    Navigator.pushNamed(context, '/gameover', arguments: score);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo de Memória'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Nome do Usuário, Score, Time Left e Fase
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${widget.userName} | Score: $score'),
                    Text('Time Left: $timeLeft s'),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Fase: $phase'),
              ],
            ),
          ),
          // Grid de quadrados
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 64,
              itemBuilder: (context, index) {
                bool isHighlighted = highlightedSquares.contains(index);
                bool isSelected = selectedSquares.contains(index);

                return InkWell(
                  onTap: () {
                    handleSquareTap(index);
                    debugPrint('Quadrado $index clicado'); // Log para depuração
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green
                          : isHighlighted
                              ? Colors.yellow
                              : Colors.blue,
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          // Botão para retornar à tela inicial
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Voltar à Tela Inicial'),
            ),
          ),
        ],
      ),
    );
  }
}
