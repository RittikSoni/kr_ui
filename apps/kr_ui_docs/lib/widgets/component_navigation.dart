import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/component_registry.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

/// A widget that provides "Previous" and "Next" navigation buttons for components
class ComponentNavigation extends StatelessWidget {
  final ComponentInfo currentComponent;

  const ComponentNavigation({
    super.key,
    required this.currentComponent,
  });

  @override
  Widget build(BuildContext context) {
    final allComponents = ComponentRegistry.all;
    final currentIndex =
        allComponents.indexWhere((c) => c.id == currentComponent.id);

    if (currentIndex == -1) return const SizedBox.shrink();

    final prevComponent =
        currentIndex > 0 ? allComponents[currentIndex - 1] : null;
    final nextComponent = currentIndex < allComponents.length - 1
        ? allComponents[currentIndex + 1]
        : null;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);
    final isMobile = AppTheme.isMobile(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.space64),
      decoration: BoxDecoration(
        border: Border(
          top: Border.all(
                  color: dynamicTheme.textSecondary.withValues(alpha: 0.1))
              .top,
        ),
      ),
      child: Row(
        children: [
          // Previous Button
          Expanded(
            child: prevComponent != null
                ? _NavigationButton(
                    component: prevComponent,
                    isNext: false,
                    dynamicTheme: dynamicTheme,
                  )
                : const SizedBox.shrink(),
          ),

          if (!isMobile) const SizedBox(width: AppTheme.space48),

          // Next Button
          Expanded(
            child: nextComponent != null
                ? _NavigationButton(
                    component: nextComponent,
                    isNext: true,
                    dynamicTheme: dynamicTheme,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _NavigationButton extends StatefulWidget {
  final ComponentInfo component;
  final bool isNext;
  final DynamicTheme dynamicTheme;

  const _NavigationButton({
    required this.component,
    required this.isNext,
    required this.dynamicTheme,
  });

  @override
  State<_NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<_NavigationButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/components/${widget.component.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppTheme.space24),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.dynamicTheme.primary.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: AppTheme.borderRadiusMedium,
            border: Border.all(
              color: _isHovered
                  ? widget.dynamicTheme.primary.withValues(alpha: 0.2)
                  : widget.dynamicTheme.textSecondary.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: widget.isNext
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                widget.isNext ? 'Next' : 'Previous',
                style: AppTheme.caption.copyWith(
                  color: widget.dynamicTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.space8),
              Text(
                widget.component.displayName,
                style: AppTheme.h3.copyWith(
                  color: _isHovered
                      ? widget.dynamicTheme.primary
                      : widget.dynamicTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
