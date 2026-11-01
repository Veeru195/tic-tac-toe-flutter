
import 'game_record.dart';

class PlayerStats {
  final int aiWins;
  final int aiLosses;
  final int aiDraws;

  final int localXWins;
  final int localOWins;
  final int localDraws;

  final int currentWinStreak;
  final int bestWinStreak;

  const PlayerStats({
    required this.aiWins,
    required this.aiLosses,
    required this.aiDraws,
    required this.localXWins,
    required this.localOWins,
    required this.localDraws,
    required this.currentWinStreak,
    required this.bestWinStreak,
  });

  int get totalGames =>
      aiWins + aiLosses + aiDraws +
          localXWins + localOWins + localDraws;

  int get totalAiGames => aiWins + aiLosses + aiDraws;

  double get aiWinRate =>
      totalAiGames == 0 ? 0 : aiWins / totalAiGames * 100;

  factory PlayerStats.fromRecords(List<GameRecord> records) {
    int wins = 0;
    int losses = 0;
    int draws = 0;

    int localX = 0;
    int localO = 0;
    int localDraw = 0;

    int streak = 0;
    int bestStreak = 0;

    final aiRecords = records
        .where((record) => record.mode == 'ai')
        .toList()
      ..sort((a, b) => a.playedAt.compareTo(b.playedAt));

    for (final record in records) {
      if (record.mode == 'ai') {
        if (record.result == 'X') {
          wins++;
        } else if (record.result == 'O') {
          losses++;
        } else {
          draws++;
        }
      } else {
        if (record.result == 'X') {
          localX++;
        } else if (record.result == 'O') {
          localO++;
        } else {
          localDraw++;
        }
      }
    }

    for (final record in aiRecords) {
      if (record.result == 'X') {
        streak++;
        if (streak > bestStreak) bestStreak = streak;
      } else {
        streak = 0;
      }
    }

    return PlayerStats(
      aiWins: wins,
      aiLosses: losses,
      aiDraws: draws,
      localXWins: localX,
      localOWins: localO,
      localDraws: localDraw,
      currentWinStreak: streak,
      bestWinStreak: bestStreak,
    );
  }

  factory PlayerStats.empty() {
    return const PlayerStats(
      aiWins: 0,
      aiLosses: 0,
      aiDraws: 0,
      localXWins: 0,
      localOWins: 0,
      localDraws: 0,
      currentWinStreak: 0,
      bestWinStreak: 0,
    );
  }
}
