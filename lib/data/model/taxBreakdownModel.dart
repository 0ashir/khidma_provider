double _toDouble(final dynamic value) =>
    double.tryParse(value?.toString().replaceAll(',', '') ?? '') ?? 0;

/// `tax_breakdown` of a single booking, keyed by charge (`services`,
/// `visiting_charges`, `fee_<id>`).
class TaxBreakdown {
  TaxBreakdown.fromJson(final Map<String, dynamic> json)
    : groups = {
        for (final MapEntry e in json.entries)
          if (e.value is Map)
            e.key.toString(): TaxGroup.fromJson(
              Map<String, dynamic>.from(e.value as Map),
            ),
      };

  /// In response order.
  final Map<String, TaxGroup> groups;
}

class TaxGroup {
  TaxGroup.fromJson(final Map<String, dynamic> json)
    : title = json['title']?.toString() ?? '',
      baseAmount = _toDouble(json['base_amount']),
      totalTax = _toDouble(json['total_tax']),
      totalWithTax = _toDouble(json['total_with_tax']),
      taxType = json['tax_type']?.toString() ?? '',
      components = [
        for (final c in (json['tax_components'] as List? ?? []))
          if (c is Map) TaxComponent.fromJson(Map<String, dynamic>.from(c)),
      ];

  /// Translated by the backend.
  final String title;
  final double baseAmount;
  final double totalTax;

  /// Amount shown for the charge (tax included).
  final double totalWithTax;

  /// `included` (inside the price) or `excluded` (added on top).
  final String taxType;
  final List<TaxComponent> components;
}

class TaxComponent {
  TaxComponent.fromJson(final Map<String, dynamic> json)
    : name = json['name']?.toString() ?? '',
      percentage = _toDouble(json['percentage']),
      amount = _toDouble(json['tax_amount'] ?? json['amount']);

  final String name;
  final double percentage;
  final double amount;
}
