import 'package:equatable/equatable.dart';

class GithubHealthEntity extends Equatable {
  final int healthScore;
  final int openIssuesCount;
  final int openPrsCount;
  final DateTime? lastCommitDate;
  final List<double> commitActivity;
  final String status;

  const GithubHealthEntity({
    required this.healthScore,
    required this.openIssuesCount,
    required this.openPrsCount,
    this.lastCommitDate,
    required this.commitActivity,
    required this.status,
  });

  @override
  List<Object?> get props => [
    healthScore,
    openIssuesCount,
    openPrsCount,
    lastCommitDate,
    commitActivity,
    status,
  ];
}
