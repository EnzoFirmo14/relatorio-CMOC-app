import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/firestore_cadastros_service.dart';
import '../../../../core/providers/dev_mode_provider.dart';
import '../../../sync/presentation/widgets/sync_status_badge.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/entities/collaborator_entity.dart';
import '../../domain/entities/work_order_entity.dart';
import '../../../sync/presentation/controllers/sync_controller.dart';
import '../controllers/report_form_controller.dart';

/// Tema de cores selecionável para a interface de Drenagem & Bombeamento
class PumpingTheme {
  final String id;
  final String nome;
  final String desc;
  final Color fundo;
  final Color painel;
  final Color agua;
  final Color alerta;
  final Color critico;

  const PumpingTheme({
    required this.id,
    required this.nome,
    required this.desc,
    required this.fundo,
    required this.painel,
    required this.agua,
    required this.alerta,
    required this.critico,
  });

  bool get isDark => id != 'claro' && id != 'branco' && id != 'bancada';
}

const List<PumpingTheme> kPumpingThemes = [
  PumpingTheme(id: 'rocha', nome: 'Rocha', desc: 'Escuro azulado. Uso geral, dia e noite.', fundo: Color(0xFF0D1419), painel: Color(0xFF151F26), agua: Color(0xFF2FB6C4), alerta: Color(0xFFF2C230), critico: Color(0xFFE4572E)),
  PumpingTheme(id: 'cmoc', nome: 'Azul Mina', desc: 'Azul forte do coletor de campo. Boa leitura no escuro.', fundo: Color(0xFF0B1F66), painel: Color(0xFF1B3EA8), agua: Color(0xFF6FE3FF), alerta: Color(0xFFFFD25E), critico: Color(0xFFFF7A63)),
  PumpingTheme(id: 'infralog', nome: 'Grafite', desc: 'Cinza escuro com azul. Para dentro da mina.', fundo: Color(0xFF161719), painel: Color(0xFF2B2E33), agua: Color(0xFF3D9DFF), alerta: Color(0xFFF5B83D), critico: Color(0xFFFF6B52)),
  PumpingTheme(id: 'claro', nome: 'Claro', desc: 'Cartões brancos e azul. Padrão do aplicativo.', fundo: Color(0xFFE9ECF2), painel: Color(0xFFFFFFFF), agua: Color(0xFF2F6BD8), alerta: Color(0xFF94670A), critico: Color(0xFFC33D22)),
  PumpingTheme(id: 'galeria', nome: 'Preto', desc: 'Preto puro. Máximo contraste na pouca luz.', fundo: Color(0xFF000000), painel: Color(0xFF0B0F12), agua: Color(0xFF4FD8E6), alerta: Color(0xFFFFD633), critico: Color(0xFFFF6A3D)),
  PumpingTheme(id: 'branco', nome: 'Branco', desc: 'Fundo claro e limpo. Leitura sob sol forte.', fundo: Color(0xFFFFFFFF), painel: Color(0xFFF4F7F8), agua: Color(0xFF0D7A86), alerta: Color(0xFF996800), critico: Color(0xFFBD3616)),
  PumpingTheme(id: 'bancada', nome: 'Bancada', desc: 'Claro e quente. Turnos longos no escritório.', fundo: Color(0xFFEFE9E0), painel: Color(0xFFFBF7F1), agua: Color(0xFF1C6B74), alerta: Color(0xFF96690B), critico: Color(0xFFA83A18)),
  PumpingTheme(id: 'lampada', nome: 'Lâmpada', desc: 'Âmbar. Não ofusca a vista no escuro da mina.', fundo: Color(0xFF120C05), painel: Color(0xFF1C1409), agua: Color(0xFFF0A92C), alerta: Color(0xFFFFD166), critico: Color(0xFFE35B2C)),
];

/// Modelo de Caixa de Distribuição
class CaixaModel {
  final String id;
  String nome;
  String setor;

  CaixaModel({required this.id, required this.nome, required this.setor});

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'setor': setor};
  factory CaixaModel.fromJson(Map<String, dynamic> json) => CaixaModel(
        id: json['id'] ?? '',
        nome: json['nome'] ?? '',
        setor: json['setor'] ?? '',
      );
}

/// Modelo de Fim de Rampa
class RampaModel {
  final String id;
  String nome;
  double atencao;
  double critico;
  String sentido; // 'menor' | 'maior'
  bool semMetragem;

  RampaModel({
    required this.id,
    required this.nome,
    this.atencao = 50,
    this.critico = 25,
    this.sentido = 'menor',
    this.semMetragem = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'atencao': atencao,
        'critico': critico,
        'sentido': sentido,
        'semMetragem': semMetragem,
      };

  factory RampaModel.fromJson(Map<String, dynamic> json) => RampaModel(
        id: json['id'] ?? '',
        nome: json['nome'] ?? '',
        atencao: (json['atencao'] ?? 50).toDouble(),
        critico: (json['critico'] ?? 25).toDouble(),
        sentido: json['sentido'] ?? 'menor',
        semMetragem: json['semMetragem'] ?? false,
      );
}

/// Modelo de Colaborador
class ColaboradorModel {
  final String id;
  String nome;
  String matricula;
  String funcao;

  ColaboradorModel({
    required this.id,
    required this.nome,
    this.matricula = '',
    this.funcao = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'matricula': matricula,
        'funcao': funcao,
      };

  factory ColaboradorModel.fromJson(Map<String, dynamic> json) => ColaboradorModel(
        id: json['id'] ?? '',
        nome: json['nome'] ?? '',
        matricula: json['matricula'] ?? '',
        funcao: json['funcao'] ?? '',
      );
}

/// Detalhes de resposta para cada Caixa
class DetalheCaixa {
  bool? abastec; // true = sim, false = nao, null = sem resposta
  String abastecMotivo;
  bool? vaz; // true = sim, false = nao
  String vazMotivo;
  String vazLocal;
  String ambosObs;
  bool avisouLider;
  String obs;

  DetalheCaixa({
    this.abastec,
    this.abastecMotivo = '',
    this.vaz,
    this.vazMotivo = '',
    this.vazLocal = '',
    this.ambosObs = '',
    this.avisouLider = false,
    this.obs = '',
  });

  Map<String, dynamic> toJson() => {
        'abastec': abastec,
        'abastecMotivo': abastecMotivo,
        'vaz': vaz,
        'vazMotivo': vazMotivo,
        'vazLocal': vazLocal,
        'ambosObs': ambosObs,
        'avisouLider': avisouLider,
        'obs': obs,
      };

  factory DetalheCaixa.fromJson(Map<String, dynamic> json) => DetalheCaixa(
        abastec: json['abastec'],
        abastecMotivo: json['abastecMotivo'] ?? '',
        vaz: json['vaz'],
        vazMotivo: json['vazMotivo'] ?? '',
        vazLocal: json['vazLocal'] ?? '',
        ambosObs: json['ambosObs'] ?? '',
        avisouLider: json['avisouLider'] ?? false,
        obs: json['obs'] ?? '',
      );
}

/// Detalhes de resposta para cada Fim de Rampa
class DetalheRampa {
  double? metragem;
  bool? bomba; // true = sim, false = nao
  bool? limpeza; // true = sim (precisa), false = nao
  List<String> ocorrencias;
  bool avisouLider;

  DetalheRampa({
    this.metragem,
    this.bomba,
    this.limpeza,
    List<String>? ocorrencias,
    this.avisouLider = false,
  }) : ocorrencias = ocorrencias ?? [];

  Map<String, dynamic> toJson() => {
        'metragem': metragem,
        'bomba': bomba,
        'limpeza': limpeza,
        'ocorrencias': ocorrencias,
        'avisouLider': avisouLider,
      };

  factory DetalheRampa.fromJson(Map<String, dynamic> json) => DetalheRampa(
        metragem: json['metragem']?.toDouble(),
        bomba: json['bomba'],
        limpeza: json['limpeza'],
        ocorrencias: (json['ocorrencias'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        avisouLider: json['avisouLider'] ?? false,
      );
}

/// Modelo de Inspeção concluída ou Rascunho
class InspecaoModel {
  String id;
  String data;
  String turno;
  String turma;
  List<String> equipe; // IDs dos colaboradores
  Map<String, double?> caixas; // id -> valor%
  Map<String, DetalheCaixa> detalhesCaixas;
  Map<String, DetalheRampa> rampas;
  String observacoes;
  String criadoEm;

  InspecaoModel({
    required this.id,
    required this.data,
    required this.turno,
    required this.turma,
    required this.equipe,
    required this.caixas,
    required this.detalhesCaixas,
    required this.rampas,
    required this.observacoes,
    required this.criadoEm,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data,
        'turno': turno,
        'turma': turma,
        'equipe': equipe,
        'caixas': caixas,
        'detalhesCaixas': detalhesCaixas.map((k, v) => MapEntry(k, v.toJson())),
        'rampas': rampas.map((k, v) => MapEntry(k, v.toJson())),
        'observacoes': observacoes,
        'criadoEm': criadoEm,
      };

  factory InspecaoModel.fromJson(Map<String, dynamic> json) {
    final cxMap = <String, double?>{};
    if (json['caixas'] != null && json['caixas'] is Map) {
      Map<String, dynamic>.from(json['caixas'] as Map).forEach((k, v) {
        cxMap[k.toString()] = v == null ? null : (v as num).toDouble();
      });
    }

    final detCxMap = <String, DetalheCaixa>{};
    if (json['detalhesCaixas'] != null && json['detalhesCaixas'] is Map) {
      Map<String, dynamic>.from(json['detalhesCaixas'] as Map).forEach((k, v) {
        if (v is Map) {
          detCxMap[k.toString()] = DetalheCaixa.fromJson(Map<String, dynamic>.from(v));
        }
      });
    }

    final rampaMap = <String, DetalheRampa>{};
    if (json['rampas'] != null && json['rampas'] is Map) {
      Map<String, dynamic>.from(json['rampas'] as Map).forEach((k, v) {
        if (v is Map) {
          rampaMap[k.toString()] = DetalheRampa.fromJson(Map<String, dynamic>.from(v));
        }
      });
    }

    return InspecaoModel(
      id: json['id'] ?? '',
      data: json['data'] ?? '',
      turno: json['turno'] ?? '',
      turma: json['turma'] ?? '',
      equipe: (json['equipe'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [''],
      caixas: cxMap,
      detalhesCaixas: detCxMap,
      rampas: rampaMap,
      observacoes: json['observacoes'] ?? '',
      criadoEm: json['criadoEm'] ?? '',
    );
  }
}

/// Painter para gráfico de linhas em Flutter Canvas
class PumpingLineChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color lineColor;
  final Color textColor;

  PumpingLineChartPainter({
    required this.values,
    required this.labels,
    required this.lineColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final paintLine = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final paintFill = Paint()
      ..color = lineColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final paintDot = Paint()..color = lineColor;

    final paintGrid = Paint()
      ..color = textColor.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    double minV = values.reduce((a, b) => a < b ? a : b);
    double maxV = values.reduce((a, b) => a > b ? a : b);
    if (minV == maxV) {
      minV = (minV - 5).clamp(0, 100);
      maxV = maxV + 5;
    }

    const padL = 30.0;
    const padB = 20.0;
    final w = size.width - padL - 10;
    final h = size.height - padB - 10;

    final path = Path();
    final fillPath = Path();

    final stepX = w / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final x = padL + (i * stepX);
      final normalized = (values[i] - minV) / (maxV - minV);
      final y = 10 + (1 - normalized) * h;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height - padB);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 3, paintDot);
    }

    fillPath.lineTo(padL + (values.length - 1) * stepX, size.height - padB);
    fillPath.close();

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);

    // Eixo horizontal e legenda
    canvas.drawLine(Offset(padL, size.height - padB), Offset(size.width, size.height - padB), paintGrid);
  }

  @override
  bool shouldRepaint(covariant PumpingLineChartPainter oldDelegate) => true;
}

/// Página Principal de Drenagem e Bombeamento 1:1 Nativa Flutter
class PumpingReportFormPage extends ConsumerStatefulWidget {
  const PumpingReportFormPage({super.key});

