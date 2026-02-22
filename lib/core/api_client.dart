import 'package:pub_api_client/pub_api_client.dart';
import 'package:http/http.dart' as http;

class PubDevPackage {
  final String name;
  final String description;
  final String latestVersion;
  final DateTime published;
  final String publisher;
  final int likes;
  final int points;
  final double popularity;
  final List<String> platforms;
  final List<String> sdks;
  final String repositoryUrl;
  final String homepage;
  final List<String> dependencies;
  final String license;
  final bool isFlutterFavorite;

  PubDevPackage({
    required this.name,
    required this.description,
    required this.latestVersion,
    required this.published,
    this.publisher = '',
    this.likes = 0,
    this.points = 0,
    this.popularity = 0,
    this.platforms = const [],
    this.sdks = const [],
    this.repositoryUrl = '',
    this.homepage = '',
    this.dependencies = const [],
    this.license = '',
    this.isFlutterFavorite = false,
  });

  factory PubDevPackage.fromPubPackage(
    PubPackage pkg, {
    String publisher = '',
    int likes = 0,
    int points = 0,
    double popularity = 0,
    List<String> platforms = const [],
    List<String> sdks = const [],
    bool isFlutterFavorite = false,
  }) {
    final pubspec = pkg.latest.pubspec;
    final deps = pubspec.dependencies.keys.toList();
    final repo =
        pubspec.repository?.toString() ?? pubspec.homepage?.toString() ?? '';
    final home = pubspec.homepage?.toString() ?? '';
    return PubDevPackage(
      name: pkg.name,
      description: pubspec.description ?? '',
      latestVersion: pkg.latest.version,
      published: pkg.latest.published,
      publisher: publisher,
      likes: likes,
      points: points,
      popularity: popularity,
      platforms: platforms,
      sdks: sdks,
      repositoryUrl: repo,
      homepage: home,
      dependencies: deps,
      isFlutterFavorite: isFlutterFavorite,
    );
  }
}

class PubDevPackageDetail {
  final PubDevPackage package;
  final String readmeMarkdown;
  final String changelogMarkdown;
  final String exampleMarkdown;
  final List<String> versions;

  PubDevPackageDetail({
    required this.package,
    this.readmeMarkdown = '',
    this.changelogMarkdown = '',
    this.exampleMarkdown = '',
    this.versions = const [],
  });
}

class PubDevApiClient {
  final PubClient _client = PubClient();
  final http.Client _http = http.Client();

  Future<List<String>> getFlutterFavorites({int page = 1}) async {
    final results = await _client.search(
      'is:flutter-favorite',
      sort: SearchOrder.popularity,
      page: page,
    );
    return results.packages.map((p) => p.package).toList();
  }

  Future<List<String>> getTrendingPackages({int page = 1}) async {
    final results = await _client.search('', sort: SearchOrder.top, page: page);
    return results.packages.map((p) => p.package).toList();
  }

  Future<List<String>> getTopFlutterPackages({int page = 1}) async {
    final results = await _client.search(
      'sdk:flutter',
      sort: SearchOrder.popularity,
      page: page,
    );
    return results.packages.map((p) => p.package).toList();
  }

  Future<List<String>> getTopDartPackages({int page = 1}) async {
    final results = await _client.search(
      'sdk:dart',
      sort: SearchOrder.popularity,
      page: page,
    );
    return results.packages.map((p) => p.package).toList();
  }

  Future<List<String>> searchPackages(
    String query, {
    int page = 1,
    SearchOrder sort = SearchOrder.top,
  }) async {
    final results = await _client.search(query, page: page, sort: sort);
    return results.packages.map((p) => p.package).toList();
  }

  Future<PubDevPackage> getPackageDetails(String packageName) async {
    final pkg = await _client.packageInfo(packageName);

    int likes = 0;
    int points = 0;
    double popularity = 0;
    String publisher = '';

    try {
      final score = await _client.packageScore(packageName);
      likes = (score.likeCount as num).toInt();
      points = (score.grantedPoints as num).toInt();
      popularity = (score.popularityScore as num).toDouble();
    } catch (_) {}

    try {
      final pub = await _client.packagePublisher(packageName);
      publisher = pub.publisherId ?? '';
    } catch (_) {}

    return PubDevPackage.fromPubPackage(
      pkg,
      publisher: publisher,
      likes: likes,
      points: points,
      popularity: popularity,
      isFlutterFavorite: false, // Default for now
    );
  }

