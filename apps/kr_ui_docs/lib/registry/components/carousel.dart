import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final ComponentInfo kruiCarouselInfo = ComponentInfo(
  id: 'carousel',
  name: 'KruiCarousel',
  displayName: 'Carousel Slider',
  description:
      'Enterprise-grade carousel with dual styling modes, 7 transition effects, auto-play, infinite loop, gesture/keyboard controls, and comprehensive customization.',
  category: 'Display',
  icon: Icons.view_carousel,
  properties: const [
    PropertyInfo(
      name: 'items',
      type: 'List<Widget>',
      defaultValue: 'required',
      description: 'List of widgets to display in the carousel.',
    ),
    PropertyInfo(
      name: 'height',
      type: 'double',
      defaultValue: '300',
      description: 'Carousel height (overridden by aspectRatio if provided).',
    ),
    PropertyInfo(
      name: 'aspectRatio',
      type: 'double?',
      defaultValue: 'null',
      description: 'Width to height ratio (overrides height if provided).',
    ),
    PropertyInfo(
      name: 'styleMode',
      type: 'CarouselStyleMode',
      defaultValue: 'glass',
      description:
          'Styling mode: glass (glassmorphic) or simple (modern minimal).',
    ),
    PropertyInfo(
      name: 'autoPlay',
      type: 'bool',
      defaultValue: 'false',
      description: 'Enable auto-play.',
    ),
    PropertyInfo(
      name: 'autoPlayDuration',
      type: 'Duration',
      defaultValue: 'Duration(seconds: 3)',
      description: 'Duration between auto-play transitions.',
    ),
    PropertyInfo(
      name: 'transitionType',
      type: 'CarouselTransitionType',
      defaultValue: 'slide',
      description:
          'Transition animation type (slide, fade, scale, cube, flip, zoom, parallax).',
    ),
    PropertyInfo(
      name: 'transitionDuration',
      type: 'Duration',
      defaultValue: 'Duration(milliseconds: 500)',
      description: 'Transition animation duration.',
    ),
    PropertyInfo(
      name: 'infinite',
      type: 'bool',
      defaultValue: 'true',
      description: 'Enable infinite loop.',
    ),
    PropertyInfo(
      name: 'indicatorType',
      type: 'CarouselIndicatorType',
      defaultValue: 'dots',
      description:
          'Pagination indicator style (dots, bars, thumbnails, numbers, none).',
    ),
    PropertyInfo(
      name: 'showIndicators',
      type: 'bool',
      defaultValue: 'true',
      description: 'Show pagination indicators.',
    ),
    PropertyInfo(
      name: 'showArrows',
      type: 'bool',
      defaultValue: 'true',
      description: 'Show navigation arrows.',
    ),
    PropertyInfo(
      name: 'viewportFraction',
      type: 'double',
      defaultValue: '1.0',
      description: 'Item width fraction (0.0 to 1.0, allows peek effect).',
    ),
  ],
  basicExample: '''KruiCarousel(
  items: [
    Container(
      color: Colors.blue,
      child: Center(child: Text('Slide 1', style: TextStyle(fontSize: 24, color: Colors.white))),
    ),
    Container(
      color: Colors.purple,
      child: Center(child: Text('Slide 2', style: TextStyle(fontSize: 24, color: Colors.white))),
    ),
    Container(
      color: Colors.pink,
      child: Center(child: Text('Slide 3', style: TextStyle(fontSize: 24, color: Colors.white))),
    ),
  ],
  autoPlay: true,
)''',
  advancedExample: '''KruiCarousel(
  items: List.generate(5, (index) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
        ),
      ),
      child: Center(
        child: Icon(Icons.star, size: 64, color: Colors.white),
      ),
    );
  }),
  styleMode: CarouselStyleMode.glass,
  autoPlay: true,
  autoPlayDuration: Duration(seconds: 4),
  transitionType: CarouselTransitionType.scale,
  transitionDuration: Duration(milliseconds: 600),
  indicatorType: CarouselIndicatorType.bars,
  arrowsOnHover: true,
  viewportFraction: 0.9,
)''',
  presets: [
    PresetInfo(
      name: 'Hero Carousel',
      description: 'Glass mode with fade transition and auto-play',
      code: '''KruiCarousel(
  items: [...],
  styleMode: CarouselStyleMode.glass,
  autoPlay: true,
  transitionType: CarouselTransitionType.fade,
  showArrows: false,
  indicatorPosition: IndicatorPosition.bottom,
)''',
      builder: () {
        return Center(
          child: SizedBox(
            width: 600,
            child: KruiCarousel(
              height: 350,
              styleMode: CarouselStyleMode.glass,
              autoPlay: true,
              autoPlayDuration: const Duration(seconds: 4),
              transitionType: CarouselTransitionType.fade,
              transitionDuration: const Duration(milliseconds: 800),
              showArrows: false,
              arrowsOnHover: false,
              indicatorType: CarouselIndicatorType.dots,
              items: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.shade700, Colors.purple.shade700],
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.rocket_launch, size: 80, color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Launch Your Dreams',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Experience the power of innovation',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.purple.shade700, Colors.pink.shade700],
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome, size: 80, color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Seamless Experience',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Built with cutting-edge technology',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.pink.shade700, Colors.orange.shade700],
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.speed, size: 80, color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Lightning Fast',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Optimized for peak performance',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
    PresetInfo(
      name: 'Product Showcase',
      description: 'Simple mode with slide and peek effect',
      code: '''KruiCarousel(
  items: [...],
  styleMode: CarouselStyleMode.simple,
  transitionType: CarouselTransitionType.slide,
  viewportFraction: 0.85,
  indicatorType: CarouselIndicatorType.bars,
)''',
      builder: () {
        return Center(
          child: SizedBox(
            width: 600,
            child: KruiCarousel(
              height: 280,
              styleMode: CarouselStyleMode.simple,
              backgroundColor: Colors.transparent,
              transitionType: CarouselTransitionType.slide,
              viewportFraction: 0.85,
              padding: const EdgeInsets.all(8),
              indicatorType: CarouselIndicatorType.bars,
              showArrows: true,
              items: List.generate(4, (index) {
                final colors = [
                  [Colors.blue.shade600, Colors.blue.shade800],
                  [Colors.green.shade600, Colors.green.shade800],
                  [Colors.orange.shade600, Colors.orange.shade800],
                  [Colors.purple.shade600, Colors.purple.shade800],
                ];
                final icons = [
                  Icons.headphones,
                  Icons.watch,
                  Icons.camera_alt,
                  Icons.laptop,
                ];
                final titles = [
                  'Premium Headphones',
                  'Smart Watch',
                  'Pro Camera',
                  'Gaming Laptop',
                ];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: colors[index],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons[index], size: 80, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        titles[index],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    ),
    PresetInfo(
      name: 'Testimonials',
      description: 'Glass mode with scale transition',
      code: '''KruiCarousel(
  items: [...],
  styleMode: CarouselStyleMode.glass,
  transitionType: CarouselTransitionType.scale,
  indicatorType: CarouselIndicatorType.dots,
  arrowsOnHover: true,
)''',
      builder: () {
        return Center(
          child: SizedBox(
            width: 600,
            child: KruiCarousel(
              height: 300,
              styleMode: CarouselStyleMode.glass,
              transitionType: CarouselTransitionType.scale,
              transitionDuration: const Duration(milliseconds: 600),
              indicatorType: CarouselIndicatorType.dots,
              arrowsOnHover: true,
              items: [
                _buildTestimonialCard(
                  '"This carousel is absolutely stunning! The animations are so smooth."',
                  'Sarah Johnson',
                  'UI/UX Designer',
                  Colors.indigo,
                ),
                _buildTestimonialCard(
                  '"The customization options are incredible. Perfect for any project!"',
                  'Michael Chen',
                  'Frontend Developer',
                  Colors.teal,
                ),
                _buildTestimonialCard(
                  '"Performance is amazing, even with complex layouts. Highly recommend!"',
                  'Emily Rodriguez',
                  'Product Manager',
                  Colors.deepPurple,
                ),
              ],
            ),
          ),
        );
      },
    ),
    PresetInfo(
      name: 'Story Carousel',
      description: 'Simple mode with cube transition',
      code: '''KruiCarousel(
  items: [...],
  styleMode: CarouselStyleMode.simple,
  transitionType: CarouselTransitionType.cube,
  indicatorType: CarouselIndicatorType.numbers,
  autoPlay: true,
)''',
      builder: () {
        return Center(
          child: SizedBox(
            width: 400,
            child: KruiCarousel(
              aspectRatio: 9 / 16,
              styleMode: CarouselStyleMode.simple,
              backgroundColor: Colors.black,
              transitionType: CarouselTransitionType.cube,
              transitionDuration: const Duration(milliseconds: 700),
              indicatorType: CarouselIndicatorType.numbers,
              indicatorPosition: IndicatorPosition.top,
              autoPlay: true,
              autoPlayDuration: const Duration(seconds: 5),
              items: [
                _buildStoryCard(
                  'Adventure Awaits',
                  'Explore the unknown',
                  Icons.explore,
                  [Colors.orange.shade700, Colors.red.shade700],
                ),
                _buildStoryCard(
                  'Create Magic',
                  'Turn ideas into reality',
                  Icons.auto_fix_high,
                  [Colors.purple.shade700, Colors.pink.shade700],
                ),
                _buildStoryCard(
                  'Connect & Share',
                  'Build meaningful connections',
                  Icons.people_alt,
                  [Colors.blue.shade700, Colors.cyan.shade700],
                ),
              ],
            ),
          ),
        );
      },
    ),
  ],
  demoBuilder: () {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade900, Colors.purple.shade900],
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 700,
          child: KruiCarousel(
            height: 300,
            styleMode: CarouselStyleMode.glass,
            autoPlay: true,
            autoPlayDuration: const Duration(seconds: 4),
            transitionType: CarouselTransitionType.slide,
            indicatorType: CarouselIndicatorType.dots,
            arrowsOnHover: true,
            items: [
              _buildDemoCard(
                'Dual Styling',
                'Choose glass or simple mode',
                Icons.palette,
                [Colors.blue.shade600, Colors.blue.shade800],
              ),
              _buildDemoCard(
                '7 Transitions',
                'Slide, fade, scale, cube & more',
                Icons.animation,
                [Colors.purple.shade600, Colors.purple.shade800],
              ),
              _buildDemoCard(
                'Auto-Play',
                'Smart pause on interaction',
                Icons.play_circle,
                [Colors.pink.shade600, Colors.pink.shade800],
              ),
              _buildDemoCard(
                'Fully Accessible',
                'Keyboard & gesture support',
                Icons.accessibility_new,
                [Colors.indigo.shade600, Colors.indigo.shade800],
              ),
            ],
          ),
        ),
      ),
    );
  },
);

Widget _buildTestimonialCard(
  String quote,
  String name,
  String title,
  Color accentColor,
) {
  return Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accentColor.withValues(alpha: 0.7),
          accentColor.withValues(alpha: 0.4),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.format_quote, size: 48, color: Colors.white70),
        const SizedBox(height: 16),
        Text(
          quote,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    ),
  );
}

Widget _buildStoryCard(
  String title,
  String subtitle,
  IconData icon,
  List<Color> colors,
) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 100, color: Colors.white),
        const SizedBox(height: 32),
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDemoCard(
  String title,
  String description,
  IconData icon,
  List<Color> colors,
) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 72, color: Colors.white),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    ),
  );
}
