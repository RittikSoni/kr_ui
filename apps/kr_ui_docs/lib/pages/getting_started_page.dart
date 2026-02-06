import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:kr_ui/kr_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../widgets/code_block.dart';

class GettingStartedPage extends StatelessWidget {
  const GettingStartedPage({super.key});

  static const String _pubDevUrl = 'https://pub.dev/packages/kr_ui';
  static const String _githubUrl = 'https://github.com/RittikSoni/kr_ui';
  static const String _youtubeUrl = 'https://www.youtube.com/@king_rittik';
  static const String _discordUrl = 'https://discord.gg/Tmn6BKwSnr';

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);
    final isMobile = AppTheme.isMobile(context);

    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          padding: EdgeInsets.all(isMobile ? 24 : 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Getting Started',
                  style: (isMobile ? AppTheme.h2 : AppTheme.h1)
                      .copyWith(color: dynamicTheme.textPrimary),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Install kr_ui and start building beautiful glassmorphic interfaces in minutes.',
                style: AppTheme.bodyLarge
                    .copyWith(color: dynamicTheme.textSecondary),
              ),
              const SizedBox(height: 48),

              // Step 1: Installation
              _StepHeader(
                  step: 1,
                  title: 'Add the dependency',
                  dynamicTheme: dynamicTheme),
              const SizedBox(height: 16),
              Text(
                'Add kr_ui to your project\'s pubspec.yaml:',
                style: AppTheme.bodyMedium
                    .copyWith(color: dynamicTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              const CodeBlock(
                code: '''dependencies:
  kr_ui: ^1.0.0''',
                language: 'yaml',
              ),
              const SizedBox(height: 16),
              Text(
                'Then install it:',
                style: AppTheme.bodyMedium
                    .copyWith(color: dynamicTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              const CodeBlock(code: 'flutter pub get', language: 'bash'),
              const SizedBox(height: 48),

              // Step 2: Import
              _StepHeader(
                  step: 2,
                  title: 'Import the package',
                  dynamicTheme: dynamicTheme),
              const SizedBox(height: 16),
              const CodeBlock(code: '''import 'package:kr_ui/kr_ui.dart';'''),
              const SizedBox(height: 48),

              // Step 3: Basic usage
              _StepHeader(
                  step: 3,
                  title: 'Use the components',
                  dynamicTheme: dynamicTheme),
              const SizedBox(height: 16),
              Text(
                'Create a glassmorphic card:',
                style: AppTheme.bodyMedium
                    .copyWith(color: dynamicTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              const CodeBlock(
                code: '''KruiGlassyCard(
  blur: 10,
  opacity: 0.15,
  child: Padding(
    padding: EdgeInsets.all(24),
    child: Text('Hello Glass!'),
  ),
)''',
              ),
              const SizedBox(height: 32),
              Text(
                'Add an interactive button:',
                style: AppTheme.bodyMedium
                    .copyWith(color: dynamicTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              const CodeBlock(
                code: '''KruiGlassyButton(
  onPressed: () => print('Tapped!'),
  blur: 12,
  opacity: 0.2,
  color: Colors.blue,
  child: Text('Click Me'),
)''',
              ),
              const SizedBox(height: 48),

              // Best practices
              Semantics(
                header: true,
                child: Text(
                  'Best practices',
                  style: AppTheme.h2.copyWith(color: dynamicTheme.textPrimary),
                ),
              ),
              const SizedBox(height: 16),
              _buildTip(
                context,
                dynamicTheme,
                icon: Icons.speed,
                text: 'Lower blur values (5–10) are more performant.',
              ),
              _buildTip(
                context,
                dynamicTheme,
                icon: Icons.palette_outlined,
                text: 'Use color tints to match your brand.',
              ),
              _buildTip(
                context,
                dynamicTheme,
                icon: Icons.smartphone,
                text: 'Test on real devices for the best glass effect.',
              ),
              _buildTip(
                context,
                dynamicTheme,
                icon: Icons.animation,
                text: 'Avoid animating blur frequently — it\'s expensive.',
              ),
              const SizedBox(height: 48),

              // Resources
              Semantics(
                header: true,
                child: Text(
                  'Resources',
                  style: AppTheme.h2.copyWith(color: dynamicTheme.textPrimary),
                ),
              ),
              const SizedBox(height: 16),
              _buildResourceLink(
                context,
                dynamicTheme,
                icon: FontAwesomeIcons.box,
                label: 'View on pub.dev',
                url: _pubDevUrl,
              ),
              _buildResourceLink(
                context,
                dynamicTheme,
                icon: FontAwesomeIcons.github,
                label: 'GitHub repository',
                url: _githubUrl,
              ),
              _buildResourceLink(
                context,
                dynamicTheme,
                icon: FontAwesomeIcons.youtube,
                label: 'YouTube tutorials',
                url: _youtubeUrl,
              ),
              _buildResourceLink(
                context,
                dynamicTheme,
                icon: FontAwesomeIcons.discord,
                label: 'Join Discord',
                url: _discordUrl,
              ),
              const SizedBox(height: 32),
              KruiGlassyButton(
                onPressed: () => context.go('/components'),
                blur: 10,
                opacity: 0.15,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Browse components',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.9),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip(
    BuildContext context,
    DynamicTheme dynamicTheme, {
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: dynamicTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style:
                  AppTheme.bodyMedium.copyWith(color: dynamicTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceLink(
    BuildContext context,
    DynamicTheme dynamicTheme, {
    required IconData icon,
    required String label,
    required String url,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _launch(url),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              FaIcon(icon, size: 20, color: dynamicTheme.primary),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  color: dynamicTheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: dynamicTheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.open_in_new, size: 16, color: dynamicTheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final int step;
  final String title;
  final DynamicTheme dynamicTheme;

  const _StepHeader({
    required this.step,
    required this.title,
    required this.dynamicTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: dynamicTheme.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border:
                Border.all(color: dynamicTheme.primary.withValues(alpha: 0.5)),
          ),
          alignment: Alignment.center,
          child: Text(
            '$step',
            style: AppTheme.label.copyWith(
              color: dynamicTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: AppTheme.h2.copyWith(color: dynamicTheme.textPrimary),
          ),
        ),
      ],
    );
  }
}
