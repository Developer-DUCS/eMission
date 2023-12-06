import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Player {
  final String name;
  final int score;

  Player(this.name, this.score);
}

class MyApp extends StatelessWidget {
  final List<Player> players = [
    Player('Alice', 150),
    Player('Bob', 200),
    Player('Charlie', 180),
    Player('David', 170),
    Player('Eve', 190),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Leaderboard(players: players),
    );
  }
}

class Leaderboard extends StatelessWidget {
  final List<Player> players;

  const Leaderboard({Key? key, required this.players}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text('${index + 1}'), // Rank
            title: Text(players[index].name),
            trailing: Text('${players[index].score}'), // Score
          );
        },
      ),
    );
  }
}