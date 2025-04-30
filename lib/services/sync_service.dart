import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/loyalty_card.dart';
import 'database_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  final DatabaseService _databaseService = DatabaseService();
  bool _isSyncing = false;

  factory SyncService() => _instance;

  SyncService._internal();

  bool get isSyncing => _isSyncing;

  Future<bool> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> syncCards() async {
    if (_isSyncing) return;

    try {
      _isSyncing = true;

      // Check connectivity
      if (!await checkConnectivity()) {
        throw Exception('No internet connection');
      }

      // Get unsynced cards from local database
      final unsyncedCards = await _databaseService.getUnsyncedCards();

      // TODO: Replace with your actual API endpoint
      const apiUrl = 'https://api.example.com/cards';

      // Upload unsynced cards to the cloud
      for (final card in unsyncedCards) {
        try {
          final response = await http.post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(card.toMap()),
          );

          if (response.statusCode == 200) {
            // Mark card as synced in local database
            await _databaseService.markCardAsSynced(card.id!);
          } else {
            throw Exception('Failed to sync card: ${response.statusCode}');
          }
        } catch (e) {
          // Log error but continue with other cards
          print('Error syncing card ${card.id}: $e');
        }
      }

      // TODO: Implement downloading new cards from the cloud
      // This would involve:
      // 1. Getting the last sync timestamp
      // 2. Fetching new cards from the cloud
      // 3. Saving them to the local database
    } catch (e) {
      print('Sync error: $e');
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> startPeriodicSync() async {
    // Check for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        syncCards();
      }
    });

    // Initial sync if connected
    if (await checkConnectivity()) {
      syncCards();
    }
  }
}
