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
  const AddSavingBottomSheet({super.key});

  @override
  State<AddSavingBottomSheet> createState() => _AddSavingBottomSheetState();
}

class _AddSavingBottomSheetState extends State<AddSavingBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();

  DateTime? _targetDate;
  bool _hasTargetAmount = false;
  bool _hasTargetDate = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addNewSaving, style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _saveSaving,
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(
                      AppLocalizations.of(context)!.save,
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
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
                  ),
                ),
                const SizedBox(height: 24),

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
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 12),
                          Text(
                            _targetDate != null
                                ? '${_targetDate!.day}/${_targetDate!.month}/${_targetDate!.year}'
                                : AppLocalizations.of(context)!.selectTargetDate,
                            style: TextStyle(fontSize: 16, color: _targetDate != null ? Colors.black : Colors.grey),
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
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade600),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(AppLocalizations.of(context)!.savingInfo, style: TextStyle(color: Colors.blue.shade800)),
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
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
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
      CustomSnackBar.showError(context, message: AppLocalizations.of(context)!.pleaseSelectTargetDate);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final saving = Saving(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        targetAmount: _hasTargetAmount ? double.parse(_targetAmountController.text) : 0.0,
        startDate: DateTime.now(),
        targetDate: _targetDate ?? DateTime.now().add(const Duration(days: 365)),
        frequency: SavingFrequency.daily,
        currentAmount: 0,
        createdAt: DateTime.now(),
      );

      final savingProvider = context.read<SavingProvider>();
      final success = await savingProvider.createSaving(saving);

      if (success) {
        // Firebase Analytics
        await FirebaseAnalyticsHelper.logCustomEvent(
          eventName: 'add_saving',
          parameters: {'has_target_amount': _hasTargetAmount, 'has_target_date': _hasTargetDate, 'saving_title': _nameController.text.trim()},
        );

        if (mounted) {
          Navigator.of(context).pop();
          CustomSnackBar.showSuccess(context, message: AppLocalizations.of(context)!.savingAddedSuccessfully);
        }
      } else {
        if (mounted) {
          CustomSnackBar.showError(context, message: AppLocalizations.of(context)!.errorAddingSaving);
        }
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
