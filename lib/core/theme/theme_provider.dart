import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provedor global do Tema (Claro / Escuro CMOC)
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
