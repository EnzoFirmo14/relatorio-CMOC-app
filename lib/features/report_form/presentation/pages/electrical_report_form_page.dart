import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/firestore_cadastros_service.dart';
import '../../../../core/providers/dev_mode_provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../sync/presentation/widgets/sync_status_badge.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/entities/collaborator_entity.dart';
import '../../domain/entities/work_order_entity.dart';
import '../../../sync/presentation/controllers/sync_controller.dart';
import '../controllers/report_form_controller.dart';
import '../widgets/whatsapp_preview_dialog.dart';

class ElectricalWorkOrder {
  String tipo;
  String causa;
  String causaOutros;
  String local;
  String tag;
  bool parado;
  String paradoIni;
  String paradoFim;
  String atividades;
  String materiais;
  bool matNA;
  String horaIni;
  String horaFim;
  String status;
  String pendencia;

  ElectricalWorkOrder({
    this.tipo = '',
    this.causa = '',
    this.causaOutros = '',
    this.local = '',
    this.tag = '',
    this.parado = false,
    this.paradoIni = '',
    this.paradoFim = '',
    this.atividades = '',
    this.materiais = '',
    this.matNA = false,
    this.horaIni = '',
    this.horaFim = '',
    this.status = '',
    this.pendencia = '',
  });

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'causa': causa,
        'causaOutros': causaOutros,
        'local': local,
        'tag': tag,
        'parado': parado,
        'paradoIni': paradoIni,
        'paradoFim': paradoFim,
        'atividades': atividades,
        'materiais': materiais,
        'matNA': matNA,
        'horaIni': horaIni,
        'horaFim': horaFim,
        'status': status,
        'pendencia': pendencia,
      };

  factory ElectricalWorkOrder.fromJson(Map<String, dynamic> json) => ElectricalWorkOrder(
        tipo: json['tipo'] ?? '',
        causa: json['causa'] ?? '',
        causaOutros: json['causaOutros'] ?? '',
        local: json['local'] ?? '',
        tag: json['tag'] ?? '',
        parado: json['parado'] ?? false,
        paradoIni: json['paradoIni'] ?? '',
        paradoFim: json['paradoFim'] ?? '',
        atividades: json['atividades'] ?? '',
        materiais: json['materiais'] ?? '',
        matNA: json['matNA'] ?? false,
        horaIni: json['horaIni'] ?? '',
        horaFim: json['horaFim'] ?? '',
        status: json['status'] ?? '',
        pendencia: json['pendencia'] ?? '',
      );
}

class ElectricalReportFormPage extends ConsumerStatefulWidget {
  const ElectricalReportFormPage({super.key});

  @override
  ConsumerState<ElectricalReportFormPage> createState() => _ElectricalReportFormPageState();
}

class _ElectricalReportFormPageState extends ConsumerState<ElectricalReportFormPage> {
  int _currentTab = 0; // 0: Relatório, 1: Cadastros & Locais

  // Constantes de Opções idênticas ao relatorio-eletrica.html
  static const List<String> _tiposOS = ['Corretiva', 'Avanço', 'Recuo', 'Transporte', 'Apoio', 'Instalação'];

  static const Map<String, List<String>> _causasMap = {
    'Corretiva': [
      'Tomada desarmada',
      'Tomada desarmada por temperatura',
      'Painel desarmado',
      'Painel com falha',
      'Sem comunicação',
      'Comunicação ruim',
      'Cabo de comunicação machucado',
      'Bomba desarmada',
      'Cabo acidentado',
      'Cabo arriado',
      'Extensão danificada',
      'Outros'
    ],
    'Avanço': [
      'Avançar tomada',
      'Avançar painel de bomba',
      'Avançar comunicação',
      'Avançar tomada e comunicação',
      'Outros'
    ],
    'Recuo': [
      'Recuar tomada',
      'Recuar painel de bomba',
      'Recuar comunicação',
      'Recuar tomada e comunicação',
      'Outros'
    ],
    'Transporte': [],
    'Apoio': [],
    'Instalação': [],
  };

  static final List<String> _tagsPadrao = (() {
    final List<String> list = [];
    String p3(int n) => n.toString().padLeft(3, '0');
    for (var prefix in ['TMJI3', 'PNVI3', 'PNBI3']) {
      for (var i = 1; i <= 90; i++) {
        list.add('$prefix${p3(i)}');
      }
    }
    return list;
  })();

  static const List<String> _equipamentosDrop = ['PT302', 'PT305', 'PT306', 'MT001', 'MT002', 'PT386'];

