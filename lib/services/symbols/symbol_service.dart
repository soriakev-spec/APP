import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class Symbol {
  final String id;
  final String label;
  final String? localPath;
  final String? networkUrl;
  final bool isCached;

  const Symbol({
    required this.id,
    required this.label,
    this.localPath,
    this.networkUrl,
    required this.isCached,
  });

  bool get hasImage => localPath != null || networkUrl != null;
}

abstract class SymbolService {
  Future<void> initialize();
  Future<List<Symbol>> search(String query, {String language = 'es', int limit = 20});
  Future<Symbol?> getById(String id);
  Future<String?> downloadAndCache(String symbolId, String url);
  Future<List<Symbol>> getByCategory(String category, {String language = 'es'});
  bool get isOnlineAvailable;
}

class ArasaacSymbolService implements SymbolService {
  static const String _baseUrl = 'https://api.arasaac.org/v1';
  final _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));
  Directory? _cacheDir;

  @override
  bool get isOnlineAvailable => true;

  @override
  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory('${appDir.path}/arasaac_cache');
    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }
  }

  @override
  Future<List<Symbol>> search(String query, {String language = 'es', int limit = 20}) async {
    if (_cacheDir == null) await initialize();

    try {
      final response = await _dio.get(
        '$_baseUrl/pictograms/$language/search/$Uri.encodeComponent(query)',
        queryParameters: {'limit': limit},
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .take(limit)
            .map((item) => Symbol(
                  id: item['_id'].toString(),
                  label: (item['keywords'] as List?)
                          ?.firstWhere(
                            (k) => true,
                            orElse: () => {'keyword': query},
                          )['keyword'] as String? ??
                      query,
                  networkUrl: 'https://static.arasaac.org/pictograms/${item['_id']}/${item['_id']}_300.png',
                  isCached: false,
                ))
            .toList();
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  @override
  Future<Symbol?> getById(String id) async {
    // Check local cache first
    final cachedPath = '${_cacheDir?.path}/$id.png';
    if (File(cachedPath).existsSync()) {
      return Symbol(id: id, label: id, localPath: cachedPath, isCached: true);
    }

    return Symbol(
      id: id,
      label: id,
      networkUrl: 'https://static.arasaac.org/pictograms/$id/${id}_300.png',
      isCached: false,
    );
  }

  @override
  Future<String?> downloadAndCache(String symbolId, String url) async {
    if (_cacheDir == null) await initialize();
    final localPath = '${_cacheDir!.path}/$symbolId.png';

    if (File(localPath).existsSync()) return localPath;

    try {
      await _dio.download(url, localPath);
      return localPath;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Symbol>> getByCategory(String category, {String language = 'es'}) async {
    return search(category, language: language, limit: 30);
  }
}

// Offline fallback using bundled assets
class AssetSymbolService implements SymbolService {
  @override
  bool get isOnlineAvailable => false;

  @override
  Future<void> initialize() async {}

  @override
  Future<List<Symbol>> search(String query, {String language = 'es', int limit = 20}) async {
    return [];
  }

  @override
  Future<Symbol?> getById(String id) async => null;

  @override
  Future<String?> downloadAndCache(String symbolId, String url) async => null;

  @override
  Future<List<Symbol>> getByCategory(String category, {String language = 'es'}) async => [];
}
