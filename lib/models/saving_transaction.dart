class SavingTransaction {
  final int? id;
  final int savingId;
  final double amount;
  final DateTime date;
  final String? note;
  final DateTime createdAt;

  // Görsel alanları - transaction'a görsel ekleme desteği
  final String? imagePath; // Yerel cihazda görsel dosya yolu
  final String? imageUrl; // Uzak sunucudaki görsel URL'i
  final String? thumbnailPath; // Yerel thumbnail yolu
  final String? thumbnailUrl; // Uzak sunucudaki thumbnail URL'i
  final Map<String, dynamic>? imageMetadata; // Görsel metadata bilgileri

  SavingTransaction({
    this.id,
    required this.savingId,
    required this.amount,
    required this.date,
    this.note,
    DateTime? createdAt,
    // Görsel parametreleri
    this.imagePath,
    this.imageUrl,
    this.thumbnailPath,
    this.thumbnailUrl,
    this.imageMetadata,
  }) : createdAt = createdAt ?? DateTime.now();

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savingId': savingId,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'note': note,
      'createdAt': createdAt.millisecondsSinceEpoch,
      // Görsel alanları
      'imagePath': imagePath,
      'imageUrl': imageUrl,
      'thumbnailPath': thumbnailPath,
      'thumbnailUrl': thumbnailUrl,
      'imageMetadata': imageMetadata,
    };
  }

  factory SavingTransaction.fromMap(Map<String, dynamic> map) {
    return SavingTransaction(
      id: map['id'],
      savingId: map['savingId'],
      amount: (map['amount'] ?? 0.0).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      note: map['note'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      // Görsel alanları
      imagePath: map['imagePath'],
      imageUrl: map['imageUrl'],
      thumbnailPath: map['thumbnailPath'],
      thumbnailUrl: map['thumbnailUrl'],
      imageMetadata: map['imageMetadata'] != null ? Map<String, dynamic>.from(map['imageMetadata']) : null,
    );
  }

  SavingTransaction copyWith({
    int? id,
    int? savingId,
    double? amount,
    DateTime? date,
    String? note,
    DateTime? createdAt,
    // Görsel parametreleri
    String? imagePath,
    String? imageUrl,
    String? thumbnailPath,
    String? thumbnailUrl,
    Map<String, dynamic>? imageMetadata,
  }) {
    return SavingTransaction(
      id: id ?? this.id,
      savingId: savingId ?? this.savingId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      // Görsel alanları
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      imageMetadata: imageMetadata ?? this.imageMetadata,
    );
  }

  /// Yeni görsel bilgileriyle kopyala - pratik metod
  SavingTransaction copyWithImage({
    String? imagePath,
    String? imageUrl,
    String? thumbnailPath,
    String? thumbnailUrl,
    Map<String, dynamic>? imageMetadata,
  }) {
    return copyWith(imagePath: imagePath, imageUrl: imageUrl, thumbnailPath: thumbnailPath, thumbnailUrl: thumbnailUrl, imageMetadata: imageMetadata);
  }

  /// Görseli temizle - pratik metod
  SavingTransaction removeImage() {
    return copyWith(imagePath: null, imageUrl: null, thumbnailPath: null, thumbnailUrl: null, imageMetadata: null);
  }

  /// Sunucuya gönderim için JSON formatı (görsel metadata dahil)
  Map<String, dynamic> toServerJson() {
    final Map<String, dynamic> json = toMap();

    // Sunucuya gönderilmeyecek yerel alanları kaldır
    json.remove('imagePath');
    json.remove('thumbnailPath');

    // Tarih formatlarını ISO string olarak değiştir
    json['date'] = date.toIso8601String();
    json['createdAt'] = createdAt.toIso8601String();

    return json;
  }

  /// Sunucudan gelen JSON'dan model oluştur
  factory SavingTransaction.fromServerJson(Map<String, dynamic> json) {
    return SavingTransaction(
      id: json['id'],
      savingId: json['savingId'],
      amount: (json['amount'] ?? 0.0).toDouble(),
      date: DateTime.parse(json['date']),
      note: json['note'],
      createdAt: DateTime.parse(json['createdAt']),
      // Sunucudan gelen görsel URL'leri
      imageUrl: json['imageUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      imageMetadata: json['imageMetadata'] != null ? Map<String, dynamic>.from(json['imageMetadata']) : null,
    );
  }
}
