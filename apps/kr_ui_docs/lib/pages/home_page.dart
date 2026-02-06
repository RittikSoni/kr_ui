import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kr_ui/kr_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../widgets/code_block.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String _pubDevUrl = 'https://pub.dev/packages/kr_ui';
  static const String _githubUrl = 'https://github.com/RittikSoni/kr_ui';

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);
    final isMobile = AppTheme.isMobile(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero
          Semantics(
            header: true,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: EdgeInsets.all(isMobile ? 24 : 80),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: dynamicTheme.gradientColors,
                    ).createShader(bounds),
                    child: Text(
                      'Premium Glassmorphic\nUI Components',
                      textAlign: TextAlign.center,
                      style: (isMobile
                              ? AppTheme.displayMedium
                              : AppTheme.displayLarge)
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Beautiful, customizable iOS-style glass effects.\nPure Flutter. Zero dependencies.',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyLarge
                        .copyWith(color: dynamicTheme.textSecondary),
                  ),
                  const SizedBox(height: 48),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      KruiGlassyButton(
                        onPressed: () => _launch(_pubDevUrl),
                        blur: 12,
                        opacity: 0.2,
                        color: dynamicTheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.download,
                                color: dynamicTheme.textPrimary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Install from pub.dev',
                              style: TextStyle(
                                color: dynamicTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      KruiGlassyButton(
                        onPressed: () => _launch(_githubUrl),
                        blur: 8,
                        opacity: 0.12,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(FontAwesomeIcons.github,
                                size: 20, color: dynamicTheme.textPrimary),
                            const SizedBox(width: 8),
                            Text(
                              'View on GitHub',
                              style: TextStyle(
                                color: dynamicTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      KruiGlassyButton(
                        onPressed: () => context.go('/getting-started'),
                        blur: 8,
                        opacity: 0.12,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.rocket_launch_outlined,
                                size: 20, color: dynamicTheme.textPrimary),
                            const SizedBox(width: 8),
                            Text(
                              'Getting Started',
                              style: TextStyle(
                                color: dynamicTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                  Semantics(
                    header: true,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Quick Start',
                        style: AppTheme.h3
                            .copyWith(color: dynamicTheme.textPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: const CodeBlock(
                      code: '''import 'package:kr_ui/kr_ui.dart';

KruiGlassyCard(
  blur: 15,
  opacity: 0.2,
  child: Text('Beautiful Glassmorphism!'),
)''',
                    ),
                  ),
                  const SizedBox(height: 80),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 900),
                    height: isMobile ? 400 : 600,
                    decoration: BoxDecoration(
                      borderRadius: AppTheme.borderRadiusXLarge,
                      color: dynamicTheme.surfaceGray,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?q=80&w=2000',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: dynamicTheme.surfaceGray,
                              child: Center(
                                child: Icon(Icons.image_not_supported_outlined,
                                    size: 48, color: dynamicTheme.textTertiary),
                              ),
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: KruiGlassyCard(
                              blur: 20,
                              opacity: 0.2,
                              padding: const EdgeInsets.all(48),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.auto_awesome,
                                      size: 64, color: Colors.white),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Glassmorphism',
                                    style: AppTheme.h2
                                        .copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Beautiful frosted glass effects\nwith full customization',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.bodyLarge.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
          // Features
          Semantics(
            header: true,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: EdgeInsets.all(isMobile ? 24 : 40),
              child: Column(
                children: [
                  Text(
                    'Why kr_ui?',
                    style:
                        AppTheme.h1.copyWith(color: dynamicTheme.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Production-ready components for modern Flutter apps.',
                    style: AppTheme.bodyLarge
                        .copyWith(color: dynamicTheme.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildFeatureCard(
                        dynamicTheme,
                        icon: FontAwesomeIcons.flutter,
                        title: 'Pure Flutter',
                        description:
                            'Zero external dependencies. Just Flutter SDK.',
                        useFaIcon: true,
                      ),
                      _buildFeatureCard(
                        dynamicTheme,
                        icon: Icons.tune,
                        title: 'Fully Customizable',
                        description:
                            'Blur, opacity, colors, borders — control every detail.',
                      ),
                      _buildFeatureCard(
                        dynamicTheme,
                        icon: Icons.speed,
                        title: 'Optimized',
                        description:
                            'Efficient rendering with smooth 60fps animations.',
                      ),
                      _buildFeatureCard(
                        dynamicTheme,
                        icon: Icons.phone_iphone,
                        title: 'iOS-Style',
                        description:
                            'Premium glassmorphic design inspired by iOS.',
                      ),
                      _buildFeatureCard(
                        dynamicTheme,
                        icon: FontAwesomeIcons.code,
                        title: 'Easy to Use',
                        description:
                            'Clean API with sensible defaults and presets.',
                        useFaIcon: true,
                      ),
                      _buildFeatureCard(
                        dynamicTheme,
                        icon: FontAwesomeIcons.shieldHalved,
                        title: 'Production Ready',
                        description:
                            'Battle-tested components for real applications.',
                        useFaIcon: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    DynamicTheme dynamicTheme, {
    required IconData icon,
    required String title,
    required String description,
    bool useFaIcon = false,
  }) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: dynamicTheme.surfaceCard,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: dynamicTheme.borderLight),
        boxShadow:
            dynamicTheme.provider.isDarkMode ? null : AppTheme.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: dynamicTheme.primary.withValues(alpha: 0.1),
              borderRadius: AppTheme.borderRadiusMedium,
            ),
            child: useFaIcon
                ? FaIcon(icon, color: dynamicTheme.primary, size: 28)
                : Icon(icon, color: dynamicTheme.primary, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTheme.h4.copyWith(color: dynamicTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style:
                AppTheme.bodyMedium.copyWith(color: dynamicTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
