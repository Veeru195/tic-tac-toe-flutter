
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_record.dart';
import '../models/player_stats.dart';

class StatsService {
  static const String _recordsKey = 'tic_tac_toe_records_v1';

  static Future<List<GameRecord>> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_recordsKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;

      final records = decoded.map((item) {
        return GameRecord.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();

      records.sort(
            (a, b) => b.playedAt.compareTo(a.playedAt),
      );

      return records;
    } catch (error) {
      throw FormatException(
        'Unable to read saved match records: $error',
      );
    }
  }

  static Future<void> saveRecord(GameRecord record) async {
    final prefs = await SharedPreferences.getInstance();

    final records = await loadRecords();

    // Prevent accidental duplicate writes.
    if (records.any((item) => item.id == record.id)) {
      return;
    }

    records.insert(0, record);

    // Keep the most recent 200 matches.
    final limitedRecords = records.take(200).toList();

    final encoded = jsonEncode(
      limitedRecords.map((record) => record.toJson()).toList(),
    );

    final saved = await prefs.setString(_recordsKey, encoded);

    if (!saved) {
      throw Exception('Could not save match history.');
    }
  }

  static Future<PlayerStats> loadStats() async {
    final records = await loadRecords();
    return PlayerStats.fromRecords(records);
  }

  static Future<void> clearRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recordsKey);
  }
}
