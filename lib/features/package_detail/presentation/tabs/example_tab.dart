import 'package:flutter/material.dart' hide Element;
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class ExampleTab extends StatelessWidget {
  final PackageEntity packageInfo;
  const ExampleTab({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Container());
  }
}
