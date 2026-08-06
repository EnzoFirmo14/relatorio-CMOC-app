import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import 'section_label.dart';

class ElectricalFormWidget extends StatefulWidget {
  const ElectricalFormWidget({super.key});

  @override
  State<ElectricalFormWidget> createState() => _ElectricalFormWidgetState();
}

class _ElectricalFormWidgetState extends State<ElectricalFormWidget> {
  final _idController = TextEditingController(text: 'EL-005');
  final _dateController = TextEditingController(text: DateTime.now().toString().split(' ')[0]);
  String _shift = 'T1 (06:00 - 14:00)';
  final _leaderController = TextEditingController(text: 'Carlos Eduardo Silva');
  final _membersController = TextEditingController(text: 'João Santos, Pedro Oliveira');
  final _locationController = TextEditingController(text: 'C23');
  final _obsController = TextEditingController(text: 'Faltou cabo 4x10mm² para terminar a instalação.');

  final List<Map<String, String>> _activities = [
    {
      'description': 'Troca de cabo de alimentação da bomba auxiliar',
      'serviceType': 'Manutenção Corretiva',
      'equipment': 'Bomba BA-12',
      'location': 'C23',
      'status': 'Concluído',
      'startTime': '07:30',
      'endTime': '10:15',
    }
  ];

  final List<Map<String, dynamic>> _materials = [
    {
      'item': 'Cabo flexível 4x10mm²',
      'quantity': '25',
      'unit': 'metros',
      'partNumber': 'CB-410-FLEX',
    }
  ];

  void _addActivity() {
    setState(() {
      _activities.add({
        'description': '',
        'serviceType': 'Manutenção Corretiva',
        'equipment': '',
        'location': _locationController.text,
        'status': 'Em Andamento',
        'startTime': '08:00',
        'endTime': '12:00',
      });
    });
  }

  void _addMaterial() {
    setState(() {
      _materials.add({
        'item': '',
        'quantity': '1',
        'unit': 'unidades',
        'partNumber': '',
      });
    });
  }

  String _buildWhatsAppMessage() {
    final buffer = StringBuffer();
    buffer.writeln('⚡ *RELATÓRIO ELÉTRICA DA MINA — CMOC*');
    buffer.writeln('📋 *ID:* ${_idController.text}');
    buffer.writeln('📅 *Data:* ${_dateController.text} | *Turno:* $_shift');
    buffer.writeln('👤 *Líder:* ${_leaderController.text}');
    buffer.writeln('👥 *Equipe:* ${_membersController.text}');
    buffer.writeln('📍 *Local:* ${_locationController.text}');
    buffer.writeln();

    buffer.writeln('🔧 *ATIVIDADES ELÉTRICAS:*');
    for (int i = 0; i < _activities.length; i++) {
      final act = _activities[i];
      buffer.writeln('   • *${act['serviceType']}* (${act['equipment']})');
      buffer.writeln('     _${act['description']}_');
      buffer.writeln('     ⏱️ ${act['startTime']} - ${act['endTime']} | Status: *${act['status']}*');
    }
    buffer.writeln();

    if (_materials.isNotEmpty) {
      buffer.writeln('📦 *MATERIAIS UTILIZADOS:*');
      for (final mat in _materials) {
        buffer.writeln('   • ${mat['item']} - ${mat['quantity']} ${mat['unit']} ${mat['partNumber'].isNotEmpty ? "(PN: ${mat['partNumber']})" : ""}');
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
        const SectionLabel(text: 'Informações Gerais — Elétrica'),
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
                            decoration: const InputDecoration(hintText: 'Ex: EL-005'),
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
                  decoration: const InputDecoration(hintText: 'Separe os nomes por vírgula'),
                ),
                const SizedBox(height: 12),
                const Text('LOCALIZAÇÃO PRINCIPAL *', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(hintText: 'Ex: C23'),
                ),
              ],
            ),
          ),
        ),

        // ATIVIDADES ELÉTRICAS
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionLabel(text: 'Atividades Elétricas'),
            ElevatedButton.icon(
              onPressed: _addActivity,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Adicionar Atividade'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary(context),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        ..._activities.asMap().entries.map((entry) {
          final idx = entry.key;
          final act = entry.value;
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
                        '⚡ Atividade #${idx + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accent(context)),
                      ),
                      if (_activities.length > 1)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          onPressed: () => setState(() => _activities.removeAt(idx)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: act['description'],
                    decoration: const InputDecoration(labelText: 'Descrição da atividade'),
                    onChanged: (v) => act['description'] = v,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: act['equipment'],
                          decoration: const InputDecoration(labelText: 'Equipamento (Ex: Bomba BA-12)'),
                          onChanged: (v) => act['equipment'] = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: act['serviceType'],
                          items: ['Manutenção Corretiva', 'Manutenção Preventiva', 'Instalação Elétrica', 'Inspeção']
                              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) => setState(() => act['serviceType'] = v ?? 'Manutenção Corretiva'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: act['startTime'],
                          decoration: const InputDecoration(labelText: 'Início (07:30)'),
                          onChanged: (v) => act['startTime'] = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: act['endTime'],
                          decoration: const InputDecoration(labelText: 'Fim (10:15)'),
                          onChanged: (v) => act['endTime'] = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: act['status'],
                          items: ['Concluído', 'Em Andamento', 'Pendente']
                              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) => setState(() => act['status'] = v ?? 'Concluído'),
                        ),
                      ),
                    ],
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
          final mat = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: mat['item'],
                      decoration: const InputDecoration(labelText: 'Item (Ex: Cabo 4x10mm²)'),
                      onChanged: (v) => mat['item'] = v,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      initialValue: mat['quantity'].toString(),
                      decoration: const InputDecoration(labelText: 'Qtd'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => mat['quantity'] = v,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: mat['unit'],
                      decoration: const InputDecoration(labelText: 'Unid'),
                      onChanged: (v) => mat['unit'] = v,
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
              decoration: const InputDecoration(hintText: 'Digite observações do turno de Elétrica...'),
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
                content: Text('Relatório de Elétrica copiado para a área de transferência!'),
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
