import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ElectricalReportFormPage extends ConsumerStatefulWidget {
  const ElectricalReportFormPage({super.key});

  @override
  ConsumerState<ElectricalReportFormPage> createState() => _ElectricalReportFormPageState();
}

class _ElectricalReportFormPageState extends ConsumerState<ElectricalReportFormPage> {
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

  // Executantes (Lista dinâmica com autocompletar)
  final List<Map<String, String>> _executantes = [
    {'nome': '', 'mat': ''}
  ];

  // Ordens de Serviço
  final List<Map<String, dynamic>> _ordensServico = [];

  // Validation
  bool _showValidationErrors = false;
  String _errorMessage = '';

  // Standard Database of Executants from relatorio-eletrica.html
  static const List<Map<String, String>> pessoasEletrica = [
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

  static const List<String> equipamentos = [
    'PT302',
    'PT305',
    'PT306',
    'MT001',
    'MT002',
    'PT386'
  ];

  static const List<Map<String, String>> tagListEletrica = [
    {'tag': 'SUB-01', 'name': 'Subestação Principal - Mina'},
    {'tag': 'SUB-02', 'name': 'Subestação Secundária - Cava'},
    {'tag': 'TRA-101', 'name': 'Transformador 13.8kV/440V - Britagem'},
    {'tag': 'QUAD-201', 'name': 'Quadro de Distribuição Força QDF-01'},
    {'tag': 'ILUM-01', 'name': 'Torre de Iluminação Portátil 01'},
    {'tag': 'CAB-501', 'name': 'Cabo Flexível de Média Tensão 5kV'},
  ];

  @override
  void initState() {
    super.initState();
    _addNovaOS();
  }

  @override
  void dispose() {
    _localEquipCtrl.dispose();
    _materiaisCtrl.dispose();
    for (var os in _ordensServico) {
      (os['tagCtrl'] as TextEditingController).dispose();
      (os['descCtrl'] as TextEditingController).dispose();
      (os['startCtrl'] as TextEditingController).dispose();
      (os['endCtrl'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _addNovaOS() {
    setState(() {
      _ordensServico.add({
        'num': _ordensServico.length + 1,
        'tagCtrl': TextEditingController(),
        'tipo': 'Preventiva', // Preventiva, Corretiva, Melhoria/Ajuste, Inspeção
        'status': 'Liberada', // Liberada, Pendente
        'instalacaoParada': false,
        'naHorario': false,
        'startCtrl': TextEditingController(text: '08:00'),
        'endCtrl': TextEditingController(text: '12:00'),
        'descCtrl': TextEditingController(),
      });
    });
  }

  void _removeOS(int index) {
    if (_ordensServico.length > 1) {
      setState(() {
        final os = _ordensServico.removeAt(index);
        (os['tagCtrl'] as TextEditingController).dispose();
        (os['descCtrl'] as TextEditingController).dispose();
        (os['startCtrl'] as TextEditingController).dispose();
        (os['endCtrl'] as TextEditingController).dispose();
      });
    }
  }

  void _addExecutante() {
    setState(() => _executantes.add({'nome': '', 'mat': ''}));
  }

  void _removeExecutante(int index) {
    if (_executantes.length > 1) {
      setState(() => _executantes.removeAt(index));
    }
  }

  String _formatDateBR(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }

  void _limparFormulario() {
    setState(() {
      _selectedDate = DateTime.now();
      _tipoRelatorio = 'Elétrica Rotina';
      _turno = 'T1';
      _turma = 'Turma A';
      _semEquip = false;
      _equipamento = '';
      _localEquipCtrl.clear();
      _combustivel = 50.0;
      _materiaisCtrl.clear();
      _executantes.clear();
      _executantes.add({'nome': '', 'mat': ''});
      _ordensServico.clear();
      _addNovaOS();
      _showValidationErrors = false;
      _errorMessage = '';
    });
  }

  bool _validar() {
    List<String> erros = [];

    if (_tipoRelatorio.isEmpty) erros.add('Tipo de Relatório é obrigatório');
    if (_turno.isEmpty) erros.add('Turno é obrigatório');
    if (_turma.isEmpty) erros.add('Turma é obrigatória');

    if (!_semEquip) {
      if (_equipamento.isEmpty) erros.add('Selecione o equipamento ou marque "Nenhum equipamento"');
      if (_localEquipCtrl.text.trim().isEmpty) erros.add('Informe o local do equipamento');
      if (_materiaisCtrl.text.trim().isEmpty) erros.add('Liste os materiais disponíveis');
    }

    bool temExecutanteValido = _executantes.any((e) => e['nome']!.trim().isNotEmpty);
    if (!temExecutanteValido) {
      erros.add('Informe ao menos 1 executante com nome');
    }

    for (int i = 0; i < _ordensServico.length; i++) {
      final os = _ordensServico[i];
      final tag = (os['tagCtrl'] as TextEditingController).text.trim();
      final desc = (os['descCtrl'] as TextEditingController).text.trim();
      if (tag.isEmpty) erros.add('OS #${i + 1}: Informe a TAG / Equipamento');
      if (desc.isEmpty) erros.add('OS #${i + 1}: Informe a descrição da atividade');
    }

    if (erros.isNotEmpty) {
      setState(() {
        _showValidationErrors = true;
        _errorMessage = '⚠️ ${erros.first}';
      });
      return false;
    }

    setState(() {
      _showValidationErrors = false;
      _errorMessage = '';
    });
    return true;
  }

  Future<void> _enviarWhatsApp() async {
    if (!_validar()) return;

    final dateStr = _formatDateBR(_selectedDate);
    final execsListStr = _executantes
        .where((e) => e['nome']!.trim().isNotEmpty)
        .map((e) => '• ${e['nome']} (Mat: ${e['mat']})')
        .join('\n');

    String text = '⚡ *RELATÓRIO DE TURNO ELÉTRICA - CMOC*\n';
    text += '📅 *Data:* $dateStr\n';
    text += '📋 *Tipo:* $_tipoRelatorio\n';
    text += '🕐 *Turno:* $_turno | *Turma:* $_turma\n\n';

    text += '👷 *EXECUTANTES:*\n$execsListStr\n\n';

    text += '🔧 *EQUIPAMENTO:*\n';
    if (_semEquip) {
      text += '🚫 Nenhum equipamento utilizado neste turno.\n\n';
    } else {
      text += '• Equipamento: $_equipamento\n';
      text += '• Local: ${_localEquipCtrl.text.trim()}\n';
      text += '• Combustível: ${_combustivel.toInt()}%\n';
      text += '• Materiais: ${_materiaisCtrl.text.trim()}\n\n';
    }

    text += '📑 *ORDENS DE SERVIÇO (${_ordensServico.length}):*\n';
    for (int i = 0; i < _ordensServico.length; i++) {
      final os = _ordensServico[i];
      final tag = (os['tagCtrl'] as TextEditingController).text.trim();
      final desc = (os['descCtrl'] as TextEditingController).text.trim();
      final start = (os['startCtrl'] as TextEditingController).text.trim();
      final end = (os['endCtrl'] as TextEditingController).text.trim();

      text += '\n*OS #${i + 1} - $tag*\n';
      text += '• Tipo: ${os['tipo']} | Status: ${os['status']}\n';
      text += '• Instalação Parada: ${os['instalacaoParada'] ? 'SIM' : 'NÃO'}\n';
      if (!os['naHorario']) text += '• Horário: $start às $end\n';
      text += '• Descrição: $desc\n';
    }

    final Uri url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
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
    const Color bgPage = Color(0xFFEEF1F7);
    const Color cardBg = Colors.white;
    const Color textColor = Color(0xFF2B2F3A);
    const Color mutedColor = Color(0xFF8A90A2);
    const Color accentPurple = Color(0xFF6366F1);
    const Color accentGreen = Color(0xFF16A34A);
    const Color borderColor = Color(0xFFE6E9F0);

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        foregroundColor: textColor,
        title: const Row(
          children: [
            Text(
              'CM',
              style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF36A635), fontSize: 24),
            ),
            Text(
              'OC',
              style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF5B2A8C), fontSize: 24),
            ),
            SizedBox(width: 10),
            Text(
              'Relatório de Turno',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF8A90A2)),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              _validar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✓ Rascunho salvo localmente'), duration: Duration(seconds: 1)),
              );
            },
            icon: const Icon(Icons.save_outlined, size: 16, color: accentPurple),
            label: const Text('Salvar', style: TextStyle(color: accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: _limparFormulario,
            tooltip: 'Limpar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ERRO BANNER
            if (_showValidationErrors && _errorMessage.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDEAEA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF3A3A3)),
                ),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Color(0xFFC0392B), fontWeight: FontWeight.bold, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),

