import 'package:kumbara/core/enums/saving_enum.dart';

class Saving {
  final int? id;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime targetDate;
  final SavingFrequency frequency;
  final SavingStatus status;
  final String? iconName;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Görsel alanları - yerel ve uzak sunucu uyumluluğu için
  final String? imagePath; // Yerel cihazda görsel dosya yolu
  final String? imageUrl; // Uzak sunucudaki görsel URL'i
  final String? thumbnailPath; // Yerel thumbnail yolu
  final String? thumbnailUrl; // Uzak sunucudaki thumbnail URL'i
  final Map<String, dynamic>? imageMetadata; // Görsel metadata bilgileri

  Saving({
    this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.startDate,
    required this.targetDate,
    required this.frequency,
    this.status = SavingStatus.active,
    this.iconName,
    this.color,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Görsel parametreleri
    this.imagePath,
    this.imageUrl,
    this.thumbnailPath,
    this.thumbnailUrl,
    this.imageMetadata,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Günlük, haftalık veya aylık biriktirme miktarını hesapla
  double get requiredAmountPerPeriod {
    final remainingAmount = targetAmount - currentAmount;
    final remainingDays = targetDate.difference(DateTime.now()).inDays;

    if (remainingDays <= 0) return 0;

    switch (frequency) {
      case SavingFrequency.daily:
        return remainingAmount / remainingDays;
      case SavingFrequency.weekly:
        final remainingWeeks = (remainingDays / 7).ceil();
        return remainingWeeks > 0 ? remainingAmount / remainingWeeks : 0;
      case SavingFrequency.monthly:
        final remainingMonths = ((targetDate.year - DateTime.now().year) * 12 + targetDate.month - DateTime.now().month);
        return remainingMonths > 0 ? remainingAmount / remainingMonths : 0;
    }
  }

  // Hedef tamamlanma yüzdesi
  double get completionPercentage {
    if (targetAmount == 0) return 0;
    return (currentAmount / targetAmount * 100).clamp(0, 100);
  }

  // Kalan gün sayısı
  int get remainingDays {
    return targetDate.difference(DateTime.now()).inDays.clamp(0, double.infinity).toInt();
  }

  // Görsel yardımcı getter'ları

  /// Görselin mevcut olup olmadığını kontrol eder (yerel veya uzak)
  bool get hasImage {
    return (imagePath != null && imagePath!.isNotEmpty) || (imageUrl != null && imageUrl!.isNotEmpty);
  }

  /// Öncelik sırasına göre görsel yolunu döndürür (yerel öncelikli)
  String? get primaryImagePath {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return imagePath;
    }
    return imageUrl;
  }

  /// Öncelik sırasına göre thumbnail yolunu döndürür (yerel öncelikli)
  String? get primaryThumbnailPath {
    if (thumbnailPath != null && thumbnailPath!.isNotEmpty) {
      return thumbnailPath;
    }
    return thumbnailUrl;
  }

  /// Görselin yerel mi uzak mı olduğunu belirtir
  bool get isImageLocal {
    return imagePath != null && imagePath!.isNotEmpty;
  }

  /// Görsel metadata'sından belirli bir değeri alır
  T? getImageMetadata<T>(String key) {
    if (imageMetadata == null) return null;
    return imageMetadata![key] as T?;
  }

  /// Yeni görsel bilgileriyle kopyala - pratik metod
  Saving copyWithImage({String? imagePath, String? imageUrl, String? thumbnailPath, String? thumbnailUrl, Map<String, dynamic>? imageMetadata}) {
    return copyWith(
      imagePath: imagePath,
      imageUrl: imageUrl,
      thumbnailPath: thumbnailPath,
      thumbnailUrl: thumbnailUrl,
      imageMetadata: imageMetadata,
      updatedAt: DateTime.now(),
    );
  }

  /// Görseli temizle - pratik metod
  Saving removeImage() {
    return copyWith(imagePath: null, imageUrl: null, thumbnailPath: null, thumbnailUrl: null, imageMetadata: null, updatedAt: DateTime.now());
  }

  /// Sunucuya gönderim için JSON formatı (görsel metadata dahil)
  Map<String, dynamic> toServerJson() {
    final Map<String, dynamic> json = toMap();

    // Sunucuya gönderilmeyecek yerel alanları kaldır
    json.remove('imagePath');
    json.remove('thumbnailPath');

    // Tarih formatlarını ISO string olarak değiştir
    json['startDate'] = startDate.toIso8601String();
    json['targetDate'] = targetDate.toIso8601String();
    json['createdAt'] = createdAt.toIso8601String();
    json['updatedAt'] = updatedAt.toIso8601String();

    return json;
  }

  /// Sunucudan gelen JSON'dan model oluştur
  factory Saving.fromServerJson(Map<String, dynamic> json) {
    return Saving(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      currentAmount: (json['currentAmount'] ?? 0.0).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      targetDate: DateTime.parse(json['targetDate']),
      frequency: SavingFrequency.values.firstWhere((e) => e.name == json['frequency'], orElse: () => SavingFrequency.daily),
      status: SavingStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => SavingStatus.active),
      iconName: json['iconName'],
      color: json['color'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      // Sunucudan gelen görsel URL'leri
      imageUrl: json['imageUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      imageMetadata: json['imageMetadata'] != null ? Map<String, dynamic>.from(json['imageMetadata']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'startDate': startDate.millisecondsSinceEpoch,
      'targetDate': targetDate.millisecondsSinceEpoch,
      'frequency': frequency.name,
      'status': status.name,
      'iconName': iconName,
      'color': color,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      // Görsel alanları
      'imagePath': imagePath,
      'imageUrl': imageUrl,
      'thumbnailPath': thumbnailPath,
      'thumbnailUrl': thumbnailUrl,
      'imageMetadata': imageMetadata,
    };
  }

  factory Saving.fromMap(Map<String, dynamic> map) {
    return Saving(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      targetAmount: (map['targetAmount'] ?? 0.0).toDouble(),
      currentAmount: (map['currentAmount'] ?? 0.0).toDouble(),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      targetDate: DateTime.fromMillisecondsSinceEpoch(map['targetDate']),
      frequency: SavingFrequency.values.firstWhere((e) => e.name == map['frequency'], orElse: () => SavingFrequency.daily),
      status: SavingStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => SavingStatus.active),
      iconName: map['iconName'],
      color: map['color'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      // Görsel alanları
      imagePath: map['imagePath'],
      imageUrl: map['imageUrl'],
      thumbnailPath: map['thumbnailPath'],
      thumbnailUrl: map['thumbnailUrl'],
      imageMetadata: map['imageMetadata'] != null ? Map<String, dynamic>.from(map['imageMetadata']) : null,
    );
  }

  Saving copyWith({
    int? id,
    String? title,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? startDate,
    DateTime? targetDate,
    SavingFrequency? frequency,
    SavingStatus? status,
    String? iconName,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Görsel parametreleri
    String? imagePath,
    String? imageUrl,
    String? thumbnailPath,
    String? thumbnailUrl,
    Map<String, dynamic>? imageMetadata,
  }) {
    return Saving(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      frequency: frequency ?? this.frequency,
      status: status ?? this.status,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      // Görsel alanları
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      imageMetadata: imageMetadata ?? this.imageMetadata,
    );
  }
}
