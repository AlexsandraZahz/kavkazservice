import 'package:flutter/material.dart';

/// Типы статусов документов
enum DocumentStatusType {
  verified, // Подтвержден
  pending, // На проверке
  expiring, // Истекает
  expired, // Просрочен
}

/// Модель статуса документа
class DocumentStatus {
  final DocumentStatusType status;
  final String date;
  final IconData icon;

  const DocumentStatus({
    required this.status,
    required this.date,
    required this.icon,
  });

  /// Получить текст статуса
  String get statusText {
    switch (status) {
      case DocumentStatusType.verified:
        return '✅ Подтвержден';
      case DocumentStatusType.pending:
        return '⏳ На проверке';
      case DocumentStatusType.expiring:
        return '⚠️ Истекает';
      case DocumentStatusType.expired:
        return '❌ Просрочен';
    }
  }

  /// Получить цвет статуса
  Color get statusColor {
    switch (status) {
      case DocumentStatusType.verified:
        return Colors.green;
      case DocumentStatusType.pending:
        return Colors.blue;
      case DocumentStatusType.expiring:
        return Colors.orange;
      case DocumentStatusType.expired:
        return Colors.red;
    }
  }

  /// Получить иконку статуса
  IconData get statusIcon {
    switch (status) {
      case DocumentStatusType.verified:
        return Icons.check_circle_rounded;
      case DocumentStatusType.pending:
        return Icons.hourglass_empty_rounded;
      case DocumentStatusType.expiring:
        return Icons.warning_rounded;
      case DocumentStatusType.expired:
        return Icons.cancel_rounded;
    }
  }
}
