# Contributing to kr_ui

First off, thank you for considering contributing to kr_ui! 🎉

We're building the best glassmorphic UI, Elegant, Simple, Clean UI component library for Flutter, and we'd love your help. Whether you're fixing bugs, adding components, improving documentation, or sharing ideas, every contribution matters.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Component Guidelines](#component-guidelines)
- [Submitting a Pull Request](#submitting-a-pull-request)
- [Community](#community)

---

## 🤝 Code of Conduct

This project follows a simple principle: **Be kind and respectful.**

- Use welcoming and inclusive language
- Respect differing viewpoints
- Accept constructive criticism gracefully
- Focus on what's best for the community

---

## 💡 How Can I Contribute?

### 1. Report Bugs 🐛

Found a bug? Please [open an issue](https://github.com/RittikSoni/kr_ui/issues/new) with:

- **Clear title** - Describe the bug in one sentence
- **Steps to reproduce** - How can we see the bug?
- **Expected behavior** - What should happen?
- **Actual behavior** - What actually happens?
- **Screenshots** - If applicable
- **Environment** - Flutter version, device, OS

**Example:**
```
Title: GlassyCard border not showing on iOS

Steps to reproduce:
1. Create a GlassyCard with default settings
2. Run on iPhone 15 simulator
3. Border is invisible

Expected: White border with 0.2 opacity
Actual: No visible border

Flutter: 3.27.0
Device: iPhone 15 Simulator (iOS 17.0)
```

### 2. Suggest Features ✨

Have an idea? [Open a feature request](https://github.com/RittikSoni/kr_ui/issues/new) with:

- **What** - Describe the feature
- **Why** - Explain the use case
- **How** - Suggest implementation (optional)
- **Examples** - Show similar features (optional)

### 3. Add Components 🎨

Want to add a new glassmorphic component? Awesome! See [Component Guidelines](#component-guidelines) below.

### 4. Improve Documentation 📚

- Fix typos or unclear explanations
- Add code examples
- Create tutorials or guides
- Translate documentation

### 5. Help Others 💬

- Answer questions in [Issues](https://github.com/RittikSoni/kr_ui/issues)
- Join our [Discord](https://discord.gg/Tmn6BKwSnr)
- Share your kr_ui projects

---

## 🚀 Getting Started

### Prerequisites

- Flutter 3.27.0 or higher
- Dart 3.6.0 or higher
- Git

### Setup Development Environment

1. **Fork the repository**

   Click the "Fork" button on GitHub

2. **Clone your fork**

   ```bash
   git clone https://github.com/YOUR_USERNAME/kr_ui.git
   cd kr_ui
   ```

3. **Install Melos** (optional but recommended)

   ```bash
   dart pub global activate melos
   ```

4. **Bootstrap the workspace**

   ```bash
   # With Melos
   melos bootstrap
   
   # Or without Melos
   flutter pub get
   ```

5. **Run the showcase app**

   ```bash
   # With Melos
   melos run demo
   
   # Or manually
   cd apps/showcase_app
   flutter run
   ```

---

## 🔧 Development Workflow

### Project Structure

```
kr_ui/
├── packages/
│   └── kr_ui/              # Main package
│       ├── lib/
│       │   ├── kr_ui.dart  # Barrel export
│       │   └── src/        # Components
│       └── test/           # Tests
│
└── apps/
    └── kr_ui_docs/       # Demo app
        └── lib/
```

### Making Changes

1. **Create a branch**

   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/bug-description
   ```

   Branch naming:
   - `feature/` - New components or features
   - `fix/` - Bug fixes
   - `docs/` - Documentation changes
   - `refactor/` - Code improvements

2. **Make your changes**

   - Edit files in `packages/kr_ui/lib/src/`
   - Add tests in `packages/kr_ui/test/`
   - Update showcase app if needed

3. **Test your changes**

   ```bash
   # Run tests
   melos run test
   
   # Analyze code
   melos run analyze
   
   # Format code
   melos run format
   
   # Run showcase app
   melos run demo
   ```

4. **Commit your changes**

   ```bash
   git add .
   git commit -m "feat: add GlassyBottomSheet component"
   ```

   Commit message format:
   - `feat:` - New feature
   - `fix:` - Bug fix
   - `docs:` - Documentation
   - `style:` - Formatting
   - `refactor:` - Code restructuring
   - `test:` - Adding tests
   - `chore:` - Maintenance

---

## 🎨 Component Guidelines

When creating a new component, follow these principles:

### Design Principles

1. **Glassmorphic First** - You can use blur/frosted glass effects
2. **Fully Customizable** - Every visual aspect should be configurable
3. **Sensible Defaults** - Work beautifully out of the box
4. **iOS-Inspired** - Follow Apple's design language
5. **Zero Dependencies** - Pure Flutter only

### Code Requirements

#### 1. Comprehensive Documentation

```dart
/// A beautiful glassmorphic [your component] widget.
///
/// [Detailed description of what it does and when to use it]
///
/// ## Basic Usage
///
/// ```dart
/// YourComponent(
///   child: Text('Example'),
/// )
/// ```
///
/// ## Advanced Usage
///
/// ```dart
/// YourComponent(
///   blur: 15,
///   opacity: 0.2,
///   // ... more examples
/// )
/// ```
///
/// ## Parameters
///
/// - [param1] - Description
/// - [param2] - Description
class YourComponent extends StatelessWidget {
  // ...
}
```

#### 2. Full Customization Options

Minimum customizable properties:
- `blur` - Blur intensity
- `opacity` - Glass opacity
- `color` - Tint color
- `borderRadius` - Corner radius
- `border` - Custom border
- `padding` - Internal padding
- `margin` - External margin

#### 3. Preset Configurations

Provide common presets:

```dart
class YourComponentPresets {
  static YourComponent subtle({required Widget child}) {
    return YourComponent(blur: 5, opacity: 0.1, child: child);
  }
  
  static YourComponent standard({required Widget child}) {
    return YourComponent(blur: 10, opacity: 0.15, child: child);
  }
  
  static YourComponent strong({required Widget child}) {
    return YourComponent(blur: 20, opacity: 0.25, child: child);
  }
}
```

#### 4. Tests

Add comprehensive tests in `packages/kr_ui/test/`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kr_ui/kr_ui.dart';

void main() {
  group('YourComponent', () {
    test('renders correctly with default values', () {
      // Test implementation
    });
    
    test('applies custom blur correctly', () {
      // Test implementation
    });
    
    // More tests...
  });
}
```

#### 5. Showcase Integration

Add your component to the showcase app at `apps/showcase_app/lib/main.dart`:

```dart
// In ComponentsPage class
YourComponent(
  child: Text('Example'),
)
```

### File Structure for New Component

```
packages/kr_ui/lib/src/
└── your_component.dart

packages/kr_ui/test/
└── your_component_test.dart

packages/kr_ui/lib/kr_ui.dart  (add export)
```

### Example Component Template

```dart
import 'dart:ui';
import 'package:flutter/material.dart';

/// A beautiful glassmorphic [component name].
///
/// [Description and use cases]
class GlassyYourComponent extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius? borderRadius;
  // ... other properties

  const GlassyYourComponent({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.15,
    this.color = Colors.white,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    
    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha:opacity),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: Colors.white.withValues(alpha:0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

---

## 📤 Submitting a Pull Request

### Before Submitting

- [ ] Code follows our style guide
- [ ] All tests pass (`melos run test`)
- [ ] Code is formatted (`melos run format`)
- [ ] No analyzer warnings (`melos run analyze`)
- [ ] Documentation is updated
- [ ] Showcase app demonstrates the feature
- [ ] CHANGELOG.md is updated (if applicable)

### PR Process

1. **Push your branch**

   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request**

   - Go to your fork on GitHub
   - Click "New Pull Request"
   - Fill in the template

3. **PR Title Format**

   ```
   feat: add GlassyBottomSheet component
   fix: GlassyCard border rendering on iOS
   docs: improve GlassyButton examples
   ```

4. **PR Description Template**

   ```markdown
   ## What does this PR do?
   [Describe the changes]
   
   ## Why?
   [Explain the motivation]
   
   ## Screenshots (if applicable)
   [Add before/after screenshots]
   
   ## Checklist
   - [ ] Tests added/updated
   - [ ] Documentation updated
   - [ ] Showcase app updated
   - [ ] No breaking changes
   ```

5. **Review Process**

   - Maintainers will review within 2-3 days
   - Address feedback promptly
   - Once approved, we'll merge!

---

## 👥 Community

### Get Help

- **Discord**: Join our [community](https://discord.gg/Tmn6BKwSnr)
- **GitHub Issues**: Ask questions
- **YouTube**: Watch [King Rittik's tutorials](https://www.youtube.com/@king_rittik)

### Stay Updated

- Star the repo ⭐
- Watch releases 👀
- Follow [@king_rittik](https://www.youtube.com/@king_rittik)

---

## 🎉 Recognition

Contributors are recognized in:

- README.md Contributors section
- Docs app credits
- Discord special role

**Top contributors get:**
- Highlighted in release announcements
- Featured on YouTube channel
- Early access to new features

---

## 📝 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## 🙏 Thank You!

Every contribution, no matter how small, helps make kr_ui better for everyone. We appreciate your time and effort! 💙

**Happy coding!** 🚀

— The kr_ui Team & King Rittik Community

<p>
  <picture>
    <source srcset="https://play-lh.googleusercontent.com/p6s0DYPgQHCfejiSGb74dLboalBXLgVQEVgxu9xQ3L3Emo24k7MstpBS0tty-5f3_YY" type="image/png">
    <img src="https://play-lh.googleusercontent.com/p6s0DYPgQHCfejiSGb74dLboalBXLgVQEVgxu9xQ3L3Emo24k7MstpBS0tty-5f3_YY" alt="King Rittik Logo: YouTube" width="120" />
  </picture>
</p>
