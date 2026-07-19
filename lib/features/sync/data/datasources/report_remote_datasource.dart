import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../report_form/domain/entities/collaborator_entity.dart';
import '../../../report_form/domain/entities/report_entity.dart';
import '../../../report_form/domain/entities/work_order_entity.dart';

abstract class IReportRemoteDataSource {
  Future<void> sendReport(ReportEntity report);
  Future<ReportEntity?> fetchRemoteReport(String uuid);
  Future<List<ReportEntity>> fetchAllRemoteReports();
}

/// Implementação remota via Firebase Firestore com fallback em memória quando offline/não configurado.
class ReportFirestoreDataSource implements IReportRemoteDataSource {
  final FirebaseFirestore? _firestore;
  final Map<String, ReportEntity> _inMemoryMockStore = {};

  ReportFirestoreDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore;

  bool get _isFirebaseAvailable {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> sendReport(ReportEntity report) async {
    if (!_isFirebaseAvailable) {
      // Fallback para mock store quando o Firebase não está configurado localmente
      _inMemoryMockStore[report.uuid] = report;
      await Future.delayed(const Duration(milliseconds: 200));
      return;
    }

    try {
      final docRef = _db.collection('reports').doc(report.uuid);
      final jsonPayload = _reportToJson(report);
      await docRef.set(jsonPayload, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Falha ao enviar relatório para o Firestore: $e');
    }
  }

  @override
  Future<ReportEntity?> fetchRemoteReport(String uuid) async {
    if (!_isFirebaseAvailable) {
      return _inMemoryMockStore[uuid];
    }

    try {
      final docSnap = await _db.collection('reports').doc(uuid).get();
      if (!docSnap.exists || docSnap.data() == null) {
        return null;
      }
      return _jsonToReport(docSnap.data()!);
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
      final querySnap = await _db.collection('reports').get();
      return querySnap.docs.map((doc) => _jsonToReport(doc.data())).toList();
    } catch (e) {
      throw Exception('Falha ao buscar todos os relatórios remotos: $e');
    }
  }

  // ─── JSON Mappers ──────────────────────────────────────────────────────────

  Map<String, dynamic> _reportToJson(ReportEntity report) {
    return {
      'uuid': report.uuid,
      'date': report.date.toIso8601String(),
      'shift': report.shift,
      'team': report.team,
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
    };
  }

  ReportEntity _jsonToReport(Map<String, dynamic> json) {
    return ReportEntity(
      uuid: json['uuid'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      shift: json['shift'] as String? ?? '',
      team: json['team'] as String? ?? '',
      globalEquipment: json['globalEquipment'] as String? ?? '',
      globalLocation: json['globalLocation'] as String? ?? '',
      fuelLevel: (json['fuelLevel'] as num?)?.toDouble() ?? 0.0,
      availableMaterials: json['availableMaterials'] as String? ?? '',
      observations: json['observations'] as String? ?? '',
      syncStatus: ReportSyncStatus.synced,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      operators: (json['operators'] as List<dynamic>?)
              ?.map((o) => CollaboratorEntity(
                    id: o['id'] as String? ?? '',
                    registration: o['registration'] as String? ?? '',
                    name: o['name'] as String? ?? '',
                  ))
              .toList() ??
          [],
      workOrders: (json['workOrders'] as List<dynamic>?)
              ?.map((os) => WorkOrderEntity(
                    id: os['id'] as String? ?? '',
                    number: os['number'] as String? ?? '',
                    location: os['location'] as String? ?? '',
                    maintenanceType: os['maintenanceType'] as String? ?? '',
                    cause: os['cause'] as String? ?? '',
                    activities: os['activities'] as String? ?? '',
                    materialsUsed:
                        List<String>.from(os['materialsUsed'] as List? ?? []),
                    quantityMeters: os['quantityMeters'] as String? ?? '',
                    quantityPieces: os['quantityPieces'] as String? ?? '',
                    startTime: os['startTime'] as String? ?? '',
                    endTime: os['endTime'] as String? ?? '',
                    status: os['status'] as String? ?? '',
                    osStatus: os['osStatus'] as String? ?? '',
                    photoPaths:
                        List<String>.from(os['photoPaths'] as List? ?? []),
                  ))
              .toList() ??
          [],
    );
  }
}