  @override
  ConsumerState<PumpingReportFormPage> createState() => _PumpingReportFormPageState();
}

class _PumpingReportFormPageState extends ConsumerState<PumpingReportFormPage> {
  int _currentTab = 0; // 0: Inspeção, 1: Painel, 2: Histórico, 3: Cadastros
  String _selectedThemeId = 'rocha';

  // Base Data
  final List<String> _setores = ['Superfície', 'Setor E', 'Setor B', 'Setor W', 'Setor C'];
  final List<CaixaModel> _caixas = [
    CaixaModel(id: 'cx-1', nome: 'Superfície do E', setor: 'Superfície'),
    CaixaModel(id: 'cx-2', nome: 'Superfície do B', setor: 'Superfície'),
    CaixaModel(id: 'cx-3', nome: 'E21', setor: 'Setor E'),
    CaixaModel(id: 'cx-4', nome: 'E32', setor: 'Setor E'),
    CaixaModel(id: 'cx-5', nome: 'E71', setor: 'Setor E'),
    CaixaModel(id: 'cx-6', nome: 'E78', setor: 'Setor E'),
    CaixaModel(id: 'cx-7', nome: 'E91', setor: 'Setor E'),
    CaixaModel(id: 'cx-8', nome: 'E96', setor: 'Setor E'),
    CaixaModel(id: 'cx-9', nome: 'B10', setor: 'Setor B'),
    CaixaModel(id: 'cx-10', nome: 'W40', setor: 'Setor W'),
    CaixaModel(id: 'cx-11', nome: 'W310', setor: 'Setor W'),
    CaixaModel(id: 'cx-12', nome: 'C15', setor: 'Setor C'),
    CaixaModel(id: 'cx-13', nome: 'C35', setor: 'Setor C'),
    CaixaModel(id: 'cx-14', nome: 'C44', setor: 'Setor C'),
    CaixaModel(id: 'cx-15', nome: 'C54', setor: 'Setor C'),
  ];

  final List<RampaModel> _rampas = [
    RampaModel(id: 'fr-1', nome: 'D200', atencao: 50, critico: 25),
    RampaModel(id: 'fr-2', nome: 'W56', atencao: 50, critico: 25),
    RampaModel(id: 'fr-3', nome: 'R4 – SAMP', atencao: 50, critico: 25, semMetragem: true),
    RampaModel(id: 'fr-4', nome: 'R4 – E6', atencao: 50, critico: 25),
    RampaModel(id: 'fr-5', nome: 'W47', atencao: 50, critico: 25, semMetragem: true),
    RampaModel(id: 'fr-6', nome: 'W49', atencao: 50, critico: 25, semMetragem: true),
    RampaModel(id: 'fr-7', nome: 'C170', atencao: 50, critico: 25, semMetragem: true),
    RampaModel(id: 'fr-8', nome: 'E DEEP', atencao: 50, critico: 25),
  ];

  late List<ColaboradorModel> _colaboradores;
  final List<String> _turnos = ['T1', 'T2', 'T3'];
  final List<String> _turmas = ['A', 'B', 'C', 'D'];

  double _limiteCaixaBaixo = 20;
  double _limiteCaixaAlto = 90;

  String _zapNumero = '';
  String _zapControle = '';
  String _zapLider = '';

  // Rascunho & Histórico Persistentes
  late InspecaoModel _rascunho;
  final List<InspecaoModel> _inspecoes = [];

  // UI State
  final Set<String> _caixasAbertas = {};
  final Set<String> _gavetasOcorrenciasAbertas = {};
  final Map<int, String> _buscaExecText = {};
  final Map<int, bool> _modoExecMatricula = {};

  // Filtros Histórico
  String _filtroTurno = '';
  String _filtroTurma = '';

  // Painel seletores
  String _chartCaixaId = 'cx-1';
  String _chartRampaId = 'fr-1';

  final List<String> _ocorrenciasOpcoes = [
    'Vazamento',
    'Obstrução',
    'Tubulação danificada',
    'Painel com falha',
    'Falta de energia',
  ];

  // Controllers para aba Cadastros
  final _colabNomeCtrl = TextEditingController();
  final _colabMatCtrl = TextEditingController();
  final _colabFunCtrl = TextEditingController();

  final _cxNomeCtrl = TextEditingController();
  String _cxSetorSel = 'Superfície';

  final _frNomeCtrl = TextEditingController();
  final _frAtenCtrl = TextEditingController(text: '50');
  final _frCritCtrl = TextEditingController(text: '25');

  @override
  void initState() {
    super.initState();
    _colaboradores = _carregarColaboradoresPadrao();
    _iniciarRascunho();
    _carregarDadosPersistidos();
  }

  PumpingTheme get _activeTheme {
    return kPumpingThemes.firstWhere((t) => t.id == _selectedThemeId, orElse: () => kPumpingThemes.first);
  }

  // --- PERSISTÊNCIA COMPLETA EM SHARED PREFERENCES ---

  Future<void> _carregarDadosPersistidos() async {
    final prefs = await SharedPreferences.getInstance();

    final themeId = prefs.getString('bombeamento_tema');
    if (themeId != null && themeId.isNotEmpty) {
      _selectedThemeId = themeId;
    }

    _zapNumero = prefs.getString('bombeamento_zapNumero') ?? '';
    _zapControle = prefs.getString('bombeamento_zapControle') ?? '';
    _zapLider = prefs.getString('bombeamento_zapLider') ?? '';

    _limiteCaixaBaixo = prefs.getDouble('bombeamento_limBaixo') ?? 20;
    _limiteCaixaAlto = prefs.getDouble('bombeamento_limAlto') ?? 90;

    final rascunhoJson = prefs.getString('bombeamento_rascunho');
    if (rascunhoJson != null && rascunhoJson.isNotEmpty) {
      try {
        _rascunho = InspecaoModel.fromJson(jsonDecode(rascunhoJson));
      } catch (_) {}
    }

    final inspecoesJson = prefs.getStringList('bombeamento_inspecoes');
    if (inspecoesJson != null) {
      _inspecoes.clear();
      for (var item in inspecoesJson) {
        try {
          _inspecoes.add(InspecaoModel.fromJson(jsonDecode(item)));
        } catch (_) {}
      }
    }

    if (mounted) setState(() {});

    // Iniciar escuta em tempo real do Cloud Firestore
    FirestoreCadastrosService().escutarCadastrosArea(
      area: 'bombeamento',
      onData: (data) {
        if (!mounted) return;
        setState(() {
          if (data['caixas'] != null) {
            _caixas.clear();
            _caixas.addAll((data['caixas'] as List).map((c) => CaixaModel.fromJson(Map<String, dynamic>.from(c))));
          }
          if (data['rampas'] != null) {
            _rampas.clear();
            _rampas.addAll((data['rampas'] as List).map((r) => RampaModel.fromJson(Map<String, dynamic>.from(r))));
          }
          if (data['colaboradores'] != null) {
            _colaboradores.clear();
            _colaboradores.addAll((data['colaboradores'] as List).map((c) => ColaboradorModel.fromJson(Map<String, dynamic>.from(c))));
          }
          if (data['zapNumero'] != null) _zapNumero = data['zapNumero'].toString();
          if (data['zapControle'] != null) _zapControle = data['zapControle'].toString();
          if (data['zapLider'] != null) _zapLider = data['zapLider'].toString();
        });
      },
    );
  }

  Future<void> _salvarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bombeamento_tema', _selectedThemeId);
    await prefs.setString('bombeamento_zapNumero', _zapNumero);
    await prefs.setString('bombeamento_zapControle', _zapControle);
    await prefs.setString('bombeamento_zapLider', _zapLider);
    await prefs.setDouble('bombeamento_limBaixo', _limiteCaixaBaixo);
    await prefs.setDouble('bombeamento_limAlto', _limiteCaixaAlto);

    await prefs.setString('bombeamento_rascunho', jsonEncode(_rascunho.toJson()));

    final listJson = _inspecoes.map((i) => jsonEncode(i.toJson())).toList();
    await prefs.setStringList('bombeamento_inspecoes', listJson);

    // Sincronizar em tempo real com Cloud Firestore
    await FirestoreCadastrosService().salvarCadastrosArea(
      area: 'bombeamento',
      data: {
        'caixas': _caixas.map((c) => c.toJson()).toList(),
        'rampas': _rampas.map((r) => r.toJson()).toList(),
        'colaboradores': _colaboradores.map((c) => c.toJson()).toList(),
        'zapNumero': _zapNumero,
        'zapControle': _zapControle,
        'zapLider': _zapLider,
        'limiteCaixaBaixo': _limiteCaixaBaixo,
        'limiteCaixaAlto': _limiteCaixaAlto,
        'atualizadoEm': DateTime.now().toIso8601String(),
      },
    );
  }

