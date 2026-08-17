import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/report_form/data/constants/mechanical_constants.dart';

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

  /// Escutar em tempo real a coleção exclusiva 'mechanical_tags' do Firestore
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? escutarTagsMecanica({
    required Function(List<Map<String, dynamic>> tags) onData,
  }) {
    final db = _db;
    if (db == null) return null;

    try {
      return db.collection('mechanical_tags').snapshots().listen(
        (snapshot) {
          if (snapshot.docs.isEmpty) {
            debugPrint('Coleção mechanical_tags vazia. Populando automaticamente...');
            popularTodasTagsEstaticasNoFirestore();
          }

          // Ordena as TAGs mais recentes primeiro (suportando Timestamp, String, updatedAt ou null)
          final docsList = snapshot.docs.toList();
          docsList.sort((a, b) {
            final dataA = a.data();
            final dataB = b.data();
            final tA = dataA['createdAt'] ?? dataA['updatedAt'];
            final tB = dataB['createdAt'] ?? dataB['updatedAt'];

            DateTime dateA = DateTime.fromMillisecondsSinceEpoch(0);
            DateTime dateB = DateTime.fromMillisecondsSinceEpoch(0);

            if (tA is Timestamp) {
              dateA = tA.toDate();
            } else if (tA is String) {
              dateA = DateTime.tryParse(tA) ?? DateTime.now();
            } else if (tA == null) {
              dateA = DateTime.now();
            }

            if (tB is Timestamp) {
              dateB = tB.toDate();
            } else if (tB is String) {
              dateB = DateTime.tryParse(tB) ?? DateTime.now();
            } else if (tB == null) {
              dateB = DateTime.now();
            }

            return dateB.compareTo(dateA);
          });

          final tagsList = <Map<String, dynamic>>[];
          for (final doc in docsList) {
            final data = doc.data();
            final tagStr = (data['tag'] ?? data['codigo'] ?? data['tagCode'] ?? data['nome'] ?? doc.id).toString().trim();
            final descStr = (data['desc'] ?? data['descricao'] ?? data['description'] ?? '').toString().trim();
            final equipTypeStr = (data['equipmentType'] ?? data['equipamento'] ?? data['tipo'] ?? data['categoria'] ?? data['category'] ?? '').toString().trim();
            final locationStr = (data['location'] ?? data['local'] ?? '').toString().trim();
            final active = data['active'] ?? true;

            if (tagStr.isNotEmpty && active == true) {
              tagsList.add({
                'tag': tagStr,
                'desc': descStr,
                'equipmentType': equipTypeStr,
                'location': locationStr,
              });
            }
          }
          debugPrint('[FirestoreCadastrosService] Recebidas ${tagsList.length} TAGs de mechanical_tags.');
          onData(tagsList);
        },
        onError: (err) {
          debugPrint('Erro listener mechanical_tags: $err');
        },
      );
    } catch (e) {
      debugPrint('Erro ao iniciar listener de mechanical_tags: $e');
      return null;
    }
  }

  /// Salvar ou atualizar TAG de equipamento na coleção 'mechanical_tags' do Firestore
  Future<void> salvarTagMecanica({
    required String tag,
    required String desc,
    required String equipmentType,
    String? location,
  }) async {
    final cleanTag = tag.trim().toUpperCase();
    if (cleanTag.isEmpty || equipmentType.trim().isEmpty) return;

    final db = _db;
    if (db != null) {
      try {
        await db.collection('mechanical_tags').doc(cleanTag).set({
          'tag': cleanTag,
          'desc': desc.trim(),
          'equipmentType': equipmentType.trim(),
          'location': location?.trim() ?? '',
          'active': true,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint('TAG mecânica "$cleanTag" ($equipmentType) sincronizada com mechanical_tags.');
      } catch (e) {
        debugPrint('Erro ao salvar TAG em mechanical_tags: $e');
      }
    }
  }

  /// Popula todas as TAGs estáticas pré-existentes do aplicativo no Cloud Firestore (se a coleção estiver vazia)
  Future<void> popularTodasTagsEstaticasNoFirestore() async {
    final db = _db;
    if (db == null) return;

    try {
      final existing = await db.collection('mechanical_tags').limit(1).get();
      if (existing.docs.isNotEmpty) {
        debugPrint('[FirestoreCadastrosService] Coleção mechanical_tags já possui documentos. Ignorando população automática.');
        return;
      }

      final batch = db.batch();
      final Map<String, List<Map<String, String>>> cmocCadastrosTags = {};

      final categorias = {
        'Bomba': MechanicalConstants.tagBomba,
        'Estação de bombeamento': MechanicalConstants.tagEstacao,
        'Central de ventilação': MechanicalConstants.tagCentral,
        'Ventilador': MechanicalConstants.tagVentilador,
        'Exaustor': MechanicalConstants.tagExaustor,
        'Motor': MechanicalConstants.tagMotor,
      };

      int count = 0;

      categorias.forEach((equipType, tagList) {
        cmocCadastrosTags[equipType] = [];
        final localMap = MechanicalConstants.getLocalMap(equipType);

        for (final item in tagList) {
          final tagCode = (item['tag'] ?? '').trim();
          final tagDesc = (item['desc'] ?? '').trim();
          if (tagCode.isEmpty || tagCode == 'OUTRO') continue;

          String location = '';
          if (localMap != null) {
            localMap.forEach((loc, tags) {
              if (tags.contains(tagCode)) {
                location = loc;
              }
            });
          }

          final docRef = db.collection('mechanical_tags').doc(tagCode);
          batch.set(docRef, {
            'tag': tagCode,
            'desc': tagDesc,
            'equipmentType': equipType,
            'location': location,
            'active': true,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          cmocCadastrosTags[equipType]!.add({
            'tag': tagCode,
            'desc': tagDesc,
            'location': location,
          });

          count++;
        }
      });

      await batch.commit();

      await db.collection('cmoc_cadastros').doc('mecanica').set({
        'tags': cmocCadastrosTags,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('$count TAGs estáticas sincronizadas com sucesso no Cloud Firestore!');
    } catch (e) {
      debugPrint('Erro ao popular TAGs no Cloud Firestore: $e');
    }
  }
}
