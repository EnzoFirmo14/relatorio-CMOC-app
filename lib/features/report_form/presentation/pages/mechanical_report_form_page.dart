import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class MechanicalReportFormPage extends ConsumerStatefulWidget {
  const MechanicalReportFormPage({super.key});

  @override
  ConsumerState<MechanicalReportFormPage> createState() => _MechanicalReportFormPageState();
}

class _MechanicalReportFormPageState extends ConsumerState<MechanicalReportFormPage> {
  DateTime _selectedDate = DateTime.now();
  String _turno = 'T1'; // T1, T2, T3, ADM
  String _turma = 'A'; // A, B, C, D, ADM

  final List<Map<String, String>> _executantes = [
    {'nome': '', 'mat': ''}
  ];

  final List<Map<String, dynamic>> _ordensManutencao = [];
  final _observacoesCtrl = TextEditingController();

  static const List<Map<String, String>> pessoasMecanica = [
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
    {'nome': 'Saul Vinicius de Jesus Souza', 'mat': '4899'},
    {'nome': 'Venancio Araújo Queiroz', 'mat': '4800'},
    {'nome': 'William Pereira da Silva', 'mat': '4802'},
  ];

  static const List<String> locaisMecanica = [
    'Oficina Infra', 'HL', 'E22 - 01', 'E22 - 02', 'EW42 - 01', 'EW42 - 02',
    'EW48', 'EW51', 'E46', 'E57', 'C52 - 01', 'C52 - 02', 'C43', 'C34', 'C25',
    'B15', 'B09', 'E67 - 02', 'E67 - 01', 'E77', 'E102', 'ER4', 'BR2', 'ER1 -03',
    'ER1 - 02', 'ER2', 'EB MOVEL', 'RV2', 'RV5', 'RV6', 'RV10', 'E85', 'ER3', 'Outro'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _observacoesCtrl.dispose();
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
    String localOm = locaisMecanica.first;
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
                                items: locaisMecanica.map((l) => DropdownMenuItem(value: l, child: Text(l, overflow: TextOverflow.ellipsis))).toList(),
                                onChanged: (val) => setModalState(() => localOm = val ?? locaisMecanica.first),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '📌 Esta rota gerará múltiplas OMs automaticamente.',
                        style: TextStyle(color: Color(0xFF4A3FA8), fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A3FA8),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            if (rotaOm.isNotEmpty) {
                              _gerarRotaOMs(rotaOm);
                            } else {
                              _addOMManual(numOm, localOm);
                            }
                          },
                          child: const Text('Adicionar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _addOMManual(String numOm, String localOm) {
    setState(() {
      _ordensManutencao.add({
        'num': numOm,
        'local': localOm,
        'finalizada': false,
        'omNumCtrl': TextEditingController(text: numOm),
        'tagCtrl': TextEditingController(),
        'tipo': 'Corretiva', // Preventiva, Corretiva, Preditiva, Lubrificação, Outro
        'descCtrl': TextEditingController(),
        'startCtrl': TextEditingController(text: '07:30'),
        'endCtrl': TextEditingController(text: '11:30'),
        'vazamento': 'Não',
        'torque': 'Sim',
        'lubrificacao': 'Sim',
        'limpeza': 'Sim',
      });
    });
  }

  void _gerarRotaOMs(String rota) {
    List<String> locaisRota = rota == 'rota01'
        ? ['Oficina Infra', 'HL', 'E22 - 01', 'EW42 - 01']
        : ['C52 - 01', 'C43', 'B15', 'ER4'];

    setState(() {
      for (int i = 0; i < locaisRota.length; i++) {
        final numOm = 'OM-${(_ordensManutencao.length + 1).toString().padLeft(3, '0')}';
        _ordensManutencao.add({
          'num': numOm,
          'local': locaisRota[i],
          'finalizada': false,
          'omNumCtrl': TextEditingController(text: numOm),
          'tagCtrl': TextEditingController(text: '${locaisRota[i]}-ROTA'),
          'tipo': 'Preventiva',
          'descCtrl': TextEditingController(text: 'Inspeção de rotina mecânica realizada.'),
          'startCtrl': TextEditingController(text: '08:00'),
          'endCtrl': TextEditingController(text: '09:00'),
          'vazamento': 'Não',
          'torque': 'Sim',
          'lubrificacao': 'Sim',
          'limpeza': 'Sim',
        });
      }
    });
  }

