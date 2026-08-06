import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import 'section_label.dart';

class PumpingFormWidget extends StatefulWidget {
  const PumpingFormWidget({super.key});

  @override
  State<PumpingFormWidget> createState() => _PumpingFormWidgetState();
}

class _PumpingFormWidgetState extends State<PumpingFormWidget> {
  final _idController = TextEditingController(text: 'BM-005');
  final _dateController = TextEditingController(text: DateTime.now().toString().split(' ')[0]);
  String _shift = 'T1 (06:00 - 14:00)';
  final _leaderController = TextEditingController(text: 'Antônio Ribeiro');
  final _membersController = TextEditingController(text: 'José Carlos, Luiz Fernando');
  final _locationController = TextEditingController(text: 'C215');
  final _volumeController = TextEditingController(text: '1720');
  final _obsController = TextEditingController(text: 'Operação normal no período da manhã.');

  // Checklist de Segurança
  bool _hasAPR = true;
  bool _hasLOTO = true;
  bool _gasMeasured = true;

  // Lista de Bombas
  final List<Map<String, dynamic>> _pumps = [
    {
      'pumpId': 'BBA-03',
      'location': 'C180 - Nível 180',
      'flowRate': '0',
      'pressure': '0',
      'operatingHours': '560',
      'status': 'Manutenção',
      'downtimeReason': 'Falha Elétrica',
      'downtimeHours': '4.5',
      'observations': 'Troca de selo mecânico agendada',
    }
  ];

  // Lista de Níveis de Água
  final List<Map<String, String>> _waterLevels = [
    {
      'pointId': 'NA-C215-01',
      'location': 'Sump C215 Principal',
      'level': '2.3',
      'trend': 'Estável',
    }
  ];

  // Materiais Utilizados
  final List<Map<String, dynamic>> _materials = [
    {
      'item': 'Selo Mecânico 1.5"',
      'quantity': '1',
      'unit': 'peça',
    },
    {
      'item': 'Óleo lubrificante AW68',
      'quantity': '5',
      'unit': 'litros',
    }
  ];

  void _addPump() {
    setState(() {
      _pumps.add({
        'pumpId': 'BBA-0${_pumps.length + 1}',
        'location': _locationController.text,
        'flowRate': '120',
        'pressure': '4.5',
        'operatingHours': '100',
        'status': 'Operando',
        'downtimeReason': 'N/A',
        'downtimeHours': '0',
        'observations': '',
      });
    });
  }

  void _addWaterLevel() {
    setState(() {
      _waterLevels.add({
        'pointId': 'NA-0${_waterLevels.length + 1}',
        'location': _locationController.text,
        'level': '1.5',
        'trend': 'Estável',
      });
    });
  }

  void _addMaterial() {
    setState(() {
      _materials.add({
        'item': '',
        'quantity': '1',
        'unit': 'peça',
      });
    });
  }

