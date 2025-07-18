import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kumbara/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/currency_constants.dart';
import '../../../core/enums/saving_enum.dart';
import '../../../core/functions/firebase_analytics_helper.dart';
import '../../../core/functions/image_picker_helper.dart';
import '../../../core/providers/saving_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../models/saving.dart';
import '../../../services/ads_service.dart';

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

  // Görsel ile ilgili değişkenler
  File? _selectedImage;
  String? _existingImagePath;

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

    // Mevcut görsel varsa yolu kaydet
    if (saving.hasImage) {
      _existingImagePath = saving.primaryImagePath;
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
    final settingsProvider = context.watch<SettingsProvider>();
    final currencySymbol = CurrencyConstants.getCurrencySymbol(settingsProvider.currency);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            _isEditMode ? AppLocalizations.of(context)!.editSaving : AppLocalizations.of(context)!.addNewSaving,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _saveSaving,
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(
                      _isEditMode ? AppLocalizations.of(context)!.update : AppLocalizations.of(context)!.save,
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

                // Görsel Seçme Bölümü
                _buildSectionTitle(AppLocalizations.of(context)!.image),
                const SizedBox(height: 8),
                _buildImageSelector(),
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
                          '$currencySymbol${widget.saving!.currentAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        Text(AppLocalizations.of(context)!.currentAmount, style: TextStyle(color: Colors.green.shade700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    AppLocalizations.of(context)!.addMoney,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addMoneyController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.addMoneyHint,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.add_circle, color: Colors.green),
                      suffixText: currencySymbol,
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.initialAmountHint,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixText: '$currencySymbol ',
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.targetAmountHint,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixText: '$currencySymbol ',
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
                                  : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
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
                        child: Text(AppLocalizations.of(context)!.savingInfo, style: TextStyle(color: Theme.of(context).primaryColor)),
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
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
    );
  }

  /// Görsel seçme widget'ını oluştur
  Widget _buildImageSelector() {
    return Container(
      width: double.infinity,
      height: _hasImage ? 200 : 120,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), style: BorderStyle.solid),
      ),
      child: _hasImage ? _buildImageDisplay() : _buildImagePlaceholder(),
    );
  }

  /// Seçilen görseli göster
  Widget _buildImageDisplay() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(width: double.infinity, height: double.infinity, child: _displayImage),
        ),
        // Sil butonu
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: _removeImage,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.8), shape: BoxShape.circle),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
        // Değiştir butonu
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: _selectImage,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.8), borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(AppLocalizations.of(context)!.change, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Görsel seçme placeholder'ı
  Widget _buildImagePlaceholder() {
    return InkWell(
      onTap: () async {
        await _selectImage();
      },
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.addImage,
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(AppLocalizations.of(context)!.tapToSelectImage, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountChips() {
    final List<double> amounts = _getQuickAmounts();
    final settingsProvider = context.watch<SettingsProvider>();
    final currencySymbol = CurrencyConstants.getCurrencySymbol(settingsProvider.currency);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: amounts.map((amount) {
        String displayText;

        // Dinamik etiketleme (sadece manuel seçilmiş hedef tarih ve tutar varken)
        if (_isEditMode && _hasTargetDate && _targetDate != null && widget.saving!.targetAmount > 0) {
          final now = DateTime.now();
          final daysUntilTarget = _targetDate!.difference(now).inDays;

          // Sadece gerçek hedef tarih seçilmiş ise (otomatik atanmış 365 gün değil)
          if (daysUntilTarget > 0 && daysUntilTarget < 350) {
            final remainingAmount = widget.saving!.targetAmount - widget.saving!.currentAmount;
            if (remainingAmount > 0) {
              final dailyAmount = remainingAmount / daysUntilTarget;

              // Tutara göre etiket belirle
              if ((amount - dailyAmount).abs() < 0.01) {
                displayText = 'Günlük $currencySymbol${amount.toStringAsFixed(0)}';
              } else if ((amount - dailyAmount * 2).abs() < 0.01) {
                displayText = '2 Gün $currencySymbol${amount.toStringAsFixed(0)}';
              } else if ((amount - dailyAmount * 7).abs() < 0.01) {
                displayText = 'Haftalık $currencySymbol${amount.toStringAsFixed(0)}';
              } else if ((amount - dailyAmount * 30).abs() < 0.01) {
                displayText = 'Aylık $currencySymbol${amount.toStringAsFixed(0)}';
              } else if ((amount - dailyAmount * 60).abs() < 0.01) {
                displayText = '2 Ay $currencySymbol${amount.toStringAsFixed(0)}';
              } else {
                displayText = '$currencySymbol${amount.toStringAsFixed(0)}';
              }
            } else {
              displayText = '$currencySymbol${amount.toStringAsFixed(0)}';
            }
          } else {
            displayText = '$currencySymbol${amount.toStringAsFixed(0)}';
          }
        } else {
          // Standart tutarlar için basit gösterim
          displayText = '$currencySymbol${amount.toStringAsFixed(0)}';
        }

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
    // Standart miktarlar (yeni birikim veya hedef olmadığında)
    const standardAmounts = [100.0, 200.0, 500.0, 1000.0, 2000.0];

    if (!_isEditMode) {
      return standardAmounts;
    }

    final saving = widget.saving!;

    // Sadece düzenleme modunda kullanıcı tarafından manuel olarak seçilmiş hedef tarih varsa
    // ve hedef tutar belirlenmiş ise dinamik hesaplama yap
    if (_hasTargetDate && _targetDate != null && saving.targetAmount > 0) {
      final now = DateTime.now();
      final daysUntilTarget = _targetDate!.difference(now).inDays;

      // Sadece hedef tarih gelecekte ve 1 yıldan az ise dinamik hesaplama yap
      // (1 yıl = 365 gün otomatik atanmış değer kontrolü)
      if (daysUntilTarget > 0 && daysUntilTarget < 350) {
        final remainingAmount = saving.targetAmount - saving.currentAmount;
        if (remainingAmount > 0) {
          final dailyAmount = remainingAmount / daysUntilTarget;

          // Dinamik tutar listesi oluştur
          List<double> dynamicAmounts = [];

          // Her zaman günlük tutar
          dynamicAmounts.add(dailyAmount);

          // Her zaman 2 günlük tutar
          dynamicAmounts.add(dailyAmount * 2);

          // 2 haftadan uzaksa haftalık tutar ekle
          if (daysUntilTarget >= 14) {
            dynamicAmounts.add(dailyAmount * 7); // 1 haftalık
          }

          // 2 aydan uzaksa aylık tutar ekle
          if (daysUntilTarget >= 60) {
            dynamicAmounts.add(dailyAmount * 30); // 1 aylık
          }

          // 3 aydan uzaksa 2 aylık tutar ekle
          if (daysUntilTarget >= 90) {
            dynamicAmounts.add(dailyAmount * 60); // 2 aylık
          }

          // Pozitif tutarları filtrele ve döndür
          final filteredAmounts = dynamicAmounts.where((amount) => amount > 0).toList();

          // Eğer dinamik tutarlar varsa onları döndür, yoksa standart tutarları
          return filteredAmounts.isNotEmpty ? filteredAmounts : standardAmounts;
        }
      }
    }

    // Hedef tarih yoksa veya hesaplama yapılamıyorsa standart miktarlar
    return standardAmounts;
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

  // Görsel seçme metodları

  /// Görsel seçme dialog'unu göster
  Future<void> _selectImage() async {
    final File? pickedImage = await ImagePickerHelper.showImageSourceDialog(
      context,
      title: AppLocalizations.of(context)!.selectImage,
      galleryText: AppLocalizations.of(context)!.selectFromGallery,
      cameraText: AppLocalizations.of(context)!.takePhoto,
      cancelText: AppLocalizations.of(context)!.cancel,
      imageQuality: 80,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
        _existingImagePath = null; // Yeni görsel seçildi, eskiyi temizle
      });
    }
  }

  /// Görseli kaldır
  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _existingImagePath = null;
    });
  }

  /// Mevcut görselin olup olmadığını kontrol et
  bool get _hasImage {
    return _selectedImage != null || (_existingImagePath != null && _existingImagePath!.isNotEmpty);
  }

  /// Gösterilecek görsel widget'ı
  Widget get _displayImage {
    if (_selectedImage != null) {
      return Image.file(_selectedImage!, fit: BoxFit.cover);
    } else if (_existingImagePath != null && _existingImagePath!.isNotEmpty) {
      // Yerel dosya yolu ise File olarak, URL ise NetworkImage olarak göster
      if (_existingImagePath!.startsWith('http')) {
        return Image.network(_existingImagePath!, fit: BoxFit.cover);
      } else {
        return Image.file(File(_existingImagePath!), fit: BoxFit.cover);
      }
    }
    return const SizedBox.shrink();
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
      final savingProvider = context.read<SavingProvider>();
      bool success = false;

      if (_isEditMode) {
        // Güncelleme modu - önce birikim bilgilerini güncelle
        final updatedSaving = Saving(
          id: widget.saving!.id,
          title: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          targetAmount: _hasTargetAmount ? double.parse(_targetAmountController.text) : 0.0,
          startDate: widget.saving!.startDate,
          targetDate: _targetDate ?? widget.saving!.targetDate,
          frequency: widget.saving!.frequency,
          currentAmount: widget.saving!.currentAmount, // Mevcut tutarı koruyoruz
          createdAt: widget.saving!.createdAt,
          status: widget.saving!.status,
          // Görsel bilgilerini ekle
          imagePath: _selectedImage?.path ?? widget.saving!.imagePath,
          imageUrl: widget.saving!.imageUrl,
          thumbnailPath: widget.saving!.thumbnailPath,
          thumbnailUrl: widget.saving!.thumbnailUrl,
          imageMetadata: _selectedImage != null
              ? {
                  'fileSize': await _selectedImage!.length(),
                  'fileName': _selectedImage!.path.split('/').last,
                  'uploadDate': DateTime.now().toIso8601String(),
                }
              : widget.saving!.imageMetadata,
        );

        success = await savingProvider.updateSaving(updatedSaving);

        // Para ekleme işlemi - sadece birikim güncelleme başarılıysa
        if (success && _addMoneyController.text.isNotEmpty) {
          final addAmount = double.tryParse(_addMoneyController.text);
          if (addAmount != null && addAmount > 0) {
            // addMoneyToSaving metodu mevcut tutara ekleme yapıyor, değiştirmiyor
            final addMoneySuccess = await savingProvider.addMoneyToSaving(widget.saving!.id!, addAmount);

            if (!addMoneySuccess) {
              if (mounted) {
                CustomSnackBar.showError(context, message: AppLocalizations.of(context)!.errorAddingMoney);
              }
              // Para ekleme başarısız olursa işlemi iptal et
              setState(() {
                _isLoading = false;
              });
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
          // Görsel bilgilerini ekle
          imagePath: _selectedImage?.path,
          imageMetadata: _selectedImage != null
              ? {
                  'fileSize': await _selectedImage!.length(),
                  'fileName': _selectedImage!.path.split('/').last,
                  'uploadDate': DateTime.now().toIso8601String(),
                }
              : null,
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

          // Sadece yeni birikim oluşturulduğunda interstitial reklam göster
          // Para ekleme veya düzenleme işlemlerinde gösterme (çok sık olmasın)
          if (!_isEditMode) {
            _showInterstitialAd();
          }
        }
      } else {
        if (mounted) {
          CustomSnackBar.showError(
            context,
            message: _isEditMode ? AppLocalizations.of(context)!.errorUpdatingSaving : AppLocalizations.of(context)!.errorAddingSaving,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(
          context,
          message: _isEditMode ? AppLocalizations.of(context)!.errorUpdatingSaving : AppLocalizations.of(context)!.errorAddingSaving,
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

  /// Kayıt işleminden sonra interstitial reklam göster
  void _showInterstitialAd() {
    // Kısa bir delay ekleyerek kullanıcı deneyimini iyileştir
    Future.delayed(const Duration(milliseconds: 800), () {
      final adsService = AdsService.instance;
      if (adsService.isInitialized && adsService.isInterstitialAdLoaded) {
        adsService.showActionInterstitialAd();
      }
    });
  }
}
