import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_dev_packages_app/core/const/constants.dart';
import 'package:retry/retry.dart';
import 'package:talker/talker.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  RetryOptions get retryOptions => RetryOptions(
    maxAttempts: 5,
    delayFactor: const Duration(seconds: 1),
    maxDelay: const Duration(seconds: 8),
  );

  @lazySingleton
  Talker get talker => Talker();

  @lazySingleton
  PubClient get pubClient => PubClient();

  @lazySingleton
  http.Client get httpClient => http.Client();

  @lazySingleton
  Dio get dio => Dio(
    BaseOptions(
      baseUrl: baseUrl,
    ),
  );
}