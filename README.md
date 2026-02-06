# kr_ui

<div align="center">

**Premium glassmorphic UI components for Flutter**

Beautiful, customizable iOS-style glass effects. Pure Flutter. Zero dependencies.

<!-- [![pub package](https://img.shields.io/pub/v/kr_ui.svg)](https://pub.dev/packages/kr_ui)
[![likes](https://img.shields.io/pub/likes/kr_ui)](https://pub.dev/packages/kr_ui)
[![popularity](https://img.shields.io/pub/popularity/kr_ui)](https://pub.dev/packages/kr_ui)
[![pub points](https://img.shields.io/pub/points/kr_ui)](https://pub.dev/packages/kr_ui/score) -->

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](/packages/kr_ui/LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.27%2B-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6%2B-0175C2?logo=dart)](https://dart.dev)

[Get Started](#-installation) • [Components](#-components) • [Examples](#-examples) • [Community](#-community)

<img src="screenshots/hero.png" alt="kr_ui Components" width="100%">

</div>

---

## ✨ Features

- 🎨 **Beautiful Glassmorphism** - iOS-style frosted glass effects
- 🎨 **Elegant Simple & Clean UI** : quick and easy to use.
- 🔧 **Fully Customizable** - Control blur, opacity, colors, borders
- ⚡ **Zero Dependencies** - Pure Flutter implementation
- 📱 **Production Ready** - Battle-tested components
- 🎯 **Easy to Use** - Clean API with sensible defaults
- 📚 **Well Documented** - Comprehensive examples and guides

---

## 📦 Installation

Add kr_ui to your `pubspec.yaml`:

```yaml
dependencies:
  kr_ui: <latest_version>
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Stack(
            children: [
              // Background image
              Image.network(
                'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              
              // Glassy card on top
              Center(
                child: KruiGlassyCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'Glassmorphism',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Beautiful frosted glass effects'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🧩 Components & Roadmap

[x] KruiAccordion

[x] KruiGlassyCard

[x] KruiContentCard


[x] KruiGlassyButton

[x] KruiSimpleButton

[x] KruiGlassyIconButton

[x] KruiSimpleIconButton

[x] KruiToast

[x] KruiSnackbar

[x] KruiForm

[x] KruiTextField

[x] KruiSelect

[x] KruiMultiSelect

[x] KruiRadioGroup

[x] KruiCheckbox

[x] KruiSwitch

[x] KruiDatePicker

[x] KruiCalendar

[x] KruiTimePicker

[x] showKruiGlassyDialog

[x] showKruiSimpleDialog

[x] showKruiGlassySheet

[x] showKruiSimpleSheet

---

## 🎬 Live Demo

Try out all components in our interactive showcase app:

**[Launch Showcase App](https://kingrittik.github.io/kr_ui)** (Coming Soon)

Or run locally:

```bash
git clone https://github.com/RittikSoni/kr_ui.git
cd kr_ui
melos bootstrap
cd apps/kr_ui_docs
flutter run -d chrome
```

---

## 📱 Platform Support

| Platform | Supported |
|----------|-----------|
| iOS | ✅ |
| Android | ✅ |
| Web | ✅ |
| macOS | ✅ |
| Windows | ✅ |
| Linux | ✅ |

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

**Ways to contribute:**
- 🐛 Report bugs
- ✨ Suggest new components
- 🎨 Submit new designs
- 📚 Improve documentation
- 💬 Help others in discussions

---

## 👥 Community

Join the kr_ui community:

- 💬 **Discord**: [Join Server](https://discord.gg/Tmn6BKwSnr)
- 🎥 **YouTube**: [@king_rittik](https://www.youtube.com/@king_rittik)
- 🐛 **Issues**: [GitHub Issues](https://github.com/RittikSoni/kr_ui/issues)
- 💡 **Discussions**: [GitHub Discussions](https://github.com/RittikSoni/kr_ui/discussions)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

Created with ❤️ by [King Rittik](https://www.youtube.com/@king_rittik)

Inspired by:
- iOS glassmorphism design
- Flutter's Material Design 3
- The amazing Flutter community

---

## ⭐ Show Your Support

If you like kr_ui, please give it a star on GitHub and like it on pub.dev! It helps others discover this package.

[![GitHub stars](https://img.shields.io/github/stars/kingrittik/kr_ui?style=social)](https://github.com/RittikSoni/kr_ui)

---

<div align="center">

**Built with Flutter 💙**

Made by [King Rittik](https://www.youtube.com/@king_rittik) for the Flutter community

</div>
