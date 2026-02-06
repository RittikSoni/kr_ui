import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/component_registry.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../widgets/tabbed_example.dart';
import '../widgets/property_table.dart';
import '../widgets/component_navigation.dart';

/// Complete component documentation display with a unified scrollable layout
class ComponentShowcase extends StatefulWidget {
  final ComponentInfo component;

  const ComponentShowcase({
    super.key,
    required this.component,
  });

  @override
  State<ComponentShowcase> createState() => _ComponentShowcaseState();
}

class _ComponentShowcaseState extends State<ComponentShowcase> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};
  final GlobalKey _contentColumnKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _buildSectionKeys();
  }

  @override
  void didUpdateWidget(ComponentShowcase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.component.id != widget.component.id) {
      _buildSectionKeys();
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
        });
      }
    }
  }

  void _buildSectionKeys() {
    _sectionKeys.clear();
    _sectionKeys['Overview'] = GlobalKey();
    _sectionKeys['API Reference'] = GlobalKey();
    _sectionKeys['Examples'] = GlobalKey();
    for (var preset in widget.component.presets) {
      _sectionKeys[preset.name] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String section, {int deferredFrames = 0}) {
    void attemptScroll() {
      final key = _sectionKeys[section];
      final ctx = key?.currentContext;
      if (key == null || ctx == null) return;

      final contentContext = _contentColumnKey.currentContext;
      if (contentContext == null) return;

      final contentBox = contentContext.findRenderObject() as RenderBox?;
      final targetBox = ctx.findRenderObject() as RenderBox?;
      if (contentBox == null ||
          targetBox == null ||
          !contentBox.hasSize ||
          !targetBox.hasSize) {
        if (deferredFrames < 2 && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _scrollToSection(section, deferredFrames: deferredFrames + 1);
            }
          });
        } else {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignment: 0.0,
            alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
          );
        }
        return;
      }
      if (!_scrollController.hasClients) {
        if (deferredFrames < 2 && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _scrollToSection(section, deferredFrames: deferredFrames + 1);
            }
          });
        } else {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignment: 0.0,
            alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
          );
        }
        return;
      }

      final targetOffset = contentBox.globalToLocal(
        targetBox.localToGlobal(Offset.zero),
      );
      final contentTopPadding =
          AppTheme.isMobile(ctx) ? AppTheme.space24 : AppTheme.space64;
      const headerPadding = 24.0;
      final scrollOffset = (contentTopPadding + targetOffset.dy - headerPadding)
          .clamp(0.0, _scrollController.position.maxScrollExtent);
      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }

    if (deferredFrames > 0) {
      attemptScroll();
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToSection(section, deferredFrames: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);
    final isMobile = AppTheme.isMobile(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Content
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? AppTheme.space16 : AppTheme.space48,
                  vertical: isMobile ? AppTheme.space24 : AppTheme.space64,
                ),
                child: Column(
                  key: _contentColumnKey,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    _buildHeader(isMobile, dynamicTheme,
                        key: _sectionKeys['Overview']),

                    const SizedBox(height: AppTheme.space48),

                    // Usage section (Basic Example)
                    _buildUsageSection(isMobile, dynamicTheme),

                    const SizedBox(height: AppTheme.space64),

                    // API Reference section
                    _buildApiSection(isMobile, dynamicTheme,
                        key: _sectionKeys['API Reference']),

                    const SizedBox(height: AppTheme.space64),

                    // Advanced Usage section
                    _buildAdvancedSection(isMobile, dynamicTheme,
                        key: _sectionKeys['Examples']),

                    const SizedBox(height: AppTheme.space64),

                    // Presets section
                    if (widget.component.presets.isNotEmpty)
                      _buildPresetsSection(isMobile, dynamicTheme),

                    const SizedBox(height: AppTheme.space64),

                    // Navigation section
                    ComponentNavigation(currentComponent: widget.component),

                    const SizedBox(height: AppTheme.space64),
                  ],
                ),
              ),
            ),
          ),
        ),

        // On this page sidebar (Hidden on mobile)
        if (!isMobile) _buildOnThisPageSidebar(dynamicTheme),
      ],
    );
  }

  Widget _buildOnThisPageSidebar(DynamicTheme dynamicTheme) {
    return Container(
      width: 200,
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ON THIS PAGE',
              style: AppTheme.label.copyWith(
                color: dynamicTheme.textTertiary,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            _buildSidebarItem('Overview', dynamicTheme),
            _buildSidebarItem('API Reference', dynamicTheme),
            _buildSidebarItem('Examples', dynamicTheme),
            if (widget.component.presets.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...widget.component.presets.map((p) =>
                  _buildSidebarItem(p.name, dynamicTheme, isSubItem: true)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(String title, DynamicTheme dynamicTheme,
      {bool isSubItem = false}) {
    return InkWell(
      onTap: () => _scrollToSection(title),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(isSubItem ? 12 : 0, 8, 0, 8),
        child: Text(
          title,
          style: AppTheme.bodySmall.copyWith(
            color: dynamicTheme.textSecondary,
            fontSize: isSubItem ? 13 : 14,
            fontWeight: isSubItem ? FontWeight.normal : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile, DynamicTheme dynamicTheme, {Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.component.displayName,
          style: (isMobile ? AppTheme.h1 : AppTheme.h1.copyWith(fontSize: 48))
              .copyWith(color: dynamicTheme.textPrimary),
        ),
        const SizedBox(height: AppTheme.space12),
        Text(
          widget.component.description,
          style: AppTheme.bodyLarge.copyWith(
            color: dynamicTheme.textSecondary,
            fontSize: 20,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppTheme.space24),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space12,
            vertical: 6.0,
          ),
          decoration: BoxDecoration(
            color: dynamicTheme.primary.withValues(alpha: 0.1),
            borderRadius: AppTheme.borderRadiusSmall,
            border:
                Border.all(color: dynamicTheme.primary.withValues(alpha: 0.2)),
          ),
          child: Text(
            widget.component.category,
            style: AppTheme.caption.copyWith(
              color: dynamicTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsageSection(bool isMobile, DynamicTheme dynamicTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage',
          style: AppTheme.h2.copyWith(color: dynamicTheme.textPrimary),
        ),
        const SizedBox(height: AppTheme.space24),
        TabbedExample(
          title: 'Basic Example',
          preview: widget.component.demoBuilder(),
          code: widget.component.basicExample,
        ),
      ],
    );
  }

  Widget _buildApiSection(bool isMobile, DynamicTheme dynamicTheme,
      {Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'API Reference',
          style: AppTheme.h2.copyWith(color: dynamicTheme.textPrimary),
        ),
        const SizedBox(height: AppTheme.space12),
        Text(
          'Explore the properties available for ${widget.component.name}.',
          style:
              AppTheme.bodyMedium.copyWith(color: dynamicTheme.textSecondary),
        ),
        const SizedBox(height: AppTheme.space24),
        PropertyTable(properties: widget.component.properties),
      ],
    );
  }

  Widget _buildAdvancedSection(bool isMobile, DynamicTheme dynamicTheme,
      {Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Examples',
          style: AppTheme.h2.copyWith(color: dynamicTheme.textPrimary),
        ),
        const SizedBox(height: AppTheme.space24),
        TabbedExample(
          title: 'Advanced Usage',
          preview: widget.component
              .demoBuilder(), // Or a more advanced version if available
          code: widget.component.advancedExample,
        ),
      ],
    );
  }

  Widget _buildPresetsSection(bool isMobile, DynamicTheme dynamicTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Presets',
          style: AppTheme.h2.copyWith(color: dynamicTheme.textPrimary),
        ),
        const SizedBox(height: AppTheme.space12),
        Text(
          'Ready-to-use configurations for common use cases.',
          style:
              AppTheme.bodyMedium.copyWith(color: dynamicTheme.textSecondary),
        ),
        const SizedBox(height: AppTheme.space32),
        ...widget.component.presets.map((preset) {
          return Padding(
            key: _sectionKeys[preset.name],
            padding: const EdgeInsets.only(bottom: AppTheme.space48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  preset.name,
                  style: AppTheme.h3.copyWith(color: dynamicTheme.textPrimary),
                ),
                const SizedBox(height: AppTheme.space8),
                Text(
                  preset.description,
                  style: AppTheme.bodyMedium
                      .copyWith(color: dynamicTheme.textSecondary),
                ),
                const SizedBox(height: AppTheme.space24),
                TabbedExample(
                  preview: preset.builder(),
                  code: preset.code,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