  Future<PubDevPackageDetail> getPackageFullDetails(String packageName) async {
    final pkg = await getPackageDetails(packageName);

    // Fetch versions
    List<String> versions = [];
    try {
      final versionList = await _client.packageVersions(packageName);
      versions = versionList.reversed.map((v) => v).toList();
    } catch (_) {}

    // Fetch content from pub.dev
    String readme = '';
    String changelog = '';
    String example = '';

    try {
      final readmeResp = await _http.get(
        Uri.parse('https://pub.dev/packages/$packageName/readme'),
        headers: {'Accept': 'text/plain'},
      );
      if (readmeResp.statusCode == 200) {
        readme = _extractRawContent(readmeResp.body);
      }

      final changelogResp = await _http.get(
        Uri.parse('https://pub.dev/packages/$packageName/changelog'),
        headers: {'Accept': 'text/plain'},
      );
      if (changelogResp.statusCode == 200) {
        changelog = _extractRawContent(changelogResp.body);
      }

      final exampleResp = await _http.get(
        Uri.parse('https://pub.dev/packages/$packageName/example'),
        headers: {'Accept': 'text/plain'},
      );
      if (exampleResp.statusCode == 200) {
        example = _extractRawContent(exampleResp.body);
      }
    } catch (_) {}

    // Try GitHub raw README if pub.dev didn't return it
    if (readme.isEmpty && pkg.repositoryUrl.contains('github.com')) {
      try {
        final repoUrl = pkg.repositoryUrl.replaceFirst(
          'https://github.com/',
          '',
        );
        final rawUrl =
            'https://raw.githubusercontent.com/$repoUrl/HEAD/README.md';
        final ghResp = await _http.get(Uri.parse(rawUrl));
        if (ghResp.statusCode == 200) {
          readme = ghResp.body;
        }
      } catch (_) {}
    }

    // Try GitHub raw CHANGELOG
    if (pkg.repositoryUrl.contains('github.com')) {
      try {
        final repoUrl = pkg.repositoryUrl.replaceFirst(
          'https://github.com/',
          '',
        );
        final rawUrl =
            'https://raw.githubusercontent.com/$repoUrl/HEAD/CHANGELOG.md';
        final ghResp = await _http.get(Uri.parse(rawUrl));
        if (ghResp.statusCode == 200) {
          changelog = ghResp.body;
        }
      } catch (_) {}
    }

    if (readme.isEmpty) {
      readme =
          '## ${pkg.name}\n\n${pkg.description}\n\nVisit [pub.dev](https://pub.dev/packages/$packageName) for full documentation.';
    }

    return PubDevPackageDetail(
      package: pkg,
      readmeMarkdown: readme,
      changelogMarkdown: changelog,
      exampleMarkdown: example,
      versions: versions,
    );
  }

  String _extractRawContent(String body) {
    if (!body.trim().startsWith('<')) return body;

    // If it's HTML, try to extract the main content or code blocks
    if (body.contains('<pre')) {
      final match = RegExp(r'<pre[^>]*>([\s\S]*?)<\/pre>').firstMatch(body);
      if (match != null) {
        String content = match.group(1) ?? '';
        // Strip other HTML tags inside <pre> if any (like <code>)
        content = content.replaceAll(RegExp(r'<[^>]*>'), '');
        // Unescape common HTML entities
        return content
            .replaceAll('&lt;', '<')
            .replaceAll('&gt;', '>')
            .replaceAll('&amp;', '&')
            .replaceAll('&quot;', '"')
            .replaceAll('&#39;', "'")
            .replaceAll('&#47;', '/');
      }
    }

    // Fallback: strip all HTML tags
    return body.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}
