import '../../../../app/generalImports.dart';

class Form6BankInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final GlobalKey<CustomFieldsFormState> customFieldsKey;
  final Map<String, dynamic>? customFieldsLocalValues;

  const Form6BankInfo({
    super.key,
    required this.formKey,
    required this.customFieldsKey,
    this.customFieldsLocalValues,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            BlocBuilder<GetCustomFieldsCubit, GetCustomFieldsState>(
              builder: (context, state) {
                if (state is GetCustomFieldsInitial ||
                    state is GetCustomFieldsInProgress) {
                  return _unavailable(
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CustomCircularProgressIndicator()),
                    ),
                  );
                } else if (state is GetCustomFieldsSuccess) {
                  final fields = state.fields
                      .where((f) => f.fieldGroup == 'bank_details')
                      .toList();
                  if (fields.isEmpty) {
                    return ErrorContainer(
                      errorMessage:
                          'No bank account fields are configured for your country. You can continue registration. Please contact support if you need to add bank details.',
                      showErrorImage: false,
                      onTapRetry: () => context
                          .read<GetCustomFieldsCubit>()
                          .fetchCustomFields(),
                    );
                  }

                  return CustomFieldsForm(
                    key: customFieldsKey,
                    fields: fields,
                    initialValues: {
                      ...state.savedValues,
                      if (customFieldsLocalValues != null)
                        ...customFieldsLocalValues!,
                    },
                  );
                } else if (state is GetCustomFieldsFail) {
                  return _unavailable(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ErrorContainer(
                        errorMessage: state.error,
                        showErrorImage: false,
                        errorMessageFontSize: 12,
                        onTapRetry: () {
                          context
                              .read<GetCustomFieldsCubit>()
                              .fetchCustomFields();
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Keep Next/step navigation from accepting an empty form while the field
  // definitions are unavailable. The visible message above explains recovery.
  Widget _unavailable(Widget child) {
    return FormField<bool>(validator: (_) => ' ', builder: (_) => child);
  }
}