  List<ColaboradorModel> _carregarColaboradoresPadrao() {
    const raw = [
      ['4786', 'ACACIO OLIVEIRA SOUZA'],
      ['99300599', 'ADAILTON SILVA SANTOS'],
      ['99300182', 'ADONIS EVARISTO SOUSA DOS SANTOS'],
      ['99300217', 'ADRIANO DA FONSECA SANTANA'],
      ['5115', 'ADRIANO SILVA DE MATOS'],
      ['4918', 'ALEANDRO BONIFACIO DOS SANTOS 05'],
      ['99300607', 'ALTAIR DA SILVA ALMEIDA'],
      ['99300855', 'ANDERSON ANDREY GOMES'],
      ['99300603', 'ANDESON DE JESUS SANTOS'],
      ['99300920', 'CAMILLY SANTANA DA SILVA E SILVA'],
      ['99300868', 'CARLOS DANIEL DE QUEIROZ FIRMO'],
      ['5252', 'CELIO MARINHO CARVALHO JUNIOR'],
      ['99300906', 'CLAUDEMIRO GORDIANO CUNHA'],
      ['99300377', 'CLAUDIO AUGUSTO DO PRADO DE OLIVEIRA'],
      ['70207063', 'CLEBSON OLIVEIRA MOURA'],
      ['5257', 'CLEILSON ARAUJO DE JESUS'],
      ['99300193', 'CLEINILSON DA MOTA FIRMO'],
      ['4895', 'CRISTIANO RODRIGUES DIAS DE JESUS'],
      ['99300582', 'DANILO PEREIRA DA SILVA'],
      ['608', 'DENILSON ALVES MOREIRA'],
      ['99300595', 'DEYFERSON DE QUEIROZ FIRMO'],
      ['99300164', 'DIMELSON SOUZA DA SILVA'],
      ['70207550', 'EDCARIO NUNES DOS SANTOS'],
      ['99300538', 'EDIMARI BARRETO CRUZ'],
      ['604', 'EDMILSON FERREIRA DOS SANTOS'],
      ['4771', 'EDMUNDO SANTOS DE JESUS'],
      ['99300869', 'ELIONALDO MORAIS DE LUCENA'],
      ['4753', 'EMANUELLE SANTOS SILVA'],
      ['99300606', 'EMILIO MANAIA LIMA'],
      ['99300432', 'ERICK DE ARAUJO PIMENTEL'],
      ['99300346', 'ERIQUE DE MATOS SANTOS'],
      ['99300635', 'FABRICIO DE CARVALHO SANTOS'],
      ['99300685', 'FAGNER DE QUEIROZ MENDONÇA'],
      ['99300144', 'FELIPE MATOS SANTOS'],
      ['4751', 'FERNANDO DE JESUS SANTOS'],
      ['99300389', 'FERNANDO JURITI REIS'],
      ['99300203', 'FRANCISCO ELEXSANDRO DA SILVA'],
      ['99300268', 'FRANCISCO FAGNE OLIVEIRA SILVA'],
      ['99300456', 'GABRIEL ALVES QUEIROZ LOPES'],
      ['607', 'GABRIEL DA SILVA DAMIÃO'],
      ['4929', 'GENESIO MUNIZ DOS SANTOS'],
      ['99300447', 'GENILSON RIBEIRO DOS SANTOS'],
      ['5255', 'GEOVANE BISPO DOS SANTOS'],
      ['4774', 'GEOVANE OLIVEIRA ARAUJO'],
      ['99300532', 'GILDENOR LOPES DE OLIVEIRA'],
      ['99300535', 'GILMAR NASCIMENTO MOREIRA'],
      ['99300575', 'GILMAR OLIVEIRA DE JESUS'],
      ['99300383', 'GILVANDRO DAMIÃO DE JESUS'],
      ['4788', 'GIRLAN QUEIROZ DOS SANTOS'],
      ['99300433', 'GUSTAVO OLIVEIRA SANTANA'],
      ['99300598', 'GUTIERRY SANTOS MATOS'],
      ['99300491', 'HAMILTON ARAUJO DOS SANTOS'],
      ['5178', 'ISAAC VALERIO DOS SANTOS'],
      ['5353', 'ITALO DA COSTA DUTRA'],
      ['5247', 'IVANILSON DE JESUS SANTOS'],
      ['4775', 'JACKSON DE JESUS SILVA'],
      ['5254', 'JAILTON OLIVEIRA DOS SANTOS'],
      ['99300149', 'JENIVALDO SILVA DOS SANTOS'],
      ['5256', 'JOANDERSON SILVA GONÇALVES'],
      ['605', 'JOAO MICAEL SANTOS SIMOES'],
      ['99300472', 'JOELSON PEREIRA DA SILVA'],
      ['99300619', 'JONATHAN GORDIANO RODRIGUES'],
      ['4748', 'JOSÉ ALBERTO DE ARAUJO CRISTO'],
      ['4782', 'JOSÉ CERQUEIRA DOS SANTOS'],
      ['4784', 'JOSE MILTON BISPO DOS SANTOS'],
      ['882', 'JOSE NARCISO FERREIRA DE QUEIROZ'],
      ['606', 'JOSEMY NUNES SANTOS'],
      ['99300239', 'JOSEVALDO SANTOS DE JESUS'],
      ['5170', 'JUCINEIA QUEIROZ OLIVEIRA'],
      ['99300525', 'KEZYA QUEIROZ OLIVEIRA'],
      ['5236', 'KLEBERLITO LUCIANO CARNEIRO DA SILVA'],
      ['99300264', 'LEONARDO DOS SANTOS LIMA DE QUEIROZ'],
      ['4752', 'LEONARDO MOTA NASCIMENTO'],
      ['99300827', 'LEONARDO PINTO DE ABREU VILLA NOVA'],
      ['611', 'LUCAS DE JESUS NUNES'],
      ['99300295', 'LUCAS EVANGELISTA F CERQUEIRA'],
      ['4791', 'LUCAS MOURA DE MENDONCA'],
      ['609', 'MAICOM SANTOS DA SILVA'],
      ['4793', 'MARCOLINO DOS SANTOS'],
      ['99300327', 'MARCOS CASSIANO OLIVEIRA'],
      ['4933', 'MARCOS NEVES MOURA'],
      ['99300152', 'MARCOS REAL MOTA'],
      ['99300306', 'MARINALDO GONÇALVES SOUZA'],
      ['99300061', 'MATEUS BARRETO CALVACANTE'],
      ['4795', 'MATHEUS SILVA PASTOR'],
      ['610', 'MAYKO FIEL DOS ANJOS SANTOS'],
      ['4794', 'NATALINO PAIXÃO DOS SANTOS'],
      ['99300589', 'NIEL PEREIRA RODRIGUES'],
      ['5100', 'PABLO OLIVEIRA ARAUJO'],
      ['99300461', 'PAULO DITARSO GUIMARAES PORTO SOUZA'],
      ['5248', 'PAULO HENRIQUE LIMA DE JESUS'],
      ['5251', 'RAFAEL DE OLIVEIRA CARDOSO'],
      ['5233', 'RAYANE SILVA LIMA'],
      ['99300440', 'RICARDO MORAES'],
      ['99300594', 'RICARDO SANTOS LIMA'],
      ['4797', 'ROBENILSON CERQUEIRA DOS SANTOS'],
      ['4798', 'ROBERTO DAS VIRGENS FERREIRA'],
      ['5258', 'ROBSON RICARDO SOARES DA SILVA'],
      ['4758', 'ROMILSON LIMA OLIVEIRA'],
      ['99300699', 'ROMILSON SANTOS DE JESUS'],
      ['99300677', 'RONALDO DO ROSARIO NASCIMENTO'],
      ['99300446', 'SANDRO PEREIRA DOS SANTOS'],
      ['4899', 'SAUL VINICIUS DE JESUS SOUZA'],
      ['4800', 'VENANCIO ARAÚJO QUEIROZ'],
      ['4802', 'WILLIAM PEREIRA DA SILVA']
    ];

    return raw.map((item) => ColaboradorModel(
      id: 'col-${item[0]}',
      nome: item[1],
      matricula: item[0],
    )).toList();
  }

  void _iniciarRascunho() {
    final now = DateTime.now();
    final dataStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final cxMap = <String, double?>{};
    final detCxMap = <String, DetalheCaixa>{};
    for (var c in _caixas) {
      cxMap[c.id] = null;
      detCxMap[c.id] = DetalheCaixa();
    }

    final rampaMap = <String, DetalheRampa>{};
    for (var r in _rampas) {
      rampaMap[r.id] = DetalheRampa();
    }

    _rascunho = InspecaoModel(
      id: 'rascunho',
      data: dataStr,
      turno: _turnos.isNotEmpty ? _turnos.first : 'T1',
      turma: _turmas.isNotEmpty ? _turmas.first : 'A',
      equipe: [''],
      caixas: cxMap,
      detalhesCaixas: detCxMap,
      rampas: rampaMap,
      observacoes: '',
      criadoEm: now.toIso8601String(),
    );
  }

  // --- HELPERS DE LAYOUT E BOTÕES 1:1 COM EXTREMO CONTRASTE ---

