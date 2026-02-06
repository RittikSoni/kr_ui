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

class _TabbedExampleState extends State<TabbedExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                child: Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        labelColor: dynamicTheme.primary,
                        unselectedLabelColor: dynamicTheme.textSecondary,
                        indicatorColor: dynamicTheme.primary,
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: Colors.transparent,
                        labelStyle: AppTheme.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: 'Preview'),
                          Tab(text: 'Code'),
                        ],
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Preview Tab
                      _TabContentWrapper(
                        child: Container(
                          padding: const EdgeInsets.all(AppTheme.space32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: dynamicTheme.gradientColors,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Center(child: widget.preview),
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
