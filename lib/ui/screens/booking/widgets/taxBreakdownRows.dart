import '../../../../app/generalImports.dart';
import 'expandableChargeRow.dart';

/// Bill rows built from a booking's `tax_breakdown`: services, visiting charge
/// and fees, each with its own tax. A row with tax opens base price + each tax.
class TaxBreakdownRows extends StatelessWidget {
  const TaxBreakdownRows({
    super.key,
    required this.breakdown,
    this.fees,
    this.visitingCharges,
    this.currencySymbol,
    this.decimalPlaces,
  });

  final TaxBreakdown breakdown;
  final List<BookingFee>? fees;
  final String? visitingCharges;

  /// Booking's own currency; null → system currency.
  final String? currencySymbol;
  final int? decimalPlaces;

  String _money(BuildContext context, double amount) =>
      amount.toString().priceFormat(
        context,
        currencySymbol: currencySymbol,
        decimalPlaces: decimalPlaces,
      );

  String _percent(double p) =>
      p == p.roundToDouble() ? p.toInt().toString() : p.toString();

  Widget _plainRow(BuildContext context, String title, String amount) => Row(
    children: [
      Expanded(
        child: CustomText(
          title,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          maxLines: 1,
          color: context.colorScheme.blackColor,
        ),
      ),
      CustomText(
        amount,
        textAlign: TextAlign.end,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: context.colorScheme.blackColor,
      ),
    ],
  );

  Widget _groupRow(
    BuildContext context, {
    required String key,
    required String title,
    required TaxGroup group,
  }) {
    final prefix = key == 'services' ? '' : '+ ';
    final amount = '$prefix${_money(context, group.totalWithTax)}';
    final taxes = group.components.where((c) => c.amount > 0).toList();
    if (taxes.isEmpty) return _plainRow(context, title, amount);

    return ExpandableChargeRow(
      key: ValueKey(key),
      title: title,
      amount: amount,
      details: [
        ChargeDetailRow(
          label: 'basePrice'.translate(context: context),
          amount: _money(context, group.baseAmount),
        ),
        for (final c in taxes)
          ChargeDetailRow(
            label:
                '${c.name.isEmpty ? 'taxLbl'.translate(context: context) : c.name}'
                '${c.percentage > 0 ? ' (${_percent(c.percentage)}%)' : ''}',
            amount: '+ ${_money(context, c.amount)}',
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = breakdown.groups;
    final rows = <Widget>[];
    final shown = <String>{};

    String titleOf(String key, TaxGroup group) {
      if (group.title.isNotEmpty) return group.title;
      if (key == 'visiting_charges') {
        return 'visitingCharge'.translate(context: context);
      }
      if (key == 'services') return 'servicesLbl'.translate(context: context);
      return fees?.where((f) => 'fee_${f.id}' == key).firstOrNull?.title ?? '';
    }

    void addRow(Widget row) => rows
      ..add(row)
      ..add(const SizedBox(height: 5));

    void addGroup(String key) {
      final group = groups[key];
      if (group == null || !shown.add(key)) return;
      addRow(
        _groupRow(context, key: key, title: titleOf(key, group), group: group),
      );
    }

    addGroup('services');
    if (groups.containsKey('visiting_charges')) {
      addGroup('visiting_charges');
    } else if ((double.tryParse((visitingCharges ?? '').replaceAll(',', '')) ??
            0) >
        0) {
      addRow(
        _plainRow(
          context,
          'visitingCharge'.translate(context: context),
          '+ ${_money(context, double.parse(visitingCharges!.replaceAll(',', '')))}',
        ),
      );
    }
    for (final fee in fees ?? const <BookingFee>[]) {
      if (groups.containsKey('fee_${fee.id}')) {
        addGroup('fee_${fee.id}');
      } else {
        addRow(
          _plainRow(
            context,
            fee.title ?? '',
            '+ ${(fee.calculatedAmount ?? '0').priceFormat(context, currencySymbol: currencySymbol, decimalPlaces: decimalPlaces)}',
          ),
        );
      }
    }
    groups.keys.forEach(addGroup);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}
