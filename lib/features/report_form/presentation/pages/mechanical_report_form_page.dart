import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/firestore_cadastros_service.dart';
import '../../../../core/providers/dev_mode_provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../sync/presentation/widgets/sync_status_badge.dart';

class MechanicalReportFormPage extends ConsumerStatefulWidget {
  const MechanicalReportFormPage({super.key});

  @override
  ConsumerState<MechanicalReportFormPage> createState() => _MechanicalReportFormPageState();
}

class _MechanicalReportFormPageState extends ConsumerState<MechanicalReportFormPage> {
  int _currentTab = 0; // 0: Relatório, 1: Cadastros & Ajustes

  DateTime _selectedDate = DateTime.now();
  String _turno = 'T1'; // T1, T2, T3, ADM
  String _turma = 'A'; // A, B, C, D, ADM

  final List<Map<String, String>> _executantes = [
    {'nome': '', 'mat': ''}
  ];

  final List<Map<String, dynamic>> _ordensManutencao = [];
  final _observacoesCtrl = TextEditingController();

  // Listas Dinâmicas Persistentes
  late List<Map<String, String>> _pessoasMecanica;
  late List<String> _locaisMecanica;
  late List<String> _equipamentosMecanica;

  static const List<Map<String, String>> _pessoasPadrao = [
    {'nome': 'Acacio Oliveira Souza', 'mat': '4786'},
    {'nome': 'Adailton Silva Santos', 'mat': '99300599'},
    {'nome': 'Adonis Evaristo Sousa dos Santos', 'mat': '99300182'},
    {'nome': 'Adriano da Fonseca Santana', 'mat': '99300217'},
    {'nome': 'Adriano Silva de Matos', 'mat': '5115'},
    {'nome': 'Aleandro Bonifacio dos Santos', 'mat': '70205994'},
    {'nome': 'Altair da Silva Almeida', 'mat': '99300607'},
    {'nome': 'Andeson de Jesus Santos', 'mat': '99300603'},
    {'nome': 'Carlos Daniel de Queiroz Firmo', 'mat': '99300868'},
    {'nome': 'Celio Marinho Carvalho Junior', 'mat': '5252'},
    {'nome': 'Claudemiro Gordiano Cunha', 'mat': '99300906'},
    {'nome': 'Claudio Augusto do Prado de Oliveira', 'mat': '99300377'},
    {'nome': 'Cleilson Araujo de Jesus', 'mat': '5237'},
    {'nome': 'Cleinilson da Mota Firmo', 'mat': '99300193'},
    {'nome': 'Cristiano Rodrigues Dias de Jesus', 'mat': '4895'},
    {'nome': 'Danilo Pereira da Silva', 'mat': '99300582'},
    {'nome': 'Deyferson de Queiroz Firmo', 'mat': '99300595'},
    {'nome': 'Dimelson Souza da Silva', 'mat': '99300164'},
    {'nome': 'Edimari Barreto da Cruz', 'mat': '99300538'},
    {'nome': 'Edmundo Santos de Jesus', 'mat': '4771'},
    {'nome': 'Elionaldo Morais de Lucena', 'mat': '99300869'},
    {'nome': 'Emilio Manaia Lima', 'mat': '99300606'},
    {'nome': 'Erick de Araujo Pimentel', 'mat': '99300432'},
    {'nome': 'Erique de Matos Santos', 'mat': '99300346'},
    {'nome': 'Fabricio de Carvalho Santos', 'mat': '99300635'},
    {'nome': 'Fagner de Queiroz Mendonça', 'mat': '991000100'},
    {'nome': 'Felipe Matos Santos', 'mat': '99300144'},
    {'nome': 'Fernando de Jesus Santos', 'mat': '4751'},
    {'nome': 'Fernando Juriti Reis', 'mat': '99300389'},
    {'nome': 'Francisco Elexsandro da Silva', 'mat': '99300203'},
    {'nome': 'Francisco Fagne Oliveira Silva', 'mat': '99300268'},
    {'nome': 'Gabriel Alves Queiroz Lopes', 'mat': '99300456'},
    {'nome': 'Genesio Muniz dos Santos', 'mat': '4929'},
    {'nome': 'Genilson Ribeiro dos Santos', 'mat': '99300447'},
    {'nome': 'Geovane Bispo dos Santos', 'mat': '5255'},
    {'nome': 'Geovane Oliveira Araujo', 'mat': '4774'},
    {'nome': 'Gildenor Lopes de Oliveira', 'mat': '99300532'},
    {'nome': 'Gilmar Nascimento Moreira', 'mat': '99300535'},
    {'nome': 'Gilmar Oliveira de Jesus', 'mat': '99300575'},
    {'nome': 'Gilvandro Damião de Jesus', 'mat': '99300383'},
    {'nome': 'Girlan Queiroz dos Santos', 'mat': '4788'},
    {'nome': 'Gustavo Oliveira Santana', 'mat': '99300433'},
    {'nome': 'Gutierry Santos Matos', 'mat': '99300598'},
    {'nome': 'Hamilton Araujo dos Santos', 'mat': '99300491'},
    {'nome': 'Isaac Valerio dos Santos', 'mat': '5178'},
    {'nome': 'Italo da Costa Dutra', 'mat': '5353'},
    {'nome': 'Itamar da Silva Lima', 'mat': '99300305'},
    {'nome': 'Ivanilson de Jesus Santos', 'mat': '5247'},
    {'nome': 'Jackson de Jesus Silva', 'mat': '4775'},
    {'nome': 'Jailton Oliveira dos Santos', 'mat': '5254'},
    {'nome': 'Jenivaldo Silva dos Santos', 'mat': '99300149'},
    {'nome': 'Joanderson Silva Gonçalves', 'mat': '5256'},
    {'nome': 'Joelson Pereira da Silva', 'mat': '99300472'},
    {'nome': 'Jonathan Gordiano Rodrigues', 'mat': '99300619'},
    {'nome': 'José Alberto de Araujo Cristo', 'mat': '4748'},
    {'nome': 'José Cerqueira dos Santos', 'mat': '4782'},
    {'nome': 'Jose Milton Bispo dos Santos', 'mat': '4784'},
    {'nome': 'Jose Narciso Ferreira de Queiroz', 'mat': '99300378'},
    {'nome': 'Josevaldo Santos de Jesus', 'mat': '99300239'},
    {'nome': 'Jucineia Queiroz Oliveira', 'mat': '5170'},
    {'nome': 'Kezya Queiroz Oliveira', 'mat': '99300525'},
    {'nome': 'Kleberlito Luciano Carneiro da Silva', 'mat': '5236'},
    {'nome': 'Leonardo dos Santos Lima de Queiroz', 'mat': '99300264'},
    {'nome': 'Leonardo Mota Nascimento', 'mat': '4752'},
    {'nome': 'Lucas Evangelista F Cerqueira', 'mat': '99300295'},
    {'nome': 'Lucas Moura de Mendonca', 'mat': '4791'},
    {'nome': 'Marcolino dos Santos', 'mat': '4793'},
    {'nome': 'Marcos Cassiano Oliveira Santos', 'mat': '99300327'},
    {'nome': 'Marcos Neves Moura', 'mat': '4933'},
    {'nome': 'Marcos Real Mota', 'mat': '99300152'},
    {'nome': 'Mateus Barreto Calvacante', 'mat': '99300061'},
    {'nome': 'Matheus Silva Pastor', 'mat': '4795'},
    {'nome': 'Natalino Paixão dos Santos', 'mat': '70206772'},
    {'nome': 'Niel Pereira Rodrigues', 'mat': '99300589'},
    {'nome': 'Pablo Oliveira Araujo', 'mat': '5100'},
    {'nome': 'Paulo Ditarso Guimaraes Porto Souza', 'mat': '99300461'},
    {'nome': 'Paulo Henrique Lima de Santana', 'mat': '5248'},
    {'nome': 'Pedro Henrique Alves de Souza', 'mat': '5169'},
    {'nome': 'Rafael de Oliveira Cardoso', 'mat': '5251'},
    {'nome': 'Rayane Silva Lima', 'mat': '5233'},
    {'nome': 'Ricardo Moraes', 'mat': '99300440'},
    {'nome': 'Ricardo Santos Lima', 'mat': '99300594'},
    {'nome': 'Robenilson Cerqueira dos Santos', 'mat': '4797'},
    {'nome': 'Roberto das Virgens Ferreira', 'mat': '4798'},
    {'nome': 'Robson Ricardo Soares da Silva', 'mat': '5258'},
    {'nome': 'Romilson Lima Oliveira', 'mat': '4758'},
    {'nome': 'Romilson Santos de Jesus', 'mat': '99300699'},
    {'nome': 'Ronaldo do Rosario Nascimento', 'mat': '99300677'},
    {'nome': 'Sandro Pereira dos Santos', 'mat': '99300446'},
    {'nome': 'Saul Vinicius de Jesus SOUZA', 'mat': '4899'},
    {'nome': 'Venancio Araújo Queiroz', 'mat': '4800'},
    {'nome': 'William Pereira da Silva', 'mat': '4802'},
  ];

