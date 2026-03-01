import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:pub_dev_packages_app/core/utils/app_utils.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/widgets/code_element_builder.dart';

class ReadmeTab extends StatelessWidget {
  final PackageEntity packageInfo;
  const ReadmeTab({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    if (packageInfo.readme.isEmpty) {
      final repoUrl =
          packageInfo.latest.pubspec.repository ??
          packageInfo.latest.pubspec.homepage;

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 64,
                color: Colors.grey.withAlpha(100),
              ),
              const SizedBox(height: 24),
              const Text(
                "NATIVE README UNAVAILABLE",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "We couldn't automatically fetch the README content from the repository.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              if (repoUrl.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () => launchUrlInBrowser(url: repoUrl, context: context),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text("View Repository"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withAlpha(30),
                    foregroundColor: Colors.blue,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Markdown(
      data: packageInfo.readme,
      selectable: true,
      padding: const EdgeInsets.all(16.0),
      builders: {'code': CodeElementBuilder(context)},
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        codeblockPadding: EdgeInsets.zero,
        codeblockDecoration: const BoxDecoration(color: Colors.transparent),
        blockquoteDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        blockquotePadding: const EdgeInsets.all(16),
        h1: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        h2: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      onTapLink: (text, href, title) async {
        if (href != null) {
          launchUrlInBrowser(url: href, context: context);
        }
      },
    );
  }

}