  String _buildWhatsAppMessage() {
    final buffer = StringBuffer();
    buffer.writeln('💧 *RELATÓRIO BOMBEAMENTO MINA — CMOC*');
    buffer.writeln('📋 *ID:* ${_idController.text}');
    buffer.writeln('📅 *Data:* ${_dateController.text} | *Turno:* $_shift');
    buffer.writeln('👤 *Líder:* ${_leaderController.text}');
    buffer.writeln('👥 *Equipe:* ${_membersController.text}');
    buffer.writeln('📍 *Local:* ${_locationController.text}');
    buffer.writeln('🌊 *Volume Total M³:* ${_volumeController.text} m³');
    buffer.writeln();

    buffer.writeln('🛡️ *CHECKLIST DE SEGURANÇA:*');
    buffer.writeln('   • APR: ${_hasAPR ? "✅ Sim" : "❌ Não"} | LOTO: ${_hasLOTO ? "✅ Sim" : "❌ Não"} | Gás Medido: ${_gasMeasured ? "✅ Sim" : "❌ Não"}');
    buffer.writeln();

    buffer.writeln('⚙️ *STATUS DAS BOMBAS:*');
    for (final p in _pumps) {
      buffer.writeln('   • *${p['pumpId']}* (${p['location']}) - Status: *${p['status']}*');
      buffer.writeln('     Vazão: ${p['flowRate']} m³/h | Pressão: ${p['pressure']} bar | Horas Op: ${p['operatingHours']}h');
      if (p['status'] != 'Operando') {
        buffer.writeln('     ⚠️ Motivo Parada: ${p['downtimeReason']} (${p['downtimeHours']}h)');
      }
      if (p['observations'].isNotEmpty) {
        buffer.writeln('     Obs: ${p['observations']}');
      }
    }
    buffer.writeln();

    buffer.writeln('📏 *NÍVEIS DE ÁGUA:*');
    for (final w in _waterLevels) {
      buffer.writeln('   • *${w['pointId']}* (${w['location']}): ${w['level']}m (Tendência: *${w['trend']}*)');
    }
    buffer.writeln();

    if (_materials.isNotEmpty) {
      buffer.writeln('📦 *MATERIAIS UTILIZADOS:*');
      for (final m in _materials) {
        buffer.writeln('   • ${m['item']} - ${m['quantity']} ${m['unit']}');
      }
      buffer.writeln();
    }

    if (_obsController.text.isNotEmpty) {
      buffer.writeln('📝 *OBSERVAÇÕES:*');
      buffer.writeln(_obsController.text);
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // CABEÇALHO
        const SectionLabel(text: 'Informações Gerais — Bombeamento'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ID DO RELATÓRIO *', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _idController,
                            decoration: const InputDecoration(hintText: 'Ex: BM-005'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('DATA *', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _dateController,
                            decoration: const InputDecoration(hintText: 'YYYY-MM-DD'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('TURNO *', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  initialValue: _shift,
                  items: ['T1 (06:00 - 14:00)', 'T2 (14:00 - 22:00)', 'T3 (22:00 - 06:00)']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _shift = val ?? _shift),
                ),
                const SizedBox(height: 12),
                const Text('LÍDER DA EQUIPE *', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _leaderController,
                  decoration: const InputDecoration(hintText: 'Nome do líder'),
                ),
                const SizedBox(height: 12),
                const Text('INTEGRANTES *', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _membersController,
                  decoration: const InputDecoration(hintText: 'Separe por vírgulas'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('LOCALIZAÇÃO *', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(hintText: 'Ex: C215'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('VOLUME TOTAL (M³) *', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _volumeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: 'Ex: 1720'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // CHECKLIST DE SEGURANÇA
        const SizedBox(height: 16),
        const SectionLabel(text: 'Checklist de Segurança'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                CheckboxListTile(
                  title: const Text('APR Realizada (Análise Prévia de Risco)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  value: _hasAPR,
                  activeColor: AppTheme.cmocGreen,
                  onChanged: (v) => setState(() => _hasAPR = v ?? false),
                ),
                CheckboxListTile(
                  title: const Text('LOTO Aplicado (Bloqueio Elétrico/Mecânico)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  value: _hasLOTO,
                  activeColor: AppTheme.cmocGreen,
                  onChanged: (v) => setState(() => _hasLOTO = v ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Gás Medido na Área', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  value: _gasMeasured,
                  activeColor: AppTheme.cmocGreen,
                  onChanged: (v) => setState(() => _gasMeasured = v ?? false),
                ),
              ],
            ),
          ),
        ),

        // STATUS DAS BOMBAS
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionLabel(text: 'Gestão de Bombas'),
            ElevatedButton.icon(
              onPressed: _addPump,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Adicionar Bomba'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary(context),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        ..._pumps.asMap().entries.map((entry) {
          final idx = entry.key;
          final p = entry.value;
          final isOperating = p['status'] == 'Operando';
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '⚙️ Bomba #${idx + 1} (${p['pumpId']})',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accent(context)),
                      ),
                      if (_pumps.length > 1)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          onPressed: () => setState(() => _pumps.removeAt(idx)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: p['pumpId'],
                          decoration: const InputDecoration(labelText: 'ID da Bomba (BBA-03)'),
                          onChanged: (v) => p['pumpId'] = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: p['location'],
                          decoration: const InputDecoration(labelText: 'Localização'),
                          onChanged: (v) => p['location'] = v,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: p['status'],
                          items: ['Operando', 'Manutenção', 'Parada']
                              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) => setState(() => p['status'] = v ?? 'Operando'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: p['operatingHours'],
                          decoration: const InputDecoration(labelText: 'Horas Operação (h)'),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => p['operatingHours'] = v,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: p['flowRate'],
                          decoration: const InputDecoration(labelText: 'Vazão (m³/h)'),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => p['flowRate'] = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: p['pressure'],
                          decoration: const InputDecoration(labelText: 'Pressão (bar)'),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => p['pressure'] = v,
                        ),
                      ),
                    ],
                  ),
                  if (!isOperating) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: p['downtimeReason'],
                            decoration: const InputDecoration(labelText: 'Motivo da Parada'),
                            onChanged: (v) => p['downtimeReason'] = v,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: p['downtimeHours'],
                            decoration: const InputDecoration(labelText: 'Tempo Inativo (Horas)'),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => p['downtimeHours'] = v,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        }),

        // NÍVEIS DE ÁGUA
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionLabel(text: 'Níveis de Água (Sumps/Poços)'),
            OutlinedButton.icon(
              onPressed: _addWaterLevel,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Adicionar Nível'),
            ),
          ],
        ),
        ..._waterLevels.asMap().entries.map((entry) {
          final idx = entry.key;
          final w = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: w['pointId'],
                      decoration: const InputDecoration(labelText: 'Ponto (NA-C215-01)'),
                      onChanged: (v) => w['pointId'] = v,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: w['level'],
                      decoration: const InputDecoration(labelText: 'Nível (m)'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => w['level'] = v,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      initialValue: w['trend'],
                      items: ['Estável', 'Subindo', 'Baixando']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setState(() => w['trend'] = v ?? 'Estável'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    onPressed: () => setState(() => _waterLevels.removeAt(idx)),
                  ),
                ],
              ),
            ),
          );
        }),

        // MATERIAIS UTILIZADOS
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionLabel(text: 'Materiais Utilizados'),
            OutlinedButton.icon(
              onPressed: _addMaterial,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Adicionar Material'),
            ),
          ],
        ),
        ..._materials.asMap().entries.map((entry) {
          final idx = entry.key;
          final m = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: m['item'],
                      decoration: const InputDecoration(labelText: 'Item (Ex: Selo Mecânico 1.5")'),
                      onChanged: (v) => m['item'] = v,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      initialValue: m['quantity'].toString(),
                      decoration: const InputDecoration(labelText: 'Qtd'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => m['quantity'] = v,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: m['unit'],
                      decoration: const InputDecoration(labelText: 'Unid'),
                      onChanged: (v) => m['unit'] = v,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    onPressed: () => setState(() => _materials.removeAt(idx)),
                  ),
                ],
              ),
            ),
          );
        }),

        // OBSERVAÇÕES
        const SizedBox(height: 16),
        const SectionLabel(text: 'Observações'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: TextFormField(
              controller: _obsController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Digite observações do turno de Bombeamento...'),
            ),
          ),
        ),

        // BOTÃO WHATSAPP
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            final msg = _buildWhatsAppMessage();
            Clipboard.setData(ClipboardData(text: msg));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Relatório de Bombeamento copiado para a área de transferência!'),
                backgroundColor: AppTheme.cmocGreen,
              ),
            );
          },
          icon: const Icon(Icons.copy, color: Colors.white),
          label: const Text('COPIAR PARA WHATSAPP', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.cmocGreen,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
