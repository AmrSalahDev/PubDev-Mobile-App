import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_bloc.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_event.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_state.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/tabs/example_tab.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/tabs/installing_tab.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/tabs/readme_tab.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/widgets/package_detail_header.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageDetailPage extends StatefulWidget {
  final PackageEntity packageInfo;

  const PackageDetailPage({super.key, required this.packageInfo});

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<PackagesBloc>().add(
      LoadPackageInfoEvent(widget.packageInfo.name),
    );
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<PackagesBloc, PackagesState>(
      builder: (context, state) {
        if (state.isPackageInfoLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!state.isPackageInfoLoading && state.packageInfo != null) {
          final pkg = state.packageInfo!;
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  PackageDetailsHeader(packageInfo: pkg),
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: Colors.blue,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
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
                  _buildTabContent(pkg),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
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

  Widget _buildTabContent(PackageEntity packageInfo) {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          ReadmeTab(packageInfo: packageInfo),

          ExampleTab(packageInfo: packageInfo),
          InstallingTab(packageInfo: packageInfo),
          _buildVersionsTab(packageInfo),
          _buildScoresTab(packageInfo),
        ],
      ),
    );
  }

  // Widget _buildReadmeTab(PackageDetailsEntity detail) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: Markdown(
  //           data: detail.readme,
  //           selectable: true,
  //           styleSheet: _markdownStyleSheet(),
  //           onTapLink: (tx, hr, ti) => hr != null ? _launchUrl(hr) : null,
  //         ),
  //       ),
  //       _buildSidebar(detail),
  //     ],
  //   );
  // }

  Widget _buildVersionsTab(PackageEntity packageInfo) => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: packageInfo.versions.length,
    itemBuilder: (_, i) => ListTile(
      title: Text(
        packageInfo.versions[i].version,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: packageInfo.versions[i].version == packageInfo.latest.version
          ? _tag('LATEST', Colors.green)
          : null,
    ),
  );

  Widget _buildScoresTab(PackageEntity packageInfo) => ListView(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
    children: [
      // 1. Large Summary Metrics
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _largeScoreItem(_formatLikes(packageInfo.score.likeCount), 'LIKES'),
          _largeScoreItem('${packageInfo.score.maxPoints}/160', 'PUB POINTS'),
          _largeScoreItem(
            packageInfo.score.downloadCount30Days.toString(),
            'DOWNLOADS',
          ),
        ],
      ),
      const SizedBox(height: 48),

      // 2. Analysis Text
      Text(
        'We analyzed this package ${_timeAgo(packageInfo.latest.published)}, and awarded it ${packageInfo.score.maxPoints} pub points (of a possible 160):',
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      const SizedBox(height: 12),
      const Divider(color: Colors.grey),

      // 3. Score Breakdown List
      _scoreBreakdownItem('Follow Dart file conventions', '30/30'),
      _scoreBreakdownItem('Provide documentation', '20/20'),
      _scoreBreakdownItem('Platform support', '20/20'),
      _scoreBreakdownItem('Pass static analysis', '50/50'),
      _scoreBreakdownItem('Support up-to-date dependencies', '40/40'),

      const SizedBox(height: 32),
      const Text(
        'Analyzed with Pana 0.23.10, Flutter 3.41.0, Dart 3.11.0.',
        style: TextStyle(color: Colors.grey, fontSize: 13),
      ),
      const SizedBox(height: 8),
      const Text(
        'Check the analysis log for details.',
        style: TextStyle(color: Colors.grey, fontSize: 13),
      ),

      const SizedBox(height: 64),

      // 4. Weekly Downloads Section
      const Text(
        'Weekly downloads',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(height: 24),
      _buildDetailedDownloadsChart(),
      const SizedBox(height: 32),
    ],
  );

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
    return '${diff.inDays} days ago';
  }

  Widget _largeScoreItem(String value, String label) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 42,
          fontWeight: FontWeight.w300,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
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
      border: Border(bottom: BorderSide(color: Colors.grey)),
    ),
    child: Row(
      children: [
        const Icon(Icons.check, color: Color(0xFF4CAF50), size: 18),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Text(
          points,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
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
          _legendItem('>=2.0.0-0 <3.0.0', Colors.blue),
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
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
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
          Text('Apr 4', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('May 2', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('Jun 27', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('Aug 22', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('Oct 17', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('Dec 12', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('Feb 6', style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    ],
  );

  Widget _chartFilter(String title, List<String> options) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 8,
    runSpacing: 4,
    children: [
      Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      for (var i = 0; i < options.length; i++) ...[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              i == 0 ? Icons.radio_button_checked : Icons.radio_button_off,
              color: i == 0 ? Colors.blue : Colors.grey,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              options[i],
              style: const TextStyle(color: Colors.white, fontSize: 12),
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
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
    ],
  );

  String _formatLikes(int likes) {
    if (likes >= 1000) return '${(likes / 1000).toStringAsFixed(1)}k';
    return likes.toString();
  }

  String _formatPopularity(double pop) => '${(pop * 100).round()}%';

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ComplexChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Grid lines
    final gridPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i <= 7; i++) {
      final y = size.height - (i * size.height / 7);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Main Blue Line (Major version)
    final bluePaint = Paint()
      ..color = Colors.blue
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
