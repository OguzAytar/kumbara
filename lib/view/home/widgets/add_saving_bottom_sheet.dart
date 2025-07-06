import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kumbara/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/saving_enum.dart';
import '../../../core/functions/firebase_analytics_helper.dart';
import '../../../core/providers/saving_provider.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../models/saving.dart';

class AddSavingBottomSheet extends StatefulWidget {
  final Saving? saving; // Null ise yeni birikim, değilse düzenleme modu
  
  const AddSavingBottomSheet({super.key, this.saving});

  @override
  State<AddSavingBottomSheet> createState() => _AddSavingBottomSheetState();
}

class _AddSavingBottomSheetState extends State<AddSavingBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _initialAmountController = TextEditingController();
  final _addMoneyController = TextEditingController();

  DateTime? _targetDate;
  bool _hasTargetAmount = false;
  bool _hasTargetDate = false;
  bool _hasInitialAmount = false;
  bool _isLoading = false;
  
  bool get _isEditMode => widget.saving != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _populateFieldsFromSaving();
    }
  }

  void _populateFieldsFromSaving() {
    final saving = widget.saving!;
    _nameController.text = saving.title;
    _descriptionController.text = saving.description;
    
    if (saving.targetAmount > 0) {
      _hasTargetAmount = true;
      _targetAmountController.text = saving.targetAmount.toString();
    }
    
    if (saving.targetDate.isAfter(DateTime.now())) {
      _hasTargetDate = true;
      _targetDate = saving.targetDate;
    }
    
    if (saving.currentAmount > 0) {
      _hasInitialAmount = true;
      _initialAmountController.text = saving.currentAmount.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    _initialAmountController.dispose();
    _addMoneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), 
          topRight: Radius.circular(20)
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            _isEditMode 
              ? AppLocalizations.of(context)!.editSaving 
              : AppLocalizations.of(context)!.addNewSaving,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close), 
            onPressed: () => Navigator.of(context).pop()
          ),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _saveSaving,
              child: _isLoading
                  ? const SizedBox(
                      width: 20, 
                      height: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2)
                    )
                  : Text(
                      _isEditMode 
                        ? AppLocalizations.of(context)!.update 
                        : AppLocalizations.of(context)!.save,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Birikim Adı
                _buildSectionTitle(AppLocalizations.of(context)!.savingName),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.savingNameHint,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterSavingName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Açıklama
                _buildSectionTitle(AppLocalizations.of(context)!.description),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.descriptionHint,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 24),

                // Mevcut Tutar ve Para Ekleme (sadece düzenleme modunda)
                if (_isEditMode) ...[
                  _buildSectionTitle(AppLocalizations.of(context)!.currentAmount),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.account_balance_wallet, color: Colors.green, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          '₺${widget.saving!.currentAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.currentAmount,
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    AppLocalizations.of(context)!.addMoney,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addMoneyController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.addMoneyHint,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.add_circle, color: Colors.green),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Hızlı tutar chip'leri
                  _buildQuickAmountChips(),
                  const SizedBox(height: 24),
                ],

                // Başlangıç Tutarı (sadece yeni birikim oluştururken)
                if (!_isEditMode) ...[
                  _buildSectionTitle(AppLocalizations.of(context)!.initialAmount),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.setInitialAmount),
                    subtitle: Text(AppLocalizations.of(context)!.initialAmountDesc),
                    value: _hasInitialAmount,
                    onChanged: (value) {
                      setState(() {
                        _hasInitialAmount = value;
                        if (!value) {
                          _initialAmountController.clear();
                        }
                      });
                    },
                  ),
                  if (_hasInitialAmount) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _initialAmountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.initialAmountHint,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.attach_money),
                        filled: true,
                        fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                      ),
                      validator: _hasInitialAmount
                          ? (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppLocalizations.of(context)!.pleaseEnterValidAmount;
                              }
                              final amount = double.tryParse(value);
                              if (amount == null || amount < 0) {
                                return AppLocalizations.of(context)!.pleaseEnterValidAmount;
                              }
                              return null;
                            }
                          : null,
                    ),
                  ],
                  const SizedBox(height: 24),
                ],

                // Hedef Tutarı
                _buildSectionTitle(AppLocalizations.of(context)!.targetAmount),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.setTargetAmount),
                  subtitle: Text(AppLocalizations.of(context)!.setTargetAmountDesc),
                  value: _hasTargetAmount,
                  onChanged: (value) {
                    setState(() {
                      _hasTargetAmount = value;
                      if (!value) {
                        _targetAmountController.clear();
                      }
                    });
                  },
                ),
                if (_hasTargetAmount) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _targetAmountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.targetAmountHint,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.attach_money),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                    ),
                    validator: _hasTargetAmount
                        ? (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppLocalizations.of(context)!.pleaseEnterTargetAmount;
                            }
                            final amount = double.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return AppLocalizations.of(context)!.pleaseEnterValidAmount;
                            }
                            return null;
                          }
                        : null,
                  ),
                ],
                const SizedBox(height: 24),

                // Hedef Tarihi
                _buildSectionTitle(AppLocalizations.of(context)!.targetDate),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.setTargetDate),
                  subtitle: Text(AppLocalizations.of(context)!.setTargetDateDesc),
                  value: _hasTargetDate,
                  onChanged: (value) {
                    setState(() {
                      _hasTargetDate = value;
                      if (!value) {
                        _targetDate = null;
                      }
                    });
                  },
                ),
                if (_hasTargetDate) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectTargetDate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(12),
                        color: isDark ? Colors.grey[800] : Colors.grey[50],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 12),
                          Text(
                            _targetDate != null
                                ? '${_targetDate!.day}/${_targetDate!.month}/${_targetDate!.year}'
                                : AppLocalizations.of(context)!.selectTargetDate,
                            style: TextStyle(
                              fontSize: 16, 
                              color: _targetDate != null 
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),

                // Bilgi Notu
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.savingInfo,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title, 
      style: TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildQuickAmountChips() {
    final List<double> amounts = _getQuickAmounts();
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: amounts.map((amount) {
        final isDaily = _isEditMode && _hasTargetDate && _targetDate != null;
        final displayText = isDaily 
          ? AppLocalizations.of(context)!.dailyTarget(amount.toStringAsFixed(0))
          : '₺${amount.toStringAsFixed(0)}';
          
        return ActionChip(
          label: Text(displayText),
          onPressed: () {
            _addMoneyController.text = amount.toStringAsFixed(0);
          },
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3)),
        );
      }).toList(),
    );
  }

  List<double> _getQuickAmounts() {
    if (!_isEditMode) {
      return [100, 200, 500, 1000, 2000];
    }
    
    final saving = widget.saving!;
    
    // Hedef tarih varsa günlük hedefi hesapla
    if (_hasTargetDate && _targetDate != null && saving.targetAmount > 0) {
      final now = DateTime.now();
      final daysUntilTarget = _targetDate!.difference(now).inDays;
      
      if (daysUntilTarget > 0) {
        final remainingAmount = saving.targetAmount - saving.currentAmount;
        if (remainingAmount > 0) {
          final dailyAmount = remainingAmount / daysUntilTarget;
          final weeklyAmount = dailyAmount * 7;
          final monthlyAmount = dailyAmount * 30;
          
          return [
            dailyAmount,
            weeklyAmount,
            monthlyAmount,
            dailyAmount * 2, // 2 günlük
            dailyAmount * 5, // haftalık iş günü
          ].where((amount) => amount > 0).toList();
        }
      }
    }
    
    // Hedef tarih yoksa sabit miktarlar
    return [100, 200, 500, 1000, 2000];
  }

  Future<void> _selectTargetDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && picked != _targetDate) {
      setState(() {
        _targetDate = picked;
      });
    }
  }

  Future<void> _saveSaving() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_hasTargetDate && _targetDate == null) {
      CustomSnackBar.showError(
        context, 
        message: AppLocalizations.of(context)!.pleaseSelectTargetDate
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final savingProvider = context.read<SavingProvider>();
      bool success = false;

      if (_isEditMode) {
        // Güncelleme modu
        final updatedSaving = Saving(
          id: widget.saving!.id,
          title: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          targetAmount: _hasTargetAmount ? double.parse(_targetAmountController.text) : 0.0,
          startDate: widget.saving!.startDate,
          targetDate: _targetDate ?? widget.saving!.targetDate,
          frequency: widget.saving!.frequency,
          currentAmount: widget.saving!.currentAmount,
          createdAt: widget.saving!.createdAt,
          status: widget.saving!.status,
        );

        success = await savingProvider.updateSaving(updatedSaving);
        
        // Para ekleme işlemi
        if (success && _addMoneyController.text.isNotEmpty) {
          final addAmount = double.tryParse(_addMoneyController.text);
          if (addAmount != null && addAmount > 0) {
            final addMoneySuccess = await savingProvider.addMoneyToSaving(
              widget.saving!.id!,
              addAmount,
            );
            
            if (!addMoneySuccess) {
              if (mounted) {
                CustomSnackBar.showError(
                  context,
                  message: AppLocalizations.of(context)!.errorAddingMoney,
                );
              }
              return;
            }
          }
        }
      } else {
        // Yeni birikim oluşturma modu
        final initialAmount = _hasInitialAmount ? double.parse(_initialAmountController.text) : 0.0;
        
        final saving = Saving(
          id: DateTime.now().millisecondsSinceEpoch,
          title: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          targetAmount: _hasTargetAmount ? double.parse(_targetAmountController.text) : 0.0,
          startDate: DateTime.now(),
          targetDate: _targetDate ?? DateTime.now().add(const Duration(days: 365)),
          frequency: SavingFrequency.daily,
          currentAmount: initialAmount,
          createdAt: DateTime.now(),
        );

        success = await savingProvider.createSaving(saving);
      }

      if (success) {
        // Firebase Analytics
        await FirebaseAnalyticsHelper.logCustomEvent(
          eventName: _isEditMode ? 'update_saving' : 'add_saving',
          parameters: {
            'has_target_amount': _hasTargetAmount,
            'has_target_date': _hasTargetDate,
            'has_initial_amount': _hasInitialAmount,
            'saving_title': _nameController.text.trim(),
            'is_edit_mode': _isEditMode,
            'added_money': _isEditMode && _addMoneyController.text.isNotEmpty,
          },
        );

        if (mounted) {
          Navigator.of(context).pop();
          
          String message;
          if (_isEditMode && _addMoneyController.text.isNotEmpty) {
            message = AppLocalizations.of(context)!.moneyAddedSuccessfully;
          } else if (_isEditMode) {
            message = AppLocalizations.of(context)!.savingUpdatedSuccessfully;
          } else {
            message = AppLocalizations.of(context)!.savingAddedSuccessfully;
          }
          
          CustomSnackBar.showSuccess(context, message: message);
        }
      } else {
        if (mounted) {
          CustomSnackBar.showError(
            context,
            message: _isEditMode 
              ? AppLocalizations.of(context)!.errorUpdatingSaving
              : AppLocalizations.of(context)!.errorAddingSaving,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(
          context,
          message: _isEditMode 
            ? AppLocalizations.of(context)!.errorUpdatingSaving
            : AppLocalizations.of(context)!.errorAddingSaving,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}