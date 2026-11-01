
class GameRecord {
  final String id;
  final String playerX;
  final String playerO;
  final String mode;
  final String difficulty;
  final String result;
  final DateTime playedAt;

  const GameRecord({
    required this.id,
    required this.playerX,
    required this.playerO,
    required this.mode,
    required this.difficulty,
    required this.result,
    required this.playedAt,
  });

  bool get isDraw => result == 'draw';
  bool get xWon => result == 'X';
  bool get oWon => result == 'O';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerX': playerX,
      'playerO': playerO,
      'mode': mode,
      'difficulty': difficulty,
      'result': result,
      'playedAt': playedAt.toIso8601String(),
    };
  }

  factory GameRecord.fromJson(Map<String, dynamic> json) {
    return GameRecord(
      id: json['id'] as String,
      playerX: json['playerX'] as String,
      playerO: json['playerO'] as String,
      mode: json['mode'] as String,
      difficulty: json['difficulty'] as String? ?? '',
      result: json['result'] as String,
      playedAt: DateTime.parse(json['playedAt'] as String),
    );
  }
}
