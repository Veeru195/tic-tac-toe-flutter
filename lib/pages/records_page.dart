
import 'package:flutter/material.dart';

import '../models/game_record.dart';
import '../services/stats_service.dart';
import '../theme/app_theme.dart';

class RecordsPage extends StatefulWidget {
  final bool isActive;

  const RecordsPage({
    super.key,
    this.isActive = false,
  });

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  late Future<List<GameRecord>> recordsFuture;

  @override
  void initState() {
    super.initState();
    recordsFuture = StatsService.loadRecords();
  }

  @override
  void didUpdateWidget(covariant RecordsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isActive && widget.isActive) {
      refreshRecords();
    }
  }

  void refreshRecords() {
    setState(() {
      recordsFuture = StatsService.loadRecords();
    });
  }

  String formatDate(DateTime date) {
    final d = date.toLocal();
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GameRecord>>(
      future: recordsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: GameColors.sage,
            ),
          );
        }

        if (snapshot.hasError) {
          return _message(
            'Unable to load match history.',
            Icons.error_outline_rounded,
          );
        }

        final records = snapshot.data ?? [];

        return RefreshIndicator(
          color: GameColors.sage,
          onRefresh: () async => refreshRecords(),
          child: records.isEmpty
              ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(25),
            children: [
              const SizedBox(height: 120),
              _message(
                'Your completed matches will appear here.',
                Icons.history_rounded,
              ),
            ],
          )
              : ListView(
            padding: const EdgeInsets.all(23),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Match records',
                      style: TextStyle(
                        color: GameColors.ink,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: refreshRecords,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: GameColors.sage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${records.length} completed matches',
                style: const TextStyle(
                  color: GameColors.muted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 22),
              ...records.map(
                    (record) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _recordCard(record),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _recordCard(GameRecord record) {
    final isAi = record.mode == 'ai';

    final resultText = record.isDraw
        ? 'Draw'
        : record.result == 'X'
        ? isAi
        ? 'You won'
        : '${record.playerX} won'
        : isAi
        ? 'AI won'
        : '${record.playerO} won';

    final resultColor = record.isDraw
        ? GameColors.gold
        : record.result == 'X'
        ? GameColors.sage
        : GameColors.burgundy;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: GameColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GameColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isAi
                    ? Icons.smart_toy_outlined
                    : Icons.people_outline_rounded,
                color: isAi ? GameColors.burgundy : GameColors.sage,
                size: 19,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isAi ? 'Against computer' : 'Two players',
                  style: const TextStyle(
                    color: GameColors.ink,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                resultText,
                style: TextStyle(
                  color: resultColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            isAi
                ? '${record.playerX} vs Computer'
                : '${record.playerX} vs ${record.playerO}',
            style: const TextStyle(
              color: GameColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Text(
                formatDate(record.playedAt),
                style: const TextStyle(
                  color: GameColors.muted,
                  fontSize: 10,
                ),
              ),
              if (isAi && record.difficulty.isNotEmpty) ...[
                const SizedBox(width: 10),
                Text(
                  record.difficulty.toUpperCase(),
                  style: const TextStyle(
                    color: GameColors.burgundy,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _message(String message, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: GameColors.sage, size: 45),
        const SizedBox(height: 17),
        Text(
          'No matches yet',
          style: const TextStyle(
            color: GameColors.ink,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: GameColors.muted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
