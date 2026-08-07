import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dev_mode_provider.dart';

class SelectReportTypePage extends ConsumerStatefulWidget {
  const SelectReportTypePage({super.key});

  @override
  ConsumerState<SelectReportTypePage> createState() => _SelectReportTypePageState();
}

class _SelectReportTypePageState extends ConsumerState<SelectReportTypePage> {
  int _tapCount = 0;
  Timer? _tapTimer;

  void _handleLogoTap() {
    _tapCount++;
    _tapTimer?.cancel();
    
    if (_tapCount >= 3) {
      _tapCount = 0;
      final isDev = ref.read(devModeProvider);
      ref.read(devModeProvider.notifier).state = !isDev;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(!isDev ? 'Modo Desenvolvedor Ativado!' : 'Modo Desenvolvedor Desativado!'),
          duration: const Duration(seconds: 2),
          backgroundColor: !isDev ? const Color(0xFF74BE45) : Colors.grey,
        ),
      );
    } else {
      _tapTimer = Timer(const Duration(milliseconds: 600), () {
        _tapCount = 0;
      });
    }
  }

  @override
  void dispose() {
    _tapTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF0B1120) : const Color(0xFFF5F7FA);
    final Color textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final Color subtitleColor = isDark ? Colors.white54 : const Color(0xFF4B5563);
    final Color borderColor = isDark ? Colors.white12 : Colors.black12;

    // Safety Banner colors
    final Color safetyBg = const Color(0xFF74BE45).withValues(alpha: isDark ? 0.08 : 0.12);
    final Color safetyBorder = const Color(0xFF74BE45).withValues(alpha: isDark ? 0.25 : 0.45);
    final Color safetyText = isDark ? const Color(0xFF74BE45) : const Color(0xFF1E5E1F);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _handleLogoTap,
                    child: SvgPicture.asset(
                      'assets/images/CMOC_bilingual_logo.svg',
                      height: 32,
                      colorFilter: ColorFilter.mode(
                        textColor, // branco no dark, azul escuro no light
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? Colors.white70 : const Color(0xFF4B5563),
                      side: BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    icon: const Icon(Icons.logout, size: 16, color: Colors.redAccent),
                    label: const Text('Sair', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Divider(color: borderColor, height: 1),

            // Content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        'Quem está registrando hoje?',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selecione a área correspondente ao seu diário de campo para continuar.',
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Grid
                      isMobile
                          ? Column(
                              children: _buildProfiles(context),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildProfiles(context)
                                  .map((card) => Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: card,
                                        ),
                                      ))
                                  .toList(),
                            ),
                      const SizedBox(height: 48),

                      // Safety Phrase/Slogan
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: safetyBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: safetyBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.gpp_good_rounded, color: safetyText, size: 20),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'SEGURANÇA EM PRIMEIRO LUGAR: Nenhum trabalho é tão urgente ou importante que não possa ser realizado com segurança.',
                                style: TextStyle(
                                  color: safetyText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: subtitleColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: borderColor),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/history');
                    },
                    icon: const Icon(Icons.dashboard_customize_rounded, size: 18),
                    label: const Text(
                      'Acessar Histórico Geral',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '| Dev by WP & EF',
                    style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProfiles(BuildContext context) {
    return [
      _ProfileCard(
        title: 'Equipagem',
        description: 'Manutenção e operação de maquinário pesado.',
        icon: Icons.engineering_rounded,
        gradientColors: const [Color(0xFF5C3FA3), Color(0xFF321474)], // Roxo CMOC
        shadowColor: const Color(0xFF5C3FA3).withValues(alpha: 0.3),
        onTap: () => Navigator.pushNamed(context, '/form'),
      ),
      const SizedBox(height: 24, width: 24),
      _ProfileCard(
        title: 'Elétrica da Mina',
        description: 'Subestações, fiação e infraestrutura elétrica.',
        icon: Icons.bolt_rounded,
        gradientColors: const [Color(0xFF23005B), Color(0xFF13003A)], // Azul CMOC
        shadowColor: const Color(0xFF23005B).withValues(alpha: 0.3),
        onTap: () => Navigator.pushNamed(context, '/form/electrical'),
      ),
      const SizedBox(height: 24, width: 24),
      _ProfileCard(
        title: 'Bombeamento',
        description: 'Sistemas de drenagem, tubulações e reservatórios.',
        icon: Icons.water_drop_rounded,
        gradientColors: const [Color(0xFF74BE45), Color(0xFF1E3A0E)], // Verde CMOC
        shadowColor: const Color(0xFF74BE45).withValues(alpha: 0.3),
        onTap: () => Navigator.pushNamed(context, '/form/pumping'),
      ),
    ];
  }
}

class _ProfileCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final Color shadowColor;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color cardBg = isDark ? const Color(0xFF111827) : Colors.white;
    final Color cardBorderColor = _isHovered 
        ? widget.gradientColors[0] 
        : (isDark ? Colors.white10 : Colors.black12);
    final Color cardTitleColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final Color cardDescColor = isDark ? Colors.white54 : const Color(0xFF4B5563);
    
    // Inactive button styles
    final Color buttonBg = _isHovered 
        ? widget.gradientColors[0] 
        : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05));
    final Color buttonBorder = _isHovered 
        ? Colors.transparent 
        : (isDark ? Colors.white12 : Colors.black12);
    final Color buttonText = _isHovered 
        ? Colors.white 
        : (isDark ? Colors.white70 : const Color(0xFF4B5563));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0.0, _isHovered ? -8.0 : 0.0, 0.0)
            ..multiply(Matrix4.diagonal3Values(_isHovered ? 1.03 : 1.0, _isHovered ? 1.03 : 1.0, 1.0)),
          constraints: const BoxConstraints(maxWidth: 320, minHeight: 280),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: cardBorderColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered 
                    ? widget.shadowColor 
                    : (isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.06)),
                blurRadius: _isHovered ? 24 : 12,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon Ring
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.gradientColors[1].withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),

              // Title & Desc
              Column(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: cardTitleColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(
                      color: cardDescColor,
                      fontSize: 12,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action button style
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: buttonBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: buttonBorder,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Iniciar Registro',
                    style: TextStyle(
                      color: buttonText,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
