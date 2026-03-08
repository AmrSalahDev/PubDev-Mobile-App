import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart' as html;
import 'package:dio/dio.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class ScoresTab extends StatefulWidget {
  final PackageEntity packageInfo;

  const ScoresTab({super.key, required this.packageInfo});

  @override
  State<ScoresTab> createState() => _ScoresTabState();
}

class _ScoresTabState extends State<ScoresTab> {
  List<double>? _sparklinePoints;
  String? _dateRange;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchScoreData();
  }

  Future<void> _fetchScoreData() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://pub.dev/packages/${widget.packageInfo.name}/score',
      );

      final document = html.parse(response.data);
      final sparklineDiv = document.querySelector(
        '.weekly-downloads-sparkline',
      );

      if (sparklineDiv != null) {
        final pointsBase64 =
            sparklineDiv.attributes['data-weekly-sparkline-points'];
        final textElement = document.querySelector(
          '.weekly-downloads-sparkline-text',
        );

        if (pointsBase64 != null) {
          final bytes = base64.decode(pointsBase64);
          final int32List = bytes.buffer.asInt32List();

          // First value is a timestamp (Unix seconds), subsequent values are data points
          final List<double> points = [];
          for (int i = 1; i < int32List.length; i++) {
            points.add(int32List[i].toDouble());
          }

          if (mounted) {
            setState(() {
              _sparklinePoints = points;
              _dateRange = textElement?.text.trim() ?? '';
              _isLoading = false;
            });
          }
          return;
        }
      }

      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context).errorSparklineData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).weeklyDownloads,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: _isLoading
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.h),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : _error != null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.h),
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_sparklinePoints != null &&
                          _sparklinePoints!.isNotEmpty)
                        SizedBox(
                          height: 100.h,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: SparklinePainter(
                              points: _sparklinePoints!,
                              lineColor: Theme.of(context).colorScheme.primary,
                              areaColor: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                      SizedBox(height: 16.h),
                      if (_dateRange != null)
                        Center(
                          child: Text(
                            _dateRange!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color lineColor;
  final Color areaColor;

  SparklinePainter({
    required this.points,
    required this.lineColor,
    required this.areaColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final double max = points.reduce((a, b) => a > b ? a : b);
    final double min = points.reduce((a, b) => a < b ? a : b);
    final double range = (max - min) == 0 ? 1 : (max - min);

    final double stepX = size.width / (points.length - 1);

    final path = Path();
    final areaPath = Path();

    for (int i = 0; i < points.length; i++) {
      final double x = i * stepX;
      final double y = size.height - ((points[i] - min) / range * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        areaPath.moveTo(x, size.height);
        areaPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        areaPath.lineTo(x, y);
      }

      if (i == points.length - 1) {
        areaPath.lineTo(x, size.height);
        areaPath.close();
      }
    }

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final areaPaint = Paint()
      ..color = areaColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(areaPath, areaPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
