import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dev_mode_provider.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/services/image_service.dart';
import 'package:image_picker/image_picker.dart';

class ElectricalReportFormPage extends ConsumerStatefulWidget {
  const ElectricalReportFormPage({super.key});

  @override
  ConsumerState<ElectricalReportFormPage> createState() => _ElectricalReportFormPageState();
}

class _ElectricalReportFormPageState extends ConsumerState<ElectricalReportFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // General Fields
  late String _id;
  late DateTime _date;
  String _shift = 'T1 (06:00 - 14:00)';
  String _team = 'Turma A';
  final _leaderController = TextEditingController();
  final _locationController = TextEditingController();
  final _observationsController = TextEditingController();

  // Safety checks
  bool _hasAPR = false;
  bool _hasLOTO = false;
  bool _gasMeasured = false;

  // Dynamic Lists
  final List<String> _members = [''];
  
  final List<Map<String, dynamic>> _activities = [
    {
      'description': '',
      'serviceType': 'Inspeção',
      'equipment': '',
      'location': '',
      'status': 'Pendente',
      'startTime': '',
      'endTime': ''
    }
  ];

  final List<Map<String, dynamic>> _materials = [];
  final List<Map<String, dynamic>> _photos = [];
  final Set<int> _uploadingPhotoIndexes = {};

  final List<String> _serviceTypes = [
    'Instalação',
    'Manutenção Preventiva',
    'Manutenção Corretiva',
    'Inspeção',
    'Comissionamento',
    'Descomissionamento',
    'Reparo Emergencial',
    'Troca de Componente',
  ];

  final List<String> _activityStatuses = ['Pendente', 'Em Andamento', 'Concluído'];

  @override
  void initState() {
    super.initState();
    _id = 'EL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    _date = DateTime.now();
  }

  @override
  void dispose() {
    _leaderController.dispose();
    _locationController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  void _addMember() => setState(() => _members.add(''));
  void _removeMember(int index) {
    if (_members.length > 1) {
      setState(() => _members.removeAt(index));
    }
  }

  void _addActivity() {
    setState(() {
      _activities.add({
        'description': '',
        'serviceType': 'Inspeção',
        'equipment': '',
        'location': '',
        'status': 'Pendente',
        'startTime': '',
        'endTime': ''
      });
    });
  }
  void _removeActivity(int index) {
    if (_activities.length > 1) {
      setState(() => _activities.removeAt(index));
    }
  }

  void _addMaterial() {
    setState(() {
      _materials.add({
        'item': '',
        'quantity': 1.0,
        'unit': 'unidade',
        'partNumber': ''
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
      _leaderController.text = 'Carlos Silva';
      _locationController.text = 'Subestação Principal';
      _observationsController.text = 'Teste automático de preenchimento.';
      _hasAPR = true;
      _hasLOTO = true;
      _gasMeasured = true;
      _members = ['José Almeida'];
      _activities = [
        {
          'description': 'Troca de disjuntor',
          'serviceType': 'Manutenção Preventiva',
          'equipment': 'Painel Elétrico 01',
          'location': 'Subestação Principal',
          'status': 'Concluído',
          'startTime': '08:00',
          'endTime': '10:00'
        }
      ];
      _materials = [
        {
          'item': 'Disjuntor Tripolar 100A',
          'quantity': 1.0,
          'unit': 'Unidade',
          'partNumber': 'DJ-100-3P'
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

    // Leader and location validation
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
        'observations': _observationsController.text.trim(),
        'members': _members.where((m) => m.trim().isNotEmpty).toList(),
        'safetyCheck': {
          'hasAPR': _hasAPR,
          'hasLOTO': _hasLOTO,
          'gasMeasured': _gasMeasured,
        },
        'activities': _activities.map((a) => {
          'description': a['description'].toString().trim(),
          'serviceType': a['serviceType'],
          'equipment': a['equipment'].toString().trim(),
          'location': a['location'].toString().trim(),
          'status': a['status'],
          'startTime': a['startTime'].toString().trim(),
          'endTime': a['endTime'].toString().trim(),
        }).toList(),
        'materialsUsed': _materials.map((m) => {
          'item': m['item'].toString().trim(),
          'quantity': double.tryParse(m['quantity'].toString()) ?? 1.0,
          'unit': m['unit'],
          'partNumber': m['partNumber'].toString().trim(),
        }).toList(),
        'photos': _photos.where((p) => p['url'].toString().isNotEmpty).map((p) => {
          'url': p['url'],
          'description': p['description'].toString().trim(),
          'timestamp': p['timestamp'],
        }).toList(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('electrical_reports')
          .doc(_id)
          .set(payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relatório de Elétrica enviado com sucesso!')),
        );
        Navigator.pushReplacementNamed(context, '/select-type');
      }
    } catch (e) {
      debugPrint('Firestore error: $e');
      if (mounted) {
        // Fallback alert
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro ao salvar no banco'),
            content: Text('Não foi possível conectar ao Firebase. Erro: $e'),
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
            const Icon(Icons.bolt_rounded, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Manutenção Elétrica',
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
                    // Card 1: Informacoes gerais
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IDENTIFICAÇÃO GERAL',
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
                            TextFormField(
                              controller: _leaderController,
                              decoration: const InputDecoration(labelText: 'Supervisor Líder *'),
                              validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 2: Segurança
                    Card(
                      color: Colors.blue.shade50.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.blue, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.shield_outlined, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  'SEGURANÇA OPERACIONAL (OBRIGATÓRIO)',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text('APR Assinada?'),
                              subtitle: const Text('Análise Preliminar de Risco validada'),
                              value: _hasAPR,
                              onChanged: (val) => setState(() => _hasAPR = val),
                            ),
                            SwitchListTile(
                              title: const Text('LOTO Executado?'),
                              subtitle: const Text('Lockout/Tagout eletromecânico'),
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

                    // Card 3: Executantes
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
                                  'EQUIPE DE EXECUTANTES',
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
                                            hintText: 'Nome do eletricista',
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

                    // Card 4: Atividades
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
                                    'ATIVIDADES DESENVOLVIDAS',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: headerColor),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _addActivity,
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Atividade'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _activities.length,
                              itemBuilder: (context, index) {
                                final act = _activities[index];
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
                                          Text('Atividade #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                          if (_activities.length > 1)
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                                              onPressed: () => _removeActivity(index),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        initialValue: act['description'],
                                        decoration: const InputDecoration(labelText: 'Descrição da Atividade *'),
                                        onChanged: (val) => act['description'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      DropdownButtonFormField<String>(
                                        initialValue: act['serviceType'],
                                        decoration: const InputDecoration(labelText: 'Tipo Serviço'),
                                        items: _serviceTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                                        onChanged: (val) => setState(() => act['serviceType'] = val!),
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        initialValue: act['equipment'],
                                        decoration: const InputDecoration(labelText: 'Equipamento *'),
                                        onChanged: (val) => act['equipment'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        initialValue: act['location'],
                                        decoration: const InputDecoration(labelText: 'Frente de Serviço *'),
                                        onChanged: (val) => act['location'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        initialValue: act['startTime'],
                                        decoration: const InputDecoration(labelText: 'Início (Ex: 08:30)'),
                                        onChanged: (val) => act['startTime'] = val,
                                      ),
                                      const SizedBox(height: 12),
                                      DropdownButtonFormField<String>(
                                        initialValue: act['status'],
                                        decoration: const InputDecoration(labelText: 'Status'),
                                        items: _activityStatuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                        onChanged: (val) => setState(() => act['status'] = val!),
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

                    // Card 5: Materiais
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
                                    'MATERIAIS UTILIZADOS',
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
                                                DropdownMenuItem(value: 'rolos', child: Text('rolos')),
                                              ],
                                              onChanged: (val) => setState(() => mat['unit'] = val!),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        initialValue: mat['partNumber'],
                                        decoration: const InputDecoration(labelText: 'PN (Opcional)'),
                                        onChanged: (val) => mat['partNumber'] = val,
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

                    // Card 6: Fotos
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
                              'OBSERVAÇÕES ADICIONAIS',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: headerColor),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _observationsController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText: 'Anotações gerais, pendências ou anomalias...',
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
                        'ENVIAR RELATÓRIO ELÉTRICA',
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
