import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/services/firestore_cadastros_service.dart';

class ElectricalReportFormPage extends ConsumerStatefulWidget {
  const ElectricalReportFormPage({super.key});

  @override
  ConsumerState<ElectricalReportFormPage> createState() => _ElectricalReportFormPageState();
}

class _ElectricalReportFormPageState extends ConsumerState<ElectricalReportFormPage> {
  int _currentTab = 0; // 0: Relatório, 1: Cadastros & Locais

  // State matching relatorio-eletrica.html
  DateTime _selectedDate = DateTime.now();
  String _tipoRelatorio = 'Elétrica Rotina'; // 'Elétrica Rotina' | 'Elétrica Programada'
  String _turno = 'T1'; // 'T1' | 'T2' | 'T3'
  String _turma = 'Turma A'; // 'Turma A' | 'Turma B' | 'Turma C' | 'Turma D'

  // Equipamento
  bool _semEquip = false;
  String _equipamento = '';
  final _localEquipCtrl = TextEditingController();
  double _combustivel = 50.0;
  final _materiaisCtrl = TextEditingController();

  // Executantes
  final List<Map<String, String>> _executantes = [
    {'nome': '', 'mat': ''}
  ];

  // Ordens de Serviço
  final List<Map<String, dynamic>> _ordensServico = [];

  // Validation
  bool _showValidationErrors = false;
  String _errorMessage = '';