  static const List<Map<String, String>> _pessoasPadrao = [
    {'nome': 'Acacio Oliveira Souza', 'mat': 'S/N'},
    {'nome': 'Adailton Silva Santos', 'mat': '99300599'},
    {'nome': 'Adonis Evaristo Sousa dos Santos', 'mat': '99300182'},
    {'nome': 'Adriano da Fonseca Santana', 'mat': '99300217'},
    {'nome': 'Adriano Silva de Matos', 'mat': '5115'},
    {'nome': 'Aleandro Bonifacio dos Santos', 'mat': '70205994'},
    {'nome': 'Altair da Silva Almeida', 'mat': '99300607'},
    {'nome': 'Anderson Andrey Gomes', 'mat': '99300855'},
    {'nome': 'Andeson de Jesus Santos', 'mat': '99300603'},
    {'nome': 'Carlos Daniel De Queiroz Firmo', 'mat': '99300868'},
    {'nome': 'Celio Marinho Carvalho Junior', 'mat': 'S/N'},
    {'nome': 'Claudemiro Gordiano Cunha', 'mat': '99300906'},
    {'nome': 'Claudio Augusto do Prado de Oliveira', 'mat': '99300377'},
    {'nome': 'Clebson Oliveira Moura', 'mat': 'S/N'},
    {'nome': 'Cleilson Araujo de Jesus', 'mat': 'S/N'},
    {'nome': 'Cleinilson da Mota Firmo', 'mat': '99300193'},
    {'nome': 'Cristiano Rodrigues Dias de Jesus', 'mat': '4895'},
    {'nome': 'Danilo Pereira da Silva', 'mat': '99300582'},
    {'nome': 'Deyferson de Queiroz Firmo', 'mat': '99300595'},
    {'nome': 'Dimelson Souza da Silva', 'mat': '99300164'},
    {'nome': 'Edimari Barreto da Cruz', 'mat': '99300538'},
    {'nome': 'Edmundo Santos de Jesus', 'mat': '70205582'},
    {'nome': 'Emanuelle Santos Silva', 'mat': 'S/N'},
    {'nome': 'Emilio Manaia Lima', 'mat': '99300606'},
    {'nome': 'Erick de Araujo Pimentel', 'mat': '99300432'},
    {'nome': 'Erique de Matos Santos', 'mat': '99300346'},
    {'nome': 'Fabricio de Carvalho Santos', 'mat': '99300635'},
    {'nome': 'Fagner de Queiroz Mendonca', 'mat': 'S/N'},
    {'nome': 'Felipe Matos Santos', 'mat': '99300144'},
    {'nome': 'Felipe Souza Barbosa', 'mat': 'S/N'},
    {'nome': 'Fernando de Jesus Santos', 'mat': '70205583'},
    {'nome': 'Fernando Juriti Reis', 'mat': '99300389'},
    {'nome': 'Francisco Elexsandro da Silva', 'mat': '99300203'},
    {'nome': 'Francisco Fagne Oliveira Silva', 'mat': '99300268'},
    {'nome': 'Gabriel Alves Queiroz Lopes', 'mat': '99300456'},
    {'nome': 'Genesio Muniz dos Santos', 'mat': '4929'},
    {'nome': 'Genilson Ribeiro dos Santos', 'mat': '99300447'},
    {'nome': 'Geovane Bispo dos Santos', 'mat': 'S/N'},
    {'nome': 'Geovane Oliveira Araujo', 'mat': '4774'},
    {'nome': 'Gildenor Lopes de Oliveira', 'mat': '99300532'},
    {'nome': 'Gilmar Nascimento Moreira', 'mat': '99300535'},
    {'nome': 'Gilmar Olivera de Jesus', 'mat': '99300575'},
    {'nome': 'Gilvandro Damiao de Jesus', 'mat': '99300383'},
    {'nome': 'Girlan Queiroz dos Santos', 'mat': 'S/N'},
    {'nome': 'Gustavo Oliveira Santana', 'mat': '99300433'},
    {'nome': 'Gutierry Santos Matos', 'mat': '99300598'},
    {'nome': 'Hamilton Araujo dos Santos', 'mat': '99300491'},
    {'nome': 'Hitalo Dantas Queiroz', 'mat': '4825'},
    {'nome': 'Isac Valerio dos Santos', 'mat': '5178'},
    {'nome': 'Italo da Costa Dutra', 'mat': 'S/N'},
    {'nome': 'Itamar da Silva Lima', 'mat': '99300305'},
    {'nome': 'Ivanilson de Jesus Santos', 'mat': 'S/N'},
    {'nome': 'Jackson de Jesus Silva', 'mat': 'S/N'},
    {'nome': 'Jailton Oliveira dos Santos', 'mat': 'S/N'},
    {'nome': 'Jenivaldo Silva dos Santos', 'mat': '99300149'},
    {'nome': 'Joanderson Silva Goncalves', 'mat': 'S/N'},
    {'nome': 'Joelson Pereira da Silva', 'mat': '99300472'},
    {'nome': 'Jonathan Gordiano Rodrigues', 'mat': '99300619'},
    {'nome': 'Jose Milton Bispo dos Santos', 'mat': '70205586'},
    {'nome': 'Jose Nacirso Ferreira de Queiroz', 'mat': '99300378'},
    {'nome': 'Josevaldo Santos de Jesus', 'mat': '99300239'},
    {'nome': 'José Alberto de Araujo Cristo', 'mat': 'S/N'},
    {'nome': 'José Cerqueira dos Santos', 'mat': '70205556'},
    {'nome': 'Jucineia Queiroz Oliveira', 'mat': 'S/N'},
    {'nome': 'Kezya Queiroz Oliveira Borges', 'mat': '99300525'},
    {'nome': 'Kleberlito Luciano Carneiro da Silva', 'mat': 'S/N'},
    {'nome': 'Leonardo dos Santos Lima de Queiroz', 'mat': '99300264'},
    {'nome': 'Leonardo Mota Nascimento', 'mat': 'S/N'},
    {'nome': 'Lucas Evangelista Farias Cerqueira', 'mat': '99300295'},
    {'nome': 'Lucas Moura de Mendonca', 'mat': '70205587'},
    {'nome': 'Marcolino dos Santos', 'mat': 'S/N'},
    {'nome': 'Marcos Cassiano Oliveira Santos', 'mat': '99300327'},
    {'nome': 'Marcos Neves Moura', 'mat': '4933'},
    {'nome': 'Marcos Real Mota', 'mat': '99300152'},
    {'nome': 'Mateus Barreto Calvacante', 'mat': '99300061'},
    {'nome': 'Matheus Silva Pastor', 'mat': '4795'},
    {'nome': 'Natalino Paixao dos Santos', 'mat': '70206772'},
    {'nome': 'Niel Pereira Rodrigues', 'mat': '99300589'},
    {'nome': 'Pablo Oliveira Araujo', 'mat': '70207289'},
    {'nome': 'Paulo Ditarso Guimaraes Porto Souza', 'mat': '99300461'},
    {'nome': 'Paulo Henrique Lima de Santana', 'mat': 'S/N'},
    {'nome': 'Pedro Henrique Alves De Souza', 'mat': 'S/N'},
    {'nome': 'Rafael de Oliveira Cardoso', 'mat': 'S/N'},
    {'nome': 'Rayane Silva Lima', 'mat': 'S/N'},
    {'nome': 'Ricardo Moraes', 'mat': '99300440'},
    {'nome': 'Ricardo Santos Lima', 'mat': '99300594'},
    {'nome': 'Robenilson Cerqueira dos Santos', 'mat': 'S/N'},
    {'nome': 'Roberto das Virgens Ferreira', 'mat': 'S/N'},
    {'nome': 'Robson Ricardo Soares da Silva', 'mat': 'S/N'},
    {'nome': 'Romilson Lima Oliveira', 'mat': '4758'},
    {'nome': 'Romilson Santos de Jesus', 'mat': '99300699'},
    {'nome': 'Ronaldo do Rosario Nascimento', 'mat': '99300677'},
    {'nome': 'Sandro Pereira dos Santos', 'mat': '99300446'},
    {'nome': 'Saul Vinicius de Jesus Souza', 'mat': 'S/N'},
    {'nome': 'Venancio Araujo Queiroz', 'mat': 'S/N'},
    {'nome': 'Verena Oliveira Lima', 'mat': 'S/N'},
    {'nome': 'William Pereira da Silva', 'mat': 'S/N'},
  ];

  // Estado idêntico ao relatorio-eletrica.html
  DateTime _selectedDate = DateTime.now();
  String _tipo = ''; // 'Elétrica Rotina' | 'Elétrica Programada'
  String _turno = ''; // 'T1' | 'T2' | 'T3'
  String _turma = ''; // 'Turma A' | 'Turma B' | 'Turma C' | 'Turma D'

