
import 'package:flutter/material.dart';

import '../models/game_record.dart';
import '../services/ai_engine.dart';
import '../services/stats_service.dart';
import '../theme/app_theme.dart';

class GamePage extends StatefulWidget {
  final String playerX;
  final String playerO;
  final bool vsAI;
  final AiDifficulty difficulty;

  const GamePage({
    super.key,
    required this.playerX,
    required this.playerO,
    required this.vsAI,
    required this.difficulty,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String?> board = List.filled(9, null);
  List<int> winningCells = [];

  bool xTurn = true;
  bool isDraw = false;
  bool thinking = false;
  bool saving = false;

  String? winner;

  int xScore = 0;
  int oScore = 0;
  int draws = 0;
  int round = 1;

  bool recordSaved = false;

  static const winningLines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  String? applyMove(int index, String mark) {
    board[index] = mark;

    for (final line in winningLines) {
      final a = line[0];
      final b = line[1];
      final c = line[2];

      if (board[a] != null &&
          board[a] == board[b] &&
          board[b] == board[c]) {
        winner = mark;
        winningCells = List<int>.from(line);

        if (mark == 'X') {
          xScore++;
        } else {
          oScore++;
        }

        return mark;
      }
    }

    if (!board.contains(null)) {
      isDraw = true;
      draws++;
      return 'draw';
    }

    xTurn = mark == 'O';
    return null;
  }

  void playMove(int index) {
    if (board[index] != null ||
        winner != null ||
        isDraw ||
        thinking ||
        (widget.vsAI && !xTurn)) {
      return;
    }

    String? result;

    setState(() {
      result = applyMove(index, xTurn ? 'X' : 'O');
    });

    if (result != null) {
      saveResult(result!);
      return;
    }

    if (widget.vsAI && !xTurn) {
      setState(() => thinking = true);
      scheduleAiMove();
    }
  }

  void scheduleAiMove() {
    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted || winner != null || isDraw) return;

      final move = AiEngine.chooseMove(
        List<String?>.from(board),
        widget.difficulty,
      );

      if (move == -1) {
        setState(() => thinking = false);
        return;
      }

      String? result;

      setState(() {
        thinking = false;
        result = applyMove(move, 'O');
      });

      if (result != null) {
        saveResult(result!);
      }
    });
  }

  Future<void> saveResult(String result) async {
    if (recordSaved || saving) return;

    recordSaved = true;
    saving = true;

    final record = GameRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      playerX: widget.playerX,
      playerO: widget.playerO,
      mode: widget.vsAI ? 'ai' : 'local',
      difficulty: widget.vsAI ? widget.difficulty.name : '',
      result: result,
      playedAt: DateTime.now(),
    );

    try {
      await StatsService.saveRecord(record);
    } catch (error) {
      recordSaved = false;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to save this match.'),
          ),
        );
      }
    } finally {
      saving = false;
    }
  }

  void nextRound() {
    setState(() {
      board = List.filled(9, null);
      winningCells = [];
      xTurn = true;
      isDraw = false;
      thinking = false;
      winner = null;
      recordSaved = false;
      round++;
    });
  }

  void resetMatch() {
    setState(() {
      board = List.filled(9, null);
      winningCells = [];
      xTurn = true;
      isDraw = false;
      thinking = false;
      winner = null;
      recordSaved = false;
      xScore = 0;
      oScore = 0;
      draws = 0;
      round = 1;
    });
  }

  void confirmReset() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: GameColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Start a new match?',
            style: TextStyle(
              color: GameColors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'The current match scores will be cleared. Saved match history will remain.',
            style: TextStyle(
              color: GameColors.muted,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Keep playing',
                style: TextStyle(color: GameColors.muted),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: GameColors.burgundy,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                resetMatch();
              },
              child: const Text('Reset match'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = winner != null
        ? '${winner == 'X' ? widget.playerX : widget.playerO} wins!'
        : isDraw
        ? "It's a draw!"
        : thinking
        ? 'Computer is thinking...'
        : widget.vsAI && !xTurn
        ? 'Computer\'s turn'
        : '${xTurn ? widget.playerX : widget.playerO}, your turn';

    final statusColor = winner == 'X'
        ? GameColors.sage
        : winner == 'O'
        ? GameColors.burgundy
        : GameColors.ink;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF7F3EA),
              GameColors.background,
              Color(0xFFF0EADC),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 19,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 470),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _header(),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Text(
                          'Match score',
                          style: TextStyle(
                            color: GameColors.ink,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'ROUND ${round.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: GameColors.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _scoreCard(
                            widget.playerX,
                            xScore,
                            'X',
                            GameColors.sage,
                            winner == 'X',
                            winner == null && !isDraw && xTurn,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _scoreCard(
                            widget.playerO,
                            oScore,
                            'O',
                            GameColors.burgundy,
                            winner == 'O',
                            winner == null && !isDraw && !xTurn,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _statusBanner(status, statusColor),
                    const SizedBox(height: 19),
                    _board(),
                    const SizedBox(height: 22),
                    _actionButton(
                      label: winner != null || isDraw
                          ? 'Play next round'
                          : 'Restart round',
                      icon: Icons.refresh_rounded,
                      onTap: nextRound,
                    ),
                    const SizedBox(height: 11),
                    _actionButton(
                      label: 'Reset match and scores',
                      icon: Icons.restart_alt_rounded,
                      onTap: confirmReset,
                      secondary: true,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'DRAWS: $draws',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: GameColors.muted,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (saving)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          'Saving match...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: GameColors.muted,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Material(
          color: GameColors.surface,
          borderRadius: BorderRadius.circular(13),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(13),
            child: const SizedBox(
              width: 43,
              height: 43,
              child: Icon(
                Icons.arrow_back_rounded,
                color: GameColors.ink,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Tic Tac Toe',
          style: TextStyle(
            color: GameColors.ink,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        _smallBadge(widget.vsAI ? 'VS COMPUTER' : 'TWO PLAYER'),
      ],
    );
  }

  Widget _smallBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: GameColors.sageLight,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: GameColors.sage,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _scoreCard(
      String name,
      int score,
      String symbol,
      Color color,
      bool isWinner,
      bool isActive,
      ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: GameColors.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: isWinner
              ? GameColors.gold
              : isActive
              ? color.withValues(alpha: 0.65)
              : GameColors.border,
          width: isWinner || isActive ? 1.6 : 1,
        ),
        boxShadow: isWinner
            ? [
          BoxShadow(
            color: GameColors.gold.withValues(alpha: 0.2),
            blurRadius: 15,
          ),
        ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            width: 41,
            height: 41,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Text(
                symbol,
                style: TextStyle(
                  color: color,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    '$score',
                    key: ValueKey(score),
                    style: const TextStyle(
                      color: GameColors.ink,
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (isWinner)
                  const Text(
                    'WINNER',
                    style: TextStyle(
                      color: GameColors.gold,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBanner(String status, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(
            winner != null
                ? Icons.emoji_events_rounded
                : isDraw
                ? Icons.handshake_rounded
                : thinking
                ? Icons.psychology_rounded
                : Icons.sports_esports_rounded,
            color: color,
            size: 19,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                status,
                key: ValueKey(status),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _board() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: GameColors.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: GameColors.border),
          boxShadow: [
            BoxShadow(
              color: GameColors.ink.withValues(alpha: 0.05),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 9,
            mainAxisSpacing: 9,
          ),
          itemBuilder: (context, index) {
            final mark = board[index];
            final color = mark == 'X'
                ? GameColors.sage
                : GameColors.burgundy;

            final isWinningCell = winningCells.contains(index);

            return AnimatedOpacity(
              duration: const Duration(milliseconds: 350),
              opacity: winner != null && !isWinningCell ? 0.5 : 1,
              child: Material(
                color: mark == null
                    ? GameColors.beige
                    : color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () => playMove(index),
                  borderRadius: BorderRadius.circular(16),
                  splashColor: color.withValues(alpha: 0.2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeInOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isWinningCell
                            ? GameColors.gold
                            : mark == null
                            ? Colors.transparent
                            : color.withValues(alpha: 0.4),
                        width: isWinningCell ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: mark == null
                            ? const SizedBox.shrink(
                          key: ValueKey('empty'),
                        )
                            : Text(
                          mark,
                          key: ValueKey('$index-$mark'),
                          style: TextStyle(
                            color: color,
                            fontSize: 55,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool secondary = false,
  }) {
    final color = secondary ? GameColors.surface : GameColors.sage;
    final textColor = secondary ? GameColors.ink : Colors.white;

    return SizedBox(
      height: secondary ? 49 : 55,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: secondary ? GameColors.burgundy : Colors.white,
          size: 18,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          elevation: secondary ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: secondary
                ? const BorderSide(color: GameColors.border)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
