import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../../report_form/domain/entities/collaborator_entity.dart';
import '../../../report_form/domain/entities/report_entity.dart';
import '../../../report_form/domain/entities/work_order_entity.dart';
import '../../../report_form/domain/entities/water_level_entity.dart';
import '../../../report_form/domain/entities/pump_entity.dart';
import '../../../report_form/domain/entities/material_entity.dart';
abstract class IReportRemoteDataSource {
  Future<void> sendReport(ReportEntity report);
  Future<ReportEntity?> fetchRemoteReport(String uuid);
  Future<List<ReportEntity>> fetchAllRemoteReports();
}

/// Implementação remota via Firebase Firestore com roteamento para as coleções específicas
/// (`electrical_reports`, `pumping_reports`, `mechanical_reports` e `reports`).
class ReportFirestoreDataSource implements IReportRemoteDataSource {
  final FirebaseFirestore? _firestore;
  final Map<String, ReportEntity> _inMemoryMockStore = {};

  ReportFirestoreDataSource({this._firestore});

  bool get _isFirebaseAvailable {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  String _getCollectionName(String type) {
    switch (type.trim().toLowerCase()) {
      case 'elétrica':
      case 'eletrica':
      case 'electrical':
        return 'electrical_reports';
      case 'bombeamento':
      case 'pumping':
      case 'drenagem & bombeamento':
        return 'pumping_reports';
      case 'mecânica':
      case 'mecanica':
      case 'mechanical':
        return 'mechanical_reports';
      case 'equipagem':
      default:
        return 'reports';
    }
  }

  @override
  Future<void> sendReport(ReportEntity report) async {
    if (!_isFirebaseAvailable) {
      debugPrint('CRITICAL WARNING: Firebase is NOT available! Falling back to in-memory mock store for sendReport.');
      _inMemoryMockStore[report.uuid] = report;
      await Future.delayed(const Duration(milliseconds: 200));
      return;
    }

    try {
      final collectionName = _getCollectionName(report.type);
      final docRef = _db.collection(collectionName).doc(report.uuid);
      final jsonPayload = _reportToJson(report);
      await docRef.set(jsonPayload, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Falha ao enviar relatório para o Firestore ($e)');
    }
  }

  @override
  Future<ReportEntity?> fetchRemoteReport(String uuid) async {
    if (!_isFirebaseAvailable) {
      return _inMemoryMockStore[uuid];
    }

    try {
      final collections = ['reports', 'electrical_reports', 'pumping_reports', 'mechanical_reports'];
      for (final col in collections) {
        final docSnap = await _db.collection(col).doc(uuid).get();
        if (docSnap.exists && docSnap.data() != null) {
          return _jsonToReport(docSnap.data()!);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Falha ao buscar relatório remoto: $e');
    }
  }

  @override
  Future<List<ReportEntity>> fetchAllRemoteReports() async {
    if (!_isFirebaseAvailable) {
      return _inMemoryMockStore.values.toList();
    }

    try {
      final List<ReportEntity> all = [];
      final collections = ['reports', 'electrical_reports', 'pumping_reports', 'mechanical_reports'];
      for (final col in collections) {
        final querySnap = await _db.collection(col).get();
        all.addAll(querySnap.docs.map((doc) => _jsonToReport(doc.data())));
      }
      return all;
    } catch (e) {
      throw Exception('Falha ao buscar todos os relatórios remotos: $e');
    }
  }

  // ─── JSON Mappers ──────────────────────────────────────────────────────────

  Map<String, dynamic> _reportToJson(ReportEntity report) {
    final leaderName = report.operators.isNotEmpty ? report.operators.first.name : '';
    final memberNames = report.operators.map((o) => o.name).where((n) => n.isNotEmpty).toList();

    return {
      'uuid': report.uuid,
      'id': report.uuid,
      'date': report.date.toIso8601String(),
      'shift': report.shift,
      'team': report.team,
      'type': report.type,
      'leader': leaderName,
      'members': memberNames,
      'location': report.globalLocation.isNotEmpty
          ? report.globalLocation
          : (report.workOrders.isNotEmpty ? report.workOrders.first.location : ''),
      'globalEquipment': report.globalEquipment,
      'globalLocation': report.globalLocation,
      'fuelLevel': report.fuelLevel,
      'availableMaterials': report.availableMaterials,
      'observations': report.observations,
      'syncStatus': 'synced',
      'createdAt': report.createdAt.toIso8601String(),
      'updatedAt': report.updatedAt.toIso8601String(),
      'operators': report.operators
          .map((o) => {
                'id': o.id,
                'registration': o.registration,
                'name': o.name,
              })
          .toList(),
      'workOrders': report.workOrders
          .map((os) => {
                'id': os.id,
                'number': os.number,
                'location': os.location,
                'maintenanceType': os.maintenanceType,
                'cause': os.cause,
                'activities': os.activities,
                'materialsUsed': os.materialsUsed,
                'quantityMeters': os.quantityMeters,
                'quantityPieces': os.quantityPieces,
                'startTime': os.startTime,
                'endTime': os.endTime,
                'status': os.status,
                'osStatus': os.osStatus,
                'photoPaths': os.photoPaths,
              })
          .toList(),
      'activities': report.workOrders
          .map((os) => {
                'description': os.activities,
                'serviceType': os.maintenanceType,
                'equipment': report.globalEquipment,
                'location': os.location,
                'status': os.status.isNotEmpty ? os.status : 'Concluído',
                'startTime': os.startTime,
                'endTime': os.endTime,
              })
          .toList(),
      'waterLevels': report.waterLevels
          .map((wl) => {
                'pointId': wl.pointId,
                'location': wl.location,
                'level': wl.level,
                'abastec': wl.abastec,
                'abastecMotivo': wl.abastecMotivo,
                'vaz': wl.vaz,
                'vazLocal': wl.vazLocal,
                'trend': wl.trend,
                'observations': wl.observations,
              })
          .toList(),
      'pumps': report.pumps
          .map((p) => {
                'name': p.name,
                'metragem': p.metragem,
                'bombaStatus': p.bombaStatus,
                'limpeza': p.limpeza,
                'ocorrencias': p.ocorrencias,
              })
          .toList(),
      'materialsUsedList': report.materialsUsed
          .map((m) => {
                'name': m.name,
                'quantity': m.quantity,
              })
          .toList(),
    };
  }

  ReportEntity _jsonToReport(Map<String, dynamic> json) {
    return ReportEntity(
      uuid: json['uuid']?.toString() ?? json['id']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      shift: json['shift']?.toString() ?? '',
      team: json['team']?.toString() ?? '',
      globalEquipment: json['globalEquipment']?.toString() ?? '',
      globalLocation: json['globalLocation']?.toString() ?? json['location']?.toString() ?? '',
      fuelLevel: (json['fuelLevel'] as num?)?.toDouble() ?? 0.0,
      availableMaterials: json['availableMaterials']?.toString() ?? '',
      observations: json['observations']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Equipagem',
      syncStatus: ReportSyncStatus.synced,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      operators: _parseOperators(json['operators']),
      workOrders: _parseWorkOrders(json['workOrders']),
      waterLevels: _parseWaterLevels(json['waterLevels']),
      pumps: _parsePumps(json['pumps']),
      materialsUsed: _parseMaterials(json['materialsUsedList']),
    );
  }

  List<CollaboratorEntity> _parseOperators(dynamic data) {
    if (data is! List) return [];
    try {
      return data.map((o) {
        if (o is! Map) return const CollaboratorEntity(id: '', registration: '', name: '');
        return CollaboratorEntity(
          id: o['id']?.toString() ?? '',
          registration: o['registration']?.toString() ?? '',
          name: o['name']?.toString() ?? '',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  List<WorkOrderEntity> _parseWorkOrders(dynamic data) {
    if (data is! List) return [];
    try {
      return data.map((os) {
        if (os is! Map) return const WorkOrderEntity(id: '', number: '', location: '');
        
        final rawMats = os['materialsUsed'];
        List<String> matsList = [];
        if (rawMats is List) {
          matsList = rawMats.map((m) => m?.toString() ?? '').toList();
        } else if (rawMats is String && rawMats.isNotEmpty) {
          matsList = [rawMats];
        }

        final rawPhotos = os['photoPaths'];
        List<String> photosList = [];
        if (rawPhotos is List) {
          photosList = rawPhotos.map((p) => p?.toString() ?? '').toList();
        } else if (rawPhotos is String && rawPhotos.isNotEmpty) {
          photosList = [rawPhotos];
        }

        return WorkOrderEntity(
          id: os['id']?.toString() ?? '',
          number: os['number']?.toString() ?? '',
          location: os['location']?.toString() ?? '',
          maintenanceType: os['maintenanceType']?.toString() ?? '',
          cause: os['cause']?.toString() ?? '',
          activities: os['activities']?.toString() ?? '',
          materialsUsed: matsList,
          quantityMeters: os['quantityMeters']?.toString() ?? '',
          quantityPieces: os['quantityPieces']?.toString() ?? '',
          startTime: os['startTime']?.toString() ?? '',
          endTime: os['endTime']?.toString() ?? '',
          status: os['status']?.toString() ?? '',
          osStatus: os['osStatus']?.toString() ?? '',
          photoPaths: photosList,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  List<WaterLevelEntity> _parseWaterLevels(dynamic data) {
    if (data is! List) return [];
    try {
      return data.map((wl) {
        if (wl is! Map) return const WaterLevelEntity(pointId: '', location: '', level: '');
        return WaterLevelEntity(
          pointId: wl['pointId']?.toString() ?? '',
          location: wl['location']?.toString() ?? '',
          level: wl['level']?.toString() ?? '',
          abastec: wl['abastec']?.toString() == 'true',
          abastecMotivo: wl['abastecMotivo']?.toString() ?? '',
          vaz: wl['vaz']?.toString() == 'true',
          vazLocal: wl['vazLocal']?.toString() ?? '',
          trend: wl['trend']?.toString() ?? '',
          observations: wl['observations']?.toString() ?? '',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  List<PumpEntity> _parsePumps(dynamic data) {
    if (data is! List) return [];
    try {
      return data.map((p) {
        if (p is! Map) return const PumpEntity(name: '', metragem: '', bombaStatus: '', limpeza: '', ocorrencias: '');
        return PumpEntity(
          name: p['name']?.toString() ?? '',
          metragem: p['metragem']?.toString() ?? '',
          bombaStatus: p['bombaStatus']?.toString() ?? '',
          limpeza: p['limpeza']?.toString() ?? '',
          ocorrencias: p['ocorrencias']?.toString() ?? '',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  List<MaterialEntity> _parseMaterials(dynamic data) {
    if (data is! List) return [];
    try {
      return data.map((m) {
        if (m is! Map) return const MaterialEntity(name: '');
        return MaterialEntity(
          name: m['name']?.toString() ?? '',
          quantity: m['quantity']?.toString() ?? '',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
