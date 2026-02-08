import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';

/// Comprehensive examples for KruiButton with all variants
class ButtonComprehensiveExample extends StatefulWidget {
  const ButtonComprehensiveExample({super.key});

  @override
  State<ButtonComprehensiveExample> createState() =>
      _ButtonComprehensiveExampleState();
}

class _ButtonComprehensiveExampleState
    extends State<ButtonComprehensiveExample> {
  bool _primaryLoading = false;
  bool _secondaryLoading = false;
  bool _destructiveLoading = false;
  bool _outlineLoading = false;
  bool _ghostLoading = false;
  bool _linkLoading = false;
  bool _gradientLoading = false;
  bool _glassyLoading = false;
  bool _glowyLoading = false;
  bool _enableRipple = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'KruiButton Component',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'A universal button component with multiple variants including glassy, gradient, and more. Features icon support and loading states.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // Ripple Toggle
          Row(
            children: [
              const Text(
                'Enable Ripple Effect:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              Switch(
                value: _enableRipple,
                onChanged: (value) => setState(() => _enableRipple = value),
              ),
              const SizedBox(width: 8),
              Text(
                _enableRipple ? 'ON' : 'OFF',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Primary Buttons
          _buildSection(
            'Primary',
            'High-contrast, solid background for primary actions',
            [
              KruiButton(
                variant: KruiButtonVariant.primary,
                label: 'Primary Button',
                onPressed: () => _showSnackBar('Primary pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.primary,
                label: 'With Icon',
                icon: Icons.check_circle,
                onPressed: () => _showSnackBar('Primary with icon pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.primary,
                label: 'Trailing Icon',
                icon: Icons.arrow_forward,
                iconPosition: KruiButtonIconPosition.trailing,
                onPressed: () => _showSnackBar('Trailing icon pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.primary,
                label: _primaryLoading ? 'Loading...' : 'Loading State',
                isLoading: _primaryLoading,
                onPressed: () => _simulateLoading((value) {
                  setState(() => _primaryLoading = value);
                }),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.primary,
                label: 'Disabled',
                onPressed: null,
                enableRipple: _enableRipple,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Secondary Buttons
          _buildSection(
            'Secondary',
            'Muted background for secondary actions',
            [
              KruiButton(
                variant: KruiButtonVariant.secondary,
                label: 'Secondary Button',
                onPressed: () => _showSnackBar('Secondary pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.secondary,
                label: 'With Icon',
                icon: Icons.settings,
                onPressed: () => _showSnackBar('Secondary with icon pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.secondary,
                label: _secondaryLoading ? 'Loading...' : 'Loading State',
                isLoading: _secondaryLoading,
                onPressed: () => _simulateLoading((value) {
                  setState(() => _secondaryLoading = value);
                }),
                enableRipple: _enableRipple,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Destructive Buttons
          _buildSection(
            'Destructive',
            'Red styling for destructive/dangerous actions',
            [
              KruiButton(
                variant: KruiButtonVariant.destructive,
                label: 'Delete',
                icon: Icons.delete,
                onPressed: () => _showSnackBar('Delete pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.destructive,
                label: 'Remove',
                icon: Icons.remove_circle,
                iconPosition: KruiButtonIconPosition.trailing,
                onPressed: () => _showSnackBar('Remove pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.destructive,
                label:
                    _destructiveLoading ? 'Deleting...' : 'Delete with Loading',
                isLoading: _destructiveLoading,
                onPressed: () => _simulateLoading((value) {
                  setState(() => _destructiveLoading = value);
                }),
                enableRipple: _enableRipple,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Outline Buttons
          _buildSection(
            'Outline',
            'Border-only with transparent background',
            [
              KruiButton(
                variant: KruiButtonVariant.outline,
                label: 'Outline Button',
                onPressed: () => _showSnackBar('Outline pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.outline,
                label: 'With Icon',
                icon: Icons.add,
                onPressed: () => _showSnackBar('Outline with icon pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.outline,
                label: _outlineLoading ? 'Loading...' : 'Loading State',
                isLoading: _outlineLoading,
                onPressed: () => _simulateLoading((value) {
                  setState(() => _outlineLoading = value);
                }),
                enableRipple: _enableRipple,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Ghost Buttons
          _buildSection(
            'Ghost',
            'Minimal styling with hover states',
            [
              KruiButton(
                variant: KruiButtonVariant.ghost,
                label: 'Ghost Button',
                onPressed: () => _showSnackBar('Ghost pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.ghost,
                label: 'With Icon',
                icon: Icons.visibility,
                onPressed: () => _showSnackBar('Ghost with icon pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.ghost,
                label: _ghostLoading ? 'Loading...' : 'Loading State',
                isLoading: _ghostLoading,
                onPressed: () => _simulateLoading((value) {
                  setState(() => _ghostLoading = value);
                }),
                enableRipple: _enableRipple,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Link Buttons
          _buildSection(
            'Link',
            'Text-only with underline on hover',
            [
              KruiButton(
                variant: KruiButtonVariant.link,
                label: 'Link Button',
                onPressed: () => _showSnackBar('Link pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.link,
                label: 'External Link',
                icon: Icons.open_in_new,
                iconPosition: KruiButtonIconPosition.trailing,
                onPressed: () => _showSnackBar('External link pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.link,
                label: _linkLoading ? 'Loading...' : 'Loading State',
                isLoading: _linkLoading,
                onPressed: () => _simulateLoading((value) {
                  setState(() => _linkLoading = value);
                }),
                enableRipple: _enableRipple,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Gradient Buttons
          _buildSection(
            'Gradient',
            'Multi-color gradient with animated shadow',
            [
              KruiButton(
                variant: KruiButtonVariant.gradient,
                label: 'Gradient Button',
                onPressed: () => _showSnackBar('Gradient pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.gradient,
                label: 'With Icon',
                icon: Icons.auto_awesome,
                onPressed: () => _showSnackBar('Gradient with icon pressed'),
                enableRipple: _enableRipple,
                elevation: 4,
              ),
              KruiButton(
                variant: KruiButtonVariant.gradient,
                label: 'Custom Colors',
                icon: Icons.color_lens,
                gradientColors: const [
                  Color(0xFFF59E0B), // Amber
                  Color(0xFFEF4444), // Red
                  Color(0xFFEC4899), // Pink
                ],
                onPressed: () => _showSnackBar('Custom gradient pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.gradient,
                label: _gradientLoading ? 'Loading...' : 'Loading State',
                isLoading: _gradientLoading,
                onPressed: () => _simulateLoading((value) {
                  setState(() => _gradientLoading = value);
                }),
                enableRipple: _enableRipple,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Glassy Buttons
          _buildSection(
            'Glassy',
            'Glassmorphic design with blur and transparency',
            [
              KruiButton(
                variant: KruiButtonVariant.glassy,
                label: 'Glassy Button',
                onPressed: () => _showSnackBar('Glassy pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.glassy,
                label: 'With Icon',
                icon: Icons.blur_on,
                onPressed: () => _showSnackBar('Glassy with icon pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.glassy,
                label: 'Custom Colors',
                icon: Icons.color_lens,
                backgroundColor: const Color(0xFF8B5CF6).withOpacity(0.2),
                foregroundColor: Colors.white,
                borderColor: const Color(0xFF8B5CF6).withOpacity(0.3),
                onPressed: () => _showSnackBar('Custom glassy pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.glassy,
                label: _glassyLoading ? 'Loading...' : 'Loading State',
                isLoading: _glassyLoading,
                onPressed: () => _simulateLoading((value) {
                  setState(() => _glassyLoading = value);
                }),
                enableRipple: _enableRipple,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Glowy Buttons
          _buildSection(
            'Glowy',
            'Pulsing glow effect with animated shadows',
            [
              KruiButton(
                variant: KruiButtonVariant.glowy,
                label: 'Glowy Button',
                onPressed: () => _showSnackBar('Glowy pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.glowy,
                label: 'With Icon',
                icon: Icons.star,
                onPressed: () => _showSnackBar('Glowy with icon pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.glowy,
                label: 'Custom Colors',
                icon: Icons.bolt,
                backgroundColor: const Color(0xFFEF4444), // Red
                onPressed: () => _showSnackBar('Custom glowy pressed'),
                enableRipple: _enableRipple,
                elevation: 6,
              ),
              KruiButton(
                variant: KruiButtonVariant.glowy,
                label: _glowyLoading ? 'Loading...' : 'Loading State',
                isLoading: _glowyLoading,
                onPressed: () => _simulateLoading((value) {
                  setState(() => _glowyLoading = value);
                }),
                enableRipple: _enableRipple,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Icon-Only Buttons
          _buildSection(
            'Icon Only',
            'Buttons with icons and no text labels',
            [
              KruiButton(
                variant: KruiButtonVariant.primary,
                icon: Icons.favorite,
                child: const SizedBox.shrink(),
                onPressed: () => _showSnackBar('Icon-only pressed'),
                enableRipple: _enableRipple,
                padding: const EdgeInsets.all(12),
              ),
              KruiButton(
                variant: KruiButtonVariant.secondary,
                icon: Icons.share,
                child: const SizedBox.shrink(),
                onPressed: () => _showSnackBar('Share pressed'),
                enableRipple: _enableRipple,
                padding: const EdgeInsets.all(12),
              ),
              KruiButton(
                variant: KruiButtonVariant.outline,
                icon: Icons.bookmark,
                child: const SizedBox.shrink(),
                onPressed: () => _showSnackBar('Bookmark pressed'),
                enableRipple: _enableRipple,
                padding: const EdgeInsets.all(12),
              ),
              KruiButton(
                variant: KruiButtonVariant.gradient,
                icon: Icons.star,
                child: const SizedBox.shrink(),
                onPressed: () => _showSnackBar('Star pressed'),
                enableRipple: _enableRipple,
                padding: const EdgeInsets.all(12),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Custom Styling
          _buildSection(
            'Custom Styling',
            'Buttons with custom colors and properties',
            [
              KruiButton(
                variant: KruiButtonVariant.primary,
                label: 'Custom Colors',
                backgroundColor: const Color(0xFF10B981), // Green
                foregroundColor: Colors.white,
                onPressed: () => _showSnackBar('Custom color pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.outline,
                label: 'Custom Border',
                borderColor: const Color(0xFFF59E0B), // Amber
                foregroundColor: const Color(0xFFF59E0B),
                onPressed: () => _showSnackBar('Custom border pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.primary,
                label: 'High Elevation',
                elevation: 8,
                onPressed: () => _showSnackBar('High elevation pressed'),
                enableRipple: _enableRipple,
              ),
              KruiButton(
                variant: KruiButtonVariant.primary,
                label: 'Custom Border Radius',
                borderRadius: BorderRadius.circular(24),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                onPressed: () => _showSnackBar('Custom radius pressed'),
                enableRipple: _enableRipple,
              ),
            ],
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String description, List<Widget> buttons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: buttons,
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _simulateLoading(Function(bool) setLoading) {
    setLoading(true);
    Future.delayed(const Duration(seconds: 2), () {
      setLoading(false);
      _showSnackBar('Loading complete!');
    });
  }
}
