import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/component_registry.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

/// Displays API documentation table for component properties
class PropertyTable extends StatelessWidget {
  final List<PropertyInfo> properties;

  const PropertyTable({
    super.key,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);
    final isMobile = AppTheme.isMobile(context);

    if (isMobile) {
      return _buildMobileLayout(dynamicTheme);
    }

    return _buildDesktopLayout(dynamicTheme);
  }

  Widget _buildDesktopLayout(DynamicTheme dynamicTheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: dynamicTheme.borderLight),
        borderRadius: AppTheme.borderRadiusMedium,
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppTheme.space16),
            decoration: BoxDecoration(
              color: dynamicTheme.surfaceGray,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMedium),
                topRight: Radius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Property',
                      style: AppTheme.label
                          .copyWith(color: dynamicTheme.textPrimary)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Type',
                      style: AppTheme.label
                          .copyWith(color: dynamicTheme.textPrimary)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Default',
                      style: AppTheme.label
                          .copyWith(color: dynamicTheme.textPrimary)),
                ),
                Expanded(
                  flex: 4,
                  child: Text('Description',
                      style: AppTheme.label
                          .copyWith(color: dynamicTheme.textPrimary)),
                ),
              ],
            ),
          ),

          // Rows
          ...properties.asMap().entries.map((entry) {
            final index = entry.key;
            final prop = entry.value;
            final isEven = index % 2 == 0;

            return Container(
              padding: const EdgeInsets.all(AppTheme.space16),
              decoration: BoxDecoration(
                color: isEven
                    ? dynamicTheme.surfaceCard
                    : dynamicTheme.surfaceGray,
                border: Border(
                  bottom: index < properties.length - 1
                      ? BorderSide(color: dynamicTheme.borderLight)
                      : BorderSide.none,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property name
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            prop.name,
                            style: AppTheme.codeMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: dynamicTheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (prop.isRequired) ...[
                          const SizedBox(width: AppTheme.space4),
                          Text(
                            '*',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.accentRed,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Type
                  Expanded(
                    flex: 2,
                    child: Text(
                      prop.type,
                      style: AppTheme.codeSmall.copyWith(
                        color: dynamicTheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),

                  // Default value
                  Expanded(
                    flex: 2,
                    child: Text(
                      prop.defaultValue,
                      style: AppTheme.codeSmall.copyWith(
                        color: dynamicTheme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),

                  // Description
                  Expanded(
                    flex: 4,
                    child: Text(
                      prop.description,
                      style: AppTheme.bodySmall.copyWith(
                        color: dynamicTheme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(DynamicTheme dynamicTheme) {
    return Column(
      children: properties.map((prop) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.space16),
          padding: const EdgeInsets.all(AppTheme.space16),
          decoration: BoxDecoration(
            color: dynamicTheme.surfaceCard,
            border: Border.all(color: dynamicTheme.borderLight),
            borderRadius: AppTheme.borderRadiusMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    prop.name,
                    style: AppTheme.codeMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: dynamicTheme.textPrimary,
                    ),
                  ),
                  if (prop.isRequired) ...[
                    const SizedBox(width: AppTheme.space4),
                    Text(
                      '*',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.accentRed,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppTheme.space8),
              Text(
                prop.type,
                style: AppTheme.codeSmall.copyWith(
                  color: dynamicTheme.primary,
                ),
              ),
              const SizedBox(height: AppTheme.space8),
              Text(
                'Default: ${prop.defaultValue}',
                style: AppTheme.bodySmall.copyWith(
                  color: dynamicTheme.textTertiary,
                ),
              ),
              const SizedBox(height: AppTheme.space12),
              Text(
                prop.description,
                style: AppTheme.bodySmall.copyWith(
                  color: dynamicTheme.textSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
