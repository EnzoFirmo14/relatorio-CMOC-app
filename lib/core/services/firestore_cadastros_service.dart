import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço de sincronização em tempo real via Cloud Firestore para os Cadastros CMOC
class FirestoreCadastrosService {
  static final FirestoreCadastrosService _instance = FirestoreCadastrosService._internal();
  factory FirestoreCadastrosService() => _instance;
  FirestoreCadastrosService._internal();

  bool get _isFirebaseAvailable {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  FirebaseFirestore? get _db {
    if (!_isFirebaseAvailable) return null;
    return FirebaseFirestore.instance;
  }

  /// Escutar alterações em tempo real de uma área ('bombeamento', 'mecanica', 'eletrica', 'equipagem')
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? escutarCadastrosArea({
    required String area,
    required Function(Map<String, dynamic> data) onData,
  }) {
    final db = _db;
    if (db == null) return null;

    try {
      return db.collection('cmoc_cadastros').doc(area).snapshots().listen(
        (snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            onData(snapshot.data()!);
            // Atualizar cache local
            _salvarCacheLocal(area, snapshot.data()!);
          }
        },
        onError: (err) {
          debugPrint('Erro listener Firestore para $area: $err');
        },
      );
    } catch (e) {
      debugPrint('Erro ao iniciar listener de $area: $e');
      return null;
    }
  }

  /// Salvar ou atualizar cadastro na nuvem (Firestore) e no armazenamento local
  Future<void> salvarCadastrosArea({
    required String area,
    required Map<String, dynamic> data,
  }) async {
    // 1. Salvar no Cache Local (SharedPreferences)
    await _salvarCacheLocal(area, data);

    // 2. Tentar enviar para o Firestore
    final db = _db;
    if (db != null) {
      try {
        await db.collection('cmoc_cadastros').doc(area).set(data, SetOptions(merge: true));
        debugPrint('Cadastros de $area sincronizados com o Firestore.');
      } catch (e) {
        debugPrint('Erro ao enviar cadastros de $area para o Firestore: $e');
      }
    }
  }

  /// Carregar cache local salvo
  Future<Map<String, dynamic>?> carregarCacheLocal(String area) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('cache_firestore_$area');
      if (raw != null && raw.isNotEmpty) {
        return jsonDecode(raw) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Erro ao ler cache local de $area: $e');
    }
    return null;
  }

  Future<void> _salvarCacheLocal(String area, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cache_firestore_$area', jsonEncode(data));
    } catch (e) {
      debugPrint('Erro ao gravar cache local de $area: $e');
    }
  }
}
