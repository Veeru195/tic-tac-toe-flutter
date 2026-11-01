
import 'dart:math';

enum AiDifficulty {
  easy,
  medium,
  hard,
}

class AiEngine {
  static final Random _random = Random();

  static int chooseMove(
      List<String?> board,
      AiDifficulty difficulty,
      ) {
    final available = <int>[
      for (int i = 0; i < 9; i++)
        if (board[i] == null) i,
    ];

    if (available.isEmpty) return -1;

    switch (difficulty) {
      case AiDifficulty.easy:
        return available[_random.nextInt(available.length)];

      case AiDifficulty.medium:
        return _mediumMove(board, available);

      case AiDifficulty.hard:
        return _hardMove(board, available);
    }
  }

  static int _mediumMove(
      List<String?> board,
      List<int> available,
      ) {
    // Take a winning move.
    final win = _winningMove(board, 'O');
    if (win != -1) return win;

    // Block the player's winning move.
    final block = _winningMove(board, 'X');
    if (block != -1) return block;

    // Prefer the center.
    if (board[4] == null) return 4;

    // Prefer corners.
    final corners = [0, 2, 6, 8]
        .where((i) => board[i] == null)
        .toList();

    if (corners.isNotEmpty) {
      return corners[_random.nextInt(corners.length)];
    }

    return available[_random.nextInt(available.length)];
  }

  static int _winningMove(List<String?> board, String mark) {
    for (int i = 0; i < 9; i++) {
      if (board[i] != null) continue;

      board[i] = mark;
      final wins = _winner(board) == mark;
      board[i] = null;

      if (wins) return i;
    }

    return -1;
  }

  static int _hardMove(
      List<String?> board,
      List<int> available,
      ) {
    int bestScore = -999;
    final bestMoves = <int>[];

    for (final index in available) {
      board[index] = 'O';

      final score = _minimax(
        board,
        false,
        1,
      );

      board[index] = null;

      if (score > bestScore) {
        bestScore = score;
        bestMoves
          ..clear()
          ..add(index);
      } else if (score == bestScore) {
        bestMoves.add(index);
      }
    }

    return bestMoves[_random.nextInt(bestMoves.length)];
  }

  static int _minimax(
      List<String?> board,
      bool maximizing,
      int depth,
      ) {
    final winner = _winner(board);

    if (winner == 'O') return 10 - depth;
    if (winner == 'X') return depth - 10;

    if (!board.contains(null)) return 0;

    if (maximizing) {
      int best = -999;

      for (int i = 0; i < 9; i++) {
        if (board[i] == null) {
          board[i] = 'O';

          best = max(
            best,
            _minimax(board, false, depth + 1),
          );

          board[i] = null;
        }
      }

      return best;
    }

    int best = 999;

    for (int i = 0; i < 9; i++) {
      if (board[i] == null) {
        board[i] = 'X';

        best = min(
          best,
          _minimax(board, true, depth + 1),
        );

        board[i] = null;
      }
    }

    return best;
  }

  static String? _winner(List<String?> board) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (final line in lines) {
      final a = line[0];
      final b = line[1];
      final c = line[2];

      if (board[a] != null &&
          board[a] == board[b] &&
          board[b] == board[c]) {
        return board[a];
      }
    }

    return null;
  }
}
