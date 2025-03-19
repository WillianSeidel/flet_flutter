import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('score', descending: true) // Ordena por pontuação
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final nickname = user['nickname'];
              final avatarUrl = user['avatarUrl'];
              final score = user['score'];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                title: Text(nickname),
                subtitle: Text('Score: $score'),
                trailing: Text('#${index + 1}'), // Posição no ranking
              );
            },
          );
        },
      ),
    );
  }
}
