import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kr_ui_docs/constants/kassets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Theme and Config
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'navigation/router.dart';

// Widgets
import 'widgets/search_bar.dart';
import 'widgets/theme_selector.dart';
import 'config/component_registry.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  // Pre-cache primary assets for "instant" feel
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // We could pre-cache specific images here if they were local assets
    // For network images, the browser/framework handles most caching,
    // but we can warm up the image cache if needed.
  });

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const KRUIShowcaseApp(),
    ),
  );
}

class KRUIShowcaseApp extends StatelessWidget {
  const KRUIShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);

    return MaterialApp.router(
      title: 'kr_ui - Premium Glassmorphic UI Components',
      debugShowCheckedModeBanner: false,
      theme: dynamicTheme.themeData,
      routerConfig: AppRouter.router,
    );
  }
}

class ShowcaseHomePage extends StatefulWidget {
  final Widget child;

  const ShowcaseHomePage({
    super.key,
    required this.child,
  });

  @override
  State<ShowcaseHomePage> createState() => _ShowcaseHomePageState();
}

class _ShowcaseHomePageState extends State<ShowcaseHomePage> {
  late final FocusNode _focusNode;
  bool _isComponentsExpanded = true;
  final Map<String, bool> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);
    final isMobile = AppTheme.isMobile(context);
    final currentPath = GoRouterState.of(context).uri.path;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        final isMetaPressed = HardwareKeyboard.instance.isMetaPressed ||
            HardwareKeyboard.instance.isControlPressed;
        if (isMetaPressed && event.logicalKey == LogicalKeyboardKey.keyK) {
          if (event is KeyDownEvent) {
            SearchOverlay.show(context, (component) {
              context.go('/components/${component.id}');
            });
          }
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                title: isMobile
                    ? Row(
                        children: [
                          Image.asset(
                            Kassets.onlyLogo,
                            height: 24,
                            filterQuality: FilterQuality.medium,
                          ),
                          const SizedBox(width: 8),
                          Text('kr_ui',
                              style: AppTheme.h3
                                  .copyWith(color: dynamicTheme.textPrimary)),
                        ],
                      )
                    : _buildDesktopHeader(context, dynamicTheme),
                backgroundColor: dynamicTheme.surface.withValues(alpha: 0.7),
                elevation: 0,
                centerTitle: false,
                actions: [
                  if (isMobile)
                    SearchTrigger(onComponentSelected: (component) {
                      context.go('/components/${component.id}');
                    }),
                  const ThemeSelector(isCompact: true),
                  const SizedBox(width: 16),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    height: 1,
                    color: dynamicTheme.borderLight.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Row(
          children: [
            // Sidebar (desktop only)
            if (!isMobile)
              Container(
                width: 280,
                decoration: BoxDecoration(
                  color: dynamicTheme.surface,
                  border: Border(
                    right: BorderSide(
                      color: dynamicTheme.borderLight,
                      width: 1,
                    ),
                  ),
                ),
                child: _buildSidebar(context, dynamicTheme, currentPath),
              ),

            // Main content
            Expanded(
              child: widget.child,
            ),
          ],
        ),
        bottomNavigationBar: isMobile
            ? NavigationBar(
                selectedIndex: _getSelectedIndex(currentPath),
                onDestinationSelected: (index) {
                  final routes = ['/', '/components', '/getting-started'];
                  context.go(routes[index]);
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.widgets_outlined),
                    selectedIcon: Icon(Icons.widgets),
                    label: 'Components',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.code_outlined),
                    selectedIcon: Icon(Icons.code),
                    label: 'Docs',
                  ),
                ],
              )
            : null,
      ),
    );
  }

  int _getSelectedIndex(String path) {
    if (path == '/') return 0;
    if (path.startsWith('/components')) return 1;
    if (path.startsWith('/getting-started')) return 2;
    return 0;
  }

  Widget _buildDesktopHeader(BuildContext context, DynamicTheme dynamicTheme) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.go('/'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Kassets.onlyLogo,
                height: 28,
                filterQuality: FilterQuality.medium,
              ),
              const SizedBox(width: 12),
              Text('kr_ui',
                  style: AppTheme.h3.copyWith(color: dynamicTheme.textPrimary)),
            ],
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SearchTrigger(
              onComponentSelected: (component) {
                context.go('/components/${component.id}');
              },
            ),
          ),
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.github, size: 20),
          color: dynamicTheme.textSecondary,
          tooltip: 'GitHub',
          onPressed: () => _launchURL('https://github.com/RittikSoni/kr_ui'),
        ),
        IconButton(
          icon:
              Icon(Icons.bug_report_rounded, color: dynamicTheme.textSecondary),
          tooltip: 'Report Issue',
          onPressed: () =>
              _launchURL('https://github.com/RittikSoni/kr_ui/issues'),
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.discord, size: 20),
          color: dynamicTheme.textSecondary,
          tooltip: 'Discord',
          onPressed: () => _launchURL('https://discord.gg/Tmn6BKwSnr'),
        ),
      ],
    );
  }

  Widget _buildSidebar(
      BuildContext context, DynamicTheme dynamicTheme, String currentPath) {
    // Group components by category
    final categories =
        ComponentRegistry.categories.where((c) => c != 'All').toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Author Profile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () =>
                  _launchURL('https://www.linkedin.com/in/rittik-soni/'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: dynamicTheme.borderLight,
                          width: 2,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://avatars.githubusercontent.com/u/42760562?v=4'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rittik Soni',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: dynamicTheme.textPrimary,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Author & Maintainer',
                              style: AppTheme.caption.copyWith(
                                color: dynamicTheme.textTertiary,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_outward_rounded,
                              size: 10,
                              color: dynamicTheme.textTertiary,
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Sponsor Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.withValues(alpha: 0.1),
                  Colors.purple.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.pink.withValues(alpha: 0.2),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () =>
                    _launchURL('https://github.com/sponsors/RittikSoni'),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.pink.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite,
                            color: Colors.pink, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sponsor Project',
                              style: AppTheme.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: dynamicTheme.textPrimary,
                              ),
                            ),
                            Text(
                              'Support development',
                              style: AppTheme.caption.copyWith(
                                color: dynamicTheme.textTertiary,
                                fontSize: 10,
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
          ),

          const SizedBox(height: 24),

          _buildNavItem(
            context,
            dynamicTheme,
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Home',
            path: '/',
            isSelected: currentPath == '/',
          ),
          _buildNavItem(
            context,
            dynamicTheme,
            icon: Icons.code_outlined,
            selectedIcon: Icons.code,
            label: 'Getting Started',
            path: '/getting-started',
            isSelected: currentPath.startsWith('/getting-started'),
          ),

          const SizedBox(height: 32),

          InkWell(
            onTap: () {
              setState(() {
                _isComponentsExpanded = !_isComponentsExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'COMPONENTS',
                    style: AppTheme.label.copyWith(
                      color: dynamicTheme.textTertiary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: _isComponentsExpanded ? 0 : -0.25,
                    child: Icon(
                      Icons.expand_more,
                      size: 16,
                      color: dynamicTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: categories.map((category) {
                final categoryComponents =
                    ComponentRegistry.getByCategory(category);

                // Ensure category has an initial expansion state (default true)
                if (!_expandedCategories.containsKey(category)) {
                  _expandedCategories[category] = true;
                }

                final isExpanded = _expandedCategories[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _expandedCategories[category] = !isExpanded;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                        child: Row(
                          children: [
                            Text(
                              category.toUpperCase(),
                              style: AppTheme.caption.copyWith(
                                color: dynamicTheme.textTertiary
                                    .withValues(alpha: 0.7),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Spacer(),
                            AnimatedRotation(
                              duration: const Duration(milliseconds: 200),
                              turns: isExpanded ? 0 : -0.25,
                              child: Icon(
                                Icons.expand_more,
                                size: 14,
                                color: dynamicTheme.textTertiary
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox(width: double.infinity),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(left: 12), // Indent
                        child: Column(
                          children: categoryComponents.map((component) {
                            final path = '/components/${component.id}';
                            final isSelected = currentPath == path;
                            return _buildSubNavItem(
                              context,
                              dynamicTheme,
                              icon: component.icon,
                              label: component.displayName,
                              path: path,
                              isSelected: isSelected,
                            );
                          }).toList(),
                        ),
                      ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ],
                );
              }).toList(),
            ),
            crossFadeState: _isComponentsExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),

          const SizedBox(height: 48),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'RESOURCES',
              style: AppTheme.label.copyWith(color: dynamicTheme.textTertiary),
            ),
          ),
          const SizedBox(height: 16),

          // Improved Resources Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildResourceCard(
                  dynamicTheme,
                  'YouTube',
                  FontAwesomeIcons.youtube,
                  'https://www.youtube.com/@king_rittik',
                  Colors.red,
                ),
                _buildResourceCard(
                  dynamicTheme,
                  'Discord',
                  FontAwesomeIcons.discord,
                  'https://discord.gg/Tmn6BKwSnr',
                  const Color(0xFF5865F2),
                ),
                _buildResourceCard(
                  dynamicTheme,
                  'GitHub',
                  FontAwesomeIcons.github,
                  'https://github.com/RittikSoni/kr_ui',
                  dynamicTheme.textPrimary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Version info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  'v1.0.0',
                  style: AppTheme.caption
                      .copyWith(color: dynamicTheme.textTertiary),
                ),
                const Spacer(),
                Text(
                  'Made with 💙',
                  style: AppTheme.caption
                      .copyWith(color: dynamicTheme.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubNavItem(
    BuildContext context,
    DynamicTheme dynamicTheme, {
    required IconData icon,
    required String label,
    required String path,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => context.go(path),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? dynamicTheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: AppTheme.borderRadiusSmall,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? dynamicTheme.primary
                  : dynamicTheme.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? dynamicTheme.primary
                      : dynamicTheme.textSecondary,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: dynamicTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    DynamicTheme dynamicTheme, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required String path,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => context.go(path),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? dynamicTheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: AppTheme.borderRadiusMedium,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 20,
              color: isSelected
                  ? dynamicTheme.primary
                  : dynamicTheme.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? dynamicTheme.primary
                    : dynamicTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(
    DynamicTheme dynamicTheme,
    String label,
    IconData icon,
    String url,
    Color accentColor,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 76,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: dynamicTheme.borderLight),
            borderRadius: BorderRadius.circular(8),
            color: dynamicTheme.surface.withValues(alpha: 0.5),
          ),
          child: Column(
            children: [
              Icon(icon, size: 24, color: accentColor.withValues(alpha: 0.8)),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTheme.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: dynamicTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
