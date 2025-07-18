import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Galeriden fotoğraf seçme işlemleri için yardımcı sınıf
class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Galeriden tek bir fotoğraf seç
  ///
  /// [imageQuality] 0-100 arasında değer (varsayılan: 80)
  /// [maxWidth] Maximum genişlik (opsiyonel)
  /// [maxHeight] Maximum yükseklik (opsiyonel)
  ///
  /// Returns: Seçilen fotoğrafın dosya yolu veya null
  static Future<File?> pickImageFromGallery({int imageQuality = 80, double? maxWidth, double? maxHeight}) async {
    try {
      // İzin kontrolü
      bool hasPermission = await _requestGalleryPermission();
      if (!hasPermission) {
        debugPrint('Galeri erişim izni reddedildi');
        return null;
      }

      // Galeriden fotoğraf seç
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }

      return null;
    } catch (e) {
      debugPrint('Galeri fotoğraf seçme hatası: $e');
      return null;
    }
  }

  /// Galeriden çoklu fotoğraf seç
  ///
  /// [imageQuality] 0-100 arasında değer (varsayılan: 80)
  /// [maxWidth] Maximum genişlik (opsiyonel)
  /// [maxHeight] Maximum yükseklik (opsiyonel)
  /// [limit] Maksimum seçilebilecek fotoğraf sayısı (opsiyonel)
  ///
  /// Returns: Seçilen fotoğrafların dosya listesi
  static Future<List<File>> pickMultipleImagesFromGallery({int imageQuality = 80, double? maxWidth, double? maxHeight, int? limit}) async {
    try {
      // İzin kontrolü
      bool hasPermission = await _requestGalleryPermission();
      if (!hasPermission) {
        debugPrint('Galeri erişim izni reddedildi');
        return [];
      }

      // Çoklu fotoğraf seç
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        limit: limit,
      );

      // XFile listesini File listesine çevir
      return pickedFiles.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      debugPrint('Çoklu galeri fotoğraf seçme hatası: $e');
      return [];
    }
  }

  /// Kameradan fotoğraf çek
  ///
  /// [imageQuality] 0-100 arasında değer (varsayılan: 80)
  /// [maxWidth] Maximum genişlik (opsiyonel)
  /// [maxHeight] Maximum yükseklik (opsiyonel)
  ///
  /// Returns: Çekilen fotoğrafın dosya yolu veya null
  static Future<File?> pickImageFromCamera({int imageQuality = 80, double? maxWidth, double? maxHeight}) async {
    try {
      // İzin kontrolü
      bool hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        debugPrint('Kamera erişim izni reddedildi');
        return null;
      }

      // Kameradan fotoğraf çek
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }

      return null;
    } catch (e) {
      debugPrint('Kamera fotoğraf çekme hatası: $e');
      return null;
    }
  }

  /// Kullanıcıya kaynak seçim dialog'u göster (Galeri/Kamera)
  ///
  /// [context] BuildContext
  /// [title] Dialog başlığı (opsiyonel)
  /// [galleryText] Galeri butonu metni (opsiyonel)
  /// [cameraText] Kamera butonu metni (opsiyonel)
  /// [cancelText] İptal butonu metni (opsiyonel)
  /// [imageQuality] 0-100 arasında değer (varsayılan: 80)
  /// [maxWidth] Maximum genişlik (opsiyonel)
  /// [maxHeight] Maximum yükseklik (opsiyonel)
  ///
  /// Returns: Seçilen fotoğrafın dosya yolu veya null
  static Future<File?> showImageSourceDialog(
    BuildContext context, {
    String? title,
    String? galleryText,
    String? cameraText,
    String? cancelText,
    int imageQuality = 80,
    double? maxWidth,
    double? maxHeight,
  }) async {
    return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? 'Fotoğraf Seç', style: Theme.of(context).textTheme.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(galleryText ?? 'Galeriden Seç', style: Theme.of(context).textTheme.bodyMedium),
                onTap: () async {
                  //    Navigator.of(context).pop();
                  final file = await pickImageFromGallery(imageQuality: imageQuality, maxWidth: maxWidth, maxHeight: maxHeight);
                  if (context.mounted) {
                    Navigator.of(context).pop(file);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(cameraText ?? 'Kameradan Çek', style: Theme.of(context).textTheme.bodyMedium),
                onTap: () async {
                  Navigator.of(context).pop();
                  final file = await pickImageFromCamera(imageQuality: imageQuality, maxWidth: maxWidth, maxHeight: maxHeight);
                  if (context.mounted) {
                    Navigator.of(context).pop(file);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(cancelText ?? 'İptal', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  /// Galeri erişim izni iste
  static Future<bool> _requestGalleryPermission() async {
    try {
      if (Platform.isAndroid) {
        // Android 13+ için yeni izin sistemi
        if (await _isAndroid13OrHigher()) {
          PermissionStatus status = await Permission.photos.status;
          if (status.isDenied) {
            status = await Permission.photos.request();
          }
          return status.isGranted;
        } else {
          // Android 12 ve altı için eski sistem
          PermissionStatus status = await Permission.storage.status;
          if (status.isDenied) {
            status = await Permission.storage.request();
          }
          return status.isGranted;
        }
      } else if (Platform.isIOS) {
        PermissionStatus status = await Permission.photos.status;
        if (status.isDenied) {
          status = await Permission.photos.request();
        }
        return status.isGranted;
      }

      return true; // Diğer platformlar için varsayılan olarak izin ver
    } catch (e) {
      debugPrint('Galeri izin kontrolü hatası: $e');
      return false;
    }
  }

  /// Kamera erişim izni iste
  static Future<bool> _requestCameraPermission() async {
    try {
      PermissionStatus status = await Permission.camera.status;
      if (status.isDenied) {
        status = await Permission.camera.request();
      }
      return status.isGranted;
    } catch (e) {
      debugPrint('Kamera izin kontrolü hatası: $e');
      return false;
    }
  }

  /// Android 13 veya üstü sürüm kontrolü
  static Future<bool> _isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      // Android API level kontrolü için
      // Şimdilik basit bir kontrol yapıyoruz
      return true; // Gelecekte daha detaylı kontrol eklenebilir
    }
    return false;
  }

  /// Dosya boyutunu hesapla (MB cinsinden)
  static Future<double> getFileSizeInMB(File file) async {
    try {
      int bytes = await file.length();
      return bytes / (1024 * 1024);
    } catch (e) {
      debugPrint('Dosya boyutu hesaplama hatası: $e');
      return 0.0;
    }
  }

  /// Görsel dosyası olup olmadığını kontrol et
  static bool isImageFile(File file) {
    final String extension = file.path.split('.').last.toLowerCase();
    const List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension);
  }
}