  // Equipamento
  bool _semEquip = false;
  String _equipamento = '';
  final TextEditingController _localEquipCtrl = TextEditingController();
  double _combustivel = 50.0;
  final TextEditingController _materiaisCtrl = TextEditingController();

  // Executantes
  final List<Map<String, String>> _execs = [
    {'nome': '', 'mat': ''}
  ];

  // Ordens de Serviço
  final List<ElectricalWorkOrder> _osList = [ElectricalWorkOrder()];

  // Validação e feedback
  bool _showValidationErrors = false;
  final Set<String> _invalidFields = {};
  final List<Map<String, bool>> _osErrors = [];

  // Lista dinâmica de pessoas
  late List<Map<String, String>> _pessoasEletrica;

  // Controllers para cadastros
  final _novoNomeEletCtrl = TextEditingController();
  final _novaMatEletCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pessoasEletrica = List.from(_pessoasPadrao);
    _carregarDraftLocal();
  }

  Future<void> _carregarDraftLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final draftJson = prefs.getString('relatorio_eletrica_v1');
    if (draftJson != null) {
      try {
        final decoded = jsonDecode(draftJson);
        if (decoded is Map) {
          final data = Map<String, dynamic>.from(decoded);
          setState(() {
            if (data['data'] != null && data['data'].toString().isNotEmpty) {
              _selectedDate = DateTime.tryParse(data['data'].toString()) ?? DateTime.now();
            }
            _tipo = data['tipo'] ?? '';
            _turno = data['turno'] ?? '';
            _turma = data['turma'] ?? '';
            _semEquip = data['semEquip'] ?? false;
            _equipamento = data['equipamento'] ?? '';
            _localEquipCtrl.text = data['local'] ?? '';
            _combustivel = (data['combustivel'] as num?)?.toDouble() ?? 50.0;
            _materiaisCtrl.text = data['materiais'] ?? '';

            if (data['execs'] != null && data['execs'] is List) {
              _execs.clear();
              for (var item in data['execs'] as List) {
                if (item is Map) {
                  _execs.add({
                    'nome': item['nome']?.toString() ?? '',
                    'mat': item['mat']?.toString() ?? '',
                  });
                }
              }
            }
            if (_execs.isEmpty) _execs.add({'nome': '', 'mat': ''});

            if (data['os'] != null && data['os'] is List) {
              _osList.clear();
              for (var osData in data['os'] as List) {
                if (osData is Map) {
                  _osList.add(ElectricalWorkOrder.fromJson(Map<String, dynamic>.from(osData)));
                }
              }
            }
            if (_osList.isEmpty) _osList.add(ElectricalWorkOrder());
          });
        }
      } catch (e) {
        debugPrint('Erro ao carregar rascunho: $e');
      }
    }

    // Carregar cadastros salvos
    final pessoasSaved = prefs.getStringList('eletrica_pessoas');
    if (pessoasSaved != null) {
      setState(() {
        _pessoasEletrica = pessoasSaved.map((item) {
          final decoded = jsonDecode(item);
          final map = decoded is Map ? Map<String, dynamic>.from(decoded) : <String, dynamic>{};
          return {'nome': map['nome']?.toString() ?? '', 'mat': map['mat']?.toString() ?? ''};
        }).toList();
      });
    }

    // Escutar Cloud Firestore
    FirestoreCadastrosService().escutarCadastrosArea(
      area: 'eletrica',
      onData: (data) {
        if (!mounted) return;
        if (data['colaboradores'] != null) {
          setState(() {
            _pessoasEletrica = (data['colaboradores'] as List).map((p) => Map<String, String>.from(p)).toList();
          });
        }
      },
    );
  }

  Future<void> _salvarDraftLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final dataMap = {
      'data': _selectedDate.toIso8601String().substring(0, 10),
      'tipo': _tipo,
      'turno': _turno,
      'turma': _turma,
      'semEquip': _semEquip,
      'equipamento': _equipamento,
      'local': _localEquipCtrl.text,
      'combustivel': _combustivel,
      'materiais': _materiaisCtrl.text,
      'execs': _execs,
      'os': _osList.map((os) => os.toJson()).toList(),
    };

    await prefs.setString('relatorio_eletrica_v1', jsonEncode(dataMap));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Rascunho salvo localmente'),
          duration: Duration(milliseconds: 1200),
          backgroundColor: Color(0xFF16A34A),
        ),
      );
    }
  }

  Future<void> _limparTudo() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar Formulário?'),
        content: const Text('Isso apagará todas as informações preenchidas neste relatório.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('relatorio_eletrica_v1');
      setState(() {
        _selectedDate = DateTime.now();
        _tipo = '';
        _turno = '';
        _turma = '';
        _semEquip = false;
        _equipamento = '';
        _localEquipCtrl.clear();
        _combustivel = 50.0;
        _materiaisCtrl.clear();
        _execs.clear();
        _execs.add({'nome': '', 'mat': ''});
        _osList.clear();
        _osList.add(ElectricalWorkOrder());
        _showValidationErrors = false;
        _invalidFields.clear();
        _osErrors.clear();
      });
    }
  }

  @override
  void dispose() {
    _localEquipCtrl.dispose();
    _materiaisCtrl.dispose();
    _novoNomeEletCtrl.dispose();
    _novaMatEletCtrl.dispose();
    super.dispose();
  }

  String _fmtBR(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  bool _normMatch(Map<String, String> p, String query) {
    if (query.trim().isEmpty) return true;
    final q = query.trim().toLowerCase();
    final nome = p['nome']!.toLowerCase();
    if (nome.contains(q)) return true;
    final initials = p['nome']!.trim().split(RegExp(r'\s+')).map((w) => w.isNotEmpty ? w[0].toLowerCase() : '').join();
    if (initials.startsWith(q)) return true;
    if (p['mat']!.startsWith(query.trim())) return true;
    return false;
  }

  bool _validarFormulario() {
    _invalidFields.clear();
    _osErrors.clear();
    bool ok = true;

    if (_tipo.isEmpty) {
      _invalidFields.add('tipo');
      ok = false;
    }
    if (_turno.isEmpty) {
      _invalidFields.add('turno');
      ok = false;
    }
    if (_turma.isEmpty) {
      _invalidFields.add('turma');
      ok = false;
    }

    final e0 = _execs.isNotEmpty ? _execs[0] : null;
    if (e0 == null || e0['nome']!.trim().isEmpty || e0['mat']!.trim().isEmpty) {
      _invalidFields.add('exec0');
      ok = false;
    }

    if (!_semEquip) {
      if (_equipamento.isEmpty) {
        _invalidFields.add('equipamento');
        ok = false;
      }
      if (_localEquipCtrl.text.trim().isEmpty) {
        _invalidFields.add('local');
        ok = false;
      }
      if (_materiaisCtrl.text.trim().isEmpty) {
        _invalidFields.add('materiais');
        ok = false;
      }
    }

    for (var i = 0; i < _osList.length; i++) {
      final o = _osList[i];
      final Map<String, bool> err = {};

      if (o.tipo.isEmpty) err['tipo'] = true;

      final causas = _causasMap[o.tipo] ?? [];
      if (causas.isNotEmpty && o.causa.isEmpty) err['causa'] = true;
      if (o.causa == 'Outros' && o.causaOutros.trim().isEmpty) err['causaOutros'] = true;

      if (o.local.trim().isEmpty) err['local'] = true;

      final precisaTag = o.tipo.isNotEmpty && o.tipo != 'Transporte' && o.tipo != 'Apoio';
      if (precisaTag && o.tag.trim().isEmpty) err['tag'] = true;

      if (precisaTag && o.parado) {
        if (o.paradoIni.isEmpty) err['paradoIni'] = true;
        if (o.paradoFim.isEmpty) err['paradoFim'] = true;
      }

      if (o.atividades.trim().isEmpty) err['atividades'] = true;

      if (!o.matNA && o.materiais.trim().isEmpty) err['materiais'] = true;

      if (o.horaIni.isEmpty) err['horaIni'] = true;
      if (o.horaFim.isEmpty) err['horaFim'] = true;

      if (o.status.isEmpty) err['status'] = true;
      if (o.status == 'Pendente' && o.pendencia.trim().isEmpty) err['pendencia'] = true;

      _osErrors.add(err);
      if (err.isNotEmpty) ok = false;
    }

    return ok;
  }

  String _buildMensagemWhatsApp() {
    final List<String> L = [];
    L.add('*RELATÓRIO ELÉTRICA*');
    L.add('📅 Data: ${_fmtBR(_selectedDate)}');
    L.add("⚡ Tipo: ${_tipo.isNotEmpty ? _tipo : '—'}");
    L.add("🕐 Turno: ${_turno.isNotEmpty ? _turno : '—'}   |   👥 Turma: ${_turma.isNotEmpty ? _turma : '—'}");
    L.add('');
    L.add('👷 *Executantes:*');
    for (var e in _execs) {
      if (e['nome']!.isNotEmpty) {
        final matStr = e['mat']!.isNotEmpty ? " (${e['mat']})" : '';
        L.add("• ${e['nome']}$matStr");
      }
    }
    L.add('');
    L.add('🔧 *Equipamento:*');
    if (_semEquip) {
      L.add('• Nenhum equipamento utilizado neste turno');
    } else {
      L.add("• Equipamento: ${_equipamento.isNotEmpty ? _equipamento : '—'}");
      L.add("• Local: ${_localEquipCtrl.text.isNotEmpty ? _localEquipCtrl.text : '—'}");
      L.add('• Nível de combustível: ${_combustivel.round()}%');
      L.add("• Materiais disponíveis: ${_materiaisCtrl.text.isNotEmpty ? _materiaisCtrl.text : '—'}");
    }
    L.add('');
    L.add('📋 *Ordens de Serviço (${_osList.length}):*');

    for (var i = 0; i < _osList.length; i++) {
      final o = _osList[i];
      final numStr = (i + 1).toString().padLeft(4, '0');
      L.add('');
      L.add('*OS-$numStr*');
      L.add("• Tipo: ${o.tipo.isNotEmpty ? o.tipo : '—'}");

      final causas = _causasMap[o.tipo] ?? [];
      if (causas.isNotEmpty) {
        String c = o.causa.isNotEmpty ? o.causa : '—';
        if (o.causa == 'Outros' && o.causaOutros.isNotEmpty) {
          c = 'Outros: ${o.causaOutros}';
        }
        L.add('• Causa: $c');
      }

      L.add("• Local: ${o.local.isNotEmpty ? o.local : '—'}");

      if (o.tipo != 'Transporte' && o.tipo != 'Apoio') {
        L.add("• Tag: ${o.tag.isNotEmpty ? o.tag : '—'}");
        final paradoStr = o.parado
            ? "Sim (${o.paradoIni.isNotEmpty ? o.paradoIni : '--'} às ${o.paradoFim.isNotEmpty ? o.paradoFim : '--'})"
            : 'Não';
        L.add('• Equipamento parado: $paradoStr');
      }

      L.add("• Atividades: ${o.atividades.isNotEmpty ? o.atividades : '—'}");
      L.add("• Materiais: ${o.matNA ? 'Não se aplica' : (o.materiais.isNotEmpty ? o.materiais : '—')}");
      L.add("• Horário: ${o.horaIni.isNotEmpty ? o.horaIni : '--'} às ${o.horaFim.isNotEmpty ? o.horaFim : '--'}");

      String st = o.status.isNotEmpty ? o.status : '—';
      if (o.status == 'Pendente') {
        st = "Pendente — ${o.pendencia.isNotEmpty ? o.pendencia : ''}";
      }
      L.add('• Status: $st');
    }

    return L.join('\n');
  }

  Future<void> _salvarESincronizarRelatorio(ReportEntity report) async {
    try {
      final repository = ref.read(reportRepositoryProvider);
      await repository.saveReport(report);
      debugPrint('[Elétrica] Salvo localmente: ${report.uuid}');
    } catch (e) {
      debugPrint('[Elétrica] Erro ao salvar localmente: $e');
    }

    // Sincronização em background sem bloquear a UI
    Future.microtask(() async {
      try {
        final syncController = ref.read(syncControllerProvider.notifier);
        await syncController.triggerSync();
      } catch (e2) {
        debugPrint('[Elétrica] Erro no sync queue: $e2');
      }
    });
  }

  void _enviarWhatsApp() async {
    setState(() {
      _showValidationErrors = true;
    });

    if (!_validarFormulario()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Preencha todos os campos obrigatórios destacados antes de enviar.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 1. Gera o texto do relatório ANTES de limpar os campos
    final texto = _buildMensagemWhatsApp();

    // 2. Monta a entidade
    final reportId = 'EL-${const Uuid().v4().substring(0, 8).toUpperCase()}';
    final operatorsList = _execs.map((e) => CollaboratorEntity(
      id: e['mat'] ?? const Uuid().v4(),
      registration: e['mat'] ?? '',
      name: e['nome'] ?? '',
    )).toList();

    final List<WorkOrderEntity> workOrders = _osList.map((os) {
      return WorkOrderEntity(
        id: os.tag.isNotEmpty ? os.tag : const Uuid().v4(),
        number: os.tipo,
        location: os.local,
        maintenanceType: os.tipo,
        cause: os.causa + (os.causaOutros.isNotEmpty ? ' - ${os.causaOutros}' : ''),
        activities: os.atividades,
        materialsUsed: [os.materiais + (os.matNA ? ' (N/A)' : '')],
        quantityMeters: '0.0',
        quantityPieces: '0',
        startTime: os.horaIni + (os.parado ? ' [Parado Ini: ${os.paradoIni}]' : ''),
        endTime: os.horaFim + (os.parado ? ' [Parado Fim: ${os.paradoFim}]' : ''),
        status: os.status,
        osStatus: os.pendencia.isNotEmpty ? 'Pendente: ${os.pendencia}' : 'OK',
        photoPaths: const [],
      );
    }).toList();

    final report = ReportEntity(
      uuid: reportId,
      date: _selectedDate,
      shift: _turno,
      team: _turma,
      type: 'Elétrica',
      globalEquipment: _semEquip ? 'Nenhum' : _equipamento,
      globalLocation: _semEquip ? '' : _localEquipCtrl.text,
      fuelLevel: _semEquip ? 0.0 : _combustivel,
      availableMaterials: _semEquip ? '' : _materiaisCtrl.text,
      observations: '',
      syncStatus: ReportSyncStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      operators: operatorsList,
      workOrders: workOrders,
    );

    // 3. Salva localmente
    await _salvarESincronizarRelatorio(report);

    // 4. Limpa o formulário imediatamente
    setState(() {
      _limparFormulario();
    });

    // 5. Exibe o modal de prévia padronizado
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => WhatsappPreviewDialog(
          formattedText: texto,
        ),
      );
    }
  }

  /// Limpa todos os campos locais do formulário elétrico.
  void _limparFormulario() {
    _selectedDate = DateTime.now();
    _tipo = '';
    _turno = '';
    _turma = '';
    _semEquip = false;
    _equipamento = '';
    _localEquipCtrl.clear();
    _combustivel = 50.0;
    _materiaisCtrl.clear();
    _execs.clear();
    _execs.add({'nome': '', 'mat': ''});
    _osList.clear();
    _osList.add(ElectricalWorkOrder());
    _showValidationErrors = false;
    _invalidFields.clear();
    _osErrors.clear();
  }

  void _preencherModoDev() {
    setState(() {
      _selectedDate = DateTime.now();
      _tipo = 'Elétrica Rotina';
      _turno = 'T1';
      _turma = 'Turma A';

      _semEquip = false;
      _equipamento = 'PT302';
      _localEquipCtrl.text = 'Galeria Norte — Subestação S-02';
      _combustivel = 75.0;
      _materiaisCtrl.text = 'Cabos flexíveis 50mm² (15m), Fita isolante 3M, Disjuntor Caixa Moldada 100A, Conectores de cobre';

      _execs.clear();
      _execs.add({'nome': 'Acacio Oliveira Souza', 'mat': '4786'});
      _execs.add({'nome': 'Adailton Silva Santos', 'mat': '99300599'});

      _osList.clear();
      _osList.add(ElectricalWorkOrder(
        tipo: 'Corretiva',
        causa: 'Painel desarmado',
        causaOutros: '',
        local: 'Subestação S-02 (Nível 4)',
        tag: 'TMJI3005',
        parado: true,
        paradoIni: '08:00',
        paradoFim: '09:15',
        atividades: 'Inspeção do painel elétrico principal, reajuste do relé térmico e substituição de fusível queimado.',
        materiais: 'Fusível 63A NH00, Conector prensa-cabo 3/4"',
        matNA: false,
        horaIni: '08:00',
        horaFim: '09:30',
        status: 'Liberado',
        pendencia: '',
      ));

      _osList.add(ElectricalWorkOrder(
        tipo: 'Avanço',
        causa: 'Avançar tomada e comunicação',
        causaOutros: '',
        local: 'Frente de Lavra 3B — Galeria Leste',
        tag: 'PNVI3012',
        parado: false,
        paradoIni: '',
        paradoFim: '',
        atividades: 'Lançamento de extensão de cabo blindado 380V e fixação do painel de tomadas auxiliar.',
        materiais: 'Cabo PP 4x6mm (30 metros), Braçadeiras metálicas, Tomada industrial 32A 3P+T',
        matNA: false,
        horaIni: '10:00',
        horaFim: '11:45',
        status: 'Liberado',
        pendencia: '',
      ));

      _showValidationErrors = false;
      _invalidFields.clear();
      _osErrors.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⚡ [Modo Dev] Dados de teste preenchidos com sucesso!'),
        backgroundColor: Color(0xFF5C3FA3),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryNavy = Color(0xFF23005B);
    const accentPurple = Color(0xFF5C3FA3);
    const bgLight = Color(0xFFEEF1F7);

    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 2,
        titleSpacing: 12,
        title: Row(
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                children: [
                  TextSpan(text: 'CM', style: TextStyle(color: Color(0xFF36A635))),
                  TextSpan(text: 'OC', style: TextStyle(color: Color(0xFF5B2A8C))),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Relatório de Turno — Elétrica',
                style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF8A90A2), fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: SyncStatusBadge(),
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amber : const Color(0xFF5C3FA3),
            ),
            tooltip: isDark ? 'Modo Claro' : 'Modo Escuro CMOC',
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          if (ref.watch(devModeProvider))
            IconButton(
              icon: const Icon(Icons.flash_on_rounded, color: Color(0xFFF59E0B)),
              tooltip: 'Preencher Automático (Modo Dev)',
              onPressed: _preencherModoDev,
            ),
          IconButton(
            icon: const Icon(Icons.save_outlined, color: Color(0xFF4F46E5)),
            tooltip: 'Salvar',
            onPressed: _salvarDraftLocal,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFC0392B)),
            tooltip: 'Limpar',
            onPressed: _limparTudo,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentTab,
        children: [
          _buildTabFormulario(primaryNavy, accentPurple),
          _buildTabCadastros(primaryNavy, accentPurple),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (idx) => setState(() => _currentTab = idx),
        selectedItemColor: primaryNavy,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Relatório Elétrica'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), label: 'Equipe & Cadastros'),
        ],
      ),
    );
  }

  // =========================================================================
  // ABA 1: FORMULÁRIO 1 PARA 1 COM relatorio-eletrica.html
  // =========================================================================

  Widget _buildTabFormulario(Color primaryNavy, Color accentPurple) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de Erro de Validação
          if (_showValidationErrors && (_invalidFields.isNotEmpty || _osErrors.any((e) => e.isNotEmpty)))
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDEAEA),
                border: Border.all(color: const Color(0xFFF3A3A3), width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '⚠️ Preencha todos os campos obrigatórios destacados em vermelho antes de enviar.',
                style: TextStyle(color: Color(0xFFC0392B), fontSize: 13, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

          // 1. IDENTIFICAÇÃO
          _buildSectionHeader('IDENTIFICAÇÃO'),
          _buildCardContainer([
            // DATA
            _buildLabel('🗓️', 'DATA'),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6FB),
                      border: Border.all(color: const Color(0xFFE6E9F0), width: 1.5),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      _fmtBR(_selectedDate),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2B2F3A)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (d != null) setState(() => _selectedDate = d);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF0FF),
                      border: Border.all(color: const Color(0xFFE6E9F0), width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('📅', style: TextStyle(fontSize: 20))),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // TIPO DE RELATÓRIO
            _buildLabel('⚡', 'TIPO DE RELATÓRIO', isRequired: true),
            _buildToggleRow(
              invalid: _showValidationErrors && _invalidFields.contains('tipo'),
              options: [
                {'label': '⚡ Elétrica Rotina', 'value': 'Elétrica Rotina'},
                {'label': '🛠️ Elétrica Programada', 'value': 'Elétrica Programada'},
              ],
              selectedValue: _tipo,
              onSelect: (val) => setState(() => _tipo = val),
            ),

            const SizedBox(height: 16),

            // EXECUTANTES
            ...List.generate(_execs.length, (i) => _buildExecutanteItem(i)),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                  backgroundColor: const Color(0xFFEEF0FF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => setState(() => _execs.add({'nome': '', 'mat': ''})),
                icon: const Icon(Icons.add, color: Color(0xFF4F46E5)),
                label: const Text(
                  '＋ Adicionar executante',
                  style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ]),

          const SizedBox(height: 18),

          // 2. TURNO & TURMA
          _buildSectionHeader('TURNO & TURMA'),
          _buildCardContainer([
            // TURNO
            _buildLabel('🕐', 'TURNO', isRequired: true),
            _buildToggleRow(
              invalid: _showValidationErrors && _invalidFields.contains('turno'),
              options: [
                {'label': 'T1', 'value': 'T1'},
                {'label': 'T2', 'value': 'T2'},
                {'label': 'T3', 'value': 'T3'},
              ],
              selectedValue: _turno,
              onSelect: (val) => setState(() => _turno = val),
            ),

            const SizedBox(height: 16),

            // TURMA
            _buildLabel('👥', 'TURMA', isRequired: true),
            _buildToggleRow(
              activeColor: const Color(0xFF16A34A),
              invalid: _showValidationErrors && _invalidFields.contains('turma'),
              options: [
                {'label': 'Turma A', 'value': 'Turma A'},
                {'label': 'Turma B', 'value': 'Turma B'},
                {'label': 'Turma C', 'value': 'Turma C'},
                {'label': 'Turma D', 'value': 'Turma D'},
              ],
              selectedValue: _turma,
              onSelect: (val) => setState(() => _turma = val),
            ),
          ]),

          const SizedBox(height: 18),

          // 3. EQUIPAMENTO
          _buildSectionHeader('EQUIPAMENTO'),
          _buildCardContainer([
            // SWITCH NENHUM EQUIPAMENTO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildLabel('🚫', 'NENHUM EQUIPAMENTO UTILIZADO NESTE TURNO')),
                InkWell(
                  onTap: () => setState(() => _semEquip = !_semEquip),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _semEquip ? const Color(0xFFF59E0B) : const Color(0xFFF4F6FB),
                      border: Border.all(color: _semEquip ? const Color(0xFFF59E0B) : const Color(0xFFE6E9F0)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _semEquip ? 'Sim' : 'Não',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: _semEquip ? Colors.white : const Color(0xFF5A6072),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (!_semEquip) ...[
              const Divider(height: 24),

              // EQUIPAMENTO DROPDOWN
              _buildLabel('🔧', 'EQUIPAMENTO', isRequired: true),
              DropdownButtonFormField<String>(
                initialValue: _equipamento.isNotEmpty ? _equipamento : null,
                decoration: _buildInputDecoration(
                  hint: '— Selecione —',
                  invalid: _showValidationErrors && _invalidFields.contains('equipamento'),
                ),
                items: _equipamentosDrop.map((eq) => DropdownMenuItem(value: eq, child: Text(eq))).toList(),
                onChanged: (val) => setState(() => _equipamento = val ?? ''),
              ),

              const SizedBox(height: 14),

              // LOCAL
              _buildLabel('📍', 'LOCAL', isRequired: true),
              TextField(
                controller: _localEquipCtrl,
                decoration: _buildInputDecoration(
                  hint: 'Ex: Galeria Norte, Poço 3...',
                  invalid: _showValidationErrors && _invalidFields.contains('local'),
                ),
              ),

              const SizedBox(height: 14),

              // NÍVEL DE COMBUSTÍVEL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildLabel('⛽', 'NÍVEL DO COMBUSTÍVEL (%)', isRequired: true)),
                  Text(
                    '${_combustivel.round()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2B2F3A)),
                  ),
                ],
              ),
              Slider(
                value: _combustivel,
                min: 0,
                max: 100,
                divisions: 20,
                activeColor: const Color(0xFF4F46E5),
                onChanged: (v) => setState(() => _combustivel = v),
              ),

              const SizedBox(height: 14),

              // MATERIAIS DISPONÍVEIS
              _buildLabel('🧰', 'MATERIAIS DISPONÍVEIS', isRequired: true),
              TextField(
                controller: _materiaisCtrl,
                maxLines: 3,
                decoration: _buildInputDecoration(
                  hint: 'Liste os materiais disponíveis...',
                  invalid: _showValidationErrors && _invalidFields.contains('materiais'),
                ),
              ),
            ],
          ]),

          const SizedBox(height: 18),

          // 4. ORDENS DE SERVIÇO
          _buildSectionHeader('ORDENS DE SERVIÇO'),

          ...List.generate(_osList.length, (index) => _buildOSCard(index)),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                backgroundColor: const Color(0xFFEEF0FF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => setState(() => _osList.add(ElectricalWorkOrder())),
              icon: const Icon(Icons.add, color: Color(0xFF4F46E5)),
              label: const Text(
                '＋ Nova Ordem de Serviço',
                style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 5. ENVIAR PARA WHATSAPP
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
            ),
            onPressed: _enviarWhatsApp,
            icon: const Icon(Icons.send_rounded, size: 22),
            label: const Text('📲 Enviar para o WhatsApp', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
          ),

          const SizedBox(height: 12),
          const Center(
            child: Text(
              '✓ Funciona 100% offline. Os dados ficam salvos no aparelho.\nO envio abre o WhatsApp com o relatório pronto.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8A90A2), fontSize: 12, height: 1.4),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildExecutanteItem(int i) {
    final ex = _execs[i];
    final isReq = i == 0;
    final isInvalid = _showValidationErrors && isReq && _invalidFields.contains('exec0');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildLabel('👷', 'EXECUTANTE ${i + 1}', isRequired: isReq)),
              if (!isReq)
                InkWell(
                  onTap: () => setState(() => _execs.removeAt(i)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFFDECEB), borderRadius: BorderRadius.circular(8)),
                    child: const Text('✕ Remover', style: TextStyle(color: Color(0xFFDC2626), fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Autocomplete<Map<String, String>>(
                  optionsBuilder: (textEditingValue) {
                    return _pessoasEletrica.where((p) => _normMatch(p, textEditingValue.text)).take(8);
                  },
                  displayStringForOption: (option) => option['nome']!,
                  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                    if (controller.text.isEmpty && ex['nome']!.isNotEmpty) {
                      controller.text = ex['nome']!;
                    }
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: _buildInputDecoration(
                        hint: 'Buscar nome ou iniciais...',
                        invalid: isInvalid,
                      ),
                      onChanged: (val) {
                        setState(() {
                          ex['nome'] = val;
                          ex['mat'] = '';
                        });
                      },
                    );
                  },
                  onSelected: (option) {
                    setState(() {
                      ex['nome'] = option['nome']!;
                      ex['mat'] = option['mat']!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                constraints: const BoxConstraints(minWidth: 90),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF0FF),
                  border: Border.all(color: const Color(0xFFE6E9F0), width: 1.5),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Column(
                  children: [
                    const Text('MATRÍCULA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF4F46E5))),
                    const SizedBox(height: 2),
                    Text(
                      ex['mat']!.isNotEmpty ? ex['mat']! : '—',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ex['mat']!.isNotEmpty ? const Color(0xFF2B2F3A) : const Color(0xFFC2C7D4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOSCard(int i) {
    final o = _osList[i];
    final Map<String, bool> err = (_showValidationErrors && i < _osErrors.length) ? _osErrors[i] : {};
    final numStr = (i + 1).toString().padLeft(4, '0');
    final temCausa = _causasMap.containsKey(o.tipo) && _causasMap[o.tipo]!.isNotEmpty;
    final precisaTag = o.tipo.isNotEmpty && o.tipo != 'Transporte' && o.tipo != 'Apoio';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE6E9F0)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header OS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF3B5BDB), Color(0xFF4C6EF5)]),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'OS-$numStr · Ordem de Serviço ${i + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if (_osList.length > 1)
                  InkWell(
                    onTap: () => setState(() => _osList.removeAt(i)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                      child: const Text('✕ Remover', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TIPO DE MANUTENÇÃO
                _buildLabel('🛠️', 'TIPO DE MANUTENÇÃO', isRequired: true),
                _buildToggleRow(
                  invalid: err['tipo'] == true,
                  options: _tiposOS.map((t) => {'label': t, 'value': t}).toList(),
                  selectedValue: o.tipo,
                  onSelect: (val) {
                    setState(() {
                      o.tipo = val;
                      o.causa = '';
                      o.causaOutros = '';
                      if (val == 'Transporte' || val == 'Apoio') {
                        o.parado = false;
                        o.paradoIni = '';
                        o.paradoFim = '';
                      }
                    });
                  },
                ),

                const SizedBox(height: 14),

                // 2. CAUSA (se aplicável ao Tipo)
                if (temCausa) ...[
                  _buildLabel('🔥', 'CAUSA', isRequired: true),
                  _buildToggleRow(
                    invalid: err['causa'] == true,
                    options: _causasMap[o.tipo]!.map((c) => {'label': c, 'value': c}).toList(),
                    selectedValue: o.causa,
                    onSelect: (val) => setState(() {
                      o.causa = val;
                      if (val != 'Outros') o.causaOutros = '';
                    }),
                  ),
                  if (o.causa == 'Outros') ...[
                    const SizedBox(height: 8),
                    TextField(
                      decoration: _buildInputDecoration(
                        hint: 'Digite a causa...',
                        invalid: err['causaOutros'] == true,
                      ),
                      onChanged: (val) => setState(() => o.causaOutros = val),
                    ),
                  ],
                  const SizedBox(height: 14),
                ],

                // 3. LOCAL DA ATIVIDADE
                _buildLabel('📍', 'LOCAL DA ATIVIDADE', isRequired: true),
                TextField(
                  decoration: _buildInputDecoration(
                    hint: 'Digite o local da atividade...',
                    invalid: err['local'] == true,
                  ),
                  controller: TextEditingController(text: o.local)
                    ..selection = TextSelection.collapsed(offset: o.local.length),
                  onChanged: (val) => o.local = val,
                ),

                const SizedBox(height: 14),

                // 4. TAG EQUIPAMENTO (se aplica)
                if (precisaTag) ...[
                  _buildLabel('🏷️', 'TAG EQUIPAMENTO', isRequired: true),
                  Autocomplete<String>(
                    optionsBuilder: (textEditingValue) {
                      final q = textEditingValue.text.trim().toUpperCase();
                      if (q.isEmpty) return const Iterable.empty();
                      return _tagsPadrao.where((t) => t.contains(q)).take(10);
                    },
                    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                      if (controller.text.isEmpty && o.tag.isNotEmpty) {
                        controller.text = o.tag;
                      }
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: _buildInputDecoration(
                          hint: 'Buscar tag (ex: TMJI3005) ou digitar...',
                          invalid: err['tag'] == true,
                        ),
                        onChanged: (val) => setState(() => o.tag = val),
                      );
                    },
                    onSelected: (val) => setState(() => o.tag = val),
                  ),

                  const SizedBox(height: 14),

                  // 5. EQUIPAMENTO FICOU PARADO?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildLabel('⏸️', 'EQUIPAMENTO FICOU PARADO?')),
                      InkWell(
                        onTap: () => setState(() {
                          o.parado = !o.parado;
                          if (!o.parado) {
                            o.paradoIni = '';
                            o.paradoFim = '';
                          }
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: o.parado ? const Color(0xFFF59E0B) : const Color(0xFFF4F6FB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            o.parado ? 'Sim' : 'Não',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: o.parado ? Colors.white : const Color(0xFF5A6072),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (o.parado) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('INÍCIO PARADA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                              const SizedBox(height: 4),
                              InkWell(
                                onTap: () async {
                                  final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                  if (t != null) {
                                    setState(() => o.paradoIni = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F6FB),
                                    border: Border.all(color: err['paradoIni'] == true ? Colors.red : const Color(0xFFE6E9F0)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(o.paradoIni.isNotEmpty ? o.paradoIni : '--:--', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('FIM PARADA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                              const SizedBox(height: 4),
                              InkWell(
                                onTap: () async {
                                  final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                  if (t != null) {
                                    setState(() => o.paradoFim = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F6FB),
                                    border: Border.all(color: err['paradoFim'] == true ? Colors.red : const Color(0xFFE6E9F0)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(o.paradoFim.isNotEmpty ? o.paradoFim : '--:--', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 14),
                ],

                // 6. ATIVIDADES REALIZADAS
                _buildLabel('📝', 'ATIVIDADES REALIZADAS', isRequired: true),
                TextField(
                  maxLines: 3,
                  decoration: _buildInputDecoration(
                    hint: 'Descreva as atividades desta OS...',
                    invalid: err['atividades'] == true,
                  ),
                  controller: TextEditingController(text: o.atividades)
                    ..selection = TextSelection.collapsed(offset: o.atividades.length),
                  onChanged: (val) => o.atividades = val,
                ),

                const SizedBox(height: 14),

                // 7. MATERIAIS UTILIZADOS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildLabel('🧰', 'MATERIAIS UTILIZADOS', isRequired: true)),
                    InkWell(
                      onTap: () => setState(() {
                        o.matNA = !o.matNA;
                        if (o.matNA) o.materiais = '';
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: o.matNA ? const Color(0xFFFDE8E8) : const Color(0xFFF4F6FB),
                          border: Border.all(color: o.matNA ? const Color(0xFFF3A3A3) : const Color(0xFFE6E9F0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '🚫 Não se aplica',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: o.matNA ? const Color(0xFFDC2626) : const Color(0xFF5A6072),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!o.matNA) ...[
                  const SizedBox(height: 6),
                  TextField(
                    maxLines: 2,
                    decoration: _buildInputDecoration(
                      hint: 'Liste os materiais utilizados...',
                      invalid: err['materiais'] == true,
                    ),
                    controller: TextEditingController(text: o.materiais)
                      ..selection = TextSelection.collapsed(offset: o.materiais.length),
                    onChanged: (val) => o.materiais = val,
                  ),
                ],

                const SizedBox(height: 14),

                // 8. HORÁRIO
                _buildLabel('⏰', 'HORÁRIO', isRequired: true),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('INÍCIO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () async {
                              final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                              if (t != null) {
                                setState(() => o.horaIni = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F6FB),
                                border: Border.all(color: err['horaIni'] == true ? Colors.red : const Color(0xFFE6E9F0)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(o.horaIni.isNotEmpty ? o.horaIni : '--:--', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('TÉRMINO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () async {
                              final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                              if (t != null) {
                                setState(() => o.horaFim = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F6FB),
                                border: Border.all(color: err['horaFim'] == true ? Colors.red : const Color(0xFFE6E9F0)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(o.horaFim.isNotEmpty ? o.horaFim : '--:--', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 9. STATUS
                _buildLabel('✅', 'STATUS', isRequired: true),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() {
                          o.status = 'Liberado';
                          o.pendencia = '';
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: o.status == 'Liberado' ? const Color(0xFF16A34A) : const Color(0xFFF4F6FB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: o.status == 'Liberado' ? const Color(0xFF16A34A) : const Color(0xFFE6E9F0)),
                          ),
                          child: Text(
                            '✔️ Liberado',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: o.status == 'Liberado' ? Colors.white : const Color(0xFF5A6072),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => o.status = 'Pendente'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: o.status == 'Pendente' ? const Color(0xFFF59E0B) : const Color(0xFFF4F6FB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: o.status == 'Pendente' ? const Color(0xFFF59E0B) : const Color(0xFFE6E9F0)),
                          ),
                          child: Text(
                            '⏳ Pendente',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: o.status == 'Pendente' ? Colors.white : const Color(0xFF5A6072),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (o.status == 'Pendente') ...[
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 2,
                    decoration: _buildInputDecoration(
                      hint: '⚠️ Descreva o que ficou pendente (obrigatório)...',
                      invalid: err['pendencia'] == true,
                    ),
                    controller: TextEditingController(text: o.pendencia)
                      ..selection = TextSelection.collapsed(offset: o.pendencia.length),
                    onChanged: (val) => o.pendencia = val,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: Color(0xFF8A90A2)),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: Color(0xFFE6E9F0))),
        ],
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE6E9F0)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildLabel(String icon, String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: text,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: Color(0xFF8A90A2)),
                children: [
                  if (isRequired)
                    const TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required List<Map<String, String>> options,
    required String selectedValue,
    required Function(String) onSelect,
    bool invalid = false,
    Color activeColor = const Color(0xFF6366F1),
  }) {
    return Container(
      decoration: BoxDecoration(
        border: invalid ? Border.all(color: Colors.red, width: 1.5) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((opt) {
          final isSelected = opt['value'] == selectedValue;
          return InkWell(
            onTap: () => onSelect(opt['value']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? activeColor : const Color(0xFFF4F6FB),
                border: Border.all(color: isSelected ? activeColor : const Color(0xFFE6E9F0)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected ? [BoxShadow(color: activeColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))] : null,
              ),
              child: Text(
                opt['label']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isSelected ? Colors.white : const Color(0xFF5A6072),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint, bool invalid = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFAAB0C0)),
      filled: true,
      fillColor: const Color(0xFFF4F6FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide(color: invalid ? Colors.red : const Color(0xFFE6E9F0), width: invalid ? 1.5 : 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
      ),
    );
  }

  // =========================================================================
  // ABA 2: EQUIPE & CADASTROS
  // =========================================================================

  Widget _buildTabCadastros(Color primaryNavy, Color accentPurple) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardContainer([
            Text('⚡ Cadastrar Colaborador / Eletricista (${_pessoasEletrica.length})',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryNavy)),
            const SizedBox(height: 12),
            TextField(
              controller: _novoNomeEletCtrl,
              decoration: _buildInputDecoration(hint: 'Nome do Eletricista *'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _novaMatEletCtrl,
              decoration: _buildInputDecoration(hint: 'Matrícula (opcional)'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  final nome = _novoNomeEletCtrl.text.trim();
                  if (nome.isNotEmpty) {
                    setState(() {
                      _pessoasEletrica.add({
                        'nome': nome,
                        'mat': _novaMatEletCtrl.text.trim().isEmpty ? 'S/N' : _novaMatEletCtrl.text.trim(),
                      });
                      _novoNomeEletCtrl.clear();
                      _novaMatEletCtrl.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Colaborador cadastrado com sucesso!')),
                    );
                  }
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Salvar Colaborador', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
