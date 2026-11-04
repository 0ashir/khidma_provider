import '../../app/generalImports.dart';

class StatusAndInvoiceWidget extends StatelessWidget {
  const StatusAndInvoiceWidget({super.key, required this.bookingsModel});

  final BookingsModel bookingsModel;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      border: Border(
        bottom: BorderSide(color: context.colorScheme.accentColor, width: 0.5),
        top: BorderSide(color: context.colorScheme.accentColor, width: 0.5),
      ),
      color: context.colorScheme.secondaryColor,
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomText('statusLbl'.translate(context: context)),
              const SizedBox(width: 5),
              CustomText(
                bookingsModel.translatedStatus.toString().capitalize(),
                color: UiUtils.getStatusColor(
                  context: context,
                  statusVal: bookingsModel.status.toString(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              CustomText('invoiceNumber'.translate(context: context)),
              const SizedBox(width: 5),
              CustomText(
                bookingsModel.invoiceNo ?? '',
                color: UiUtils.getStatusColor(
                  context: context,
                  statusVal: bookingsModel.status.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
