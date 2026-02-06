import 'component_models.dart';
import '../registry/components/card.dart';
import '../registry/components/content_card.dart';
import '../registry/components/button.dart';
import '../registry/components/accordion.dart';
import '../registry/components/toast.dart';
import '../registry/components/snackbar.dart';
import '../registry/components/simple_button.dart';
import '../registry/components/glassy_dialog.dart';
import '../registry/components/simple_dialog.dart';
import '../registry/components/glassy_sheet.dart';
import '../registry/components/simple_sheet.dart';
import '../registry/components/glassy_icon_button.dart';
import '../registry/components/simple_icon_button.dart';
import '../registry/components/text_field.dart';
import '../registry/components/select.dart';
import '../registry/components/multi_select.dart';
import '../registry/components/radio.dart';
import '../registry/components/checkbox.dart';
import '../registry/components/switch.dart';
import '../registry/components/date_picker.dart';
import '../registry/components/calendar.dart';
import '../registry/components/time_picker.dart';
import '../registry/components/form.dart';

export 'component_models.dart';

/// Central registry of all kr_ui components
class ComponentRegistry {
  static final List<ComponentInfo> _components = [
    kruiGlassyCardInfo,
    kruiContentCardInfo,
    kruiGlassyButtonInfo,
    kruiSimpleButtonInfo,
    kruiGlassyIconButtonInfo,
    kruiSimpleIconButtonInfo,
    kruiGlassyDialogInfo,
    kruiSimpleDialogInfo,
    kruiGlassySheetInfo,
    kruiSimpleSheetInfo,
    kruiAccordionInfo,
    kruiToastInfo,
    kruiSnackbarInfo,
    kruiTextFieldInfo,
    kruiSelectInfo,
    kruiMultiSelectInfo,
    kruiRadioInfo,
    kruiCheckboxInfo,
    kruiSwitchInfo,
    kruiDatePickerInfo,
    kruiCalendarInfo,
    kruiTimePickerInfo,
    kruiFormInfo,
  ];

  /// Get all registered components
  static List<ComponentInfo> get all => List.unmodifiable(_components);

  /// Get all registered components (legacy)
  static List<ComponentInfo> get allComponents => all;

  /// Get components by category
  static List<ComponentInfo> getByCategory(String category) {
    if (category == 'All') return allComponents;
    return _components.where((c) => c.category == category).toList();
  }

  /// Get all unique categories
  static List<String> get categories {
    final cats = _components.map((c) => c.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  /// Search components by query
  static List<ComponentInfo> search(String query) {
    final lowerQuery = query.toLowerCase();
    return _components.where((component) {
      return component.displayName.toLowerCase().contains(lowerQuery) ||
          component.description.toLowerCase().contains(lowerQuery) ||
          component.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
