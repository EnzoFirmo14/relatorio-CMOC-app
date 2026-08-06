import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dev_mode_provider.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/services/image_service.dart';
import 'package:image_picker/image_picker.dart';

class PumpingReportFormPage extends ConsumerStatefulWidget {
  const PumpingReportFormPage({super.key});

  @override
  ConsumerState<PumpingReportFormPage> createState() => _PumpingReportFormPageState();
}

class _PumpingReportFormPageState extends ConsumerState<PumpingReportFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // General Parameters
  late String _id;
  late DateTime _date;
  String _shift = 'T1 (06:00 - 14:00)';
  String _team = 'Turma A';
  final _leaderController = TextEditingController();
  final _locationController = TextEditingController();
  final _volumeController = TextEditingController(text: '0');
  final _observationsController = TextEditingController();

  // Safety checks
  bool _hasAPR = false;
  bool _hasLOTO = false;
  bool _gasMeasured = false;

  // Dynamic Lists
  final List<String> _members = [''];
  
  final List<Map<String, dynamic>> _pumps = [
    {
      'pumpId': '',
      'location': '',
      'flowRate': '',
      'pressure': '',
      'operatingHours': '',
      'status': 'Operando',
      'downtimeReason': '',
      'downtimeHours': 0.0,
      'observations': ''
    }
  ];

  final List<Map<String, dynamic>> _waterLevels = [];
  final List<Map<String, dynamic>> _materials = [];
  final List<Map<String, dynamic>> _photos = [];
  final Set<int> _uploadingPhotoIndexes = {};

  final List<String> _pumpStatusOptions = ['Operando', 'Parada', 'Manutenção', 'Stand-by'];
  final List<String> _trendOptions = ['Subindo', 'Estável', 'Descendo'];

  @override
  void initState() {
    super.initState();
    _id = 'BOM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    _date = DateTime.now();
  }

  @override
  void dispose() {
    _leaderController.dispose();
    _locationController.dispose();
    _volumeController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  void _addMember() => setState(() => _members.add(''));
  void _removeMember(int index) {
    if (_members.length > 1) {
      setState(() => _members.removeAt(index));
    }
  }

  void _addPump() {
    setState(() {
      _pumps.add({
        'pumpId': '',
        'location': '',
        'flowRate': '',
        'pressure': '',
        'operatingHours': '',
        'status': 'Operando',
        'downtimeReason': '',
        'downtimeHours': 0.0,
        'observations': ''
      });
    });
  }
  void _removePump(int index) {
    if (_pumps.length > 1) {
      setState(() => _pumps.removeAt(index));
    }
  }

  void _addWaterLevel() {
    setState(() {
      _waterLevels.add({
        'pointId': '',
        'location': '',
        'level': '',
        'trend': 'Estável'
      });
    });
  }
  void _removeWaterLevel(int index) {
    setState(() => _waterLevels.removeAt(index));
  }

  void _addMaterial() {
    setState(() {
      _materials.add({
        'item': '',
        'quantity': 1.0,
        'unit': 'unidade'
      });
    });
  }
  void _removeMaterial(int index) {
    setState(() => _materials.removeAt(index));
  }

  void _addPhotoSlot() {
    setState(() {
      _photos.add({
        'url': '',
        'description': '',
        'timestamp': ''
      });
    });
  }
  void _removePhotoSlot(int index) {
    setState(() => _photos.removeAt(index));
  }

  Future<void> _takePhoto(int index) async {
    final pickedPath = await ImageService.pickAndCompressImage(ImageSource.camera);
    if (pickedPath == null) return;

    if (mounted) {
      setState(() => _uploadingPhotoIndexes.add(index));
    }

    try {
      final absolutePath = await ImageService.getAbsolutePath(pickedPath);
      final secureUrl = await CloudinaryService().uploadImage(absolutePath);
      
      final timeStr = DateTime.now().toIso8601String().substring(11, 16);

      if (mounted) {
        setState(() {
          _photos[index]['url'] = secureUrl;
          _photos[index]['timestamp'] = timeStr;
          _uploadingPhotoIndexes.remove(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto enviada com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _uploadingPhotoIndexes.remove(index));
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro de Upload'),
            content: Text('Não foi possível enviar a foto. Erro: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _fillMockData() {
    setState(() {
      _leaderController.text = 'João da Silva';
      _locationController.text = 'Mina Principal';
      _volumeController.text = '1500';
      _observationsController.text = 'Teste automático de preenchimento.';
      _hasAPR = true;
      _hasLOTO = true;
      _gasMeasured = true;
      _members = ['Carlos Souza'];
      _pumps = [
        {
          'pumpId': 'BOM-01',
          'location': 'Fundo da Cava',
          'flowRate': '150',
          'pressure': '5.0',
          'operatingHours': '8',
          'status': 'Operando',
          'downtimeReason': '',
          'downtimeHours': 0.0,
          'observations': 'Sem vazamentos'
        }
      ];
      _waterLevels = [
        {
          'pointId': 'Ponto A',
          'location': 'Cota 450',
          'level': '2.5',
          'trend': 'Estável',
        }
      ];
      _materials = [
        {
          'item': 'Óleo Lubrificante',
          'quantity': 2.0,
          'unit': 'Litros',
        }
      ];
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Safety checks validation
    if (!_hasAPR || !_hasLOTO || !_gasMeasured) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Segurança Bloqueada'),
            ],
          ),
          content: const Text(
            'Todos os itens de segurança operacional (APR, LOTO e Medição de Gases) devem ser atestados e marcados como concluídos antes de enviar o relatório.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }

    // Validate fields
    if (_leaderController.text.trim().isEmpty || _locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha os campos obrigatórios.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final payload = {
        'id': _id,
        'date': _date.toIso8601String().split('T')[0],
        'shift': _shift,
        'team': _team,
        'leader': _leaderController.text.trim(),
        'location': _locationController.text.trim(),
        'totalVolumeM3': double.tryParse(_volumeController.text) ?? 0.0,
        'observations': _observationsController.text.trim(),
        'members': _members.where((m) => m.trim().isNotEmpty).toList(),
        'safetyCheck': {
          'hasAPR': _hasAPR,
          'hasLOTO': _hasLOTO,
          'gasMeasured': _gasMeasured,
        },
        'pumps': _pumps.map((p) => {
          'pumpId': p['pumpId'].toString().trim(),
          'location': p['location'].toString().trim(),
          'flowRate': p['flowRate'].toString().trim(),
          'pressure': p['pressure'].toString().trim(),
          'operatingHours': p['operatingHours'].toString().trim(),
          'status': p['status'],
          'downtimeReason': p['downtimeReason'].toString().trim(),
          'downtimeHours': double.tryParse(p['downtimeHours'].toString()) ?? 0.0,
          'observations': p['observations'].toString().trim(),
        }).toList(),
        'waterLevels': _waterLevels.map((w) => {
          'pointId': w['pointId'].toString().trim(),
          'location': w['location'].toString().trim(),
          'level': w['level'].toString().trim(),
          'trend': w['trend'],
        }).toList(),
        'materialsUsed': _materials.map((m) => {
          'item': m['item'].toString().trim(),
          'quantity': double.tryParse(m['quantity'].toString()) ?? 1.0,
          'unit': m['unit'],
        }).toList(),
        'photos': _photos.where((p) => p['url'].toString().isNotEmpty).map((p) => {
          'url': p['url'],
          'description': p['description'].toString().trim(),
          'timestamp': p['timestamp'],
        }).toList(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('pumping_reports')
          .doc(_id)
          .set(payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relatório de Bombeamento enviado com sucesso!')),
        );
        Navigator.pushReplacementNamed(context, '/select-type');
      }
    } catch (e) {
      debugPrint('Firestore error: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro ao salvar no banco'),
            content: Text('Não foi possível salvar os dados no Firebase. Erro: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headerColor = isDark ? const Color(0xFFE8F1F8) : const Color(0xFF23005B);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.water_drop, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Bombeamento e Drenagem',
                style: theme.appBarTheme.titleTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/select-type'),
        ),
        actions: [
          if (ref.watch(devModeProvider))
            IconButton(
              icon: const Icon(Icons.bolt, color: Colors.amberAccent),
              tooltip: 'Preencher Automático (Testes)',
              onPressed: () {
                _fillMockData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Formulário preenchido com dados de teste!'), duration: Duration(seconds: 2)),
                );
              },
            ),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save_rounded),
              tooltip: 'Salvar Relatório',
              onPressed: _submit,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Card 1: Geral
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PARÂMETROS GERAIS',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: headerColor),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: _id,
                              decoration: const InputDecoration(labelText: 'ID do Relatório (Editável)'),
                              onChanged: (val) => _id = val,
                            ),
                            const SizedBox(height: 12),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('DATA DO RELATÓRIO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              subtitle: Text('${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}', style: const TextStyle(fontSize: 16)),
                              trailing: const Icon(Icons.calendar_month),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _date,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (picked != null) {
                                  setState(() => _date = picked);
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _shift,
                                    decoration: const InputDecoration(labelText: 'Turno *'),
                                    items: const [
                                      DropdownMenuItem(value: 'T1 (06:00 - 14:00)', child: Text('T1')),
                                      DropdownMenuItem(value: 'T2 (14:00 - 22:00)', child: Text('T2')),
                                      DropdownMenuItem(value: 'T3 (22:00 - 06:00)', child: Text('T3')),
                                    ],
                                    onChanged: (val) => setState(() => _shift = val!),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _team,
                                    decoration: const InputDecoration(labelText: 'Turma *'),
                                    items: const [
                                      DropdownMenuItem(value: 'Turma A', child: Text('Turma A')),
                                      DropdownMenuItem(value: 'Turma B', child: Text('Turma B')),
                                      DropdownMenuItem(value: 'Turma C', child: Text('Turma C')),
                                      DropdownMenuItem(value: 'Turma D', child: Text('Turma D')),
                                      DropdownMenuItem(value: 'Turma ADM', child: Text('Turma ADM')),
                                    ],
                                    onChanged: (val) => setState(() => _team = val!),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _locationController,
                              decoration: const InputDecoration(labelText: 'Localização Geral *'),
                              validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _leaderController,
                                    decoration: const InputDecoration(labelText: 'Líder da Equipe *'),
                                    validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _volumeController,
                                    decoration: const InputDecoration(labelText: 'Volume Drenado Total (m³)'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 2: Segurança
                    Card(
                      color: Colors.amber.shade50.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.amber, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.shield_outlined, color: Colors.amber),
                                const SizedBox(width: 8),
                                Text(
                                  'SEGURANÇA OPERACIONAL (OBRIGATÓRIO)',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isDark ? const Color(0xFF74BE45) : Colors.amber),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text('APR Assinada?'),
                              subtitle: const Text('Análise de risco de drenagem concluída'),
                              value: _hasAPR,
                              onChanged: (val) => setState(() => _hasAPR = val),
                            ),
                            SwitchListTile(
                              title: const Text('LOTO Executado?'),
                              subtitle: const Text('Bloqueio elétrico/hidráulico de bombas'),
                              value: _hasLOTO,
                              onChanged: (val) => setState(() => _hasLOTO = val),
                            ),
                            SwitchListTile(
                              title: const Text('Gases Medidos?'),
                              subtitle: const Text('Atmosfera segura verificada'),
                              value: _gasMeasured,
                              onChanged: (val) => setState(() => _gasMeasured = val),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 3: Equipe
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'MEMBROS DA EQUIPE',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: headerColor),
                                ),
                                TextButton.icon(
                                  onPressed: _addMember,
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Membro'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _members.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: _members[index],
                                          decoration: InputDecoration(
                                            labelText: 'Nome do Membro ${index + 1}',
                                            hintText: 'Operador de bombeamento',
                                          ),
                                          onChanged: (val) => _members[index] = val,
                                        ),
                                      ),
                                      if (_members.length > 1)
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _removeMember(index),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 4: Bombas
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'TELEMETRIA DAS BOMBAS',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: headerColor),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _addPump,
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Bomba'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _pumps.length,
                              itemBuilder: (context, index) {
                                final pump = _pumps[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.05),
                                    border: Border.all(color: Colors.white10),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Bomba #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                          if (_pumps.length > 1)
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                                              onPressed: () => _removePump(index),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        initialValue: pump['pumpId'],
                                        decoration: const InputDecoration(labelText: 'Tag/ID Bomba *'),
                                        onChanged: (val) => pump['pumpId'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        initialValue: pump['location'],
                                        decoration: const InputDecoration(labelText: 'Localização Específica *'),
                                        onChanged: (val) => pump['location'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      DropdownButtonFormField<String>(
                                        initialValue: pump['status'],
                                        decoration: const InputDecoration(labelText: 'Status'),
                                        items: _pumpStatusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                        onChanged: (val) => setState(() => pump['status'] = val!),
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        initialValue: pump['flowRate'],
                                        decoration: const InputDecoration(labelText: 'Vazão (m³/h) *'),
                                        onChanged: (val) => pump['flowRate'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        initialValue: pump['pressure'],
                                        decoration: const InputDecoration(labelText: 'Pressão (bar) *'),
                                        onChanged: (val) => pump['pressure'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        initialValue: pump['operatingHours'],
                                        decoration: const InputDecoration(labelText: 'Horas Operadas *'),
                                        onChanged: (val) => pump['operatingHours'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        initialValue: pump['downtimeReason'],
                                        decoration: const InputDecoration(labelText: 'Motivo Parada (Se houver)'),
                                        onChanged: (val) => pump['downtimeReason'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        initialValue: pump['downtimeHours'].toString(),
                                        decoration: const InputDecoration(labelText: 'Horas Paradas'),
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) => pump['downtimeHours'] = double.tryParse(val) ?? 0.0,
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        initialValue: pump['observations'],
                                        decoration: const InputDecoration(labelText: 'Observações da Bomba'),
                                        onChanged: (val) => pump['observations'] = val,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 5: Níveis de Água
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'NÍVEIS DOS RESERVATÓRIOS',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: headerColor),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _addWaterLevel,
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Ponto Nível'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _waterLevels.length,
                              itemBuilder: (context, index) {
                                final water = _waterLevels[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white10),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Ponto Reservatório #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => _removeWaterLevel(index),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        initialValue: water['pointId'],
                                        decoration: const InputDecoration(labelText: 'Reservatório/Ponto *'),
                                        onChanged: (val) => water['pointId'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        initialValue: water['location'],
                                        decoration: const InputDecoration(labelText: 'Localização *'),
                                        onChanged: (val) => water['location'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        initialValue: water['level'],
                                        decoration: const InputDecoration(labelText: 'Nível (m) *'),
                                        onChanged: (val) => water['level'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      DropdownButtonFormField<String>(
                                        initialValue: water['trend'],
                                        decoration: const InputDecoration(labelText: 'Tendência'),
                                        items: _trendOptions.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                                        onChanged: (val) => setState(() => water['trend'] = val!),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 6: Materiais
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'MATERIAIS E ACESSÓRIOS UTILIZADOS',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: headerColor),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _addMaterial,
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Material'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _materials.length,
                              itemBuilder: (context, index) {
                                final mat = _materials[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white10),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              initialValue: mat['item'],
                                              decoration: const InputDecoration(labelText: 'Material/Item *'),
                                              onChanged: (val) => mat['item'] = val,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => _removeMaterial(index),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              initialValue: mat['quantity'].toString(),
                                              decoration: const InputDecoration(labelText: 'Qtd.'),
                                              keyboardType: TextInputType.number,
                                              onChanged: (val) => mat['quantity'] = double.tryParse(val) ?? 1.0,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: DropdownButtonFormField<String>(
                                              initialValue: mat['unit'],
                                              decoration: const InputDecoration(labelText: 'Unidade'),
                                              items: const [
                                                DropdownMenuItem(value: 'unidade', child: Text('unidade')),
                                                DropdownMenuItem(value: 'metros', child: Text('metros')),
                                                DropdownMenuItem(value: 'pecas', child: Text('peças')),
                                              ],
                                              onChanged: (val) => setState(() => mat['unit'] = val!),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 7: Fotos
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'EVIDÊNCIAS FOTOGRÁFICAS',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: headerColor),
                                ),
                                TextButton.icon(
                                  onPressed: _addPhotoSlot,
                                  icon: const Icon(Icons.add_a_photo, size: 16),
                                  label: const Text('Foto'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.85,
                              ),
                              itemCount: _photos.length,
                              itemBuilder: (context, index) {
                                final photo = _photos[index];
                                final isUploading = _uploadingPhotoIndexes.contains(index);
                                final hasImage = photo['url'].toString().isNotEmpty;

                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.03),
                                    border: Border.all(color: Colors.white10),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Foto #${index + 1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red, size: 16),
                                            onPressed: () => _removePhotoSlot(index),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            color: Colors.black12,
                                            width: double.infinity,
                                            child: isUploading
                                                ? const Center(child: CircularProgressIndicator())
                                                : hasImage
                                                    ? Image.network(photo['url'], fit: BoxFit.cover)
                                                    : Center(
                                                        child: TextButton(
                                                          onPressed: () => _takePhoto(index),
                                                          child: const Text('Tirar Foto', style: TextStyle(fontSize: 11)),
                                                        ),
                                                      ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      TextFormField(
                                        initialValue: photo['description'],
                                        decoration: const InputDecoration(hintText: 'Descrição da foto', isDense: true),
                                        style: const TextStyle(fontSize: 11),
                                        onChanged: (val) => photo['description'] = val,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Observations
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'OBSERVAÇÕES OPERACIONAIS',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: headerColor),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _observationsController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText: 'Anotações gerais, pendências de drenagem...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF23005B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submit,
                      child: const Text(
                        'ENVIAR RELATÓRIO BOMBEAMENTO',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        '| Dev by WP & EF',
                        style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
