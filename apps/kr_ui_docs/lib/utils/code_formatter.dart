import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Professional code block widget with isolate-based syntax highlighting
class CodeFormatter {
  /// Format Dart code with syntax highlighting using an isolate
  static Future<TextSpan> formatDartCodeAsync(String code,
      {bool isDark = false}) async {
    return compute(_formatDartCodeWorker, {
      'code': code,
      'isDark': isDark,
    });
  }

  /// Synchronous version for legacy support or very small snippets
  static TextSpan formatDartCode(String code, {bool isDark = false}) {
    return _formatDartCodeWorker({'code': code, 'isDark': isDark});
  }

  /// Worker function that runs in the isolate
  static TextSpan _formatDartCodeWorker(Map<String, dynamic> params) {
    final String code = params['code'] as String;
    final bool isDark = params['isDark'] as bool;

    final List<TextSpan> spans = [];
    final lines = code.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      spans.addAll(_highlightLine(line, isDark));

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(
      style: AppTheme.codeMedium.copyWith(
        color:
            isDark ? Colors.white.withValues(alpha: 0.9) : AppTheme.textPrimary,
        height: 1.5,
      ),
      children: spans,
    );
  }

  static List<TextSpan> _highlightLine(String line, bool isDark) {
    final List<TextSpan> spans = [];

    if (line.trimLeft().startsWith('//')) {
      spans.add(TextSpan(
        text: line,
        style: TextStyle(
          color: isDark ? Colors.grey : AppTheme.codeComment,
          fontStyle: FontStyle.italic,
        ),
      ));
      return spans;
    }

    final tokens = _tokenize(line);

    for (final token in tokens) {
      spans.add(TextSpan(
        text: token.text,
        style: TextStyle(color: _getColorForToken(token, isDark)),
      ));
    }

    return spans;
  }

  static List<_Token> _tokenize(String line) {
    final List<_Token> tokens = [];
    final buffer = StringBuffer();
    bool inString = false;
    String? stringChar;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if ((char == '"' || char == "'") && (i == 0 || line[i - 1] != '\\')) {
        if (!inString) {
          if (buffer.isNotEmpty) {
            tokens.add(
                _Token(buffer.toString(), _getTokenType(buffer.toString())));
            buffer.clear();
          }
          inString = true;
          stringChar = char;
          buffer.write(char);
        } else if (char == stringChar) {
          buffer.write(char);
          tokens.add(_Token(buffer.toString(), _TokenType.string));
          buffer.clear();
          inString = false;
          stringChar = null;
        } else {
          buffer.write(char);
        }
      } else if (inString) {
        buffer.write(char);
      } else if (_isWordBoundary(char)) {
        if (buffer.isNotEmpty) {
          tokens
              .add(_Token(buffer.toString(), _getTokenType(buffer.toString())));
          buffer.clear();
        }
        tokens.add(_Token(char, _TokenType.other));
      } else {
        buffer.write(char);
      }
    }

    if (buffer.isNotEmpty) {
      tokens.add(_Token(
        buffer.toString(),
        inString ? _TokenType.string : _getTokenType(buffer.toString()),
      ));
    }

    return tokens;
  }

  static bool _isWordBoundary(String char) {
    return ' (){}[],;:!=<>!+-*/.?'.contains(char);
  }

  static _TokenType _getTokenType(String word) {
    if (_keywords.contains(word)) return _TokenType.keyword;
    if (_types.contains(word)) return _TokenType.type;
    if (double.tryParse(word) != null) return _TokenType.number;
    if (_constants.contains(word)) return _TokenType.constant;
    return _TokenType.other;
  }

  static Color _getColorForToken(_Token token, bool isDark) {
    if (isDark) {
      switch (token.type) {
        case _TokenType.keyword:
          return const Color(0xFFCC7832);
        case _TokenType.string:
          return const Color(0xFF6A8759);
        case _TokenType.number:
          return const Color(0xFF6897BB);
        case _TokenType.type:
          return const Color(0xFFFFC66D);
        case _TokenType.constant:
          return const Color(0xFF9876AA);
        case _TokenType.other:
          return Colors.white.withValues(alpha: 0.9);
      }
    } else {
      switch (token.type) {
        case _TokenType.keyword:
          return AppTheme.codeKeyword;
        case _TokenType.string:
          return AppTheme.codeString;
        case _TokenType.number:
          return AppTheme.codeNumber;
        case _TokenType.type:
          return AppTheme.codeClass;
        case _TokenType.constant:
          return AppTheme.codeFunction;
        case _TokenType.other:
          return AppTheme.textPrimary;
      }
    }
  }

  static const Set<String> _keywords = {
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'default',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'get',
    'if',
    'implements',
    'import',
    'in',
    'is',
    'late',
    'library',
    'new',
    'null',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'set',
    'static',
    'super',
    'switch',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'while',
    'with',
    'yield',
  };

  static const Set<String> _types = {
    'String',
    'int',
    'double',
    'bool',
    'List',
    'Map',
    'Set',
    'Widget',
    'BuildContext',
    'State',
    'StatelessWidget',
    'StatefulWidget',
    'Key',
    'Color',
    'EdgeInsets',
    'BoxDecoration',
    'BorderRadius',
    'TextStyle',
    'MainAxisAlignment',
    'CrossAxisAlignment',
    'Alignment',
    'Icon',
    'Text',
    'Container',
    'Row',
    'Column',
    'Padding',
    'Center',
    'SizedBox',
    'Offset',
    'Border',
    'VoidCallback',
    'Duration',
    'Curve',
    'Curves',
    'MaterialApp',
    'Scaffold',
    'AppBar',
    'FloatingActionButton',
    'IconData',
    'IconButton',
    'ElevatedButton',
    'TextButton',
    'OutlinedButton',
    'TextField',
    'Checkbox',
    'Radio',
    'Switch',
    'Slider',
    'AlertDialog',
    'SnackBar',
    'BottomSheet',
    'KruiGlassyCard',
    'KruiGlassyButton',
    'KruiCalendar',
    'KruiCalendarSelectionMode',
    'KruiCalendarThemeData',
    'KruiGlassyIconButton',
    'KruiSimpleIconButton',
    'KruiGlassyDialogAction',
    'KruiSimpleDialogAction',
    'GlassyCardPresets',
    'GlassyButtonPresets',
    'showKruiGlassyDialog',
    'showKruiSimpleDialog',
    'showKruiGlassySheet',
    'showKruiSimpleSheet',
    'KruiSheetPosition',
    'HapticType',
    'Colors',
    'FontWeight',
    'Icons',
    'MainAxisSize',
  };

  static const Set<String> _constants = {
    'Colors',
    'Icons',
    'FontWeight',
    'MainAxisSize',
    'CrossAxisAlignment',
    'MainAxisAlignment',
    'TileMode',
  };
}

class _Token {
  final String text;
  final _TokenType type;
  _Token(this.text, this.type);
}

enum _TokenType {
  keyword,
  type,
  string,
  number,
  constant,
  other,
}