  // Listas Dinâmicas Persistentes
  late List<Map<String, String>> _pessoasEletrica;
  late List<String> _subestacoesEletrica;
  late List<String> _equipamentosEletrica;

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
  ];

  static const List<String> _subestacoesPadrao = [
    'Subestação S-01', 'Subestação S-02', 'Subestação S-03', 'Subestação S-04',
    'Quadro Geral QG-01', 'Quadro Geral QG-02', 'Painel de Distribuição P-01',
    'Oficina Elétrica Subterrânea', 'Superfície Eletro'
  ];

  static const List<String> _equipamentosPadrao = [
    'Transformador T-500kVA', 'Transformador T-1000kVA', 'Gerador G-01',
    'Gerador G-02', 'Painel Soft-Starter', 'Nobreak Principal', 'Chave Seccionadora'
  ];

  // Controllers para cadastros
  final _novaSubestacaoCtrl = TextEditingController();
  final _novoEquipCtrl = TextEditingController();
  final _novoNomeEletCtrl = TextEditingController();
  final _novaMatEletCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pessoasEletrica = List.from(_pessoasPadrao);
    _subestacoesEletrica = List.from(_subestacoesPadrao);
    _equipamentosEletrica = List.from(_equipamentosPadrao);
    _carregarCadastrosPersistidos();
  }

  Future<void> _carregarCadastrosPersistidos() async {
    final prefs = await SharedPreferences.getInstance();

    final subsSaved = prefs.getStringList('eletrica_subestacoes');
    if (subsSaved != null) {
      _subestacoesEletrica = subsSaved;
    }

    final equipsSaved = prefs.getStringList('eletrica_equipamentos');
    if (equipsSaved != null) {
      _equipamentosEletrica = equipsSaved;
    }

    final pessoasSaved = prefs.getStringList('eletrica_pessoas');
    if (pessoasSaved != null) {
      _pessoasEletrica = pessoasSaved.map((item) {
        final map = jsonDecode(item) as Map<String, dynamic>;
        return {'nome': map['nome'].toString(), 'mat': map['mat'].toString()};
      }).toList();
    }

    if (mounted) setState(() {});

    // Escutar atualizações do Cloud Firestore em tempo real
    FirestoreCadastrosService().escutarCadastrosArea(
      area: 'eletrica',
      onData: (data) {
        if (!mounted) return;
        setState(() {
          if (data['subestacoes'] != null) {
            _subestacoesEletrica = List<String>.from(data['subestacoes']);
          }
          if (data['equipamentos'] != null) {
            _equipamentosEletrica = List<String>.from(data['equipamentos']);
          }
          if (data['colaboradores'] != null) {
            _pessoasEletrica = (data['colaboradores'] as List).map((p) => Map<String, String>.from(p)).toList();
          }
        });
      },
    );
  }

  Future<void> _salvarCadastrosPersistidos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('eletrica_subestacoes', _subestacoesEletrica);
    await prefs.setStringList('eletrica_equipamentos', _equipamentosEletrica);

    final pessoasJson = _pessoasEletrica.map((p) => jsonEncode(p)).toList();
    await prefs.setStringList('eletrica_pessoas', pessoasJson);

    // Sincronizar com o Cloud Firestore
    await FirestoreCadastrosService().salvarCadastrosArea(
      area: 'eletrica',
      data: {
        'subestacoes': _subestacoesEletrica,
        'equipamentos': _equipamentosEletrica,
        'colaboradores': _pessoasEletrica,
        'atualizadoEm': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  void dispose() {
    _localEquipCtrl.dispose();
    _materiaisCtrl.dispose();
    _novaSubestacaoCtrl.dispose();
    _novoEquipCtrl.dispose();
    _novoNomeEletCtrl.dispose();
    _novaMatEletCtrl.dispose();
    for (var os in _ordensServico) {
      (os['numCtrl'] as TextEditingController).dispose();
      (os['tagCtrl'] as TextEditingController).dispose();
      (os['descCtrl'] as TextEditingController).dispose();
      (os['localCtrl'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _adicionarOS() {
    setState(() {
      _ordensServico.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'numCtrl': TextEditingController(text: 'OS-${(_ordensServico.length + 1).toString().padLeft(3, '0')}'),
        'tagCtrl': TextEditingController(),
        'descCtrl': TextEditingController(),
        'localCtrl': TextEditingController(),
        'status': 'CONCLUÍDA',
        'fotos': <String>[],
      });
    });
  }

  bool _validarFormulario() {
    if (_tipoRelatorio.isEmpty) {
      _errorMessage = 'Selecione o tipo de relatório.';
      return false;
    }

    bool executantePreenchido = false;
    for (var ex in _executantes) {
      if (ex['nome'] != null && ex['nome']!.trim().isNotEmpty) {
        executantePreenchido = true;
        break;
      }
    }
    if (!executantePreenchido) {
      _errorMessage = 'Adicione ao menos um executante.';
      return false;
    }

    if (!_semEquip && _equipamento.isEmpty) {
      _errorMessage = 'Selecione o equipamento utilizado ou marque "Não se aplica".';
      return false;
    }

    return true;
  }

  String _gerarTextoRelatorio() {
    final StringBuffer sb = StringBuffer();
    final String dataStr = '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';

    sb.writeln('*RELATÓRIO DE MANUTENÇÃO ELÉTRICA*');
    sb.writeln('Tipo: $_tipoRelatorio');
    sb.writeln('Data: $dataStr | Turno: $_turno | $_turma');
    sb.writeln('');

    sb.writeln('*EQUIPAMENTO:*');
    if (_semEquip) {
      sb.writeln('• Não se aplica');
    } else {
      sb.writeln('• Equipamento: $_equipamento');
      if (_localEquipCtrl.text.isNotEmpty) sb.writeln('• Local: ${_localEquipCtrl.text}');
      sb.writeln('• Nível Combustível: ${_combustivel.round()}%');
    }
    sb.writeln('');

    sb.writeln('*EXECUTANTES (ELETRICISTAS):*');
    for (var ex in _executantes) {
      if (ex['nome'] != null && ex['nome']!.isNotEmpty) {
        final matStr = ex['mat'] != null && ex['mat']!.isNotEmpty ? ' (${ex['mat']})' : '';
        sb.writeln('• ${ex['nome']}$matStr');
      }
    }
    sb.writeln('');

    sb.writeln('*ACTIVIDADES / ORDENS DE SERVIÇO (${_ordensServico.length}):*');
    if (_ordensServico.isEmpty) {
      sb.writeln('• Nenhuma atividade registrada.');
    } else {
      for (var os in _ordensServico) {
        final numOs = (os['numCtrl'] as TextEditingController).text;
        final tag = (os['tagCtrl'] as TextEditingController).text;
        final desc = (os['descCtrl'] as TextEditingController).text;
        final local = (os['localCtrl'] as TextEditingController).text;
        final st = os['status'] ?? 'CONCLUÍDA';

        sb.writeln('• *$numOs* | Status: $st');
        if (tag.isNotEmpty) sb.writeln('  TAG/Painel: $tag');
        if (local.isNotEmpty) sb.writeln('  Local: $local');
        if (desc.isNotEmpty) sb.writeln('  Descrição: $desc');
        sb.writeln('');
      }
    }

    if (_materiaisCtrl.text.isNotEmpty) {
      sb.writeln('*MATERIAIS E OBSERVAÇÕES:*');
      sb.writeln(_materiaisCtrl.text);
    }

    return sb.toString();
  }

  void _enviarWhatsApp() async {
    setState(() {
      _showValidationErrors = true;
    });

    if (!_validarFormulario()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final texto = _gerarTextoRelatorio();
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

  @override
  Widget build(BuildContext context) {
    const primaryNavy = Color(0xFF23005B);
    const accentPurple = Color(0xFF5C3FA3);
    const bgLight = Color(0xFFF5F7FA);
    const textColor = Color(0xFF1F2937);

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: Color(0xFF1A9E4A), shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            const Text('CM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
            const Text('OC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: accentPurple)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: const BoxDecoration(
                color: Color(0xFFEDE9FF),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Text('⚡ ELÉTRICA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: accentPurple)),
            ),
          ],
        ),
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
  // ABA 1: FORMULÁRIO OPERACIONAL ELÉTRICA
  // =========================================================================

  Widget _buildTabFormulario(Color primaryNavy, Color accentPurple, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tipo de Relatório
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Elétrica Rotina'),
                    selected: _tipoRelatorio == 'Elétrica Rotina',
                    selectedColor: accentPurple.withValues(alpha: 0.2),
                    onSelected: (val) => setState(() => _tipoRelatorio = 'Elétrica Rotina'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Elétrica Programada'),
                    selected: _tipoRelatorio == 'Elétrica Programada',
                    selectedColor: accentPurple.withValues(alpha: 0.2),
                    onSelected: (val) => setState(() => _tipoRelatorio = 'Elétrica Programada'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Header Card (Data, Turno, Turma)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
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
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Executantes
          Text('⚡ ELETRICISTAS E EXECUTANTES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryNavy)),
          const SizedBox(height: 6),

          ...List.generate(_executantes.length, (idx) {
            final currentItem = _executantes[idx];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Autocomplete<Map<String, String>>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) return const Iterable.empty();
                  return _pessoasEletrica.where((p) => p['nome']!.toLowerCase().contains(textEditingValue.text.toLowerCase()) || p['mat']!.contains(textEditingValue.text));
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
                      hintText: 'Digite o nome do eletricista...',
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
            label: Text('Adicionar Eletricista', style: TextStyle(color: accentPurple, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 16),

          // Ordens de Serviço
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⚡ ATIVIDADES E ORDENS DE SERVIÇO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryNavy)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: primaryNavy, foregroundColor: Colors.white),
                onPressed: _adicionarOS,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Nova Atividade'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (_ordensServico.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Column(
                children: [
                  Icon(Icons.bolt, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Nenhuma atividade elétrica adicionada.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            )
          else
            ..._ordensServico.map((os) => _buildCardOS(os, primaryNavy)),

          const SizedBox(height: 16),

          // Materiais e Observações
          Text('📦 MATERIAIS E OBSERVAÇÕES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryNavy)),
          const SizedBox(height: 6),
          TextField(
            controller: _materiaisCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Cabos substituídos, disjuntores trocados, pendências elétricas...',
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

  Widget _buildCardOS(Map<String, dynamic> os, Color primaryNavy) {
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
                  controller: os['numCtrl'] as TextEditingController,
                  decoration: const InputDecoration(labelText: 'Nº Atividade / OS', isDense: true),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => setState(() => _ordensServico.remove(os)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: os['tagCtrl'] as TextEditingController,
            decoration: const InputDecoration(labelText: 'TAG / Painel / Subestação', isDense: true),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: os['descCtrl'] as TextEditingController,
            decoration: const InputDecoration(labelText: 'Descrição do Serviço Elétrico', isDense: true),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // ABA 2: CADASTROS & CONFIGURAÇÕES (SUBESTAÇÕES, EQUIPAMENTOS, ELETRICISTAS)
  // =========================================================================

  Widget _buildTabCadastros(Color primaryNavy, Color accentPurple, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Subestações e Locais Elétricos
          _buildCardCadastroSection(
            title: '⚡ Subestações e Locais Elétricos (${_subestacoesEletrica.length})',
            primaryNavy: primaryNavy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _novaSubestacaoCtrl,
                        decoration: const InputDecoration(hintText: 'Ex: Subestação S-05, Quadro QG-03'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primaryNavy, foregroundColor: Colors.white),
                      onPressed: () {
                        final val = _novaSubestacaoCtrl.text.trim();
                        if (val.isNotEmpty && !_subestacoesEletrica.contains(val)) {
                          setState(() {
                            _subestacoesEletrica.add(val);
                            _novaSubestacaoCtrl.clear();
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
                  children: _subestacoesEletrica.map((sub) {
                    return Chip(
                      label: Text(sub, style: const TextStyle(fontSize: 12)),
                      onDeleted: () {
                        setState(() {
                          _subestacoesEletrica.remove(sub);
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

          // 2. Equipamentos Elétricos
          _buildCardCadastroSection(
            title: '🔌 Equipamentos e Transformadores (${_equipamentosEletrica.length})',
            primaryNavy: primaryNavy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _novoEquipCtrl,
                        decoration: const InputDecoration(hintText: 'Ex: Transformador T-1500kVA'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primaryNavy, foregroundColor: Colors.white),
                      onPressed: () {
                        final val = _novoEquipCtrl.text.trim();
                        if (val.isNotEmpty && !_equipamentosEletrica.contains(val)) {
                          setState(() {
                            _equipamentosEletrica.add(val);
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
                  children: _equipamentosEletrica.map((eq) {
                    return Chip(
                      label: Text(eq, style: const TextStyle(fontSize: 12)),
                      onDeleted: () {
                        setState(() {
                          _equipamentosEletrica.remove(eq);
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

          // 3. Cadastrar Novo Eletricista
          _buildCardCadastroSection(
            title: '⚡ Cadastrar Eletricista / Colaborador (${_pessoasEletrica.length})',
            primaryNavy: primaryNavy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _novoNomeEletCtrl,
                  decoration: const InputDecoration(labelText: 'Nome do Eletricista *'),
                ),
                TextField(
                  controller: _novaMatEletCtrl,
                  decoration: const InputDecoration(labelText: 'Matrícula'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: accentPurple, foregroundColor: Colors.white),
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
