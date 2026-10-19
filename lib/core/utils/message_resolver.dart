import 'package:flutter/material.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

String resolveMessage(BuildContext context, String message) {
  final l10n = AppLocalizations.of(context);
  switch (message) {
    case 'networkError':
      return l10n.networkError;
    case 'unknownError':
      return l10n.unknownError;
    case 'invalidCredentials':
      return l10n.invalidCredentials;
    case 'emailInUse':
      return l10n.emailInUse;
    default:
      return message;
  }
}