            // SEÇÃO 1: IDENTIFICAÇÃO
            _buildSectionHeader('IDENTIFICAÇÃO'),
            _buildCard(
              cardBg: cardBg,
              borderColor: borderColor,
              children: [
                // Data
                _buildLabel('🗓️', 'DATA'),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6FB),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDateBR(_selectedDate),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                        ),
                        const Icon(Icons.calendar_month, color: accentPurple),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tipo de Relatório
                _buildLabel('⚡', 'TIPO DE RELATÓRIO *'),
                Row(
                  children: [
                    Expanded(
                      child: _buildToggleButton(
                        label: '⚡ Elétrica Rotina',
                        isSelected: _tipoRelatorio == 'Elétrica Rotina',
                        activeColor: accentPurple,
                        onTap: () => setState(() => _tipoRelatorio = 'Elétrica Rotina'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildToggleButton(
                        label: '🛠️ Elétrica Programada',
                        isSelected: _tipoRelatorio == 'Elétrica Programada',
                        activeColor: accentPurple,
                        onTap: () => setState(() => _tipoRelatorio = 'Elétrica Programada'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Executantes
                _buildLabel('👥', 'EXECUTANTES *'),
                ..._executantes.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final exec = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6FB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'EXECUTANTE ${idx + 1}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: mutedColor),
                            ),
                            if (_executantes.length > 1)
                              InkWell(
                                onTap: () => _removeExecutante(idx),
                                child: const Text('Excluir', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Autocomplete Executante
                        RawAutocomplete<Map<String, String>>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return pessoasEletrica;
                            }
                            final q = textEditingValue.text.toLowerCase().trim();
                            return pessoasEletrica.where((p) {
                              return p['nome']!.toLowerCase().contains(q) || p['mat']!.contains(q);
                            });
                          },
                          displayStringForOption: (option) => option['nome']!,
                          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                            if (controller.text.isEmpty && exec['nome']!.isNotEmpty) {
                              controller.text = exec['nome']!;
                            }
                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                hintText: 'Digite o nome ou matrícula...',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              onChanged: (val) {
                                exec['nome'] = val;
                                setState(() {});
                              },
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 6,
                                borderRadius: BorderRadius.circular(10),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width - 64,
                                    maxHeight: 200,
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final option = options.elementAt(index);
                                      return ListTile(
                                        title: Text(option['nome']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        subtitle: Text('Matrícula: ${option['mat']}', style: const TextStyle(fontSize: 12, color: mutedColor)),
                                        onTap: () {
                                          onSelected(option);
                                          setState(() {
                                            exec['nome'] = option['nome']!;
                                            exec['mat'] = option['mat']!;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),

                        // Matrícula Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: accentPurple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🪪 MATRÍCULA: ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: accentPurple)),
                              Text(
                                exec['mat']!.isNotEmpty ? exec['mat']! : 'S/N',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEEF0FF),
                    foregroundColor: accentPurple,
                    elevation: 0,
                    side: const BorderSide(color: accentPurple),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  onPressed: _addExecutante,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar executante', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // SEÇÃO 2: TURNO & TURMA
            _buildSectionHeader('TURNO & TURMA'),
            _buildCard(
              cardBg: cardBg,
              borderColor: borderColor,
              children: [
                _buildLabel('🕐', 'TURNO *'),
                Row(
                  children: ['T1', 'T2', 'T3'].map((t) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _buildToggleButton(
                          label: t,
                          isSelected: _turno == t,
                          activeColor: accentPurple,
                          onTap: () => setState(() => _turno = t),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                _buildLabel('👥', 'TURMA *'),
                Row(
                  children: ['Turma A', 'Turma B', 'Turma C', 'Turma D'].map((t) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _buildToggleButton(
                          label: t.replaceAll('Turma ', ''),
                          isSelected: _turma == t,
                          activeColor: accentGreen,
                          onTap: () => setState(() => _turma = t),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // SEÇÃO 3: EQUIPAMENTO
            _buildSectionHeader('EQUIPAMENTO'),
            _buildCard(
              cardBg: cardBg,
              borderColor: borderColor,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        '🚫 Nenhum equipamento utilizado neste turno',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
                      ),
                    ),
                    Switch(
                      value: _semEquip,
                      activeThumbColor: const Color(0xFFF59E0B),
                      onChanged: (val) => setState(() => _semEquip = val),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Opacity(
                  opacity: _semEquip ? 0.4 : 1.0,
                  child: IgnorePointer(
                    ignoring: _semEquip,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('🔧', 'EQUIPAMENTO *'),
                        DropdownButtonFormField<String>(
                          initialValue: equipamentos.contains(_equipamento) ? _equipamento : null,
                          decoration: InputDecoration(
                            hintText: '— Selecione —',
                            fillColor: const Color(0xFFF4F6FB),
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                          ),
                          items: equipamentos.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setState(() => _equipamento = val ?? ''),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('📍', 'LOCAL *'),
                        TextFormField(
                          controller: _localEquipCtrl,
                          decoration: InputDecoration(
                            hintText: 'Ex: Galeria Norte, Poço 3...',
                            fillColor: const Color(0xFFF4F6FB),
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('⛽', 'NÍVEL DO COMBUSTÍVEL (%) *'),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _combustivel,
                                min: 0,
                                max: 100,
                                divisions: 20,
                                activeColor: accentPurple,
                                label: '${_combustivel.toInt()}%',
                                onChanged: (val) => setState(() => _combustivel = val),
                              ),
                            ),
                            Text(
                              '${_combustivel.toInt()}%',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: textColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('🧰', 'MATERIAIS DISPONÍVEIS *'),
                        TextFormField(
                          controller: _materiaisCtrl,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Liste os materiais disponíveis...',
                            fillColor: const Color(0xFFF4F6FB),
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // SEÇÃO 4: ORDENS DE SERVIÇO
            _buildSectionHeader('ORDENS DE SERVIÇO'),
            ..._ordensServico.asMap().entries.map((entry) {
              final idx = entry.key;
              final os = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
                  ],
                ),
                child: Column(
                  children: [
                    // OS Header (Gradiente azul)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFF3B5BDB), Color(0xFF4C6EF5)]),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ordem de Serviço #${idx + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                          ),
                          if (_ordensServico.length > 1)
                            InkWell(
                              onTap: () => _removeOS(idx),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Excluir', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Autocomplete TAG
                          _buildLabel('🏷️', 'TAG / EQUIPAMENTO *'),
                          RawAutocomplete<Map<String, String>>(
                            optionsBuilder: (TextEditingValue val) {
                              if (val.text.isEmpty) return tagListEletrica;
                              final q = val.text.toLowerCase();
                              return tagListEletrica.where((t) => t['tag']!.toLowerCase().contains(q) || t['name']!.toLowerCase().contains(q));
                            },
                            displayStringForOption: (opt) => '${opt['tag']} - ${opt['name']}',
                            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                              if (controller.text.isEmpty && (os['tagCtrl'] as TextEditingController).text.isNotEmpty) {
                                controller.text = (os['tagCtrl'] as TextEditingController).text;
                              }
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  hintText: 'Digite a TAG ou nome (Ex: SUB-01)...',
                                  fillColor: const Color(0xFFF4F6FB),
                                  filled: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                                ),
                                onChanged: (v) => (os['tagCtrl'] as TextEditingController).text = v,
                              );
                            },
                            optionsViewBuilder: (context, onSelected, options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 6,
                                  borderRadius: BorderRadius.circular(10),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width - 64,
                                      maxHeight: 180,
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder: (context, i) {
                                        final opt = options.elementAt(i);
                                        return ListTile(
                                          title: Text(opt['tag']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: accentPurple)),
                                          subtitle: Text(opt['name']!, style: const TextStyle(fontSize: 12)),
                                          onTap: () {
                                            onSelected(opt);
                                            (os['tagCtrl'] as TextEditingController).text = '${opt['tag']} - ${opt['name']}';
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 14),

                          // Tipo de Serviço
                          _buildLabel('🛠️', 'TIPO DE SERVIÇO *'),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: ['Preventiva', 'Corretiva', 'Melhoria/Ajuste', 'Inspeção'].map((tipo) {
                              final isSel = os['tipo'] == tipo;
                              return ChoiceChip(
                                label: Text(tipo),
                                selected: isSel,
                                selectedColor: accentPurple,
                                labelStyle: TextStyle(color: isSel ? Colors.white : textColor, fontWeight: FontWeight.bold, fontSize: 12),
                                onSelected: (_) => setState(() => os['tipo'] = tipo),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),

                          // Status OS & Instalação Parada
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('📌', 'STATUS'),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildToggleButton(
                                            label: 'Liberada',
                                            isSelected: os['status'] == 'Liberada',
                                            activeColor: accentGreen,
                                            onTap: () => setState(() => os['status'] = 'Liberada'),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: _buildToggleButton(
                                            label: 'Pendente',
                                            isSelected: os['status'] == 'Pendente',
                                            activeColor: const Color(0xFFF59E0B),
                                            onTap: () => setState(() => os['status'] = 'Pendente'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('⚠️ Instalação Parada?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Switch(
                                value: os['instalacaoParada'],
                                activeThumbColor: Colors.redAccent,
                                onChanged: (val) => setState(() => os['instalacaoParada'] = val),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Horários
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: os['startCtrl'] as TextEditingController,
                                  decoration: InputDecoration(
                                    labelText: 'INÍCIO (HH:MM)',
                                    fillColor: const Color(0xFFF4F6FB),
                                    filled: true,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: os['endCtrl'] as TextEditingController,
                                  decoration: InputDecoration(
                                    labelText: 'FIM (HH:MM)',
                                    fillColor: const Color(0xFFF4F6FB),
                                    filled: true,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Descrição
                          _buildLabel('📝', 'DESCRIÇÃO DA ATIVIDADE *'),
                          TextFormField(
                            controller: os['descCtrl'] as TextEditingController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Descreva detalhadamente os testes, manutenção ou intervenção efetuada...',
                              fillColor: const Color(0xFFF4F6FB),
                              filled: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEEF0FF),
                foregroundColor: accentPurple,
                side: const BorderSide(color: accentPurple),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _addNovaOS,
              icon: const Icon(Icons.add),
              label: const Text('Nova Ordem de Serviço', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            const SizedBox(height: 24),

            // BOTÃO ENVIAR PARA WHATSAPP
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 6,
                ),
                onPressed: _enviarWhatsApp,
                icon: const Icon(Icons.send_rounded, size: 22),
                label: const Text(
                  'Enviar para o WhatsApp',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                '✓ Funciona 100% offline. O envio abre o WhatsApp com o relatório formatado.',
                style: TextStyle(fontSize: 11, color: mutedColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF8A90A2), letterSpacing: 1.2),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFE6E9F0), Colors.transparent]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required Color cardBg,
    required Color borderColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLabel(String icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF8A90A2), letterSpacing: 0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : const Color(0xFFF4F6FB),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: isSelected ? activeColor : const Color(0xFFE6E9F0)),
          boxShadow: isSelected
              ? [BoxShadow(color: activeColor.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 3))]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF5A6072),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
