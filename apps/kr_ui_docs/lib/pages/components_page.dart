import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../config/component_registry.dart';

class ComponentsPage extends StatefulWidget {
  const ComponentsPage({super.key});

  @override
  State<ComponentsPage> createState() => _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);
    final isMobile = AppTheme.isMobile(context);
    final categories = ComponentRegistry.categories;
    final components = ComponentRegistry.getByCategory(_selectedCategory);

    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          padding: EdgeInsets.all(isMobile ? 24 : 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('Components',
                  style: (isMobile ? AppTheme.h2 : AppTheme.h1)
                      .copyWith(color: dynamicTheme.textPrimary)),
              const SizedBox(height: 16),
              Text(
                'Explore our collection of premium glassmorphic UI components',
                style: AppTheme.bodyLarge
                    .copyWith(color: dynamicTheme.textSecondary),
              ),

              const SizedBox(height: 40),

              // Category tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: KruiGlassyButton(
                        onPressed: () {
                          setState(() => _selectedCategory = category);
                        },
                        blur: isSelected ? 12 : 8,
                        opacity: isSelected ? 0.2 : 0.12,
                        color: isSelected
                            ? dynamicTheme.primary
                            : dynamicTheme.surfaceCard,
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : dynamicTheme.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 40),

              // Components grid
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: components.map((component) {
                  return _buildComponentCard(component, isMobile, dynamicTheme);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComponentCard(
      ComponentInfo component, bool isMobile, DynamicTheme dynamicTheme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go('/components/${component.id}'),
        borderRadius: AppTheme.borderRadiusLarge,
        child: Container(
          width: isMobile ? double.infinity : 380,
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
              // Preview
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: dynamicTheme.gradientColors,
                  ),
                  borderRadius: AppTheme.borderRadiusMedium,
                ),
                child: Center(
                  child: component.demoBuilder(),
                ),
              ),

              const SizedBox(height: 20),

              // Title and category
              Row(
                children: [
                  Expanded(
                    child: Text(component.displayName,
                        style: AppTheme.h3
                            .copyWith(color: dynamicTheme.textPrimary)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: dynamicTheme.primary.withValues(alpha: 0.1),
                      borderRadius: AppTheme.borderRadiusSmall,
                    ),
                    child: Text(
                      component.category,
                      style: AppTheme.caption.copyWith(
                        color: dynamicTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                component.description,
                style: AppTheme.bodyMedium.copyWith(
                  color: dynamicTheme.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // View details link
              Row(
                children: [
                  Text(
                    'View Details',
                    style: AppTheme.bodyMedium.copyWith(
                      color: dynamicTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: dynamicTheme.primary,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
