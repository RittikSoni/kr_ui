import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final ComponentInfo kruiRippleRevealInfo = ComponentInfo(
  id: 'ripple-reveal',
  name: 'KruiRippleReveal',
  displayName: 'Ripple Reveal',
  description:
      'Unique tap-to-reveal animation with circular ripple originating from exact tap position.',
  category: 'Animation',
  icon: Icons.radio_button_unchecked,
  properties: const [
    PropertyInfo(
      name: 'revealChild',
      type: 'Widget',
      defaultValue: 'required',
      description: 'Widget to show when revealed.',
    ),
    PropertyInfo(
      name: 'hiddenChild',
      type: 'Widget?',
      defaultValue: 'null',
      description: 'Widget to show when hidden. Shows default icon if null.',
    ),
    PropertyInfo(
      name: 'initiallyRevealed',
      type: 'bool',
      defaultValue: 'false',
      description: 'Initial reveal state.',
    ),
    PropertyInfo(
      name: 'duration',
      type: 'Duration',
      defaultValue: '600ms',
      description: 'Animation duration.',
    ),
    PropertyInfo(
      name: 'allowReverse',
      type: 'bool',
      defaultValue: 'true',
      description: 'Allow tap to hide after revealing.',
    ),
    PropertyInfo(
      name: 'rippleColor',
      type: 'Color?',
      defaultValue: 'null',
      description: 'Optional color overlay during ripple.',
    ),
  ],
  basicExample: '''KruiRippleReveal(
  revealChild: Image.asset('secret.jpg'),
  hiddenChild: Container(color: Colors.grey),
)''',
  advancedExample: '''KruiRippleReveal(
  revealChild: Image.network('beautiful-image.jpg'),
  hiddenChild: Container(
    color: Colors.black87,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.visibility_off, size: 48),
        SizedBox(height: 16),
        Text('Tap to reveal', style: TextStyle(fontSize: 18)),
      ],
    ),
  ),
  duration: Duration(milliseconds: 800),
  rippleColor: Colors.blue,
  allowReverse: true,
  onTap: (revealed) => print('Revealed: \$revealed'),
)''',
  presets: [
    PresetInfo(
      name: 'Image Gallery',
      description: 'Tap to reveal next image',
      code: '''KruiRippleReveal(
  revealChild: YourImage(),
  hiddenChild: PlaceholderWidget(),
);''',
      builder: () {
        return SizedBox(
          height: 300,
          child: KruiRippleReveal(
            revealChild: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 64, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      '✨ Revealed!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            hiddenChild: Container(
              color: Colors.grey.shade800,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app, size: 64, color: Colors.white70),
                    const SizedBox(height: 16),
                    Text(
                      'TAP ANYWHERE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'to reveal hidden content',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
    PresetInfo(
      name: 'Spoiler Content',
      description: 'Hide/reveal spoiler text',
      code: '''KruiRippleReveal(
  revealChild: Text('Secret!'),
  hiddenChild: Text('SPOILER'),
  rippleColor: Colors.amber,
);''',
      builder: () {
        return SizedBox(
          height: 200,
          child: KruiRippleReveal(
            revealChild: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: const Center(
                child: Text(
                  '🎉 Secret Message Revealed!\n\nThis is hidden until you tap!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            hiddenChild: Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '⚠️ SPOILER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to reveal',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            rippleColor: Colors.amber,
          ),
        );
      },
    ),
    PresetInfo(
      name: 'Quiz Card',
      description: 'Interactive quiz question with answer reveal',
      code: '''KruiRippleReveal(
  revealChild: AnswerCard(),
  hiddenChild: QuestionCard(),
);''',
      builder: () => const _QuizCardDemo(),
    ),
  ],
  demoBuilder: () {
    return SizedBox(
      height: 300,
      child: KruiRippleReveal(
        revealChild: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade400, Colors.purple.shade400],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, size: 80, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'You revealed it!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        hiddenChild: Container(
          color: Colors.grey.shade900,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app, size: 64, color: Colors.white24),
                const SizedBox(height: 16),
                Text(
                  'TAP ANYWHERE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'to see the ripple effect',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        duration: const Duration(milliseconds: 700),
        rippleColor: Colors.blue,
      ),
    );
  },
);

// Quiz Card Demo
class _QuizCardDemo extends StatelessWidget {
  const _QuizCardDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: KruiRippleReveal(
        revealChild: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green.shade400, Colors.teal.shade600],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 60, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                '✓ Correct!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Paris is the capital of France',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Tap again to see question',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        hiddenChild: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo.shade700, Colors.purple.shade800],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Question:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'What is the capital of France?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Icon(Icons.help_outline,
                  size: 48, color: Colors.white.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app, size: 20, color: Colors.white70),
                    const SizedBox(width: 8),
                    const Text(
                      'TAP TO REVEAL ANSWER',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        rippleColor: Colors.green,
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}