  static const List<String> _locaisPadrao = [
    'Oficina Infra', 'HL', 'E22 - 01', 'E22 - 02', 'EW42 - 01', 'EW42 - 02',
    'EW48', 'EW51', 'E46', 'E57', 'C52 - 01', 'C52 - 02', 'C43', 'C34', 'C25',
    'B15', 'B09', 'E67 - 02', 'E67 - 01', 'E77', 'E102', 'ER4', 'BR2', 'ER1 -03',
    'ER1 - 02', 'ER2', 'EB MOVEL', 'RV2', 'RV5', 'RV6', 'RV10', 'E85', 'ER3', 'Outro'
  ];

  static const List<String> _equipamentosPadrao = [
    'Pá Carregadeira L-130', 'Caminhão R-40', 'Perfuratriz H-12', 'Manipulador de Pneus',
    'Jumbo de Perfuração', 'Escavadeira K-90', 'Trator D-8', 'Veículo Utilitário V-01'
  ];

  // Controllers para formulários de cadastro
  final _novoLocalCtrl = TextEditingController();
  final _novoEquipCtrl = TextEditingController();
  final _novoNomeMecCtrl = TextEditingController();
  final _novaMatMecCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pessoasMecanica = List.from(_pessoasPadrao);
    _locaisMecanica = List.from(_locaisPadrao);
    _equipamentosMecanica = List.from(_equipamentosPadrao);
    _carregarCadastrosPersistidos();
  }

  Future<void> _carregarCadastrosPersistidos() async {
    final prefs = await SharedPreferences.getInstance();

    final locaisSaved = prefs.getStringList('mecanica_locais');
    if (locaisSaved != null) {
      _locaisMecanica = locaisSaved;
    }

    final equipsSaved = prefs.getStringList('mecanica_equipamentos');
    if (equipsSaved != null) {
      _equipamentosMecanica = equipsSaved;
    }

    final pessoasSaved = prefs.getStringList('mecanica_pessoas');
    if (pessoasSaved != null) {
      _pessoasMecanica = pessoasSaved.map((item) {
        final map = jsonDecode(item) as Map<String, dynamic>;
        return {'nome': map['nome'].toString(), 'mat': map['mat'].toString()};
      }).toList();
    }

    if (mounted) setState(() {});

    // Escutar atualizações do Cloud Firestore em tempo real
    FirestoreCadastrosService().escutarCadastrosArea(
      area: 'mecanica',
      onData: (data) {
        if (!mounted) return;
        setState(() {
          if (data['locais'] != null) {
            _locaisMecanica = List<String>.from(data['locais']);
          }
          if (data['equipamentos'] != null) {
            _equipamentosMecanica = List<String>.from(data['equipamentos']);
          }
          if (data['colaboradores'] != null) {
            _pessoasMecanica = (data['colaboradores'] as List).map((p) => Map<String, String>.from(p)).toList();
          }
        });
      },
    );
  }

  Future<void> _salvarCadastrosPersistidos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('mecanica_locais', _locaisMecanica);
    await prefs.setStringList('mecanica_equipamentos', _equipamentosMecanica);

    final pessoasJson = _pessoasMecanica.map((p) => jsonEncode(p)).toList();
    await prefs.setStringList('mecanica_pessoas', pessoasJson);

    // Sincronizar com o Cloud Firestore
    await FirestoreCadastrosService().salvarCadastrosArea(
      area: 'mecanica',
      data: {
        'locais': _locaisMecanica,
        'equipamentos': _equipamentosMecanica,
        'colaboradores': _pessoasMecanica,
        'atualizadoEm': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  void dispose() {
    _observacoesCtrl.dispose();
    _novoLocalCtrl.dispose();
    _novoEquipCtrl.dispose();
    _novoNomeMecCtrl.dispose();
    _novaMatMecCtrl.dispose();
    for (var om in _ordensManutencao) {
      (om['omNumCtrl'] as TextEditingController).dispose();
      (om['tagCtrl'] as TextEditingController).dispose();
      (om['descCtrl'] as TextEditingController).dispose();
      (om['startCtrl'] as TextEditingController).dispose();
      (om['endCtrl'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _abrirModalNovaOM() {
    String numOm = 'OM-${(_ordensManutencao.length + 1).toString().padLeft(3, '0')}';
    String localOm = _locaisMecanica.first;
    String rotaOm = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Row(
                    children: [
                      Text('➕ Nova ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Ordem de Manutenção', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A3FA8))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Rota
                  const Text('🛣️ Rota de Inspeção (Opcional)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: rotaOm.isEmpty ? '' : rotaOm,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: const [
                      DropdownMenuItem(value: '', child: Text('— Sem rota (OM manual) —')),
                      DropdownMenuItem(value: 'rota01', child: Text('Rota de inspeção 01')),
                      DropdownMenuItem(value: 'rota02', child: Text('Rota de inspeção 02')),
                    ],
                    onChanged: (val) => setModalState(() => rotaOm = val ?? ''),
                  ),
                  const SizedBox(height: 14),

                  if (rotaOm.isEmpty) ...[
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('🔢 Nº OM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                              const SizedBox(height: 4),
                              TextFormField(
                                initialValue: numOm,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                                onChanged: (val) => numOm = val,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('📍 Local', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                initialValue: localOm,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                                items: _locaisMecanica.map((l) => DropdownMenuItem(value: l, child: Text(l, overflow: TextOverflow.ellipsis))).toList(),
                                onChanged: (val) => setModalState(() => localOm = val ?? _locaisMecanica.first),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF23005B),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (rotaOm.isNotEmpty) {
                        _adicionarOMsDaRota(rotaOm);
                      } else {
                        _adicionarOMManual(numOm, localOm);
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar à Lista', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _adicionarOMManual(String numOm, String localOm) {
    setState(() {
      _ordensManutencao.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'omNumCtrl': TextEditingController(text: numOm),
        'local': localOm,
        'tagCtrl': TextEditingController(),
        'descCtrl': TextEditingController(),
        'status': 'ABERTA',
        'concluida': false,
        'startCtrl': TextEditingController(),
        'endCtrl': TextEditingController(),
        'fotos': <String>[],
      });
    });
  }

  void _adicionarOMsDaRota(String rotaId) {
    final List<Map<String, String>> itens = rotaId == 'rota01'
        ? [
            {'om': 'OM-101', 'local': 'Oficina Infra', 'tag': 'HL-01', 'desc': 'Inspeção mecânica estrutural'},
            {'om': 'OM-102', 'local': 'E22 - 01', 'tag': 'BOMBA-01', 'desc': 'Verificação de alinhamento'},
          ]
        : [
            {'om': 'OM-201', 'local': 'EW42 - 01', 'tag': 'VALV-02', 'desc': 'Revisão hidráulica'},
            {'om': 'OM-202', 'local': 'ER4', 'tag': 'HL-03', 'desc': 'Lubrificação geral'},
          ];

    setState(() {
      for (var item in itens) {
        _ordensManutencao.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString() + item['om']!,
          'omNumCtrl': TextEditingController(text: item['om']),
          'local': item['local'],
          'tagCtrl': TextEditingController(text: item['tag']),
          'descCtrl': TextEditingController(text: item['desc']),
          'status': 'ABERTA',
          'concluida': false,
          'startCtrl': TextEditingController(),
          'endCtrl': TextEditingController(),
          'fotos': <String>[],
        });
      }
    });
  }

  String _gerarTextoRelatorio() {
    final StringBuffer sb = StringBuffer();
    final String dataStr = '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';

    sb.writeln('*RELATÓRIO DE MANUTENÇÃO MECÂNICA*');
    sb.writeln('Data: $dataStr | Turno: $_turno | Turma: $_turma');
    sb.writeln('');

    sb.writeln('*EXECUTANTES:*');
    int countExec = 0;
    for (var ex in _executantes) {
      if (ex['nome'] != null && ex['nome']!.isNotEmpty) {
        countExec++;
        final matStr = ex['mat'] != null && ex['mat']!.isNotEmpty ? ' (${ex['mat']})' : '';
        sb.writeln('• ${ex['nome']}$matStr');
      }
    }
    if (countExec == 0) sb.writeln('• Nenhum informado');
    sb.writeln('');

    sb.writeln('*ORDENS DE SERVIÇO / MANUTENÇÕES (${_ordensManutencao.length}):*');
    if (_ordensManutencao.isEmpty) {
      sb.writeln('• Nenhuma OM adicionada.');
    } else {
      for (var om in _ordensManutencao) {
        final omNum = (om['omNumCtrl'] as TextEditingController).text;
        final local = om['local'] ?? '';
        final tag = (om['tagCtrl'] as TextEditingController).text;
        final desc = (om['descCtrl'] as TextEditingController).text;
        final st = om['status'] ?? 'ABERTA';

        sb.writeln('• *$omNum* | Local: $local');
        if (tag.isNotEmpty) sb.writeln('  TAG: $tag');
        if (desc.isNotEmpty) sb.writeln('  Descrição: $desc');
        sb.writeln('  Status: $st');
        sb.writeln('');
      }
    }

    if (_observacoesCtrl.text.isNotEmpty) {
      sb.writeln('*OBSERVAÇÕES:*');
      sb.writeln(_observacoesCtrl.text);
    }

    return sb.toString();
  }

  Future<void> _enviarMecanicaReportFirestore() async {
    try {
      final db = FirebaseFirestore.instance;
      
      final snap = await db.collection('mechanical_reports').get();
      final count = snap.docs.length + 1;
      final reportId = 'MC${count.toString().padLeft(7, '0')}';

      // Map operators
      final operatorsList = _executantes.map((e) => {
        'id': e['mat'] ?? '',
        'registration': e['mat'] ?? '',
        'name': e['nome'] ?? '',
      }).toList();

      // Map work orders
      final List<Map<String, dynamic>> workOrders = _ordensManutencao.map((om) {
        final concluida = om['concluida'] ?? false;
        return {
          'id': om['id'] ?? '',
          'number': (om['omNumCtrl'] as TextEditingController).text,
          'location': om['local'] ?? '',
          'maintenanceType': 'MECANICA',
          'cause': '',
          'activities': (om['descCtrl'] as TextEditingController).text,
          'materialsUsed': '',
          'quantityMeters': 0.0,
          'quantityPieces': 0,
          'startTime': (om['startCtrl'] as TextEditingController).text,
          'endTime': (om['endCtrl'] as TextEditingController).text,
          'status': om['status'] ?? 'ABERTA',
          'osStatus': concluida ? 'CONCLUÍDA' : 'ABERTA',
          'photoPaths': List<String>.from(om['fotos'] ?? []),
        };
      }).toList();

      final payload = {
        'uuid': reportId,
        'date': _selectedDate.toIso8601String(),
        'shift': _turno,
        'team': _turma,
        'globalEquipment': 'Manutenção Mecânica',
        'globalLocation': '',
        'fuelLevel': 0.0,
        'availableMaterials': '',
        'observations': _observacoesCtrl.text,
        'syncStatus': 'synced',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'operators': operatorsList,
        'workOrders': workOrders,
      };

      await db.collection('mechanical_reports').doc(reportId).set(payload, SetOptions(merge: true));
      debugPrint('Relatório mecânico enviado à coleção mechanical_reports com sucesso: $reportId');
    } catch (e) {
      debugPrint('Erro ao enviar relatório mecânico: $e');
    }
  }

  void _enviarWhatsApp() async {
    final texto = _gerarTextoRelatorio();
    _enviarMecanicaReportFirestore();
    final uri = Uri.parse("whatsapp://send?text=${Uri.encodeComponent(texto)}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
        );
      }
    }
  }

  void _preencherModoDev() {
    setState(() {
      _selectedDate = DateTime.now();
      _turno = 'T1';
      _turma = 'A';
      _executantes.clear();
      _executantes.add({'nome': 'Acacio Oliveira Souza', 'mat': '4786'});
      _executantes.add({'nome': 'Adailton Silva Santos', 'mat': '99300599'});

      _ordensManutencao.clear();
      _ordensManutencao.add({
        'id': '101',
        'omNumCtrl': TextEditingController(text: 'OM-3012'),
        'local': 'Subestação S-01',
        'tagCtrl': TextEditingController(text: 'MC-101'),
        'descCtrl': TextEditingController(text: 'Inspeção mecânica das bombas principais e lubrificação de rolamentos'),
        'status': 'CONCLUÍDA',
        'concluida': true,
        'startCtrl': TextEditingController(text: '08:00'),
        'endCtrl': TextEditingController(text: '10:00'),
        'fotos': <String>[],
      });
      _ordensManutencao.add({
        'id': '102',
        'omNumCtrl': TextEditingController(text: 'OM-3015'),
        'local': 'Oficina Subterrânea',
        'tagCtrl': TextEditingController(text: 'PT-302'),
        'descCtrl': TextEditingController(text: 'Troca de vedações hidráulicas e teste de pressão do sistema'),
        'status': 'CONCLUÍDA',
        'concluida': true,
        'startCtrl': TextEditingController(text: '10:30'),
        'endCtrl': TextEditingController(text: '12:00'),
        'fotos': <String>[],
      });

      _observacoesCtrl.text = 'Manutenção preventiva realizada com sucesso. Equipamentos liberados sem pendências.';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⚙️ [Modo Dev] Dados de Mecânica preenchidos com sucesso!'),
        backgroundColor: Color(0xFF23005B),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryNavy = Color(0xFF23005B);
    const accentPurple = Color(0xFF5C3FA3);
    const bgLight = Color(0xFFF5F7FA);
    const textColor = Color(0xFF1F2937);

    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 1,
        titleSpacing: 16,
        title: Row(
          children: [
            const SyncStatusBadge(),
            const SizedBox(width: 8),
            Text('CM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : textColor)),
            const Text('OC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: accentPurple)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: const BoxDecoration(
                color: Color(0xFFEDE9FF),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Text('⚙️ MECÂNICA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: accentPurple)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amber : accentPurple,
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
        ],
      ),
      body: IndexedStack(
        index: _currentTab,
        children: [
          _buildTabFormulario(primaryNavy, accentPurple, textColor),
          _buildTabCadastros(primaryNavy, accentPurple, textColor),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (idx) => setState(() => _currentTab = idx),
        selectedItemColor: primaryNavy,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Relatório'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cadastros & Locais'),
        ],
      ),
    );
  }

  // =========================================================================
  // ABA 1: FORMULÁRIO OPERACIONAL MECÂNICA
  // =========================================================================

  Widget _buildTabFormulario(Color primaryNavy, Color accentPurple, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: primaryNavy),
                    const SizedBox(width: 6),
                    Text(
                      '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (d != null) setState(() => _selectedDate = d);
                      },
                      child: const Text('Alterar Data'),
                    ),
                  ],
                ),
                const Divider(),
                const Text('TURNO E TURMA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'T1', label: Text('T1')),
                          ButtonSegment(value: 'T2', label: Text('T2')),
                          ButtonSegment(value: 'T3', label: Text('T3')),
                        ],
                        selected: {_turno},
                        onSelectionChanged: (val) => setState(() => _turno = val.first),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'A', label: Text('A')),
                          ButtonSegment(value: 'B', label: Text('B')),
                          ButtonSegment(value: 'C', label: Text('C')),
                          ButtonSegment(value: 'D', label: Text('D')),
                        ],
                        selected: {_turma},
                        onSelectionChanged: (val) => setState(() => _turma = val.first),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Executantes
          Text('👨‍🔧 EXECUTANTES (MECÂNICOS)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryNavy)),
          const SizedBox(height: 6),

          ...List.generate(_executantes.length, (idx) {
            final currentItem = _executantes[idx];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Autocomplete<Map<String, String>>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) return const Iterable.empty();
                  return _pessoasMecanica.where((p) => p['nome']!.toLowerCase().contains(textEditingValue.text.toLowerCase()) || p['mat']!.contains(textEditingValue.text));
                },
                displayStringForOption: (option) => '${option['nome']} (${option['mat']})',
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  if (controller.text.isEmpty && currentItem['nome']!.isNotEmpty) {
                    controller.text = '${currentItem['nome']} (${currentItem['mat']})';
                  }
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Digite o nome ou matrícula do mecânico...',
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: idx > 0
                          ? IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                              onPressed: () => setState(() => _executantes.removeAt(idx)),
                            )
                          : null,
                    ),
                  );
                },
                onSelected: (option) {
                  setState(() {
                    _executantes[idx] = {'nome': option['nome']!, 'mat': option['mat']!};
                  });
                },
              ),
            );
          }),

          TextButton.icon(
            onPressed: () => setState(() => _executantes.add({'nome': '', 'mat': ''})),
            icon: Icon(Icons.add_circle_outline, color: accentPurple),
            label: Text('Adicionar Mecânico', style: TextStyle(color: accentPurple, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 16),

          // Lista de Manutenções
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🛠️ ORDENS DE SERVIÇO E MANUTENÇÕES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryNavy)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: primaryNavy, foregroundColor: Colors.white),
                onPressed: _abrirModalNovaOM,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Nova OM'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (_ordensManutencao.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Column(
                children: [
                  Icon(Icons.build_outlined, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Nenhuma Ordem de Manutenção adicionada.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            )
          else
            ..._ordensManutencao.map((om) => _buildCardOM(om, primaryNavy, accentPurple)),

          const SizedBox(height: 16),

          // Observações
          Text('📝 OBSERVAÇÕES GERAIS DA MANUTENÇÃO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryNavy)),
          const SizedBox(height: 6),
          TextField(
            controller: _observacoesCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Anormalidades mecânicas, peças substituídas, pendências...',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _enviarWhatsApp,
            icon: const Icon(Icons.send),
            label: const Text('Enviar Relatório via WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildCardOM(Map<String, dynamic> om, Color primaryNavy, Color accentPurple) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: om['omNumCtrl'] as TextEditingController,
                  decoration: const InputDecoration(labelText: 'Nº da OM', isDense: true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _locaisMecanica.contains(om['local']) ? om['local'] : _locaisMecanica.first,
                  decoration: const InputDecoration(labelText: 'Local', isDense: true),
                  items: _locaisMecanica.map((l) => DropdownMenuItem(value: l, child: Text(l, overflow: TextOverflow.ellipsis))).toList(),
                  onChanged: (val) => setState(() => om['local'] = val ?? _locaisMecanica.first),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => setState(() => _ordensManutencao.remove(om)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: om['tagCtrl'] as TextEditingController,
            decoration: const InputDecoration(labelText: 'TAG / Equipamento (Ex: HL-01, BOMBA-02)', isDense: true),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: om['descCtrl'] as TextEditingController,
            decoration: const InputDecoration(labelText: 'Descrição da Atividade Mecânica', isDense: true),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // ABA 2: CADASTROS & CONFIGURAÇÕES (LOCAIS, EQUIPAMENTOS, MECÂNICOS)
  // =========================================================================

  Widget _buildTabCadastros(Color primaryNavy, Color accentPurple, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Locais e Frentes de Manutenção
          _buildCardCadastroSection(
            title: '📍 Frentes e Locais de Manutenção (${_locaisMecanica.length})',
            primaryNavy: primaryNavy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _novoLocalCtrl,
                        decoration: const InputDecoration(hintText: 'Ex: Oficina K-02, Rampa Sul'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primaryNavy, foregroundColor: Colors.white),
                      onPressed: () {
                        final val = _novoLocalCtrl.text.trim();
                        if (val.isNotEmpty && !_locaisMecanica.contains(val)) {
                          setState(() {
                            _locaisMecanica.add(val);
                            _novoLocalCtrl.clear();
                            _salvarCadastrosPersistidos();
                          });
                        }
                      },
                      child: const Text('Adicionar'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _locaisMecanica.map((loc) {
                    return Chip(
                      label: Text(loc, style: const TextStyle(fontSize: 12)),
                      onDeleted: loc == 'Outro'
                          ? null
                          : () {
                              setState(() {
                                _locaisMecanica.remove(loc);
                                _salvarCadastrosPersistidos();
                              });
                            },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Frota e Equipamentos Mecânicos
          _buildCardCadastroSection(
            title: '🚜 Frota e Equipamentos Mecânicos (${_equipamentosMecanica.length})',
            primaryNavy: primaryNavy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _novoEquipCtrl,
                        decoration: const InputDecoration(hintText: 'Ex: Pá Carregadeira L-140'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primaryNavy, foregroundColor: Colors.white),
                      onPressed: () {
                        final val = _novoEquipCtrl.text.trim();
                        if (val.isNotEmpty && !_equipamentosMecanica.contains(val)) {
                          setState(() {
                            _equipamentosMecanica.add(val);
                            _novoEquipCtrl.clear();
                            _salvarCadastrosPersistidos();
                          });
                        }
                      },
                      child: const Text('Adicionar'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _equipamentosMecanica.map((eq) {
                    return Chip(
                      label: Text(eq, style: const TextStyle(fontSize: 12)),
                      onDeleted: () {
                        setState(() {
                          _equipamentosMecanica.remove(eq);
                          _salvarCadastrosPersistidos();
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Cadastrar Novo Mecânico
          _buildCardCadastroSection(
            title: '👨‍🔧 Cadastrar Mecânico / Colaborador (${_pessoasMecanica.length})',
            primaryNavy: primaryNavy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _novoNomeMecCtrl,
                  decoration: const InputDecoration(labelText: 'Nome do Mecânico *'),
                ),
                TextField(
                  controller: _novaMatMecCtrl,
                  decoration: const InputDecoration(labelText: 'Matrícula'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: accentPurple, foregroundColor: Colors.white),
                  onPressed: () {
                    final nome = _novoNomeMecCtrl.text.trim();
                    if (nome.isNotEmpty) {
                      setState(() {
                        _pessoasMecanica.add({
                          'nome': nome,
                          'mat': _novaMatMecCtrl.text.trim().isEmpty ? 'S/N' : _novaMatMecCtrl.text.trim(),
                        });
                        _novoNomeMecCtrl.clear();
                        _novaMatMecCtrl.clear();
                        _salvarCadastrosPersistidos();
                      });
                    }
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Salvar Colaborador'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardCadastroSection({required String title, required Color primaryNavy, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryNavy)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
