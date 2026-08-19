import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/cmoc_logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          AppTheme.backgroundDark,
                          AppTheme.primaryBlue.withValues(alpha: 0.2),
                          AppTheme.backgroundDark,
                        ]
                      : [
                          AppTheme.backgroundLight,
                          AppTheme.primaryBlue.withValues(alpha: 0.05),
                          Colors.white,
                        ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glassmorphism Card
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withValues(alpha: isDark ? 0.2 : 0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CmocLogo(height: 60).animate().fade(duration: 500.ms).scale(),
                          const SizedBox(height: 40),
                          
                          Text(
                            'Bem-vindo ao InfraLog',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.w800,
                                ),
                            textAlign: TextAlign.center,
                          ).animate().fade(delay: 200.ms).slideY(begin: 0.2),
                          
                          const SizedBox(height: 12),
                          
                          Text(
                            'Acesso restrito para sistema de\nRelatórios Operacionais e Manutenção',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                            textAlign: TextAlign.center,
                          ).animate().fade(delay: 300.ms).slideY(begin: 0.2),
                          
                          const SizedBox(height: 48),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/select-type');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
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
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(Icons.arrow_forward_rounded, size: 20),
                                ],
                              ),
                            ),
                          ).animate().fade(delay: 500.ms).slideY(begin: 0.2),
                          
                          const SizedBox(height: 24),
                          
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified_user_outlined, size: 16, color: AppTheme.cmocGreen),
                              SizedBox(width: 8),
                              Text(
                                'Acesso Seguro CMOC',
                                style: TextStyle(
                                  color: AppTheme.cmocGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ).animate().fade(delay: 600.ms),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    const Text(
                      'InfraLog CMOC © 2026\nDesenvolvido por WP & EF',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textFaint,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ).animate().fade(delay: 700.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
