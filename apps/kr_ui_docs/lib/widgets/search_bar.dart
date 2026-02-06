import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../utils/search_service.dart';
import '../config/component_registry.dart';

/// A sleek trigger button that opens the professional search overlay
class SearchTrigger extends StatelessWidget {
  final Function(ComponentInfo) onComponentSelected;

  const SearchTrigger({
    super.key,
    required this.onComponentSelected,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);

    final isMobile = AppTheme.isMobile(context);

    if (isMobile) {
      return IconButton(
        onPressed: () => SearchOverlay.show(context, onComponentSelected),
        icon: Icon(Icons.search_rounded, color: dynamicTheme.textPrimary),
        tooltip: 'Search components',
      );
    }

    return InkWell(
      onTap: () => SearchOverlay.show(context, onComponentSelected),
      borderRadius: AppTheme.borderRadiusMedium,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: dynamicTheme.surfaceGray,
          borderRadius: AppTheme.borderRadiusMedium,
          border: Border.all(color: dynamicTheme.borderLight),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded,
                size: 18, color: dynamicTheme.textTertiary),
            const SizedBox(width: 8),
            Text(
              'Search components...',
              style:
                  AppTheme.bodySmall.copyWith(color: dynamicTheme.textTertiary),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: dynamicTheme.surfaceCard,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: dynamicTheme.borderLight),
              ),
              child: Text(
                '⌘K',
                style: AppTheme.label.copyWith(
                  fontSize: 10,
                  color: dynamicTheme.textTertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Professional modal search overlay with Algolia-style UX
class SearchOverlay extends StatefulWidget {
  final Function(ComponentInfo) onComponentSelected;

  const SearchOverlay({
    super.key,
    required this.onComponentSelected,
  });

  static bool _isShowing = false;

  static Future<void> show(
      BuildContext context, Function(ComponentInfo) onComponentSelected) {
    if (_isShowing) return Future.value();
    _isShowing = true;
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (context) =>
          SearchOverlay(onComponentSelected: onComponentSelected),
    ).then((_) => _isShowing = false);
  }

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<SearchResult> _results = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }

    final results = await SearchService.search(query);
    setState(() {
      _results = results;
      _selectedIndex = 0;
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1).clamp(0, _results.length - 1);
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _selectedIndex = (_selectedIndex - 1).clamp(0, _results.length - 1);
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_results.isNotEmpty) {
          _onResultSelected(_results[_selectedIndex].component);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        Navigator.of(context).pop();
      }
    }
  }

  void _onResultSelected(ComponentInfo component) {
    context.go('/components/${component.id}');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: (themeProvider.isDarkMode ? Colors.black : Colors.white)
                .withValues(alpha: 0.4),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 80, left: 24, right: 24),
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: _handleKeyEvent,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: GestureDetector(
                  onTap: () {}, // Prevent closing when clicking inside
                  child: Container(
                    decoration: BoxDecoration(
                      color: dynamicTheme.surfaceCard,
                      borderRadius: AppTheme.borderRadiusLarge,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Search Input Header
                        _buildHeader(dynamicTheme),

                        // Results Area
                        if (_results.isNotEmpty)
                          _buildResults(dynamicTheme)
                        else if (_controller.text.isNotEmpty)
                          _buildNoResults(dynamicTheme)
                        else
                          _buildInitialState(dynamicTheme),

                        // Footer (shortcuts info)
                        _buildFooter(dynamicTheme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(DynamicTheme dynamicTheme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dynamicTheme.borderLight)),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: dynamicTheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search for components...',
                hintStyle: AppTheme.bodyLarge
                    .copyWith(color: dynamicTheme.textTertiary),
                border: InputBorder.none,
              ),
              style:
                  AppTheme.bodyLarge.copyWith(color: dynamicTheme.textPrimary),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close_rounded,
                  color: dynamicTheme.textSecondary, size: 20),
              onPressed: () {
                _controller.clear();
                _onSearchChanged('');
              },
            ),
        ],
      ),
    );
  }

  Widget _buildResults(DynamicTheme dynamicTheme) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(AppTheme.space8),
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final result = _results[index];
          final isSelected = index == _selectedIndex;
          return _buildResultItem(result, isSelected, dynamicTheme);
        },
      ),
    );
  }

  Widget _buildResultItem(
      SearchResult result, bool isSelected, DynamicTheme dynamicTheme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onResultSelected(result.component),
        borderRadius: AppTheme.borderRadiusMedium,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? dynamicTheme.primary : Colors.transparent,
            borderRadius: AppTheme.borderRadiusMedium,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : dynamicTheme.primary.withValues(alpha: 0.1),
                  borderRadius: AppTheme.borderRadiusSmall,
                ),
                child: Icon(
                  Icons.widgets_outlined,
                  size: 18,
                  color: isSelected ? Colors.white : dynamicTheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.component.displayName,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : dynamicTheme.textPrimary,
                      ),
                    ),
                    Text(
                      result.component.description,
                      style: AppTheme.bodySmall.copyWith(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : dynamicTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.subdirectory_arrow_left_rounded,
                    color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoResults(DynamicTheme dynamicTheme) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded,
              size: 48,
              color: dynamicTheme.textTertiary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No results for "${_controller.text}"',
            style:
                AppTheme.bodyMedium.copyWith(color: dynamicTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(DynamicTheme dynamicTheme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text(
            'Find any component',
            style: AppTheme.h3.copyWith(color: dynamicTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Search by name, category, or implementation details.',
            style:
                AppTheme.bodySmall.copyWith(color: dynamicTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(DynamicTheme dynamicTheme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space12),
      decoration: BoxDecoration(
        color: dynamicTheme.surfaceGray.withValues(alpha: 0.5),
        border: Border(top: BorderSide(color: dynamicTheme.borderLight)),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppTheme.radiusLarge),
          bottomRight: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildShortcutHint('↑↓', 'Navigate', dynamicTheme),
          const SizedBox(width: 16),
          _buildShortcutHint('↵', 'Select', dynamicTheme),
          const SizedBox(width: 16),
          _buildShortcutHint('esc', 'Close', dynamicTheme),
        ],
      ),
    );
  }

  Widget _buildShortcutHint(
      String key, String action, DynamicTheme dynamicTheme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: dynamicTheme.surfaceCard,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: dynamicTheme.borderLight),
          ),
          child: Text(
            key,
            style: AppTheme.label
                .copyWith(fontSize: 10, color: dynamicTheme.textTertiary),
          ),
        ),
        const SizedBox(width: 6),
        Text(action,
            style: AppTheme.caption
                .copyWith(color: dynamicTheme.textTertiary, fontSize: 10)),
      ],
    );
  }
}
