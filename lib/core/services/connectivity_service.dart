import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Retorna um Stream indicando se o dispositivo possui conexão com a internet (Wi-Fi, Dados Móveis, etc.).
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  /// Verifica se o dispositivo está conectado à internet.
  Future<bool> checkHasInternet() async {
    if (kIsWeb) return true;
    try {
      final results = await _connectivity.checkConnectivity();
      if (!_hasConnection(results)) return false;
      
      // lookup pode falhar em redes móveis reais (timeout/IPv6),
      // então se falhar, confiamos no checkConnectivity e retornamos true.
      // O Firestore lidará com o enfileiramento offline caso a internet esteja realmente inacessível.
      try {
        final lookupResult = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 5));
        return lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty;
      } catch (_) {
        return true; 
      }
    } catch (_) {
      return false;
    }
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    if (kIsWeb) return true;
    if (results.isEmpty) return false;
    return results.any((result) => result != ConnectivityResult.none);
  }
}
