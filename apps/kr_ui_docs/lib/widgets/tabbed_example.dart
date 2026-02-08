import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import 'code_block.dart';

class TabbedExample extends StatefulWidget {
  final Widget preview;
  final String code;
  final String? title;

  const TabbedExample({
    super.key,
    required this.preview,
    required this.code,
    this.title,
  });

  @override
  State<TabbedExample> createState() => _TabbedExampleState();
}

enum _PreviewBackground {
  gradient,
  solid,
}

class _TabbedExampleState extends State<TabbedExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  _PreviewBackground _backgroundType = _PreviewBackground.solid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _getPreviewBackground(DynamicTheme dynamicTheme, Widget child) {
    switch (_backgroundType) {
      case _PreviewBackground.gradient:
        return Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: dynamicTheme.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        );
      case _PreviewBackground.solid:
        return Container(
          padding: const EdgeInsets.all(40),
          color: dynamicTheme.surfaceCard,
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: AppTheme.h4.copyWith(color: dynamicTheme.textPrimary),
          ),
          const SizedBox(height: AppTheme.space16),
        ],
        KruiGlassyCard(
          padding: EdgeInsets.zero,
          blur: 10,
          opacity: themeProvider.isDarkMode ? 0.2 : 0.1,
          color: dynamicTheme.surfaceCard,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: dynamicTheme.borderLight),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space16,
                  vertical: AppTheme.space12,
                ),
                child: Row(
                  children: [
                    // Modern Pill-style tabs
                    Container(
                      decoration: BoxDecoration(
                        color: dynamicTheme.surfaceCard.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPillTab(
                            index: 0,
                            icon: Icons.visibility_outlined,
                            label: 'Preview',
                            dynamicTheme: dynamicTheme,
                          ),
                          const SizedBox(width: 4),
                          _buildPillTab(
                            index: 1,
                            icon: Icons.code,
                            label: 'Code',
                            dynamicTheme: dynamicTheme,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Background selector (only show on Preview tab)
                    if (_tabController.index == 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildBackgroundButton(
                            _PreviewBackground.gradient,
                            Icons.gradient,
                            'Gradient',
                            dynamicTheme,
                          ),
                          const SizedBox(width: 4),
                          _buildBackgroundButton(
                            _PreviewBackground.solid,
                            Icons.rectangle_outlined,
                            'Solid',
                            dynamicTheme,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 400,
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Preview Tab
                      _TabContentWrapper(
                        child: _getPreviewBackground(
                          dynamicTheme,
                          SingleChildScrollView(
                            child: Center(
                              child: widget.preview,
                            ),
                          ),
                        ),
                      ),
                      // Code Tab
                      _TabContentWrapper(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(AppTheme.space16),
                          child: CodeBlock(code: widget.code),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPillTab({
    required int index,
    required IconData icon,
    required String label,
    required DynamicTheme dynamicTheme,
  }) {
    final isSelected = _tabController.index == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSelected ? dynamicTheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _tabController.animateTo(index);
            setState(() {});
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : dynamicTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color:
                        isSelected ? Colors.white : dynamicTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundButton(
    _PreviewBackground type,
    IconData icon,
    String tooltip,
    DynamicTheme dynamicTheme,
  ) {
    final isSelected = _backgroundType == type;

    return Tooltip(
      message: tooltip,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? dynamicTheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: dynamicTheme.primary.withValues(alpha: 0.3))
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _backgroundType = type;
              });
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                icon,
                size: 16,
                color: isSelected
                    ? dynamicTheme.primary
                    : dynamicTheme.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabContentWrapper extends StatefulWidget {
  final Widget child;
  const _TabContentWrapper({required this.child});

  @override
  State<_TabContentWrapper> createState() => _TabContentWrapperState();
}

class _TabContentWrapperState extends State<_TabContentWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
