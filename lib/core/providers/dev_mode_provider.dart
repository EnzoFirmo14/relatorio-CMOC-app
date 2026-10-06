import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provedor global para habilitar funcionalidades de Desenvolvedor (ex: preenchimento automático)
final devModeProvider = StateProvider<bool>((ref) => false);