  Widget _buildChipButton({
    required PumpingTheme theme,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Color? activeColor,
  }) {
    final textColor = theme.isDark ? Colors.white : Colors.black87;
    final effectiveActiveColor = activeColor ?? theme.agua;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? effectiveActiveColor.withValues(alpha: 0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? effectiveActiveColor : (theme.isDark ? Colors.white30 : Colors.black26),
            width: selected ? 1.8 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? effectiveActiveColor : textColor,
          ),
        ),
      ),
    );
  }

  String _formatDateBR(String isoDate) {
    if (isoDate.isEmpty) return '—';
    final parts = isoDate.split('-');
    if (parts.length != 3) return isoDate;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  String _nomeColaborador(String id) {
    final col = _colaboradores.firstWhere((c) => c.id == id, orElse: () => ColaboradorModel(id: '', nome: ''));
    if (col.id.isEmpty) return '—';
    return col.matricula.isNotEmpty ? '${col.nome} (${col.matricula})' : col.nome;
  }

  Map<String, String> _estadoCaixa(double? p) {
    if (p == null) return {'cls': '', 'selo': '', 'txt': 'não informado'};
    if (p <= _limiteCaixaBaixo) return {'cls': 'crit', 'selo': 'crit', 'txt': 'nível baixo'};
    if (p >= _limiteCaixaAlto) return {'cls': 'crit', 'selo': 'crit', 'txt': 'risco de transbordo'};
    if (p <= _limiteCaixaBaixo + 10 || p >= _limiteCaixaAlto - 10) return {'cls': 'aten', 'selo': 'aten', 'txt': 'atenção'};
    return {'cls': '', 'selo': 'ok', 'txt': 'normal'};
  }

  Map<String, String> _estadoRampa(RampaModel r, double? m, DetalheRampa? d) {
    if (d?.bomba == false) return {'cls': 'crit', 'selo': 'crit', 'txt': 'bomba parada'};
    if (d?.limpeza == true) return {'cls': 'aten', 'selo': 'aten', 'txt': 'precisa de limpeza'};
    if (d != null && d.ocorrencias.isNotEmpty) return {'cls': 'aten', 'selo': 'aten', 'txt': d.ocorrencias.join(', ').toLowerCase()};
    if (r.semMetragem) {
      final respondido = d != null && (d.bomba != null || d.limpeza != null);
      return respondido ? {'cls': '', 'selo': 'ok', 'txt': 'normal'} : {'cls': '', 'selo': '', 'txt': 'não informado'};
    }
    if (m == null) return {'cls': '', 'selo': '', 'txt': 'não informado'};
    final v = m;
    final menor = r.sentido != 'maior';
    if (menor) {
      if (v < 0) return {'cls': 'crit', 'selo': 'crit', 'txt': 'passou do ponto zero'};
      if (v == 0) return {'cls': 'crit', 'selo': 'crit', 'txt': 'água no ponto zero'};
      if (v <= r.critico) return {'cls': 'crit', 'selo': 'crit', 'txt': 'água próxima da rampa'};
      if (v <= r.atencao) return {'cls': 'aten', 'selo': 'aten', 'txt': 'atenção'};
      return {'cls': '', 'selo': 'ok', 'txt': 'normal'};
    }
    if (v >= r.critico) return {'cls': 'crit', 'selo': 'crit', 'txt': 'água próxima da rampa'};
    if (v >= r.atencao) return {'cls': 'aten', 'selo': 'aten', 'txt': 'atenção'};
    return {'cls': '', 'selo': 'ok', 'txt': 'normal'};
  }

  String _resumoCaixa(DetalheCaixa? d) {
    if (d == null) return '';
    final L = <String>[];
    if (d.abastec == false) {
      final m = d.abastecMotivo.trim();
      L.add("Não está sendo abastecida${m.isNotEmpty ? ' — $m' : ''}");
    }
    if (d.vaz == true) {
      final ex = <String>[];
      if (d.vazLocal.trim().isNotEmpty) ex.add('local: ${d.vazLocal.trim()}');
      if (d.vazMotivo.trim().isNotEmpty) ex.add('motivo: ${d.vazMotivo.trim()}');
      L.add("Vazamento no circuito${ex.isNotEmpty ? ' — ${ex.join(', ')}' : ''}");
    }
    if (d.abastec == true && d.vaz == true && d.ambosObs.trim().isNotEmpty) {
      L.add('Abastecida com vazamento — ${d.ambosObs.trim()}');
    }
    if (d.obs.trim().isNotEmpty) L.add(d.obs.trim());
    return L.join(' · ');
  }

  List<Map<String, String>> _criticosInspecao(InspecaoModel insp) {
    final saida = <Map<String, String>>[];
    for (var c in _caixas) {
      final p = insp.caixas[c.id];
      final d = insp.detalhesCaixas[c.id];
      final anom = _resumoCaixa(d);
      if (anom.isNotEmpty) {
        saida.add({'tipo': 'Caixa', 'ponto': c.nome, 'valor': (p == null ? '—' : '${p.toInt()}%'), 'motivo': anom});
      } else if (p != null) {
        final e = _estadoCaixa(p);
        if (e['selo'] == 'crit') {
          saida.add({'tipo': 'Caixa', 'ponto': c.nome, 'valor': '${p.toInt()}%', 'motivo': e['txt']!});
        }
      }
    }
    for (var r in _rampas) {
      final d = insp.rampas[r.id];
      if (d == null) continue;
      final e = _estadoRampa(r, d.metragem, d);
      final p = <String>[];
      if (d.bomba == false) p.add('bomba parada');
      if (d.limpeza == true) p.add('necessidade de limpeza');
      final valor = r.semMetragem ? '—' : (d.metragem == null ? '—' : '${d.metragem} m');
      if (p.isNotEmpty) {
        saida.add({'tipo': 'Fim de rampa', 'ponto': r.nome, 'valor': valor, 'motivo': p.join(' e ')});
      } else if (e['selo'] == 'crit') {
        saida.add({'tipo': 'Fim de rampa', 'ponto': r.nome, 'valor': valor, 'motivo': e['txt']!});
      }
    }
    return saida;
  }

  // --- WHATSAPP & AÇÕES ---

  Future<void> _salvarESincronizarRelatorio(InspecaoModel insp, String txt) async {
    try {
      final equipeOps = insp.equipe.map((id) {
        final nome = _nomeColaborador(id);
        return CollaboratorEntity(
          id: id,
          registration: id,
          name: nome != '—' ? nome : id,
        );
      }).toList();

      final List<WorkOrderEntity> workOrders = [];

      // Mapeia caixas de distribuição para leituras de Nível
      for (final c in _caixas) {
        final val = insp.caixas[c.id];
        final det = insp.detalhesCaixas[c.id];
        if (val != null || det != null) {
          workOrders.add(WorkOrderEntity(
            id: 'cx_${c.id}',
            number: c.nome,
            location: '${c.setor} — ${c.nome}',
            maintenanceType: 'Nível',
            cause: 'Caixa',
            activities: det != null ? (det.obs.isNotEmpty ? det.obs : 'Leitura de nível: ${val?.toInt() ?? 0}%') : 'Leitura de nível: ${val?.toInt() ?? 0}%',
            materialsUsed: const [],
            quantityMeters: val != null ? '${val.toInt()}' : '0',
            quantityPieces: '1',
            startTime: '',
            endTime: '',
            osStatus: (det?.vaz == true) ? 'Alerta' : 'Estável',
            photoPaths: const [],
          ));
        }
      }

      // Mapeia fins de rampa para status de bombas
      for (final r in _rampas) {
        final det = insp.rampas[r.id];
        if (det != null) {
          final st = det.bomba == true ? 'Operando' : (det.bomba == false ? 'Parada' : 'Stand-by');
          workOrders.add(WorkOrderEntity(
            id: 'rmp_${r.id}',
            number: r.nome,
            location: r.nome,
            maintenanceType: 'Bomba',
            cause: r.nome,
            activities: det.ocorrencias.isNotEmpty ? det.ocorrencias.join(', ') : 'Operação de rampa',
            materialsUsed: const [],
            quantityMeters: det.metragem != null ? '${det.metragem}' : '0',
            quantityPieces: '1',
            startTime: '',
            endTime: '',
            osStatus: st,
            photoPaths: const [],
          ));
        }
      }

      final report = ReportEntity(
        uuid: insp.id.startsWith('insp_') ? insp.id : 'insp_pumping_${DateTime.now().millisecondsSinceEpoch}',
        date: DateTime.tryParse(insp.data) ?? DateTime.now(),
        shift: insp.turno,
        team: insp.turma,
        type: 'Bombeamento',
        globalLocation: _caixas.isNotEmpty ? _caixas.first.setor : 'Mina Subterrânea',
        observations: txt,
        operators: equipeOps,
        workOrders: workOrders,
        syncStatus: ReportSyncStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final repository = ref.read(reportRepositoryProvider);
      await repository.saveReport(report);
      await ref.read(syncControllerProvider.notifier).triggerSync();
    } catch (e) {
      debugPrint('Erro ao salvar relatório de bombeamento no Firestore: $e');
    }
  }

  Future<void> _abrirWhatsApp(String text, String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse("whatsapp://send?${cleanPhone.isNotEmpty ? 'phone=$cleanPhone&' : ''}text=${Uri.encodeComponent(text)}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se o WhatsApp não abrir, use o botão Copiar texto.')),
        );
      }
    }
  }

  String _gerarTextoRelatorio(InspecaoModel i) {
    final L = <String>[];
    final crit = _criticosInspecao(i);
    final equipeNames = i.equipe.map((id) => _nomeColaborador(id)).where((n) => n != '—').toList();
    final vals = _caixas.map((c) => i.caixas[c.id]).where((v) => v != null).cast<double>().toList();
    final media = vals.isNotEmpty ? (vals.reduce((a, b) => a + b) / vals.length).round() : 0;

    L.add('*RELATÓRIO DE DRENAGEM E BOMBEAMENTO*');
    L.add('${_formatDateBR(i.data)}  |  ${i.turno}  |  Turma ${i.turma}');
    L.add("Executantes: ${equipeNames.isNotEmpty ? equipeNames.join(', ') : 'não informados'}");
    L.add('');
    L.add('*CAIXAS DE DISTRIBUIÇÃO*  (média $media%)');
    for (var st in _setores) {
      final lista = _caixas.where((c) => c.setor == st && i.caixas[c.id] != null).toList();
      if (lista.isEmpty) continue;
      L.add('_${st}_');
      for (var c in lista) {
        final val = i.caixas[c.id]!.toInt();
        final e = _estadoCaixa(i.caixas[c.id]);
        final anot = _resumoCaixa(i.detalhesCaixas[c.id]);
        final m = anot.isNotEmpty ? ' ⚠' : (e['selo'] == 'crit' ? ' 🔴' : (e['selo'] == 'aten' ? ' 🟡' : ''));
        L.add('• ${c.nome}: $val%$m');
        if (anot.isNotEmpty) L.add('   ↳ $anot');
      }
    }
    final semLeitura = _caixas.where((c) => i.caixas[c.id] == null).map((c) => c.nome).toList();
    if (semLeitura.isNotEmpty) L.add("_Sem leitura:_ ${semLeitura.join(', ')}");

    L.add('');
    L.add('*ÁGUAS DE FIM DE RAMPA*');
    for (var r in _rampas) {
      final d = i.rampas[r.id];
      if (d == null) continue;
      final e = _estadoRampa(r, d.metragem, d);
      final m = e['selo'] == 'crit' ? ' 🔴' : (e['selo'] == 'aten' ? ' 🟡' : '');
      final metTxt = r.semMetragem ? 'sem medição' : (d.metragem == null ? 'sem leitura' : '${d.metragem} m');
      L.add('• ${r.nome}: $metTxt$m');
      final bombaTxt = d.bomba == true ? 'operando' : (d.bomba == false ? '*PARADA*' : 'não informado');
      final limpTxt = d.limpeza == true ? '*NECESSÁRIA*' : (d.limpeza == false ? 'não' : 'não informado');
      L.add('   ↳ Bomba: $bombaTxt  |  Limpeza: $limpTxt');
      if (d.ocorrencias.isNotEmpty) L.add("   ↳ Ocorrência: ${d.ocorrencias.join(', ')}");
    }

    L.add('');
    L.add('*PONTOS CRÍTICOS*');
    if (crit.isNotEmpty) {
      for (var c in crit) {
        L.add("🔴 ${c['ponto']} — ${c['valor']} (${c['motivo']})");
      }
    } else {
      L.add('Nenhum ponto fora dos limites.');
    }

    L.add('');
    L.add('*OBSERVAÇÕES*');
    L.add(i.observacoes.trim().isNotEmpty ? i.observacoes.trim() : 'Sem observações registradas.');

    return L.join('\n');
  }

  // --- BUILD METHOD PRINCIPAL ---

  @override
  Widget build(BuildContext meContext) {
    final theme = _activeTheme;

    return Scaffold(
      backgroundColor: theme.fundo,
      appBar: AppBar(
        backgroundColor: theme.painel,
        elevation: 2,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.water_drop, color: theme.agua, size: 20),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Drenagem & Bombeamento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.isDark ? Colors.white : Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              'Mina Subterrânea — CMOC',
              style: TextStyle(fontSize: 11, color: theme.isDark ? Colors.white60 : Colors.black54),
            ),
          ],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: SyncStatusBadge(),
          ),
          if (ref.watch(devModeProvider))
            IconButton(
              icon: const Icon(Icons.flash_on_rounded, color: Colors.amber),
              tooltip: 'Preencher Automático (Modo Dev)',
              onPressed: () {
                setState(() {
                  if (_colaboradores.isNotEmpty) {
                    _rascunho.equipe = _colaboradores.take(2).map((c) => c.id).toList();
                  }
                  for (var caixa in _caixas) {
                    _rascunho.caixas[caixa.id] = 85.0;
                    _rascunho.detalhesCaixas[caixa.id] = DetalheCaixa(
                      abastec: true,
                      vaz: false,
                      obs: 'Nível normal, sem vazamentos.',
                    );
                  }
                  for (var rampa in _rampas) {
                    _rascunho.rampas[rampa.id] = DetalheRampa(
                      metragem: rampa.semMetragem ? null : 15.0,
                      bomba: true,
                      limpeza: false,
                    );
                  }
                  _rascunho.observacoes = 'Inspeção completa de rotina do sistema de bombeamento e caixas d\'água. Todos os equipamentos operacionais.';
                  _salvarEstado();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('⚡ [Modo Dev] Dados de Bombeamento preenchidos!'),
                    backgroundColor: Color(0xFF0F4C81),
                  ),
                );
              },
            ),
          IconButton(
            icon: Icon(Icons.palette_outlined, color: theme.agua),
            tooltip: 'Alterar Tema de Fundo',
            onPressed: _abrirModalTemas,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentTab,
        children: [
          _buildTabInspecao(theme),
          _buildTabPainel(theme),
          _buildTabHistorico(theme),
          _buildTabCadastros(theme),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (idx) => setState(() => _currentTab = idx),
        backgroundColor: theme.painel,
        selectedItemColor: theme.agua,
        unselectedItemColor: theme.isDark ? Colors.white38 : Colors.black45,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Inspeção'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Painel'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Cadastros'),
        ],
      ),
    );
  }

  // =========================================================================
  // ABA 1: INSPEÇÃO
  // =========================================================================

  Widget _buildTabInspecao(PumpingTheme theme) {
    final preenchidas = _caixas.where((c) => _rascunho.caixas[c.id] != null).length;
    final rampasMede = _rampas.where((r) => !r.semMetragem).toList();
    final rampasOk = rampasMede.where((r) => _rascunho.rampas[r.id]?.metragem != null).length;
    final textColor = theme.isDark ? Colors.white : Colors.black87;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Identificação do turno
          _buildCardSection(
            theme: theme,
            title: 'Identificação do Turno',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Data
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(theme, 'DATA *'),
                          InkWell(
                            onTap: () async {
                              final d = await showDatePicker(
                                context: context,
                                initialDate: DateTime.tryParse(_rascunho.data) ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (d != null) {
                                setState(() {
                                  _rascunho.data = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
                                  _salvarEstado();
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: theme.fundo,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: theme.agua.withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatDateBR(_rascunho.data), style: TextStyle(color: theme.agua, fontWeight: FontWeight.bold)),
                                  Icon(Icons.calendar_today, size: 16, color: theme.agua),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Turno
                _buildLabel(theme, 'TURNO *'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _turnos.map((t) {
                    final sel = _rascunho.turno == t;
                    return _buildChipButton(
                      theme: theme,
                      label: t,
                      selected: sel,
                      onTap: () {
                        setState(() => _rascunho.turno = t);
                        _salvarEstado();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Turma
                _buildLabel(theme, 'TURMA *'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _turmas.map((tm) {
                    final sel = _rascunho.turma == tm;
                    return _buildChipButton(
                      theme: theme,
                      label: 'Turma $tm',
                      selected: sel,
                      onTap: () {
                        setState(() => _rascunho.turma = tm);
                        _salvarEstado();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Executantes
                _buildLabel(theme, 'EXECUTANTES'),
                ...List.generate(_rascunho.equipe.length, (idx) => _buildExecutanteSlot(theme, idx)),

                const SizedBox(height: 8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.agua,
                    side: BorderSide(color: theme.agua),
                  ),
                  onPressed: () {
                    setState(() {
                      _rascunho.equipe.add('');
                      _salvarEstado();
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('+ Adicionar Executante'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Caixas de distribuição Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Caixas de Distribuição', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.agua)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: theme.painel, borderRadius: BorderRadius.circular(12)),
                child: Text('$preenchidas/${_caixas.length}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.agua)),
              ),
            ],
          ),
          Text('Toque na coluna para marcar o percentual da caixa.', style: TextStyle(fontSize: 11, color: theme.isDark ? Colors.white54 : Colors.black54)),
          const SizedBox(height: 8),

          // Caixas por Setor
          ..._setores.map((setor) {
            final caixasDoSetor = _caixas.where((c) => c.setor == setor).toList();
            if (caixasDoSetor.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 6),
                  child: Text(setor, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.alerta)),
                ),
                ...caixasDoSetor.map((c) => _buildCaixaCard(theme, c)),
              ],
            );
          }),

          const SizedBox(height: 16),

          // Águas de fim de rampa Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Águas de Fim de Rampa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.agua)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: theme.painel, borderRadius: BorderRadius.circular(12)),
                child: Text('$rampasOk/${rampasMede.length}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.agua)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ..._rampas.map((r) => _buildRampaCard(theme, r)),

          const SizedBox(height: 16),

          // Observações gerais do turno
          _buildCardSection(
            theme: theme,
            title: 'Observações Gerais do Turno',
            child: Column(
              children: [
                TextFormField(
                  initialValue: _rascunho.observacoes,
                  maxLines: 3,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Anormalidades, serviços executados, pendências...',
                    hintStyle: TextStyle(color: theme.isDark ? Colors.white38 : Colors.black38),
                    fillColor: theme.fundo,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (val) {
                    _rascunho.observacoes = val;
                    _salvarEstado();
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.agua,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () { _encerrarTurno(); },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Encerrar Turno e Gerar Relatório', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 6),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _iniciarRascunho();
                        _salvarEstado();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Formulário limpo.')));
                    },
                    child: const Text('Limpar Formulário', style: TextStyle(color: Colors.redAccent)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutanteSlot(PumpingTheme theme, int idx) {
    final textColor = theme.isDark ? Colors.white : Colors.black87;
    final idAtual = _rascunho.equipe.length > idx ? _rascunho.equipe[idx] : '';
    final busca = _buscaExecText[idx] ?? '';
    final modoMat = _modoExecMatricula[idx] ?? false;

    if (idAtual.isNotEmpty) {
      final colab = _colaboradores.firstWhere((c) => c.id == idAtual, orElse: () => ColaboradorModel(id: '', nome: ''));
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(color: theme.fundo, borderRadius: BorderRadius.circular(8), border: Border.all(color: theme.agua)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(colab.nome, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  Text(colab.matricula.isNotEmpty ? 'Matrícula ${colab.matricula}' : 'Sem matrícula', style: TextStyle(fontSize: 11, color: theme.isDark ? Colors.white54 : Colors.black54)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh, size: 18, color: theme.agua),
              onPressed: () => setState(() {
                _rascunho.equipe[idx] = '';
                _salvarEstado();
              }),
            ),
            if (idx > 0)
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.redAccent),
                onPressed: () => setState(() {
                  _rascunho.equipe.removeAt(idx);
                  _salvarEstado();
                }),
              ),
          ],
        ),
      );
    }

    final sugeridos = _colaboradores.where((c) {
      if (busca.isEmpty) return false;
      final term = busca.toLowerCase();
      if (modoMat) return c.matricula.toLowerCase().contains(term);
      return c.nome.toLowerCase().contains(term) || c.matricula.toLowerCase().contains(term);
    }).take(6).toList();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: modoMat ? 'Buscar por Matrícula...' : 'Buscar Colaborador...',
                  hintStyle: TextStyle(color: theme.isDark ? Colors.white38 : Colors.black38),
                  isDense: true,
                  fillColor: theme.fundo,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (val) => setState(() => _buscaExecText[idx] = val),
              ),
            ),
            const SizedBox(width: 6),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: modoMat ? theme.agua : (theme.isDark ? Colors.white54 : Colors.black54)),
              onPressed: () => setState(() => _modoExecMatricula[idx] = !modoMat),
              child: Text(modoMat ? 'Matrícula ✓' : 'Matrícula'),
            ),
          ],
        ),
        if (sugeridos.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4, bottom: 8),
            decoration: BoxDecoration(color: theme.fundo, borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: sugeridos.map((col) {
                return ListTile(
                  dense: true,
                  title: Text(col.nome, style: TextStyle(fontSize: 13, color: textColor)),
                  subtitle: Text(col.matricula.isNotEmpty ? 'Matrícula: ${col.matricula}' : '', style: TextStyle(fontSize: 11, color: theme.agua)),
                  onTap: () {
                    setState(() {
                      _rascunho.equipe[idx] = col.id;
                      _buscaExecText[idx] = '';
                      _salvarEstado();
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // Visual Caixa Card
  Widget _buildCaixaCard(PumpingTheme theme, CaixaModel c) {
    final textColor = theme.isDark ? Colors.white : Colors.black87;
    final valor = _rascunho.caixas[c.id];
    final estado = _estadoCaixa(valor);
    final d = _rascunho.detalhesCaixas[c.id];
    final resumo = _resumoCaixa(d);
    final estaAberto = _caixasAbertas.contains(c.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.painel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: estado['selo'] == 'crit' ? theme.critico : (estado['selo'] == 'aten' || resumo.isNotEmpty ? theme.alerta : theme.fundo),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coluna Vertical de Nível (100% até 0%)
              Container(
                width: 44,
                decoration: BoxDecoration(color: theme.fundo, borderRadius: BorderRadius.circular(6)),
                child: Column(
                  children: List.generate(11, (idx) {
                    final p = (10 - idx) * 10;
                    final isFilled = valor != null && p <= valor;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (_rascunho.caixas[c.id] == p.toDouble() && p == 0) {
                            _rascunho.caixas[c.id] = null;
                          } else {
                            _rascunho.caixas[c.id] = p.toDouble();
                          }
                          _salvarEstado();
                        });
                      },
                      child: Container(
                        height: 16,
                        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                        decoration: BoxDecoration(
                          color: isFilled ? theme.agua : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: Text(
                            '$p%',
                            style: TextStyle(fontSize: 8, color: isFilled ? Colors.black : (theme.isDark ? Colors.white38 : Colors.black45)),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.nome, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                    Text(c.setor, style: TextStyle(fontSize: 11, color: theme.isDark ? Colors.white54 : Colors.black54)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(valor == null ? '--%' : '${valor.toInt()}%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.agua)),
                        const SizedBox(width: 8),
                        Text(
                          estado['txt']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: estado['selo'] == 'crit' ? theme.critico : (estado['selo'] == 'aten' ? theme.alerta : (theme.isDark ? Colors.white54 : Colors.black54)),
                          ),
                        ),
                      ],
                    ),
                    if (resumo.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('⚠️ $resumo', style: TextStyle(fontSize: 11, color: theme.alerta)),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              setState(() {
                if (estaAberto) {
                  _caixasAbertas.remove(c.id);
                } else {
                  _caixasAbertas.add(c.id);
                }
              });
            },
            icon: Icon(estaAberto ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: theme.agua),
            label: Text(estaAberto ? '▲ Fechar' : (resumo.isNotEmpty ? '▼ Ver Observação' : '▼ Observação'), style: TextStyle(color: theme.agua, fontSize: 12)),
          ),

          if (estaAberto && d != null) ...[
            const Divider(),
            _buildLabel(theme, 'A caixa está sendo abastecida?'),
            Row(
              children: [
                Expanded(
                  child: _buildChipButton(
                    theme: theme,
                    label: 'Sim',
                    selected: d.abastec == true,
                    activeColor: theme.agua,
                    onTap: () => setState(() {
                      d.abastec = d.abastec == true ? null : true;
                      _salvarEstado();
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildChipButton(
                    theme: theme,
                    label: 'Não',
                    selected: d.abastec == false,
                    activeColor: theme.critico,
                    onTap: () => setState(() {
                      d.abastec = d.abastec == false ? null : false;
                      _salvarEstado();
                    }),
                  ),
                ),
              ],
            ),
            if (d.abastec == false)
              TextFormField(
                initialValue: d.abastecMotivo,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(hintText: 'Por que não está abastecendo?', hintStyle: TextStyle(color: theme.isDark ? Colors.white38 : Colors.black38)),
                onChanged: (val) {
                  d.abastecMotivo = val;
                  _salvarEstado();
                },
              ),

            const SizedBox(height: 10),
            _buildLabel(theme, 'Existe algum vazamento no circuito?'),
            Row(
              children: [
                Expanded(
                  child: _buildChipButton(
                    theme: theme,
                    label: 'Sim',
                    selected: d.vaz == true,
                    activeColor: theme.critico,
                    onTap: () => setState(() {
                      d.vaz = d.vaz == true ? null : true;
                      _salvarEstado();
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildChipButton(
                    theme: theme,
                    label: 'Não',
                    selected: d.vaz == false,
                    activeColor: theme.agua,
                    onTap: () => setState(() {
                      d.vaz = d.vaz == false ? null : false;
                      _salvarEstado();
                    }),
                  ),
                ),
              ],
            ),
            if (d.vaz == true) ...[
              TextFormField(
                initialValue: d.vazLocal,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(hintText: 'Local do vazamento', hintStyle: TextStyle(color: theme.isDark ? Colors.white38 : Colors.black38)),
                onChanged: (val) {
                  d.vazLocal = val;
                  _salvarEstado();
                },
              ),
              TextFormField(
                initialValue: d.vazMotivo,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(hintText: 'Causa do vazamento', hintStyle: TextStyle(color: theme.isDark ? Colors.white38 : Colors.black38)),
                onChanged: (val) {
                  d.vazMotivo = val;
                  _salvarEstado();
                },
              ),
            ],

            if (d.abastec == true && d.vaz == true) ...[
              const SizedBox(height: 8),
              _buildLabel(theme, 'Abastecida e com vazamento ao mesmo tempo'),
              TextFormField(
                initialValue: d.ambosObs,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(hintText: 'Registre o que foi observado', hintStyle: TextStyle(color: theme.isDark ? Colors.white38 : Colors.black38)),
                onChanged: (val) {
                  d.ambosObs = val;
                  _salvarEstado();
                },
              ),
            ],
          ],
        ],
      ),
    );
  }

  // Visual Rampa Card
  Widget _buildRampaCard(PumpingTheme theme, RampaModel r) {
    final textColor = theme.isDark ? Colors.white : Colors.black87;
    final d = _rascunho.rampas[r.id] ?? DetalheRampa();
    final estado = _estadoRampa(r, d.metragem, d);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.painel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: estado['selo'] == 'crit' ? theme.critico : (estado['selo'] == 'aten' ? theme.alerta : theme.fundo),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(r.nome, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: estado['selo'] == 'crit' ? theme.critico : (estado['selo'] == 'aten' ? theme.alerta : theme.agua.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  estado['txt']!,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: estado['selo'] == 'crit' || estado['selo'] == 'aten' ? Colors.black : theme.agua),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Stepper de Metragem
          if (!r.semMetragem) ...[
            _buildLabel(theme, 'Metragem da água até o ponto zero'),
            Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: theme.fundo),
                  icon: Icon(Icons.remove, color: theme.agua),
                  onPressed: () {
                    setState(() {
                      final curr = d.metragem ?? 0;
                      d.metragem = (curr - 5);
                      _salvarEstado();
                    });
                  },
                ),
                Expanded(
                  child: TextFormField(
                    key: Key('metragem_${r.id}_${d.metragem}'),
                    initialValue: d.metragem?.toString() ?? '',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.agua),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(color: theme.isDark ? Colors.white38 : Colors.black38),
                      fillColor: theme.fundo,
                      filled: true,
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (val) {
                      d.metragem = double.tryParse(val);
                      _salvarEstado();
                    },
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: theme.fundo),
                  icon: Icon(Icons.add, color: theme.agua),
                  onPressed: () {
                    setState(() {
                      final curr = d.metragem ?? 0;
                      d.metragem = (curr + 5);
                      _salvarEstado();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Perguntas Sim/Não
          _buildLabel(theme, 'A bomba está operando? *'),
          Row(
            children: [
              Expanded(
                child: _buildChipButton(
                  theme: theme,
                  label: 'Sim',
                  selected: d.bomba == true,
                  activeColor: theme.agua,
                  onTap: () => setState(() {
                    d.bomba = d.bomba == true ? null : true;
                    _salvarEstado();
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildChipButton(
                  theme: theme,
                  label: 'Não',
                  selected: d.bomba == false,
                  activeColor: theme.critico,
                  onTap: () => setState(() {
                    d.bomba = d.bomba == false ? null : false;
                    _salvarEstado();
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          _buildLabel(theme, 'Há necessidade de limpeza? *'),
          Row(
            children: [
              Expanded(
                child: _buildChipButton(
                  theme: theme,
                  label: 'Não',
                  selected: d.limpeza == false,
                  activeColor: theme.agua,
                  onTap: () => setState(() {
                    d.limpeza = d.limpeza == false ? null : false;
                    _salvarEstado();
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildChipButton(
                  theme: theme,
                  label: 'Sim',
                  selected: d.limpeza == true,
                  activeColor: theme.alerta,
                  onTap: () => setState(() {
                    d.limpeza = d.limpeza == true ? null : true;
                    _salvarEstado();
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Seletor de Ocorrências idêntico ao modelo HTML (.barra-sel)
          _buildOcorrenciasSelector(theme, r, d),
        ],
      ),
    );
  }

  /// Seletor expansível de Vazamentos/Obstruções idêntico ao modelo HTML (.barra-sel)
  Widget _buildOcorrenciasSelector(PumpingTheme theme, RampaModel r, DetalheRampa d) {
    final isExpanded = _gavetasOcorrenciasAbertas.contains(r.id);
    final count = d.ocorrencias.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(theme, 'Vazamentos / obstruções *'),
        InkWell(
          onTap: () {
            setState(() {
              if (isExpanded) {
                _gavetasOcorrenciasAbertas.remove(r.id);
              } else {
                _gavetasOcorrenciasAbertas.add(r.id);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.fundo,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: count > 0 ? theme.alerta : theme.agua.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    count > 0 ? d.ocorrencias.join(', ') : 'Sem anormalidade',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: count > 0 ? FontWeight.bold : FontWeight.normal,
                      color: count > 0 ? theme.alerta : (theme.isDark ? Colors.white54 : Colors.black54),
                    ),
                  ),
                ),
                if (count > 1)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: theme.alerta, borderRadius: BorderRadius.circular(10)),
                    child: Text('$count', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: count > 0 ? theme.alerta : theme.agua),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: theme.fundo, borderRadius: BorderRadius.circular(8)),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Chip "Sem anormalidade"
                _buildChipButton(
                  theme: theme,
                  label: 'Sem anormalidade',
                  selected: count == 0,
                  activeColor: theme.agua,
                  onTap: () {
                    setState(() {
                      d.ocorrencias.clear();
                      _salvarEstado();
                    });
                  },
                ),
                ..._ocorrenciasOpcoes.map((oc) {
                  final sel = d.ocorrencias.contains(oc);
                  return _buildChipButton(
                    theme: theme,
                    label: oc,
                    selected: sel,
                    activeColor: theme.alerta,
                    onTap: () {
                      setState(() {
                        if (sel) {
                          d.ocorrencias.remove(oc);
                        } else {
                          d.ocorrencias.add(oc);
                        }
                        _salvarEstado();
                      });
                    },
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  String _gerarCodigoPumping() {
    final rand = Random();
    final code = rand.nextInt(900000) + 100000;
    return 'BOM-$code';
  }

  Future<void> _enviarPumpingReportFirestore(InspecaoModel insp) async {
    try {
      final db = FirebaseFirestore.instance;

      // Map operators
      final operatorsList = insp.equipe.map((colabId) {
        final colab = _colaboradores.firstWhere(
          (c) => c.id == colabId,
          orElse: () => ColaboradorModel(id: colabId, nome: colabId, matricula: colabId),
        );
        return {
          'id': colab.id,
          'registration': colab.matricula,
          'name': colab.nome,
        };
      }).toList();

      // Map caixas and rampas to workOrders, waterLevels, and pumps
      final List<Map<String, dynamic>> workOrders = [];
      final List<Map<String, dynamic>> waterLevels = [];
      final List<Map<String, dynamic>> pumps = [];

      insp.caixas.forEach((caixaId, value) {
        final r = _caixas.firstWhere(
          (c) => c.id == caixaId,
          orElse: () => CaixaModel(id: caixaId, nome: caixaId, setor: ''),
        );
        final detalhe = insp.detalhesCaixas[caixaId];
        
        final observationsText = [detalhe?.obs, detalhe?.ambosObs]
            .where((e) => e != null && e.trim().isNotEmpty)
            .join(' | ');

        waterLevels.add({
          'pointId': caixaId,
          'location': r.setor,
          'level': value != null ? '$value%' : '',
          'abastec': detalhe?.abastec,
          'abastecMotivo': detalhe?.abastecMotivo ?? '',
          'vaz': detalhe?.vaz,
          'vazLocal': detalhe?.vazLocal ?? '',
          'trend': '',
          'observations': observationsText,
        });

        workOrders.add({
          'id': caixaId,
          'number': 'CX-${r.nome}',
          'location': r.setor,
          'maintenanceType': 'BOMBEAMENTO_CAIXA',
          'cause': 'Inspeção de Caixa',
          'activities': observationsText,
          'level': value != null ? '$value%' : '',
          'abastec': detalhe?.abastec,
          'vaz': detalhe?.vaz,
          'materialsUsed': <String>[],
          'quantityMeters': '0',
          'quantityPieces': '0',
          'startTime': '',
          'endTime': '',
          'status': 'Normal',
          'osStatus': detalhe != null && detalhe.avisouLider ? 'Avisou Líder' : 'Normal',
          'photoPaths': <String>[],
        });
      });

      insp.rampas.forEach((rampaId, detalhe) {
        final r = _rampas.firstWhere(
          (rm) => rm.id == rampaId,
          orElse: () => RampaModel(id: rampaId, nome: rampaId),
        );
        
        final ocorrenciasText = detalhe.ocorrencias.join(', ');

        pumps.add({
          'name': r.nome,
          'metragem': detalhe.metragem != null ? '${detalhe.metragem} m' : '',
          'bombaStatus': detalhe.bomba == true ? 'operando' : (detalhe.bomba == false ? 'parada' : ''),
          'limpeza': detalhe.limpeza == true ? 'necessária' : (detalhe.limpeza == false ? 'não' : ''),
          'ocorrencias': ocorrenciasText,
        });

        workOrders.add({
          'id': rampaId,
          'number': 'RP-${r.nome}',
          'location': 'Rampa',
          'maintenanceType': 'BOMBEAMENTO_RAMPA',
          'cause': 'Inspeção de Rampa',
          'activities': ocorrenciasText,
          'metragem': detalhe.metragem,
          'bombaStatus': detalhe.bomba,
          'limpeza': detalhe.limpeza,
          'materialsUsed': <String>[],
          'quantityMeters': '0',
          'quantityPieces': '0',
          'startTime': '',
          'endTime': '',
          'status': 'Normal',
          'osStatus': detalhe.avisouLider ? 'Avisou Líder' : 'Normal',
          'photoPaths': <String>[],
        });
      });

      // Assemble payload matching ReportEntity format
      final payload = {
        'uuid': insp.id,
        'date': DateTime.tryParse(insp.data)?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'shift': insp.turno,
        'team': insp.turma,
        'globalEquipment': 'Bombeamento',
        'globalLocation': 'Mina',
        'fuelLevel': 0.0,
        'availableMaterials': '',
        'observations': insp.observacoes,
        'syncStatus': 'synced',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'operators': operatorsList,
        'workOrders': workOrders,
        'waterLevels': waterLevels,
        'pumps': pumps,
        'pumpingRawData': insp.toJson(),
      };

      await db.collection('pumping_reports').doc(insp.id).set(payload, SetOptions(merge: true));
      debugPrint('Relatório de bombeamento enviado à coleção pumping_reports com sucesso: ${insp.id}');
    } catch (e) {
      debugPrint('Erro ao enviar relatório de bombeamento: $e');
    }
  }

  Future<void> _encerrarTurno() async {
    final insp = InspecaoModel.fromJson(_rascunho.toJson());
    insp.id = _gerarCodigoPumping();
    insp.criadoEm = DateTime.now().toIso8601String();

    setState(() {
      _inspecoes.add(insp);
      _iniciarRascunho();
      _salvarEstado();
    });

    await _enviarPumpingReportFirestore(insp);

    _abrirModalRelatorio(insp);

    // Mapear para ReportEntity e salvar no banco local para o SyncController sincronizar
    try {
      final txt = _gerarTextoRelatorio(insp);
      final report = ReportEntity(
        uuid: insp.id,
        date: DateTime.now(),
        shift: insp.turno,
        type: 'Bombeamento',
        observations: txt, // Todo o relatório vai em observações para flexibilidade
        syncStatus: ReportSyncStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final repository = ref.read(reportRepositoryProvider);
      await repository.saveReport(report);
      await ref.read(syncControllerProvider.notifier).triggerSync();
    } catch (e) {
      debugPrint('Erro ao salvar relatório de bombeamento no Firebase: $e');
    }
  }

  void _abrirModalRelatorio(InspecaoModel insp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _activeTheme.painel,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        final txt = _gerarTextoRelatorio(insp);
        final theme = _activeTheme;
        final textColor = theme.isDark ? Colors.white : Colors.black87;
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          expand: false,
          builder: (ctx, scrollCtrl) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: scrollCtrl,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Relatório do Turno', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.agua)),
                      IconButton(icon: Icon(Icons.close, color: textColor), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white),
                    onPressed: () async {
                      await _salvarESincronizarRelatorio(insp, txt);
                      _abrirWhatsApp(txt, _zapNumero);
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar por WhatsApp', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: theme.fundo, borderRadius: BorderRadius.circular(8)),
                    child: SelectableText(
                      txt,
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: textColor),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================================
  // ABA 2: PAINEL (COMPLETO DEDICADO)
  // =========================================================================

  Widget _buildTabPainel(PumpingTheme theme) {
    final textColor = theme.isDark ? Colors.white : Colors.black87;
    final ult = _inspecoes.isNotEmpty ? _inspecoes.last : null;
    final crit = ult != null ? _criticosInspecao(ult) : [];
    final vals = _caixas.map((c) => ult?.caixas[c.id]).where((v) => v != null).cast<double>().toList();
    final media = vals.isNotEmpty ? (vals.reduce((a, b) => a + b) / vals.length).round() : 0;

    // Pontos do gráfico de caixas
    final chartCaixaPoints = _inspecoes.map((i) => i.caixas[_chartCaixaId]).where((v) => v != null).cast<double>().toList();
    final chartCaixaLabels = _inspecoes.map((i) => _formatDateBR(i.data)).toList();

    // Pontos do gráfico de rampas
    final chartRampaPoints = _inspecoes.map((i) => i.rampas[_chartRampaId]?.metragem).where((v) => v != null).cast<double>().toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 4 Indicadores
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.8,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildMetricCard(theme, '$media%', 'NÍVEL MÉDIO CAIXAS', theme.agua),
              _buildMetricCard(theme, '${crit.length}', 'PONTOS CRÍTICOS', crit.isNotEmpty ? theme.critico : theme.agua),
              _buildMetricCard(theme, '${_inspecoes.length}', 'INSPEÇÕES REGISTRADAS', theme.agua),
              _buildMetricCard(theme, ult != null ? _formatDateBR(ult.data) : '—', 'ÚLTIMA INSPEÇÃO', theme.alerta),
            ],
          ),
          const SizedBox(height: 16),

          // Pontos críticos da última inspeção
          _buildCardSection(
            theme: theme,
            title: 'Pontos Críticos da Última Inspeção',
            child: crit.isNotEmpty
                ? Column(
                    children: crit.map((c) {
                      return ListTile(
                        dense: true,
                        leading: Icon(Icons.warning, color: theme.critico),
                        title: Text('${c['ponto']} (${c['tipo']})', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        subtitle: Text(c['motivo']!, style: TextStyle(color: theme.isDark ? Colors.white54 : Colors.black54)),
                        trailing: Text(c['valor']!, style: TextStyle(fontWeight: FontWeight.bold, color: theme.critico)),
                      );
                    }).toList(),
                  )
                : Text('Nenhum ponto fora dos limites registrado na última inspeção.', style: TextStyle(fontSize: 12, color: theme.isDark ? Colors.white54 : Colors.black54)),
          ),

          const SizedBox(height: 14),

          // Evolução do nível das caixas
          _buildCardSection(
            theme: theme,
            title: 'Evolução do Nível das Caixas (%)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _chartCaixaId,
                  decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                  items: _caixas.map((c) => DropdownMenuItem(value: c.id, child: Text('${c.nome} — ${c.setor}'))).toList(),
                  onChanged: (val) => setState(() => _chartCaixaId = val ?? _chartCaixaId),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 140,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: theme.fundo, borderRadius: BorderRadius.circular(8)),
                  child: chartCaixaPoints.length >= 2
                      ? CustomPaint(
                          painter: PumpingLineChartPainter(
                            values: chartCaixaPoints,
                            labels: chartCaixaLabels,
                            lineColor: theme.agua,
                            textColor: textColor,
                          ),
                        )
                      : Center(
                          child: Text(
                            'Insira ao menos 2 inspeções para visualizar a curva de tendência.',
                            style: TextStyle(fontSize: 11, color: theme.isDark ? Colors.white54 : Colors.black54),
                          ),
                        ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Evolução da metragem nos fins de rampa
          _buildCardSection(
            theme: theme,
            title: 'Evolução da Metragem nos Fins de Rampa (m)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _chartRampaId,
                  decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                  items: _rampas.where((r) => !r.semMetragem).map((r) => DropdownMenuItem(value: r.id, child: Text(r.nome))).toList(),
                  onChanged: (val) => setState(() => _chartRampaId = val ?? _chartRampaId),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 140,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: theme.fundo, borderRadius: BorderRadius.circular(8)),
                  child: chartRampaPoints.length >= 2
                      ? CustomPaint(
                          painter: PumpingLineChartPainter(
                            values: chartRampaPoints,
                            labels: chartCaixaLabels,
                            lineColor: theme.alerta,
                            textColor: textColor,
                          ),
                        )
                      : Center(
                          child: Text(
                            'Insira ao menos 2 inspeções com metragem registrada.',
                            style: TextStyle(fontSize: 11, color: theme.isDark ? Colors.white54 : Colors.black54),
                          ),
                        ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Situação Atual dos Fins de Rampa
          _buildCardSection(
            theme: theme,
            title: 'Situação Atual dos Fins de Rampa',
            child: Column(
              children: _rampas.map((r) {
                final d = ult?.rampas[r.id];
                final e = _estadoRampa(r, d?.metragem, d);
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.fundo))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.nome, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                          Text(e['txt']!, style: TextStyle(fontSize: 11, color: e['selo'] == 'crit' ? theme.critico : (e['selo'] == 'aten' ? theme.alerta : theme.agua))),
                        ],
                      ),
                      Text(
                        r.semMetragem ? 'sem medição' : (d?.metragem == null ? '—' : '${d!.metragem} m'),
                        style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, color: theme.agua),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(PumpingTheme theme, String val, String label, Color valColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: theme.painel, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(val, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: valColor)),
          Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: theme.isDark ? Colors.white54 : Colors.black54)),
        ],
      ),
    );
  }

  // =========================================================================
  // ABA 3: HISTÓRICO
  // =========================================================================

  Widget _buildTabHistorico(PumpingTheme theme) {
    final textColor = theme.isDark ? Colors.white : Colors.black87;
    final filtradas = _inspecoes.reversed.where((i) {
      if (_filtroTurno.isNotEmpty && i.turno != _filtroTurno) return false;
      if (_filtroTurma.isNotEmpty && i.turma != _filtroTurma) return false;
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardSection(
            theme: theme,
            title: 'Consultar Inspeções',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _filtroTurno,
                        decoration: const InputDecoration(labelText: 'Turno', isDense: true),
                        items: [
                          const DropdownMenuItem(value: '', child: Text('Todos')),
                          ..._turnos.map((t) => DropdownMenuItem(value: t, child: Text(t))),
                        ],
                        onChanged: (val) => setState(() => _filtroTurno = val ?? ''),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _filtroTurma,
                        decoration: const InputDecoration(labelText: 'Turma', isDense: true),
                        items: [
                          const DropdownMenuItem(value: '', child: Text('Todas')),
                          ..._turmas.map((t) => DropdownMenuItem(value: t, child: Text('Turma $t'))),
                        ],
                        onChanged: (val) => setState(() => _filtroTurma = val ?? ''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          if (filtradas.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Text('Nenhuma inspeção registrada ainda.', style: TextStyle(color: theme.isDark ? Colors.white54 : Colors.black54)),
            )
          else
            ...filtradas.map((insp) {
              final critCount = _criticosInspecao(insp).length;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: theme.painel, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_formatDateBR(insp.data), style: TextStyle(fontWeight: FontWeight.bold, color: theme.agua)),
                          Text('${insp.turno} · Turma ${insp.turma}', style: TextStyle(fontSize: 11, color: theme.isDark ? Colors.white54 : Colors.black54)),
                        ],
                      ),
                    ),
                    if (critCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: theme.critico, borderRadius: BorderRadius.circular(4)),
                        child: Text('$critCount críticos', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    IconButton(
                      icon: Icon(Icons.visibility, color: textColor),
                      onPressed: () => _abrirModalRelatorio(insp),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // =========================================================================
  // ABA 4: CADASTROS & AJUSTES (COMPLETO DEDICADO)
  // =========================================================================

  Widget _buildTabCadastros(PumpingTheme theme) {
    final textColor = theme.isDark ? Colors.white : Colors.black87;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Cadastrar Colaboradores
          _buildCardSection(
            theme: theme,
            title: 'Equipe & Colaboradores (${_colaboradores.length})',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _colabNomeCtrl,
                  style: TextStyle(color: textColor),
                  decoration: const InputDecoration(labelText: 'Nome do Colaborador *'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _colabMatCtrl,
                        style: TextStyle(color: textColor),
                        decoration: const InputDecoration(labelText: 'Matrícula'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _colabFunCtrl,
                        style: TextStyle(color: textColor),
                        decoration: const InputDecoration(labelText: 'Função'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: theme.agua, foregroundColor: Colors.black),
                  onPressed: () {
                    final nome = _colabNomeCtrl.text.trim();
                    if (nome.isEmpty) return;
                    setState(() {
                      _colaboradores.add(ColaboradorModel(
                        id: 'col_${DateTime.now().millisecondsSinceEpoch}',
                        nome: nome,
                        matricula: _colabMatCtrl.text.trim(),
                        funcao: _colabFunCtrl.text.trim(),
                      ));
                      _colabNomeCtrl.clear();
                      _colabMatCtrl.clear();
                      _colabFunCtrl.clear();
                      _salvarEstado();
                    });
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Adicionar Colaborador'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 2. Cadastrar Caixas de Distribuição
          _buildCardSection(
            theme: theme,
            title: 'Caixas de Distribuição (${_caixas.length})',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _cxNomeCtrl,
                  style: TextStyle(color: textColor),
                  decoration: const InputDecoration(labelText: 'Nome / Código da Caixa *'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _cxSetorSel,
                  decoration: const InputDecoration(labelText: 'Setor'),
                  items: _setores.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (val) => setState(() => _cxSetorSel = val ?? _cxSetorSel),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: theme.agua, foregroundColor: Colors.black),
                  onPressed: () {
                    final nome = _cxNomeCtrl.text.trim();
                    if (nome.isEmpty) return;
                    setState(() {
                      _caixas.add(CaixaModel(
                        id: 'cx_${DateTime.now().millisecondsSinceEpoch}',
                        nome: nome,
                        setor: _cxSetorSel,
                      ));
                      _cxNomeCtrl.clear();
                      _salvarEstado();
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar Caixa'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 3. Cadastrar Fins de Rampa
          _buildCardSection(
            theme: theme,
            title: 'Fins de Rampa (${_rampas.length})',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _frNomeCtrl,
                  style: TextStyle(color: textColor),
                  decoration: const InputDecoration(labelText: 'Nome do Ponto / Rampa *'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _frAtenCtrl,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: textColor),
                        decoration: const InputDecoration(labelText: 'Atenção (m)'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _frCritCtrl,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: textColor),
                        decoration: const InputDecoration(labelText: 'Crítico (m)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: theme.agua, foregroundColor: Colors.black),
                  onPressed: () {
                    final nome = _frNomeCtrl.text.trim();
                    if (nome.isEmpty) return;
                    setState(() {
                      _rampas.add(RampaModel(
                        id: 'fr_${DateTime.now().millisecondsSinceEpoch}',
                        nome: nome,
                        atencao: double.tryParse(_frAtenCtrl.text) ?? 50,
                        critico: double.tryParse(_frCritCtrl.text) ?? 25,
                      ));
                      _frNomeCtrl.clear();
                      _salvarEstado();
                    });
                  },
                  icon: const Icon(Icons.add_location),
                  label: const Text('Adicionar Fim de Rampa'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 4. Cor de Fundo / Temas
          _buildCardSection(
            theme: theme,
            title: 'Cor de Fundo / Tema Visual',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Escolha o tema que melhor se adéqua ao seu ambiente de trabalho:', style: TextStyle(fontSize: 11, color: theme.isDark ? Colors.white54 : Colors.black54)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: kPumpingThemes.map((t) {
                    final sel = t.id == _selectedThemeId;
                    return InkWell(
                      onTap: () {
                        setState(() => _selectedThemeId = t.id);
                        _salvarEstado();
                      },
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: t.painel,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: sel ? t.agua : Colors.grey.withValues(alpha: 0.3), width: sel ? 2 : 1),
                        ),
                        child: Column(
                          children: [
                            Container(height: 20, decoration: BoxDecoration(color: t.fundo, borderRadius: BorderRadius.circular(4))),
                            const SizedBox(height: 4),
                            Text(t.nome, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: t.id == 'branco' || t.id == 'claro' ? Colors.black87 : Colors.white)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 5. Envio WhatsApp Numbers
          _buildCardSection(
            theme: theme,
            title: 'Configurações de WhatsApp',
            child: Column(
              children: [
                TextFormField(
                  initialValue: _zapNumero,
                  style: TextStyle(color: textColor),
                  decoration: const InputDecoration(labelText: 'WhatsApp Relatório Turno (DDI+DDD)'),
                  onChanged: (val) {
                    _zapNumero = val;
                    _salvarEstado();
                  },
                ),
                TextFormField(
                  initialValue: _zapControle,
                  style: TextStyle(color: textColor),
                  decoration: const InputDecoration(labelText: 'WhatsApp Sala de Controle'),
                  onChanged: (val) {
                    _zapControle = val;
                    _salvarEstado();
                  },
                ),
                TextFormField(
                  initialValue: _zapLider,
                  style: TextStyle(color: textColor),
                  decoration: const InputDecoration(labelText: 'WhatsApp Líder Infraestrutura'),
                  onChanged: (val) {
                    _zapLider = val;
                    _salvarEstado();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _abrirModalTemas() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _activeTheme.painel,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selecionar Tema Visual', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _activeTheme.agua)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kPumpingThemes.map((t) {
                  return _buildChipButton(
                    theme: _activeTheme,
                    label: t.nome,
                    selected: t.id == _selectedThemeId,
                    onTap: () {
                      setState(() => _selectedThemeId = t.id);
                      _salvarEstado();
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- HELPERS LAYOUT ---

  Widget _buildCardSection({required PumpingTheme theme, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.painel, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.agua)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildLabel(PumpingTheme theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.isDark ? Colors.white70 : Colors.black54),
      ),
    );
  }
}
