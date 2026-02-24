import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:http/http.dart' as http;
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_highlighter/themes/atom-one-light.dart';

class ReadmeTab extends StatefulWidget {
  final PackageEntity packageInfo;
  const ReadmeTab({super.key, required this.packageInfo});

  @override
  State<ReadmeTab> createState() => _ReadmeTabState();
}

class _ReadmeTabState extends State<ReadmeTab> {
  String? _markdownData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchReadmeNatively();
  }

  Future<void> _fetchReadmeNatively() async {
    try {
      final pkgUrl = Uri.parse(
        'https://pub.dev/api/packages/${widget.packageInfo.name}',
      );
      final pkgResponse = await http.get(pkgUrl);

      if (pkgResponse.statusCode != 200)
        throw Exception("Failed to fetch package details");

      final pkgData = json.decode(pkgResponse.body);
      final pubspec = pkgData['latest']['pubspec'];
      final repoUrl = pubspec['repository'] ?? pubspec['homepage'];

      if (repoUrl == null || !repoUrl.contains('github.com')) {
        throw Exception("No GitHub repository found for this package.");
      }

      final readmeUrlMain = _getRawMarkdownUrl(repoUrl, 'main');
      final readmeUrlMaster = _getRawMarkdownUrl(repoUrl, 'master');

      if (readmeUrlMain == null || readmeUrlMaster == null) {
        throw Exception("Could not parse GitHub repository URL.");
      }

      var mdResponse = await http.get(Uri.parse(readmeUrlMain));
      if (mdResponse.statusCode != 200) {
        mdResponse = await http.get(Uri.parse(readmeUrlMaster));
      }

      if (mdResponse.statusCode == 200) {
        if (mounted) {
          setState(() {
            _markdownData = mdResponse.body;
            _isLoading = false;
          });
        }
      } else {
        throw Exception("README.md not found in the repository.");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String? _getRawMarkdownUrl(String repoUrl, String branchFallback) {
    final uri = Uri.tryParse(repoUrl);
    if (uri == null || uri.host != 'github.com' || uri.pathSegments.length < 2)
      return null;

    final user = uri.pathSegments[0];
    final repo = uri.pathSegments[1];

    if (uri.pathSegments.length > 3 && uri.pathSegments[2] == 'tree') {
      final actualBranch = uri.pathSegments[3];
      final subfolderPath = uri.pathSegments.sublist(4).join('/');
      return "https://raw.githubusercontent.com/$user/$repo/$actualBranch/$subfolderPath/README.md";
    }

    return "https://raw.githubusercontent.com/$user/$repo/$branchFallback/README.md";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          "Could not load native README\n$_errorMessage",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return Markdown(
      data: _markdownData ?? "No README provided.",
      selectable: true,
      
      padding: const EdgeInsets.all(16.0),
      // 1. Register our custom Code Builder
      builders: {'code': CodeElementBuilder(context)},
      // 2. Remove default markdown styling for codeblocks so our highlighter takes full control
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        codeblockPadding: EdgeInsets.zero,
        codeblockDecoration: const BoxDecoration(color: Colors.transparent),
      ),
      onTapLink: (text, href, title) async {
        if (href != null) {
          final uri = Uri.parse(href);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
    );
  }
}

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
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white12
              : Colors.grey.shade200,
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
