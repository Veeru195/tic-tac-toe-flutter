
import 'package:flutter/material.dart';

import '../models/game_record.dart';
import '../models/player_stats.dart';
import '../services/stats_service.dart';
import '../theme/app_theme.dart';

class ProfilePage extends StatefulWidget {
  final bool isActive;

  const ProfilePage({
    super.key,
    this.isActive = false,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<GameRecord>> recordsFuture;

  @override
  void initState() {
    super.initState();
    recordsFuture = StatsService.loadRecords();
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isActive && widget.isActive) {
      refreshStats();
    }
  }

  void refreshStats() {
    setState(() {
      recordsFuture = StatsService.loadRecords();
    });
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
          return const Center(
            child: Text('Unable to load profile statistics.'),
          );
        }

        final records = snapshot.data ?? [];
        final stats = PlayerStats.fromRecords(records);

        return RefreshIndicator(
          color: GameColors.sage,
          onRefresh: () async => refreshStats(),
          child: ListView(
            padding: const EdgeInsets.all(23),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your profile',
                      style: TextStyle(
                        color: GameColors.ink,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: refreshStats,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: GameColors.sage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 19),
              _profileHeader(),
              const SizedBox(height: 26),
              const Text(
                'PERFORMANCE AGAINST AI',
                style: TextStyle(
                  color: GameColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      'Wins',
                      stats.aiWins,
                      GameColors.sage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statCard(
                      'Losses',
                      stats.aiLosses,
                      GameColors.burgundy,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statCard(
                      'Draws',
                      stats.aiDraws,
                      GameColors.lavender,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _winRateCard(stats),
              const SizedBox(height: 20),
              const Text(
                'PERSONAL RECORDS',
                style: TextStyle(
                  color: GameColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 13),
              _detailCard(
                'Current winning streak',
                '${stats.currentWinStreak}',
                Icons.local_fire_department_rounded,
                GameColors.burgundy,
              ),
              const SizedBox(height: 10),
              _detailCard(
                'Best winning streak',
                '${stats.bestWinStreak}',
                Icons.emoji_events_outlined,
                GameColors.gold,
              ),
              const SizedBox(height: 10),
              _detailCard(
                'Total completed matches',
                '${stats.totalGames}',
                Icons.sports_esports_rounded,
                GameColors.sage,
              ),
              const SizedBox(height: 23),
              const Text(
                'LOCAL MULTIPLAYER',
                style: TextStyle(
                  color: GameColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 13),
              _detailCard(
                'Player X wins',
                '${stats.localXWins}',
                Icons.circle_outlined,
                GameColors.sage,
              ),
              const SizedBox(height: 10),
              _detailCard(
                'Player O wins',
                '${stats.localOWins}',
                Icons.circle_outlined,
                GameColors.burgundy,
              ),
              const SizedBox(height: 10),
              _detailCard(
                'Drawn matches',
                '${stats.localDraws}',
                Icons.handshake_outlined,
                GameColors.gold,
              ),
              const SizedBox(height: 18),
              const Text(
                'Statistics are calculated from completed matches saved on this device.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GameColors.muted,
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF50384F),
            Color(0xFF332A3B),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFD6B574),
            child: Icon(
              Icons.person_rounded,
              color: Color(0xFF29202D),
              size: 33,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Player profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Your personal gaming statistics',
                  style: TextStyle(
                    color: CoverColors.silverMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color: GameColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GameColors.border),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: GameColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _winRateCard(PlayerStats stats) {
    final rate = stats.aiWinRate;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GameColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GameColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI win percentage',
            style: TextStyle(
              color: GameColors.ink,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            stats.totalAiGames == 0
                ? '—'
                : '${rate.toStringAsFixed(1)}%',
            style: const TextStyle(
              color: GameColors.sage,
              fontWeight: FontWeight.w900,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: rate / 100,
              minHeight: 9,
              backgroundColor: GameColors.beige,
              color: GameColors.sage,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            stats.totalAiGames == 0
                ? 'Complete an AI match to calculate your win rate.'
                : '${stats.totalAiGames} completed AI matches',
            style: const TextStyle(
              color: GameColors.muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GameColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GameColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: GameColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
