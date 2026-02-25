import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';

@immutable
sealed class IToastService {
  void showSuccessToast({required BuildContext context, required String message});
  void showErrorToast({required BuildContext context, required String message});
  void showInfoToast({required BuildContext context, required String message});
  void showWarningToast({required BuildContext context, required String message});
}

@LazySingleton()
class ToastService implements IToastService {
  @override
  void showErrorToast({required BuildContext context, required String message}) {
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      backgroundColor:  ColorScheme.of(context).surface,
      foregroundColor: ColorScheme.of(context).onSurface,
      borderSide: BorderSide(color: ColorScheme.of(context).outline),
    );
  }

  @override
  void showInfoToast({required BuildContext context, required String message}) {
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      backgroundColor: ColorScheme.of(context).surface,
      foregroundColor: ColorScheme.of(context).onSurface,
      borderSide: BorderSide(color: ColorScheme.of(context).outline),
    );
  }

  @override
  void showSuccessToast({required BuildContext context, required String message}) {
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      backgroundColor: ColorScheme.of(context).surface,
      foregroundColor: ColorScheme.of(context).onSurface,
      borderSide: BorderSide(color: ColorScheme.of(context).outline),
    );
  }

  @override
  void showWarningToast({required BuildContext context, required String message}) {
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      backgroundColor: ColorScheme.of(context).surface,
      foregroundColor: ColorScheme.of(context).onSurface,
      borderSide: BorderSide(color: ColorScheme.of(context).outline),
    );
  }
}