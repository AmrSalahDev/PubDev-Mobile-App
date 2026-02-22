import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/api_client.dart';

// ─── Colors matching pub.dev ────────────────────────────────────────────────
const kBg = Color(0xFF0A1628);
const kCardBg = Color(0xFF1C2834);
const kBluePrimary = Color(0xFF5BB4F8);
const kBlueLight = Color(0xFF4EAFF7);
const kTextWhite = Colors.white;
const kTextGrey = Color(0xFFB0BEC5);
const kDivider = Color(0xFF263545);
const kTagDart = Color(0xFF0E2A5E);
const kTagFlutter = Color(0xFF1B5E9B);
const kTagPlatform = Color(0xFF1A3A5C);
const kSuccess = Color(0xFF2E7D32);
const kCodeBg = Color(0xFF1E2D3D);

class PackageDetailPage extends StatefulWidget {
  final PubDevPackage package;

  const PackageDetailPage({super.key, required this.package});

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<PubDevPackageDetail> _detailFuture;
  final _api = PubDevApiClient();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _detailFuture = _api.getPackageFullDetails(widget.package.name);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: FutureBuilder<PubDevPackageDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          final pkg = snapshot.data?.package ?? widget.package;
          return NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                pinned: true,
                backgroundColor: kBg,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: kTextWhite),
                  onPressed: () => Navigator.pop(context),
                ),
                centerTitle: false,
                titleSpacing: 0,
                title: Text(
                  pkg.name,
                  style: const TextStyle(color: kTextWhite, fontSize: 18),
                ),
              ),
              SliverToBoxAdapter(child: _buildHeader(pkg)),
              _buildTabBar(),
            ],
            body: snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(color: kBluePrimary),
                  )
                : snapshot.hasError
                ? _buildError(snapshot.error.toString())
                : _buildTabContent(snapshot.data!),
          );
        },
      ),
    );
  }

  // Removed _buildAppBar as it's now inline above for better clarity and to fix overflow.

  Widget _buildHeader(PubDevPackage pkg) {
    return Container(
      color: kBg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                color: kBg,
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + share/copy
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${pkg.name} ${pkg.latestVersion}',
                            style: const TextStyle(
                              color: kTextWhite,
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            color: kTextGrey,
                            size: 20,
                          ),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: '${pkg.name}: ^${pkg.latestVersion}',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied!')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Published by
                    Row(
                      children: [
                        Text(
                          'Published ${_timeAgo(pkg.published)} ',
                          style: const TextStyle(
                            color: kTextGrey,
                            fontSize: 13,
                          ),
                        ),
                        const Icon(
                          Icons.verified,
                          color: kBluePrimary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pkg.publisher,
                          style: const TextStyle(
                            color: kBluePrimary,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // SDK Tags
                    Wrap(
                      spacing: 8,
                      children: [
                        _tag('SDK', kSuccess),
                        _tag('DART', kTagDart),
                        _tag('FLUTTER', kTagFlutter),
                        _tag('PLATFORM', kTagPlatform),
                        _tag('ANDROID', kTagPlatform),
                        _tag('IOS', kTagPlatform),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Scores summary
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: kDivider),
                          bottom: BorderSide(color: kDivider),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _scoreItem(pkg.likes.toString(), 'LIKES'),
                          _vDivider(),
                          _scoreItem(pkg.points.toString(), 'POINTS'),
                          _vDivider(),
                          _scoreItem(
                            '${(pkg.popularity * 100).round()}%',
                            'POPULARITY',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (pkg.isFlutterFavorite) _buildFlutterFavoriteRibbon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlutterFavoriteRibbon() {
    return Positioned(
      top: 0,
      right: 0,
      child: Image.network(
        'https://pub.dev/static/img/flutter-favorite-badge.png',
        width: 100,
        errorBuilder: (ctx, err, st) => const SizedBox(),
      ),
    );
  }

  Widget _tag(String label, Color bg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _scoreItem(String value, String label) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: kBluePrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(label, style: const TextStyle(color: kTextGrey, fontSize: 10)),
    ],
  );

  Widget _vDivider() => Container(width: 1, height: 30, color: kDivider);

  SliverPersistentHeader _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: kBluePrimary,
          labelColor: kTextWhite,
          unselectedLabelColor: kTextGrey,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Readme'),
            Tab(text: 'Changelog'),
            Tab(text: 'Example'),
            Tab(text: 'Installing'),
            Tab(text: 'Versions'),
            Tab(text: 'Scores'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(PubDevPackageDetail detail) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildReadmeTab(detail),
        _buildMarkdownTab(detail.changelogMarkdown, 'No Changelog'),
        _buildExampleTab(detail),
        _buildInstallingTab(detail.package),
        _buildVersionsTab(detail),
        _buildScoresTab(detail.package),
      ],
    );
  }

  Widget _buildExampleTab(PubDevPackageDetail detail) {
    if (detail.exampleMarkdown.isEmpty) {
      return const Center(
        child: Text('No Example', style: TextStyle(color: kTextGrey)),
      );
    }

    // Attempt to extract raw code if it's wrapped in markdown code blocks
    String code = detail.exampleMarkdown.trim();
    if (code.contains('```')) {
      final lines = code.split('\n');
      int start = lines.indexWhere((l) => l.startsWith('```'));
      int end = lines.lastIndexWhere((l) => l.startsWith('```'));
      if (start != -1 && end != -1 && start < end) {
        code = lines.sublist(start + 1, end).join('\n');
      }
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'example/example.dart', // Common convention on pub.dev
          style: TextStyle(
            color: kBluePrimary.withAlpha(200),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        _copyableCodeBlock(code, isDart: true),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildReadmeTab(PubDevPackageDetail detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Markdown(
            data: detail.readmeMarkdown,
            selectable: true,
            styleSheet: _markdownStyleSheet(),
            onTapLink: (tx, hr, ti) => hr != null ? _launchUrl(hr) : null,
          ),
        ),
        _buildSidebar(detail.package),
      ],
    );
  }

  Widget _buildMarkdownTab(String content, String emptyMsg) {
    if (content.isEmpty) {
      return Center(
        child: Text(emptyMsg, style: const TextStyle(color: kTextGrey)),
      );
    }
    return Markdown(
      data: content,
      selectable: true,
      styleSheet: _markdownStyleSheet(),
      onTapLink: (tx, hr, ti) => hr != null ? _launchUrl(hr) : null,
    );
  }

  Widget _buildSidebar(PubDevPackage pkg) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: kDivider)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Publisher',
              style: TextStyle(
                color: kTextGrey,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.verified, color: kBluePrimary, size: 16),
                const SizedBox(width: 4),
                Text(
                  pkg.publisher,
                  style: const TextStyle(color: kBluePrimary, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Weekly Downloads',
              style: TextStyle(
                color: kTextGrey,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildChart(),
            const SizedBox(height: 24),
            _sidebarInfo('Metadata', pkg.description),
            if (pkg.repositoryUrl.isNotEmpty)
              _sidebarLink('Repository (GitHub)', pkg.repositoryUrl),
            _sidebarLink(
              'API reference',
              'https://pub.dev/documentation/${pkg.name}/latest/',
            ),
            const SizedBox(height: 24),
            const Text(
              'Dependencies',
              style: TextStyle(
                color: kTextGrey,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: pkg.dependencies
                  .take(15)
                  .map(
                    (d) => Text(
                      d,
                      style: const TextStyle(color: kBluePrimary, fontSize: 12),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() => Container(
    height: 50,
    decoration: BoxDecoration(
      color: kCardBg,
      borderRadius: BorderRadius.circular(4),
    ),
    child: CustomPaint(painter: _ChartPainter(), child: Container()),
  );

  Widget _sidebarInfo(String title, String content) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: kTextGrey,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(content, style: const TextStyle(color: kTextWhite, fontSize: 12)),
      const SizedBox(height: 24),
    ],
  );

  Widget _sidebarLink(String label, String url) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: InkWell(
      onTap: () => _launchUrl(url),
      child: Text(
        label,
        style: const TextStyle(
          color: kBluePrimary,
          fontSize: 13,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
  );

  Widget _buildInstallingTab(PubDevPackage pkg) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      const Text(
        'Use this package as a library',
        style: TextStyle(
          color: kTextWhite,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(height: 12),
      const Divider(color: kDivider),
      const SizedBox(height: 24),

      // Section 1: Depend on it
      const Text(
        'Depend on it',
        style: TextStyle(
          color: kTextWhite,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(height: 16),
      const Text(
        'Run this command:',
        style: TextStyle(color: kTextWhite, fontSize: 14),
      ),
      const SizedBox(height: 12),
      const Text(
        'With Flutter:',
        style: TextStyle(color: kTextGrey, fontSize: 14),
      ),
      const SizedBox(height: 12),
      _copyableCodeBlock('\$ flutter pub add ${pkg.name}', isTerminal: true),
      const SizedBox(height: 24),
      Wrap(
        children: [
          const Text(
            'This will add a line like this to your package\'s pubspec.yaml (and run an implicit ',
            style: TextStyle(color: kTextGrey, fontSize: 13),
          ),
          _inlineCode('flutter pub get'),
          const Text('):', style: TextStyle(color: kTextGrey, fontSize: 13)),
        ],
      ),
      const SizedBox(height: 12),
      _copyableCodeBlock(
        'dependencies:\n  ${pkg.name}: ^${pkg.latestVersion}',
        isYaml: true,
      ),
      const SizedBox(height: 24),
      Wrap(
        children: [
          const Text(
            'Alternatively, your editor might support ',
            style: TextStyle(color: kTextGrey, fontSize: 13),
          ),
          _inlineCode('flutter pub get'),
          const Text(
            '. Check the docs for your editor to learn more.',
            style: TextStyle(color: kTextGrey, fontSize: 13),
          ),
        ],
      ),
      const SizedBox(height: 48),

      // Section 2: Import it
      const Text(
        'Import it',
        style: TextStyle(
          color: kTextWhite,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(height: 16),
      const Text(
        'Now in your Dart code, you can use:',
        style: TextStyle(color: kTextWhite, fontSize: 14),
      ),
      const SizedBox(height: 12),
      _copyableCodeBlock(
        "import 'package:${pkg.name}/${pkg.name}.dart';",
        isDart: true,
      ),
      const SizedBox(height: 48),
    ],
  );

  Widget _inlineCode(String code) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    decoration: BoxDecoration(
      color: kDivider.withAlpha(100),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      code,
      style: const TextStyle(
        color: kTextGrey,
        fontSize: 12,
        fontFamily: 'monospace',
      ),
    ),
  );

  Widget _copyableCodeBlock(
    String code, {
    bool isTerminal = false,
    bool isYaml = false,
    bool isDart = false,
  }) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: kCodeBg,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              children: _highlightCode(
                code,
                isTerminal: isTerminal,
                isYaml: isYaml,
                isDart: isDart,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: code));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard')),
            );
          },
          child: const Icon(Icons.copy, color: kTextGrey, size: 18),
        ),
      ],
    ),
  );

  List<TextSpan> _highlightCode(
    String code, {
    bool isTerminal = false,
    bool isYaml = false,
    bool isDart = false,
  }) {
    if (isTerminal) {
      if (code.startsWith('\$')) {
        return [
          const TextSpan(
            text: '\$ ',
            style: TextStyle(color: kBluePrimary),
          ),
          TextSpan(
            text: code.substring(2),
            style: const TextStyle(color: kTextWhite),
          ),
        ];
      }
    }
    if (isYaml) {
      return [
        const TextSpan(
          text: 'dependencies:\n',
          style: TextStyle(color: kBluePrimary),
        ),
        const TextSpan(
          text: '  ',
          style: TextStyle(color: kTextWhite),
        ),
        TextSpan(
          text: code.split('\n')[1].trim(),
          style: const TextStyle(color: kTextWhite),
        ),
      ];
    }
    if (isDart) {
      final List<TextSpan> spans = [];
      // Basic Dart highlighting for common keywords and comments
      final lines = code.split('\n');
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trim().startsWith('//')) {
          spans.add(
            TextSpan(
              text: line,
              style: const TextStyle(color: Colors.blueGrey),
            ),
          );
        } else {
          // Simple keyword highlight
          final parts = line.split(RegExp(r'(\s+|[().,;{}[\]])'));
          int lastPos = 0;
          for (final part in parts) {
            if (part.isEmpty) continue;
            final partIndex = line.indexOf(part, lastPos);

            // Add text between parts (spaces/punctuation)
            if (partIndex > lastPos) {
              spans.add(
                TextSpan(
                  text: line.substring(lastPos, partIndex),
                  style: const TextStyle(color: kTextWhite),
                ),
              );
            }

            final keywords = [
              'import',
              'as',
              'void',
              'main',
              'print',
              'for',
              'var',
              'in',
              'const',
              'final',
              'return',
              'if',
              'else',
              'class',
            ];
            final textColor = keywords.contains(part)
                ? const Color(0xFFE57373)
                : (part.startsWith("'") || part.startsWith('"')
                      ? const Color(0xFFFFF176)
                      : kTextWhite);

            spans.add(
              TextSpan(
                text: part,
                style: TextStyle(color: textColor),
              ),
            );
            lastPos = partIndex + part.length;
          }
          if (lastPos < line.length) {
            spans.add(
              TextSpan(
                text: line.substring(lastPos),
                style: const TextStyle(color: kTextWhite),
              ),
            );
          }
        }
        if (i < lines.length - 1) spans.add(const TextSpan(text: '\n'));
      }
      return spans;
    }
    return [
      TextSpan(
        text: code,
        style: const TextStyle(color: kTextWhite),
      ),
    ];
  }

  // Removed _step in favor of the new redesigned _copyableCodeBlock logic.

  Widget _buildVersionsTab(PubDevPackageDetail detail) => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: detail.versions.length,
    itemBuilder: (_, i) => ListTile(
      title: Text(
        detail.versions[i],
        style: const TextStyle(color: kTextWhite),
      ),
      trailing: detail.versions[i] == detail.package.latestVersion
          ? _tag('LATEST', kSuccess)
          : null,
    ),
  );

  Widget _buildScoresTab(PubDevPackage pkg) => ListView(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
    children: [
      // 1. Large Summary Metrics
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _largeScoreItem(_formatLikes(pkg.likes), 'LIKES'),
          _largeScoreItem('${pkg.points}/160', 'PUB POINTS'),
          _largeScoreItem(_formatPopularity(pkg.popularity), 'POPULARITY'),
        ],
      ),
      const SizedBox(height: 48),

      // 2. Analysis Text
      Text(
        'We analyzed this package ${_timeAgo(pkg.published)}, and awarded it ${pkg.points} pub points (of a possible 160):',
        style: const TextStyle(color: kTextWhite, fontSize: 14),
      ),
      const SizedBox(height: 12),
      const Divider(color: kDivider),

      // 3. Score Breakdown List
      _scoreBreakdownItem('Follow Dart file conventions', '30/30'),
      _scoreBreakdownItem('Provide documentation', '20/20'),
      _scoreBreakdownItem('Platform support', '20/20'),
      _scoreBreakdownItem('Pass static analysis', '50/50'),
      _scoreBreakdownItem('Support up-to-date dependencies', '40/40'),

      const SizedBox(height: 32),
      const Text(
        'Analyzed with Pana 0.23.10, Flutter 3.41.0, Dart 3.11.0.',
        style: TextStyle(color: kTextGrey, fontSize: 13),
      ),
      const SizedBox(height: 8),
      const Text(
        'Check the analysis log for details.',
        style: TextStyle(color: kTextGrey, fontSize: 13),
      ),

      const SizedBox(height: 64),

      // 4. Weekly Downloads Section
      const Text(
        'Weekly downloads',
        style: TextStyle(
          color: kTextWhite,
          fontSize: 28,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(height: 24),
      _buildDetailedDownloadsChart(),
      const SizedBox(height: 32),
    ],
  );

  Widget _largeScoreItem(String value, String label) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: kBluePrimary,
          fontSize: 42,
          fontWeight: FontWeight.w300,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(
          color: kTextGrey,
          fontSize: 12,
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );

  Widget _scoreBreakdownItem(String title, String points) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: kDivider)),
    ),
    child: Row(
      children: [
        const Icon(Icons.check, color: Color(0xFF4CAF50), size: 18),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: kTextWhite, fontSize: 16),
          ),
        ),
        Text(
          points,
          style: const TextStyle(
            color: kTextWhite,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.keyboard_arrow_down, color: kTextGrey, size: 20),
      ],
    ),
  );

  Widget _buildDetailedDownloadsChart() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Filters row from screenshot - use Wrap to prevent overflow
      Wrap(
        spacing: 24,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _chartFilter('Display as:', ['Unstacked', 'Stacked', 'Percentage']),
          _chartFilter('By versions:', ['Major', 'Minor', 'Patch']),
        ],
      ),
      const SizedBox(height: 24),
      // Legend
      // Legend - use Wrap
      Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _legendItem('>=2.0.0-0 <3.0.0', kBluePrimary),
          _legendItem('>=1.0.0-0 <2.0.0', Colors.redAccent),
          _legendItem('>=0.0.0-0 <1.0.0', Colors.green),
        ],
      ),
      const SizedBox(height: 32),
      // The Chart
      Container(
        height: 250,
        width: double.infinity,
        padding: const EdgeInsets.only(right: 40), // Space for Y axis labels
        child: CustomPaint(
          painter: _ComplexChartPainter(),
          child: Stack(
            children: [
              // Y Axis Labels
              for (var i = 0; i <= 7; i++)
                Positioned(
                  right: -35,
                  bottom: (i * 250 / 7) - 6,
                  child: Text(
                    '${(i * 0.2).toStringAsFixed(1)}M',
                    style: const TextStyle(color: kTextGrey, fontSize: 10),
                  ),
                ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      // X Axis Labels
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Apr 4', style: TextStyle(color: kTextGrey, fontSize: 10)),
          Text('May 2', style: TextStyle(color: kTextGrey, fontSize: 10)),
          Text('Jun 27', style: TextStyle(color: kTextGrey, fontSize: 10)),
          Text('Aug 22', style: TextStyle(color: kTextGrey, fontSize: 10)),
          Text('Oct 17', style: TextStyle(color: kTextGrey, fontSize: 10)),
          Text('Dec 12', style: TextStyle(color: kTextGrey, fontSize: 10)),
          Text('Feb 6', style: TextStyle(color: kTextGrey, fontSize: 10)),
        ],
      ),
    ],
  );

  Widget _chartFilter(String title, List<String> options) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 8,
    runSpacing: 4,
    children: [
      Text(title, style: const TextStyle(color: kTextGrey, fontSize: 12)),
      for (var i = 0; i < options.length; i++) ...[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              i == 0 ? Icons.radio_button_checked : Icons.radio_button_off,
              color: i == 0 ? kBluePrimary : kTextGrey,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              options[i],
              style: const TextStyle(color: kTextWhite, fontSize: 12),
            ),
          ],
        ),
      ],
    ],
  );

  Widget _legendItem(String label, Color color) => Row(
    children: [
      Container(width: 12, height: 12, color: color),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(color: kTextGrey, fontSize: 11)),
    ],
  );

  String _formatLikes(int likes) {
    if (likes >= 1000) return '${(likes / 1000).toStringAsFixed(1)}k';
    return likes.toString();
  }

  String _formatPopularity(double pop) => '${(pop * 100).round()}%';

  Widget _buildError(String msg) => Center(
    child: Text(msg, style: const TextStyle(color: Colors.redAccent)),
  );

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
    return '${diff.inDays} days ago';
  }

  MarkdownStyleSheet _markdownStyleSheet() => MarkdownStyleSheet(
    h1: const TextStyle(
      color: kBlueLight,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    h2: const TextStyle(
      color: kBlueLight,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    p: const TextStyle(color: kTextWhite, height: 1.6),
    code: const TextStyle(color: Color(0xFF90CAF9), backgroundColor: kCodeBg),
    codeblockDecoration: BoxDecoration(
      color: kCodeBg,
      borderRadius: BorderRadius.circular(6),
    ),
  );
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);
  @override
  Widget build(ctx, so, oc) => Container(color: kBg, child: tabBar);
  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(_) => false;
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = kBluePrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..lineTo(size.width * 0.3, size.height * 0.3)
      ..lineTo(size.width * 0.6, size.height * 0.8)
      ..lineTo(size.width, size.height * 0.2);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ComplexChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Grid lines
    final gridPaint = Paint()
      ..color = kDivider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i <= 7; i++) {
      final y = size.height - (i * size.height / 7);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Main Blue Line (Major version)
    final bluePaint = Paint()
      ..color = kBluePrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final bluePath = Path();
    bluePath.moveTo(0, size.height * 0.6);
    bluePath.lineTo(size.width * 0.1, size.height * 0.55);
    bluePath.lineTo(size.width * 0.2, size.height * 0.62);
    bluePath.lineTo(size.width * 0.3, size.height * 0.45);
    bluePath.lineTo(size.width * 0.45, size.height * 0.4);
    bluePath.lineTo(size.width * 0.5, size.height * 0.48);
    bluePath.lineTo(size.width * 0.6, size.height * 0.1); // Peak
    bluePath.lineTo(size.width * 0.65, size.height * 0.35);
    bluePath.lineTo(size.width * 0.75, size.height * 0.45);
    bluePath.lineTo(size.width * 0.85, size.height * 0.8); // Drop
    bluePath.lineTo(size.width * 0.9, size.height * 0.55);
    bluePath.lineTo(size.width, size.height * 0.5);

    canvas.drawPath(bluePath, bluePaint);

    // 3. Minor lines (Red/Green - low activity)
    final redPaint = Paint()
      ..color = Colors.redAccent.withAlpha(150)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final redPath = Path();
    redPath.moveTo(0, size.height * 0.95);
    redPath.lineTo(size.width, size.height * 0.96);
    canvas.drawPath(redPath, redPaint);

    final greenPaint = Paint()
      ..color = Colors.green.withAlpha(150)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final greenPath = Path();
    greenPath.moveTo(0, size.height * 0.98);
    greenPath.lineTo(size.width, size.height * 0.97);
    canvas.drawPath(greenPath, greenPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
