import '../../../config.dart';

class BankDetailScreen extends StatelessWidget {
  const BankDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BankDetailProvider>(builder: (context1, value, child) {
      return WillPopScope(
        onWillPop: () async {
          // Clear all controllers before popping
          value.bankNameCtrl.clear();
          value.holderNameCtrl.clear();
          value.accountCtrl.clear();
          value.ifscCtrl.clear();
          value.swiftCtrl.clear();
          value.branchCtrl.clear();
          return true; // allow the pop
        },
        child: Scaffold(
            appBar: AppBarCommon(
              title: translations!.bankDetails,
              onTap: () {
                route.pop(context);
                value.bankNameCtrl.clear();
                value.holderNameCtrl.clear();
                value.accountCtrl.clear();
                value.ifscCtrl.clear();
                value.swiftCtrl.clear();
                value.branchCtrl.clear();
              },
            ),
            body: SingleChildScrollView(
                child: Column(children: [
              const Stack(
                  children: [FieldsBackground(), BankDetailBodyWidget()]),
              ButtonCommon(
                      isLoading: value.isBankDetailsLoader ? true : false,
                      title: translations!.update,
                      onTap: () => value.updateBankDetail(context))
                  .paddingOnly(bottom: Insets.i10, top: Insets.i40)
            ]).paddingAll(Insets.i20))),
      );
    });
  }
}
