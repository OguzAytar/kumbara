import 'package:kumbara/core/enums/saving_enum.dart';

import '../models/saving.dart';
import '../models/saving_transaction.dart';
import 'database_helper.dart';

class SavingService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Birikim işlemleri
  Future<int> createSaving(Saving saving) async {
    return await _databaseHelper.insertSaving(saving);
  }

  Future<List<Saving>> getAllSavings() async {
    return await _databaseHelper.getAllSavings();
  }

  Future<Saving?> getSavingById(int id) async {
    return await _databaseHelper.getSavingById(id);
  }

  Future<void> updateSaving(Saving saving) async {
    await _databaseHelper.updateSaving(saving);
  }

  Future<void> deleteSaving(int id) async {
    await _databaseHelper.deleteSaving(id);
  }

  // Aktif birikimler
  Future<List<Saving>> getActiveSavings() async {
    final allSavings = await getAllSavings();
    return allSavings.where((saving) => saving.status == SavingStatus.active).toList();
  }

  // Transaction işlemleri
  Future<int> addTransaction(SavingTransaction transaction) async {
    return await _databaseHelper.insertTransaction(transaction);
  }

  Future<List<SavingTransaction>> getTransactionsBySavingId(int savingId) async {
    return await _databaseHelper.getTransactionsBySavingId(savingId);
  }

  Future<void> deleteTransaction(int id) async {
    await _databaseHelper.deleteTransaction(id);
  }

  // Para ekleme
  Future<void> addMoneyToSaving(int savingId, double amount, {String? note}) async {
    final transaction = SavingTransaction(
      savingId: savingId,
      amount: amount,
      date: DateTime.now(),
      note: note,
    );
    await addTransaction(transaction);
  }

  // Birikim durumunu güncelle
  Future<void> updateSavingStatus(int savingId, SavingStatus status) async {
    final saving = await getSavingById(savingId);
    if (saving != null) {
      final updatedSaving = saving.copyWith(status: status);
      await updateSaving(updatedSaving);
    }
  }

  // Dashboard istatistikleri
  Future<Map<String, dynamic>> getDashboardStats() async {
    return await _databaseHelper.getDashboardStats();
  }

  // Hedef tamamlanmış mı kontrol et
  Future<void> checkAndCompleteGoals() async {
    final activeSavings = await getActiveSavings();
    
    for (final saving in activeSavings) {
      if (saving.currentAmount >= saving.targetAmount) {
        await updateSavingStatus(saving.id!, SavingStatus.completed);
      }
    }
  }

  // En çok birikim yapılan hedef
  Future<Saving?> getMostProgressedSaving() async {
    final allSavings = await getAllSavings();
    if (allSavings.isEmpty) return null;
    
    Saving? mostProgressed;
    double highestProgress = 0;
    
    for (final saving in allSavings) {
      if (saving.completionPercentage > highestProgress) {
        highestProgress = saving.completionPercentage;
        mostProgressed = saving;
      }
    }
    
    return mostProgressed;
  }

  // En yakın tarihli hedef
  Future<Saving?> getNearestTargetSaving() async {
    final activeSavings = await getActiveSavings();
    if (activeSavings.isEmpty) return null;
    
    activeSavings.sort((a, b) => a.targetDate.compareTo(b.targetDate));
    return activeSavings.first;
  }

  // Aylık progress
  Future<List<Map<String, dynamic>>> getMonthlyProgress() async {
    final now = DateTime.now();
    final months = <Map<String, dynamic>>[];
    
    for (int i = 0; i < 12; i++) {
      final monthStart = DateTime(now.year, i + 1, 1);
      final monthEnd = DateTime(now.year, i + 2, 0);
      
      // Bu aydaki tüm transaction'ları getir
      final allSavings = await getAllSavings();
      double monthlyTotal = 0;
      
      for (final saving in allSavings) {
        final transactions = await getTransactionsBySavingId(saving.id!);
        final monthlyTransactions = transactions.where((t) =>
          t.date.isAfter(monthStart) && t.date.isBefore(monthEnd)
        );
        
        monthlyTotal += monthlyTransactions.fold(0.0, (sum, t) => sum + t.amount);
      }
      
      months.add({
        'month': i + 1,
        'monthName': _getMonthName(i + 1),
        'amount': monthlyTotal,
      });
    }
    
    return months;
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return monthNames[month - 1];
  }
}
