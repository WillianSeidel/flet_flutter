import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChooseNicknameScreen extends StatelessWidget {
  final String userId;

  ChooseNicknameScreen({required this.userId});

  final TextEditingController nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Escolha seu Nickname')),
      body: Column(
        children: [
          TextField(
            controller: nicknameController,
            decoration: InputDecoration(labelText: 'Nickname'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('users').doc(userId).set({
                'nickname': nicknameController.text,
                'avatarUrl':
                    'https://link-do-avatar.com/avatar1.png', // Avatar fixo ou escolha do usuário
                'score': 0,
              });
              Navigator.pop(context); // Retorna à tela inicial
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
