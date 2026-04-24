import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class CacheCleanResult {
  final int deletedBytes;
  final List<String> errors;
  final List<String> cleaned;

  const CacheCleanResult({
    required this.deletedBytes,
    required this.errors,
    required this.cleaned,
  });

  String get deletedMB => '${(deletedBytes / 1024 / 1024).toStringAsFixed(2)} MB';
}

Future<CacheCleanResult> cleanOnlyCache() async {
  final errors = <String>[];
  final cleaned = <String>[];
  int totalDeleted = 0;

  Future<int> _dirSize(Directory dir) async {
    int size = 0;
    try {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) size += await entity.length();
      }
    } catch (_) {}
    return size;
  }

  Future<void> _safeDeleteDir(
      Directory dir, {
        required String label,
        bool recreate = false,
      }) async {
    try {
      if (!await dir.exists()) return;

      final size = await _dirSize(dir);
      await dir.delete(recursive: true);

      if (recreate) await dir.create(recursive: true);

      totalDeleted += size;
      cleaned.add(label);
    } catch (e, stack) {
      // Log stack trace để debug
      debugPrint('[CacheClean] Lỗi xóa $label: $e\n$stack');
      errors.add('$label: $e');
    }
  }

  // 1. Temporary directory
  final tempDir = await getTemporaryDirectory();
  await _safeDeleteDir(tempDir, label: 'TempDir', recreate: true);

  // 2. flutter_cache_manager / cached_network_image
  try {
    await DefaultCacheManager().emptyCache();
    cleaned.add('DefaultCacheManager');
  } catch (e) {
    errors.add('DefaultCacheManager: $e');
  }

  // 3. Dio cache – thường lưu trong applicationSupportDirectory, không phải tempDir
  final supportDir = await getApplicationSupportDirectory();
  await _safeDeleteDir(
    Directory('${supportDir.path}/dio_cache'),
    label: 'DioCache',
  );

  // 4. WebView cache – phân biệt platform
  if (Platform.isIOS) {
    await _safeDeleteDir(
      Directory('${supportDir.path}/WebKit'),
      label: 'WebKit (iOS)',
    );
  } else if (Platform.isAndroid) {
    final appDir = await getApplicationDocumentsDirectory();
    // WebView Android thường nằm ở app data/cache
    final cacheDir = Directory('${appDir.parent.path}/cache/WebView');
    await _safeDeleteDir(cacheDir, label: 'WebView (Android)');
  }

  // 5. Shared Preferences cache (optional – chỉ xóa key tạm thời nếu cần)
  // SharedPreferences.getInstance().then((p) => p.remove('some_temp_key'));

  return CacheCleanResult(
    deletedBytes: totalDeleted,
    errors: errors,
    cleaned: cleaned,
  );
}