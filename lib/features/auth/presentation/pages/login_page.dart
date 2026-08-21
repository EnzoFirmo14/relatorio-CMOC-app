import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/cmoc_logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fallback
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fotografia de Fundo (100% da tela)
          Image.asset(
            'assets/images/image.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),

          // 2. Overlay Escuro Elegante para Contraste
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.5),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),

          // 3. Conteúdo da Tela
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  const Spacer(flex: 1), // Reduzido de 3 para 1 para empurrar o conteúdo para cima

                  // Logo CMOC (Forçando branco)
                  const CmocLogo(height: 60, color: Colors.white).animate().fade(duration: 500.ms).scale(),
                  const SizedBox(height: 32),

                  // Título Bicolor
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                      children: const [
                        TextSpan(text: 'Bem-vindo ao '),
                        TextSpan(
                          text: 'InfraLog',
                          style: TextStyle(color: Color(0xFFA78BFA)), // Roxo claro/lilás (Premium)
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 200.ms).slideY(begin: 0.1),

                  const SizedBox(height: 16),

                  // Descrição
                  Text(
                    'Acesso restrito para sistema de\nRelatórios Operacionais e Manutenção',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.5,
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  ).animate().fade(delay: 300.ms).slideY(begin: 0.1),

                  const SizedBox(height: 48),

                  // Botão de Login
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 340),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/select-type');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF23005B), // Azul Escuro CMOC Oficial
                          foregroundColor: Colors.white,
                          elevation: 12,
                          shadowColor: Colors.black.withValues(alpha: 0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Entrar no Sistema',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fade(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),

                  const Spacer(flex: 8), // Aumentado de 5 para 8 para jogar tudo para cima

                  // Rodapé e Segurança CMOC
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Segurança CMOC
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.gpp_good_outlined, size: 20, color: AppTheme.cmocGreen),
                          SizedBox(width: 8),
                          Text(
                            'Acesso Seguro CMOC',
                            style: TextStyle(
                              color: AppTheme.cmocGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ).animate().fade(delay: 500.ms),
                      
                      const SizedBox(height: 24),
                      
                      const Text(
                        'InfraLog CMOC © 2026',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Desenvolvido por WP & EF',
                        style: TextStyle(
                          color: const Color(0xFFA78BFA).withValues(alpha: 0.9), // Roxo combinando com o título
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ).animate().fade(delay: 600.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
