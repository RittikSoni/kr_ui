import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kr_ui/kr_ui.dart';
import '../theme/app_theme.dart';
import '../theme/theme_config.dart';
import '../theme/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  final bool isCompact;

  const ThemeSelector({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);
    final isMobile = AppTheme.isMobile(context);

    if (isMobile) {
      return IconButton(
        icon: Icon(
          themeProvider.isDarkMode
              ? Icons.dark_mode_rounded
              : Icons.light_mode_rounded,
          size: 20,
          color: dynamicTheme.textPrimary,
        ),
        onPressed: () => _showThemeSheet(context),
      );
    }

    if (isCompact) {
      return _buildCompactSelector(context, themeProvider, dynamicTheme);
    }

    return _buildDesktopSelector(context, themeProvider, dynamicTheme);
  }

  Widget _buildCompactSelector(
      BuildContext context, ThemeProvider provider, DynamicTheme dynamicTheme) {
    return PopupMenuButton<dynamic>(
      offset: const Offset(0, 45),
      position: PopupMenuPosition.under,
      color: dynamicTheme.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: AppTheme.borderRadiusMedium,
        side: BorderSide(color: dynamicTheme.borderLight),
      ),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: dynamicTheme.primary.withValues(alpha: 0.05),
          borderRadius: AppTheme.borderRadiusSmall,
        ),
        child: Icon(
          provider.isDarkMode
              ? Icons.dark_mode_rounded
              : Icons.light_mode_rounded,
          size: 18,
          color: dynamicTheme.primary,
        ),
      ),
      itemBuilder: (context) => [
        // Brightness Section
        PopupMenuItem(
          enabled: false,
          child: Text('Appearance',
              style: AppTheme.label.copyWith(color: dynamicTheme.textTertiary)),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              _buildCompactBrightnessBtn(provider, AppBrightnessMode.light,
                  Icons.light_mode_outlined, 'Light', dynamicTheme, context),
              const SizedBox(width: 8),
              _buildCompactBrightnessBtn(provider, AppBrightnessMode.dark,
                  Icons.dark_mode_outlined, 'Dark', dynamicTheme, context),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          enabled: false,
          child: Text('Theme Color',
              style: AppTheme.label.copyWith(color: dynamicTheme.textTertiary)),
        ),
        PopupMenuItem(
          child: SizedBox(
            width: 200,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppColorTheme.values.map((theme) {
                final isSelected = provider.colorTheme == theme;
                final colorData =
                    ColorThemeData.get(theme, provider.brightness);
                return InkWell(
                  onTap: () {
                    provider.setColorTheme(theme);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: colorData.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? dynamicTheme.textPrimary
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color:
                                      colorData.primary.withValues(alpha: 0.4),
                                  blurRadius: 4)
                            ]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactBrightnessBtn(
      ThemeProvider provider,
      AppBrightnessMode mode,
      IconData icon,
      String label,
      DynamicTheme dynamicTheme,
      BuildContext context) {
    final isSelected = provider.brightness == mode;
    return Expanded(
      child: InkWell(
        onTap: () {
          provider.setBrightness(mode);
          Navigator.pop(context);
        },
        borderRadius: AppTheme.borderRadiusSmall,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? dynamicTheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: AppTheme.borderRadiusSmall,
            border: Border.all(
                color: isSelected
                    ? dynamicTheme.primary
                    : dynamicTheme.borderLight),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 16,
                  color: isSelected
                      ? dynamicTheme.primary
                      : dynamicTheme.textSecondary),
              const SizedBox(height: 4),
              Text(label,
                  style: AppTheme.label.copyWith(
                      fontSize: 10,
                      color: isSelected
                          ? dynamicTheme.primary
                          : dynamicTheme.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopSelector(
      BuildContext context, ThemeProvider provider, DynamicTheme dynamicTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            'APPEARANCE',
            style: AppTheme.label.copyWith(
              color: dynamicTheme.textTertiary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildBrightnessChip(context, 'Light', Icons.light_mode_outlined,
                  AppBrightnessMode.light, provider, dynamicTheme),
              const SizedBox(width: 8),
              _buildBrightnessChip(context, 'Dark', Icons.dark_mode_outlined,
                  AppBrightnessMode.dark, provider, dynamicTheme),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            'Color Theme',
            style: AppTheme.label.copyWith(
              color: dynamicTheme.textTertiary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppColorTheme.values.map((theme) {
              return _buildColorChip(context, theme, provider, dynamicTheme);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBrightnessChip(
      BuildContext context,
      String label,
      IconData icon,
      AppBrightnessMode mode,
      ThemeProvider provider,
      DynamicTheme dynamicTheme) {
    final isSelected = provider.brightness == mode;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => provider.setBrightness(mode),
          borderRadius: AppTheme.borderRadiusMedium,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? dynamicTheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: AppTheme.borderRadiusMedium,
              border: Border.all(
                  color: isSelected
                      ? dynamicTheme.primary
                      : dynamicTheme.borderLight),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 16,
                    color: isSelected
                        ? dynamicTheme.primary
                        : dynamicTheme.textSecondary),
                const SizedBox(width: 6),
                Text(label,
                    style: AppTheme.bodySmall.copyWith(
                        color: isSelected
                            ? dynamicTheme.primary
                            : dynamicTheme.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorChip(BuildContext context, AppColorTheme theme,
      ThemeProvider provider, DynamicTheme dynamicTheme) {
    final isSelected = provider.colorTheme == theme;
    final colorData = ColorThemeData.get(theme, provider.brightness);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => provider.setColorTheme(theme),
        borderRadius: AppTheme.borderRadiusMedium,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? colorData.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: AppTheme.borderRadiusMedium,
            border: Border.all(
                color:
                    isSelected ? colorData.primary : dynamicTheme.borderLight),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colorData.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: AppTheme.shadowSmall,
                ),
              ),
              const SizedBox(width: 8),
              Text(theme.displayName,
                  style: AppTheme.bodySmall.copyWith(
                      color: isSelected
                          ? colorData.primary
                          : dynamicTheme.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          final dynamicTheme = DynamicTheme(provider);
          return KruiGlassyCard(
            blur: 20,
            opacity: 0.8,
            color: dynamicTheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Theme Settings',
                      style: AppTheme.h3
                          .copyWith(color: dynamicTheme.textPrimary)),
                  const SizedBox(height: 24),
                  Text('Appearance',
                      style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: dynamicTheme.textPrimary)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildBrightnessChip(
                          context,
                          'Light',
                          Icons.light_mode_outlined,
                          AppBrightnessMode.light,
                          provider,
                          dynamicTheme),
                      const SizedBox(width: 12),
                      _buildBrightnessChip(
                          context,
                          'Dark',
                          Icons.dark_mode_outlined,
                          AppBrightnessMode.dark,
                          provider,
                          dynamicTheme),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Color Theme',
                      style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: dynamicTheme.textPrimary)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: AppColorTheme.values.map((theme) {
                      return _buildColorChip(
                          context, theme, provider, dynamicTheme);
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
