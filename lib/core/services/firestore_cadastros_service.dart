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
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
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

  /// Escutar em tempo real a coleção exclusiva 'mechanical_locations' do Firestore
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? escutarLocaisMecanica({
    required Function(List<String> locais) onData,
  }) {
    final db = _db;
    if (db == null) return null;

    try {
      return db.collection('mechanical_locations').snapshots().listen(
        (snapshot) {
          final locais = <String>[];
          for (final doc in snapshot.docs) {
            final data = doc.data();
            final name = data['name']?.toString() ?? doc.id;
            final active = data['active'] ?? true;
            if (name.trim().isNotEmpty && active == true && !locais.contains(name.trim())) {
              locais.add(name.trim());
            }
          }
          if (locais.isNotEmpty) {
            onData(locais);
          }
        },
        onError: (err) {
          debugPrint('Erro listener mechanical_locations: $err');
        },
      );
    } catch (e) {
      debugPrint('Erro ao iniciar listener de mechanical_locations: $e');
      return null;
    }
  }

  /// Salvar novo local na coleção 'mechanical_locations'
  Future<void> salvarLocalMecanica(String local) async {
    final cleanName = local.trim();
    if (cleanName.isEmpty) return;

    final db = _db;
    if (db != null) {
      try {
        await db.collection('mechanical_locations').doc(cleanName).set({
          'name': cleanName,
          'active': true,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint('Local mecânico "$cleanName" sincronizado com mechanical_locations.');
      } catch (e) {
        debugPrint('Erro ao salvar local em mechanical_locations: $e');
      }
    }
  }
}
