import 'package:flutter/foundation.dart';
import '../models/loyalty_card.dart';
import '../services/database_service.dart';

class LoyaltyCardProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<LoyaltyCard> _cards = [];
  bool _isLoading = false;

  List<LoyaltyCard> get cards => _cards;
  bool get isLoading => _isLoading;

  Future<void> loadCards() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cards = await _databaseService.getAllCards();
    } catch (e) {
      debugPrint('Error loading cards: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCard(LoyaltyCard card) async {
    try {
      final id = await _databaseService.insertCard(card);
      final newCard = card.copyWith(id: id);
      _cards.add(newCard);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding card: $e');
      rethrow;
    }
  }

  Future<void> updateCard(LoyaltyCard card) async {
    try {
      await _databaseService.updateCard(card);
      final index = _cards.indexWhere((c) => c.id == card.id);
      if (index != -1) {
        _cards[index] = card;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating card: $e');
      rethrow;
    }
  }

  Future<void> deleteCard(int id) async {
    try {
      await _databaseService.deleteCard(id);
      _cards.removeWhere((card) => card.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting card: $e');
      rethrow;
    }
  }

  Future<List<LoyaltyCard>> getUnsyncedCards() async {
    try {
      return await _databaseService.getUnsyncedCards();
    } catch (e) {
      debugPrint('Error getting unsynced cards: $e');
      return [];
    }
  }

  Future<void> markCardAsSynced(int id) async {
    try {
      await _databaseService.markCardAsSynced(id);
      final index = _cards.indexWhere((c) => c.id == id);
      if (index != -1) {
        _cards[index] = _cards[index].copyWith(isSynced: true);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking card as synced: $e');
      rethrow;
    }
  }
}
