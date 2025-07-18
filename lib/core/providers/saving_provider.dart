import 'package:flutter/material.dart';
import 'package:kumbara/core/enums/saving_enum.dart';

import '../../models/saving.dart';
import '../../models/saving_transaction.dart';
import '../../services/ads_service.dart';
import '../../services/saving_service.dart';

class SavingProvider with ChangeNotifier {
  final SavingService _savingService = SavingService();

  List<Saving> _savings = [];
  Map<String, dynamic>? _dashboardStats;
  bool _isLoading = false;
  String? _error;

  List<Saving> get savings => _savings;
  Map<String, dynamic>? get dashboardStats => _dashboardStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Saving> get activeSavings => _savings.where((saving) => saving.status == SavingStatus.active).toList();

  Future<void> loadSavings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _savings = await _savingService.getAllSavings();
    } catch (e) {
      _error = 'Birikimler yüklenirken hata oluştu: $e';
      debugPrint('Error loading savings: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadDashboardStats() async {
    try {
      _dashboardStats = await _savingService.getDashboardStats();
      debugPrint('Dashboard stats loaded successfully: $_dashboardStats');
      notifyListeners();
    } catch (e) {
      _error = 'Dashboard istatistikleri yüklenirken hata oluştu: $e';
      debugPrint('Error loading dashboard stats: $e');
      // Hata durumunda boş stats sağla
      _dashboardStats = {'totalSavings': 0, 'activeSavings': 0, 'totalAmount': 0.0, 'nearestTarget': null};
      notifyListeners();
    }
  }

  Future<bool> createSaving(Saving saving) async {
    try {
      await _savingService.createSaving(saving);
      await loadSavings();
      await loadDashboardStats();
      return true;
    } catch (e) {
      _error = 'Birikim oluşturulurken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSaving(Saving saving) async {
    try {
      await _savingService.updateSaving(saving);
      await loadSavings();
      await loadDashboardStats();
      return true;
    } catch (e) {
      _error = 'Birikim güncellenirken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSaving(int id) async {
    try {
      await _savingService.deleteSaving(id);
      await loadSavings();
      await loadDashboardStats();
      return true;
    } catch (e) {
      _error = 'Birikim silinirken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> addMoneyToSaving(int savingId, double amount, {String? note}) async {
    try {
      await _savingService.addMoneyToSaving(savingId, amount, note: note);
      await loadSavings();
      await loadDashboardStats();

      // Hedef tamamlanmış mı kontrol et
      await _savingService.checkAndCompleteGoals();

      // Para ekleme işleminden sonra interstitial reklam göster
      AdsService.instance.showActionInterstitialAd();

      return true;
    } catch (e) {
      _error = 'Para eklenirken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  Future<List<SavingTransaction>> getTransactionsBySavingId(int savingId) async {
    try {
      return await _savingService.getTransactionsBySavingId(savingId);
    } catch (e) {
      debugPrint('Error loading transactions: $e');
      return [];
    }
  }

  Future<bool> deleteTransaction(int id) async {
    try {
      await _savingService.deleteTransaction(id);
      await loadSavings();
      await loadDashboardStats();
      return true;
    } catch (e) {
      _error = 'İşlem silinirken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSavingStatus(int savingId, SavingStatus status) async {
    try {
      await _savingService.updateSavingStatus(savingId, status);
      await loadSavings();
      await loadDashboardStats();
      return true;
    } catch (e) {
      _error = 'Durum güncellenirken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  Saving? getSavingById(int id) {
    try {
      return _savings.firstWhere((saving) => saving.id == id);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
