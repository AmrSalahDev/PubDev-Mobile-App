import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_highlighter/themes/atom-one-light.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

/// A Custom Element Builder that intercepts `<code>` tags and applies syntax highlighting
class CodeElementBuilder extends MarkdownElementBuilder {
  final BuildContext context;
  CodeElementBuilder(this.context);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    String language = '';

    // Extract the language if the codeblock has one (e.g. ```dart)
    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      if (lg.startsWith('language-')) {
        language = lg.substring(9);
      }
    }

    // Determine if it is inline code or a code block
    bool isInline = !element.textContent.contains('\n') && language.isEmpty;

    if (isInline) {
      // Styling for inline code (`like this`)
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          element.textContent,
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Colors.redAccent,
          ),
        ),
      );
    }

    // Styling for Code Blocks (multiline with syntax highlighting)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias, // Applies the border radius perfectly
      child: HighlightView(
        element.textContent.trim(), // Remove trailing newlines
        language: language.isEmpty
            ? 'dart'
            : language, // Default to dart if unspecified
        theme: isDark
            ? atomOneDarkTheme
            : atomOneLightTheme, // Automatically switch based on Dark/Light mode
        padding: const EdgeInsets.all(16),
        textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 14),
      ),
    );
  }
}
