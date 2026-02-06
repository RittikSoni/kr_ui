import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../utils/code_formatter.dart';
import 'package:kr_ui/kr_ui.dart';

/// Professional code block widget with isolate-based syntax highlighting
class CodeBlock extends StatefulWidget {
  final String code;
  final String? language;
  final bool showLineNumbers;

  const CodeBlock({
    super.key,
    this.code = '',
    this.language,
    this.showLineNumbers = true,
  });

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _isCopied = false;
  TextSpan? _formattedSpan;
  bool _isFormatting = true;
  bool? _lastIsDark;

  @override
  void initState() {
    super.initState();
    // Background formatting will be triggered in build or via post frame callback
  }

  @override
  void didUpdateWidget(CodeBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.code != oldWidget.code ||
        widget.language != oldWidget.language) {
      _formattedSpan = null;
      _isFormatting = true;
      _lastIsDark = null;
    }
  }

  Future<void> _formatInIsolate(bool isDark) async {
    if (_formattedSpan != null && _lastIsDark == isDark) return;

    final span = await CodeFormatter.formatDartCodeAsync(
      widget.code,
      isDark: isDark,
    );

    if (mounted) {
      setState(() {
        _formattedSpan = span;
        _isFormatting = false;
        _lastIsDark = isDark;
      });
    }
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (mounted) {
      setState(() => _isCopied = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isCopied = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);

    // Trigger background formatting
    if (_formattedSpan == null || _lastIsDark != themeProvider.isDarkMode) {
      _formatInIsolate(themeProvider.isDarkMode);
    }

    return Container(
      decoration: BoxDecoration(
        color: dynamicTheme.codeBackground,
        borderRadius: AppTheme.borderRadiusMedium,
        border: Border.all(color: dynamicTheme.borderLight),
      ),
      child: Stack(
        children: [
          // Code Content
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.space20,
              AppTheme.space48,
              AppTheme.space20,
              AppTheme.space20,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RepaintBoundary(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Line Numbers
                    if (widget.showLineNumbers)
                      _buildLineNumbers(widget.code, dynamicTheme),
                    // Code
                    if (_isFormatting && _formattedSpan == null)
                      SizedBox(
                        width: 100,
                        child: Text(
                          widget.code,
                          style: AppTheme.codeMedium.copyWith(
                            color: dynamicTheme.textTertiary
                                .withValues(alpha: 0.3),
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    else if (_formattedSpan != null)
                      SelectableText.rich(_formattedSpan!)
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),

          // Tools (Copy button, language tag)
          Positioned(
            top: AppTheme.space8,
            right: AppTheme.space8,
            child: Row(
              children: [
                if (widget.language != null)
                  Container(
                    margin: const EdgeInsets.only(right: AppTheme.space8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space8,
                      vertical: AppTheme.space4,
                    ),
                    decoration: BoxDecoration(
                      color: dynamicTheme.primary.withValues(alpha: 0.1),
                      borderRadius: AppTheme.borderRadiusSmall,
                    ),
                    child: Text(
                      widget.language!.toUpperCase(),
                      style: AppTheme.label.copyWith(
                        color: dynamicTheme.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                KruiGlassyButton(
                  onPressed: _copyToClipboard,
                  padding: const EdgeInsets.all(AppTheme.space8),
                  blur: 4,
                  opacity: 0.1,
                  child: Icon(
                    _isCopied ? Icons.check : Icons.content_copy,
                    size: 16,
                    color:
                        _isCopied ? AppTheme.accentGreen : dynamicTheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // Loading Indicator for very large blocks
          if (_isFormatting && _formattedSpan == null)
            Positioned(
              bottom: 8,
              right: 8,
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    dynamicTheme.primary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLineNumbers(String code, DynamicTheme dynamicTheme) {
    final lines = code.split('\n');
    final lineCount = lines.length;
    final lineNumbers =
        Iterable.generate(lineCount, (i) => '${i + 1}').join('\n');

    return Container(
      padding: const EdgeInsets.only(right: AppTheme.space16),
      margin: const EdgeInsets.only(right: AppTheme.space16),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: dynamicTheme.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Text(
        lineNumbers,
        style: AppTheme.codeMedium.copyWith(
          color: dynamicTheme.textTertiary.withValues(alpha: 0.5),
          height: 1.5,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
