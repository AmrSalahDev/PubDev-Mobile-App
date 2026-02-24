import 'package:flutter/material.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class InstallingTab extends StatelessWidget {
  final PackageEntity packageInfo;
  const InstallingTab({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    return Text("",
        style: const TextStyle(fontSize: 16, fontFamily: 'Roboto', color: Colors.white));
  }
}