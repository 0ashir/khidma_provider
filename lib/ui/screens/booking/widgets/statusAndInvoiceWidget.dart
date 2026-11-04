import '../../../../app/generalImports.dart';

class StatusAndInvoiceWidget extends StatelessWidget {
  const StatusAndInvoiceWidget({super.key, required this.bookingsModel});

  final BookingsModel bookingsModel;

  @override
  Widget build(BuildContext context) {
    final statusColor = UiUtils.getStatusColor(
      context: context,
      statusVal: bookingsModel.status.toString().toLowerCase(),
    );
    return CustomContainer(
      border: Border(
        bottom: BorderSide(color: statusColor, width: 0.5),
        top: BorderSide(color: statusColor, width: 0.5),
      ),
      color: context.colorScheme.secondaryColor,
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: CustomText(
                    "${'statusLbl'.translate(context: context)}:",
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 5),
                CustomText(
                  bookingsModel.translatedStatus.toString().capitalize(),
                  maxLines: 2,
                  color: statusColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: CustomText(
                    'invoiceNumber'.translate(context: context),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 5),
                CustomText(
                  bookingsModel.invoiceNo ?? '',
                  maxLines: 2,
                  color: UiUtils.getStatusColor(
                    context: context,
                    statusVal: bookingsModel.status.toString(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