  void _removeOM(int index) {
    setState(() {
      final om = _ordensManutencao.removeAt(index);
      (om['omNumCtrl'] as TextEditingController).dispose();
      (om['tagCtrl'] as TextEditingController).dispose();
      (om['descCtrl'] as TextEditingController).dispose();
      (om['startCtrl'] as TextEditingController).dispose();
      (om['endCtrl'] as TextEditingController).dispose();
    });
  }

  double _calcularHH(String start, String end, int numExecs) {
    try {
      final s = start.split(':').map(int.parse).toList();
      final e = end.split(':').map(int.parse).toList();
      double sMin = (s[0] * 60 + s[1]).toDouble();
      double eMin = (e[0] * 60 + e[1]).toDouble();
      if (eMin < sMin) eMin += 24 * 60;
      double hrs = (eMin - sMin) / 60.0;
      return hrs * (numExecs > 0 ? numExecs : 1);
    } catch (_) {
      return 0.0;
    }
  }

  String _formatDateBR(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }

  Future<void> _enviarWhatsApp() async {
    final dateStr = _formatDateBR(_selectedDate);
    final execsValid = _executantes.where((e) => e['nome']!.isNotEmpty).toList();

    String text = '⚙️ *RELATÓRIO DE MANUTENÇÃO MECÂNICA - CMOC*\n';
    text += '📅 *Data:* $dateStr\n';
    text += '⏱️ *Turno:* $_turno | *Turma:* $_turma\n\n';

    text += '👷 *EXECUTANTES (${execsValid.length}):*\n';
    for (var e in execsValid) {
      text += '• ${e['nome']} (Mat: ${e['mat']})\n';
    }
    text += '\n';

    text += '📑 *ORDENS DE MANUTENÇÃO (${_ordensManutencao.length}):*\n';
    for (int i = 0; i < _ordensManutencao.length; i++) {
      final om = _ordensManutencao[i];
      final tag = (om['tagCtrl'] as TextEditingController).text.trim();
      final desc = (om['descCtrl'] as TextEditingController).text.trim();
      final start = (om['startCtrl'] as TextEditingController).text.trim();
      final end = (om['endCtrl'] as TextEditingController).text.trim();
      final double hh = _calcularHH(start, end, execsValid.length);

      text += '\n*OM #${i + 1} [${om['num']}] - ${om['local']}*\n';
      text += '• TAG: $tag\n';
      text += '• Tipo: ${om['tipo']} | Status: ${om['finalizada'] ? 'Concluída' : 'Em Andamento'}\n';
      text += '• Horário: $start às $end (HH Total: ${hh.toStringAsFixed(1)}h)\n';
      text += '• Checklist: Vazamentos: ${om['vazamento']} | Torque: ${om['torque']} | Lubrificação: ${om['lubrificacao']} | 5S: ${om['limpeza']}\n';
      text += '• Atividade: $desc\n';
    }

    if (_observacoesCtrl.text.trim().isNotEmpty) {
      text += '\n📝 *OBSERVAÇÕES:*\n${_observacoesCtrl.text.trim()}\n';
    }

    final Uri url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color bgPage = Color(0xFFF0F0F4);
    const Color cardBg = Colors.white;
    const Color textColor = Color(0xFF18172A);
    const Color mutedColor = Color(0xFF6B6882);
    const Color accentPurple = Color(0xFF4A3FA8);
    const Color borderColor = Color(0xFFE0E0E8);

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: textColor,
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: Color(0xFF1A9E4A), shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text('CM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
            Text('OC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: accentPurple)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: const BoxDecoration(
                color: Color(0xFFEDE9FF),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text('⚙️ MECÂNICA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: accentPurple)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IDENTIFICAÇÃO
            _buildSectionLabel('IDENTIFICAÇÃO'),
            _buildCard(
              cardBg: cardBg,
              borderColor: borderColor,
              children: [
                _buildFieldLabel('📅 Data'),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7FA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDateBR(_selectedDate),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
                        ),
                        const Icon(Icons.calendar_month, color: accentPurple, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Executantes
                ..._executantes.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final exec = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7FA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('👷 EXECUTANTE ${idx + 1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: mutedColor)),
                            if (_executantes.length > 1)
                              InkWell(
                                onTap: () => setState(() => _executantes.removeAt(idx)),
                                child: const Icon(Icons.close, size: 16, color: Colors.redAccent),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        DropdownButtonFormField<String>(
                          initialValue: pessoasMecanica.any((p) => p['nome'] == exec['nome']) ? exec['nome'] : null,
                          decoration: InputDecoration(
                            hintText: '— Selecione —',
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          items: pessoasMecanica.map((p) {
                            return DropdownMenuItem(
                              value: p['nome'],
                              child: Text(p['nome']!, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) {
                            final match = pessoasMecanica.firstWhere((p) => p['nome'] == val);
                            setState(() {
                              exec['nome'] = match['nome']!;
                              exec['mat'] = match['mat']!;
                            });
                          },
                        ),
                        const SizedBox(height: 6),

                        Row(
                          children: [
                            const Text('🪪 MATRÍCULA: ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: mutedColor)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE9FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                exec['mat']!.isNotEmpty ? exec['mat']! : '—',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accentPurple),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: mutedColor,
                    minimumSize: const Size(double.infinity, 42),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => setState(() => _executantes.add({'nome': '', 'mat': ''})),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Adicionar executante', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // TURNO & TURMA
            _buildSectionLabel('TURNO & TURMA'),
            _buildCard(
              cardBg: cardBg,
              borderColor: borderColor,
              children: [
                _buildFieldLabel('⏱️ TURNO'),
                Wrap(
                  spacing: 6,
                  children: ['T1', 'T2', 'T3', 'ADM'].map((t) {
                    final isSel = _turno == t;
                    return ChoiceChip(
                      label: Text(t),
                      selected: isSel,
                      selectedColor: const Color(0xFFEDE9FF),
                      labelStyle: TextStyle(color: isSel ? accentPurple : mutedColor, fontWeight: FontWeight.bold),
                      onSelected: (_) => setState(() => _turno = t),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                _buildFieldLabel('👥 TURMA'),
                Wrap(
                  spacing: 6,
                  children: ['A', 'B', 'C', 'D', 'ADM'].map((t) {
                    final isSel = _turma == t;
                    return ChoiceChip(
                      label: Text(t),
                      selected: isSel,
                      selectedColor: const Color(0xFFE6F9EE),
                      labelStyle: TextStyle(color: isSel ? const Color(0xFF1A9E4A) : mutedColor, fontWeight: FontWeight.bold),
                      onSelected: (_) => setState(() => _turma = t),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ORDENS DE MANUTENÇÃO
            _buildSectionLabel('ORDENS DE MANUTENÇÃO'),
            if (_ordensManutencao.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, style: BorderStyle.solid),
                ),
                child: const Column(
                  children: [
                    Text('📭', style: TextStyle(fontSize: 28)),
                    SizedBox(height: 6),
                    Text('Nenhuma OM adicionada.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: mutedColor)),
                    Text('Toque em "+ Nova OM" para começar.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),

            ..._ordensManutencao.asMap().entries.map((entry) {
              final idx = entry.key;
              final om = entry.value;
              final bool isFin = om['finalizada'] == true;
              final start = (om['startCtrl'] as TextEditingController).text;
              final end = (om['endCtrl'] as TextEditingController).text;
              final double hh = _calcularHH(start, end, _executantes.where((e) => e['nome']!.isNotEmpty).length);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isFin ? const Color(0xFFF0FDF4) : cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isFin ? const Color(0xFF1A9E4A) : borderColor),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    // Header OM
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isFin ? const Color(0xFFE6F9EE) : const Color(0xFFEDE9FF),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                om['num'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isFin ? const Color(0xFF1A9E4A) : accentPurple,
                                  fontSize: 14,
                                ),
                              ),
                              Text(om['local'], style: const TextStyle(fontSize: 11, color: mutedColor)),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  foregroundColor: isFin ? const Color(0xFF1A9E4A) : accentPurple,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                onPressed: () => setState(() => om['finalizada'] = !isFin),
                                icon: Icon(isFin ? Icons.check_circle : Icons.radio_button_unchecked, size: 16),
                                label: Text(isFin ? 'Concluída' : 'Finalizar', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                                onPressed: () => _removeOM(idx),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('🏷️ TAG / EQUIPAMENTO'),
                          TextFormField(
                            controller: om['tagCtrl'] as TextEditingController,
                            decoration: InputDecoration(
                              hintText: 'Digite a TAG...',
                              isDense: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 10),

                          _buildFieldLabel('🛠️ TIPO DE MANUTENÇÃO'),
                          Wrap(
                            spacing: 6,
                            children: ['Preventiva', 'Corretiva', 'Preditiva', 'Lubrificação', 'Outro'].map((tipo) {
                              final isSel = om['tipo'] == tipo;
                              return ChoiceChip(
                                label: Text(tipo, style: const TextStyle(fontSize: 11)),
                                selected: isSel,
                                selectedColor: accentPurple,
                                labelStyle: TextStyle(color: isSel ? Colors.white : mutedColor, fontWeight: FontWeight.bold),
                                onSelected: (_) => setState(() => om['tipo'] = tipo),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),

                          _buildFieldLabel('📝 DESCRIÇÃO DA ATIVIDADE'),
                          TextFormField(
                            controller: om['descCtrl'] as TextEditingController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Descreva a intervenção efetuada...',
                              isDense: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: om['startCtrl'] as TextEditingController,
                                  decoration: InputDecoration(
                                    labelText: 'INÍCIO',
                                    isDense: true,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: om['endCtrl'] as TextEditingController,
                                  decoration: InputDecoration(
                                    labelText: 'FIM',
                                    isDense: true,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // HH Display
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7FA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('⏱️ Horas Homem (HH):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mutedColor)),
                                Text(
                                  '${hh.toStringAsFixed(1)} h',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: accentPurple),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          const Text('CHECKLIST MECÂNICO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: mutedColor)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _buildCheckChip('Sem Vazamentos', om['vazamento'], (v) => setState(() => om['vazamento'] = v)),
                              _buildCheckChip('Torque OK', om['torque'], (v) => setState(() => om['torque'] = v)),
                              _buildCheckChip('Lubrificação OK', om['lubrificacao'], (v) => setState(() => om['lubrificacao'] = v)),
                              _buildCheckChip('5S OK', om['limpeza'], (v) => setState(() => om['limpeza'] = v)),
                            ],
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
                backgroundColor: const Color(0xFFEDE9FF),
                foregroundColor: accentPurple,
                side: const BorderSide(color: accentPurple),
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _abrirModalNovaOM,
              icon: const Icon(Icons.add),
              label: const Text('Nova OM / Atividade', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 18),

            // OBSERVAÇÕES
            _buildSectionLabel('OBSERVAÇÕES / PENDÊNCIAS'),
            _buildCard(
              cardBg: cardBg,
              borderColor: borderColor,
              children: [
                TextFormField(
                  controller: _observacoesCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Registre observações gerais, pendências ou informações adicionais...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // BOTÃO WHATSAPP
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                onPressed: _enviarWhatsApp,
                icon: const Icon(Icons.send),
                label: const Text('Enviar pelo WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckChip(String label, String value, Function(String) onToggle) {
    final isOk = value == 'Sim';
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      selected: isOk,
      selectedColor: const Color(0xFFE6F9EE),
      checkmarkColor: const Color(0xFF1A9E4A),
      onSelected: (_) => onToggle(isOk ? 'Não' : 'Sim'),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF6B6882), letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildFieldLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6B6882)),
      ),
    );
  }

  Widget _buildCard({
    required Color cardBg,
    required Color borderColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
