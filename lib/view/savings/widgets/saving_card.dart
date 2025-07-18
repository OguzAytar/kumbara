import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kumbara/l10n/app_localizations.dart';

import '../../../core/enums/saving_enum.dart';
import '../../../models/saving.dart';

class SavingCard extends StatefulWidget {
  final Saving saving;
  final VoidCallback? onTap;

  const SavingCard({super.key, required this.saving, this.onTap});

  @override
  State<SavingCard> createState() => _SavingCardState();
}

class _SavingCardState extends State<SavingCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _iconAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık ve durum
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.saving.title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
                        ),
                      ),
                      _buildStatusChip(),
                    ],
                  ),

                  if (widget.saving.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.saving.description,
                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 16),

                  // İlerleme çubuğu
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₺${widget.saving.currentAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.lightGreen : Colors.green),
                          ),
                          if (widget.saving.targetAmount > 0)
                            Text(
                              '₺${widget.saving.targetAmount.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (widget.saving.targetAmount > 0) ...[
                        LinearProgressIndicator(
                          value: widget.saving.completionPercentage / 100,
                          backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(widget.saving.completionPercentage)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.saving.completionPercentage.toStringAsFixed(1)}% ${AppLocalizations.of(context)!.completed}',
                          style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Alt bilgiler ve resim göster butonu
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${widget.saving.startDate.day}/${widget.saving.startDate.month}/${widget.saving.startDate.year}',
                          style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                        ),
                      ),
                      if (widget.saving.remainingDays > 0) ...[
                        const SizedBox(width: 16),
                        Icon(Icons.access_time, size: 16, color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.daysLeft(widget.saving.remainingDays),
                            style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                          ),
                        ),
                      ],
                      // Resim göster butonu (sadece resim varsa)
                      if (widget.saving.hasImage) ...[
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                              if (_isExpanded) {
                                _animationController.forward();
                              } else {
                                _animationController.reverse();
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image, size: 16, color: Theme.of(context).primaryColor),
                                const SizedBox(width: 4),
                                AnimatedBuilder(
                                  animation: _iconAnimation,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _iconAnimation.value * 3.14159,
                                      child: Icon(Icons.keyboard_arrow_down, size: 16, color: Theme.of(context).primaryColor),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Genişletilmiş resim alanı
          if (widget.saving.hasImage)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isExpanded ? 200 : 0,
              child: _isExpanded ? _buildImageSection() : null,
            ),
        ],
      ),
    );
  }

  /// Resim bölümünü oluşturur
  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _buildImage()),
    );
  }

  /// Görseli oluşturur
  Widget _buildImage() {
    final imagePath = widget.saving.primaryImagePath;

    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: const Center(child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey)),
      );
    }

    // URL ise NetworkImage, yerel dosya ise FileImage kullan
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: const Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey)),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
            ),
          );
        },
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: const Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey)),
          );
        },
      );
    }
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;

    switch (widget.saving.status) {
      case SavingStatus.active:
        chipColor = Colors.green;
        statusText = 'Aktif';
        break;
      case SavingStatus.completed:
        chipColor = Colors.blue;
        statusText = 'Tamamlandı';
        break;
      case SavingStatus.paused:
        chipColor = Colors.orange;
        statusText = 'Duraklatıldı';
        break;
      case SavingStatus.cancelled:
        chipColor = Colors.red;
        statusText = 'İptal Edildi';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(color: chipColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 70) return Colors.lightGreen;
    if (percentage >= 50) return Colors.orange;
    if (percentage >= 30) return Colors.amber;
    return Colors.red;
  }
}
