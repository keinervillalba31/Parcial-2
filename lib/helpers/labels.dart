import 'package:flutter/material.dart';
import 'package:pacial_2/l10n/app_localizations.dart';

/// Valores de los enums de la API (Gender y OrderStatus).
const genders = ['HOMBRE', 'MUJER', 'UNISEX'];
const orderStatuses = [
  'PENDIENTE',
  'PAGADO',
  'ENVIADO',
  'ENTREGADO',
  'CANCELADO',
];
const cancelledStatus = 'CANCELADO';

String genderLabel(AppLocalizations t, String gender) => switch (gender) {
  'HOMBRE' => t.genderMen,
  'MUJER' => t.genderWomen,
  _ => t.genderUnisex,
};

String statusLabel(AppLocalizations t, String status) => switch (status) {
  'PENDIENTE' => t.statusPending,
  'PAGADO' => t.statusPaid,
  'ENVIADO' => t.statusShipped,
  'ENTREGADO' => t.statusDelivered,
  'CANCELADO' => t.statusCancelled,
  _ => status,
};

Color statusColor(String status) => switch (status) {
  'PENDIENTE' => Colors.orange,
  'PAGADO' => Colors.blue,
  'ENVIADO' => Colors.indigo,
  'ENTREGADO' => Colors.green,
  'CANCELADO' => Colors.red,
  _ => Colors.grey,
};

IconData statusIcon(String status) => switch (status) {
  'PENDIENTE' => Icons.schedule,
  'PAGADO' => Icons.payments_outlined,
  'ENVIADO' => Icons.local_shipping_outlined,
  'ENTREGADO' => Icons.check_circle_outline,
  'CANCELADO' => Icons.cancel_outlined,
  _ => Icons.help_outline,
};
