import 'package:flutter/material.dart';

/// Validator function type: returns error message or null if valid.
typedef KruiFormValidator = String? Function(dynamic value);

/// Single source of truth for form state: initial values, current values,
/// errors, and optional per-field validators.
///
/// **Linking fields**: Each form control is linked by a **field key** (string),
/// e.g. `'email'`, `'password'`. Use the same key in [initialValues],
/// [getValue]/[setValue], [getError]/[setValue], and in [validate]. Text fields
/// use [name] or [id]; other widgets wire `value: getValue('key')` and
/// `onChanged: (v) => setValue('key', v)`.
///
/// Use with [KruiForm] so descendants can bind by that key. Supports:
/// - **Initial values**: pass [initialValues] to pre-fill the form.
/// - **Current state**: read [values] or [getValue] anytime; use [getTextController]
///   for text fields so the controller stays in sync.
/// - **Validation**: call [validate] with a map of field names to validators;
///   errors are stored and can be read via [getError].
/// - **Reset**: [reset] restores [values] from [initialValues] and clears errors.
///
/// For non-text fields (e.g. [KruiSelect], [KruiCheckbox], [KruiSwitch]), wire
/// `value: controller.getValue('field')` and `onChanged: (v) => controller.setValue('field', v)`.
///
/// Optimized: only widgets that depend on this controller (e.g. via [KruiForm.of])
/// and that use [getValue]/[getError] will rebuild when [setValue]/[setError]
/// or [notifyListeners] is called. Dispose the controller when the form is
/// no longer needed (e.g. in State.dispose).
class KruiFormController extends ChangeNotifier {
  KruiFormController({Map<String, dynamic>? initialValues})
      : _initialValues = Map<String, dynamic>.from(initialValues ?? {}),
        _values = Map<String, dynamic>.from(initialValues ?? {});

  final Map<String, dynamic> _initialValues;
  final Map<String, dynamic> _values;
  final Map<String, String?> _errors = {};
  final Map<String, TextEditingController> _textControllers = {};

  /// Current form values (mutable copy; prefer [getValue] / [setValue] for single fields).
  Map<String, dynamic> get values => Map.unmodifiable(_values);

  /// Initial values passed at construction.
  Map<String, dynamic> get initialValues => Map.unmodifiable(_initialValues);

  /// Get current value for [name]. Returns [initialValues][name] if not yet set.
  dynamic getValue(String name) {
    if (_values.containsKey(name)) return _values[name];
    return _initialValues[name];
  }

  /// Set value for [name] and notify listeners. Syncs text controller if present.
  void setValue(String name, dynamic value) {
    if (_values[name] == value) return;
    _values[name] = value;
    _errors.remove(name);
    final tc = _textControllers[name];
    if (tc != null && value is String && tc.text != value) {
      tc.text = value;
      tc.selection = TextSelection.collapsed(offset: value.length);
    }
    notifyListeners();
  }

  /// Get error message for [name], if any.
  String? getError(String name) => _errors[name];

  /// Set error for [name]. Pass null to clear.
  void setError(String name, String? error) {
    if (_errors[name] == error) return;
    if (error == null) {
      _errors.remove(name);
    } else {
      _errors[name] = error;
    }
    notifyListeners();
  }

  /// Clear all errors.
  void clearErrors() {
    if (_errors.isEmpty) return;
    _errors.clear();
    notifyListeners();
  }

  /// Get a [TextEditingController] for [name], creating and syncing with [values] if needed.
  /// Use this when building a text field bound to this form so the field stays in sync.
  /// The controller is owned by this [KruiFormController] and disposed in [dispose].
  TextEditingController getTextController(String name) {
    var tc = _textControllers[name];
    if (tc == null) {
      final initial = _values[name] ?? _initialValues[name];
      final text = initial is String ? initial : (initial?.toString() ?? '');
      tc = TextEditingController(text: text);
      tc.addListener(() {
        final v = tc!.text;
        if (_values[name] != v) {
          _values[name] = v;
          _errors.remove(name);
          notifyListeners();
        }
      });
      _textControllers[name] = tc;
    }
    return tc;
  }

  /// Run [validators] and set errors. Returns true if all pass.
  bool validate(Map<String, KruiFormValidator> validators) {
    bool allValid = true;
    for (final e in validators.entries) {
      final name = e.key;
      final v = e.value(getValue(name));
      setError(name, v);
      if (v != null && v.isNotEmpty) allValid = false;
    }
    return allValid;
  }

  /// Reset form to [initialValues] and clear errors. Syncs text controllers.
  void reset() {
    _values.clear();
    _values.addAll(_initialValues);
    _errors.clear();
    for (final e in _textControllers.entries) {
      final name = e.key;
      final initial = _initialValues[name];
      final text = initial is String ? initial : (initial?.toString() ?? '');
      e.value.text = text;
      e.value.selection = TextSelection.collapsed(offset: text.length);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (final tc in _textControllers.values) {
      tc.dispose();
    }
    _textControllers.clear();
    super.dispose();
  }
}
