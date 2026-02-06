import 'package:flutter/material.dart';
import 'krui_form_controller.dart';

/// Provides [KruiFormController] to descendants. Use [KruiForm.of] to obtain the controller.
///
/// Place form fields (e.g. [KruiTextField] with [name], or widgets wired via
/// [controller.getValue]/[controller.setValue]) as [child]. Then:
/// - Set **initial values** on the controller: `KruiFormController(initialValues: {...})`.
/// - Read **current state** via `controller.values` or `controller.getValue(name)`.
/// - **Validate** on submit: `if (controller.validate(validators)) { ... }`.
/// - **Reset** with `controller.reset()`.
class KruiForm extends StatelessWidget {
  const KruiForm({
    super.key,
    required this.controller,
    required this.child,
  });

  final KruiFormController controller;
  final Widget child;

  /// Returns the [KruiFormController] from the nearest [KruiForm] ancestor, or null.
  static KruiFormController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_KruiFormScope>()
        ?.controller;
  }

  @override
  Widget build(BuildContext context) {
    return _KruiFormScope(controller: controller, child: child);
  }
}

class _KruiFormScope extends InheritedWidget {
  const _KruiFormScope({required this.controller, required super.child});

  final KruiFormController controller;

  @override
  bool updateShouldNotify(_KruiFormScope oldWidget) =>
      controller != oldWidget.controller;
}
