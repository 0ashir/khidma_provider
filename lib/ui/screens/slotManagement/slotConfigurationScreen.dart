import 'package:flutter/material.dart';
import '../../../app/generalImports.dart';

class SlotConfigurationScreen extends StatefulWidget {
  const SlotConfigurationScreen({super.key});

  static Route route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => FetchSlotConfigurationsCubit()),
          BlocProvider(create: (_) => ManageSlotConfigurationsCubit()),
        ],
        child: const SlotConfigurationScreen(),
      ),
    );
  }

  @override
  State<SlotConfigurationScreen> createState() =>
      _SlotConfigurationScreenState();
}

class _SlotConfigurationScreenState extends State<SlotConfigurationScreen> {
  final TextEditingController _slotIntervalController = TextEditingController(
    text: '5',
  );
  final TextEditingController _minAdvanceValueController =
      TextEditingController(text: '1');
  String _minAdvanceUnit = 'hours';
  final TextEditingController _maxFutureDaysController = TextEditingController(
    text: '10',
  );
  bool _sameDayBooking = true;
  bool _allowConcurrentBookings = false;
  final TextEditingController _concurrentCapacityController =
      TextEditingController(text: '2');
  final TextEditingController _bufferBeforeController = TextEditingController(
    text: '0',
  );
  final TextEditingController _bufferAfterController = TextEditingController(
    text: '0',
  );
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    context.read<FetchSlotConfigurationsCubit>().fetchSlotConfigurations();
  }

  void _initFromSettings(SlotSettings s) {
    _slotIntervalController.text = s.slotInterval.toString();
    _minAdvanceValueController.text = s.minAdvanceBookingValue.toString();
    _minAdvanceUnit = s.minAdvanceBookingUnit;
    _maxFutureDaysController.text = s.maxAdvanceBookingDays.toString();
    _sameDayBooking = s.sameDayBooking == 1;
    _allowConcurrentBookings = s.allowMultipleBookings == 1;
    _concurrentCapacityController.text = s.slotCapacity.toString();
    _bufferBeforeController.text = s.bufferBefore.toString();
    _bufferAfterController.text = s.bufferAfter.toString();
  }

  @override
  void dispose() {
    _slotIntervalController.dispose();
    _minAdvanceValueController.dispose();
    _maxFutureDaysController.dispose();
    _bufferBeforeController.dispose();
    _bufferAfterController.dispose();
    _concurrentCapacityController.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    final intervalVal = int.tryParse(_slotIntervalController.text.trim()) ?? 0;
    if (intervalVal < 5 || intervalVal > 240 || intervalVal % 5 != 0) {
      UiUtils.showMessage(
        context,
        'slotIntervalValidation'.translate(context: context),
        ToastificationType.warning,
      );
      return;
    }
    final isOrganisation =
        context.read<ProviderDetailsCubit>().getProviderType() == "1";
    context.read<ManageSlotConfigurationsCubit>().manageSlotSettings({
      'slot_interval': _slotIntervalController.text.trim(),
      if (isOrganisation)
        'allow_multiple_bookings': _allowConcurrentBookings ? 1 : 0,
      if (isOrganisation)
        'slot_capacity': _concurrentCapacityController.text.trim(),
      'min_advance_booking_value': _minAdvanceValueController.text.trim(),
      'min_advance_booking_unit': _minAdvanceUnit,
      'max_advance_booking_days': _maxFutureDaysController.text.trim(),
      'same_day_booking': _sameDayBooking ? 1 : 0,
      'buffer_before': _bufferBeforeController.text.trim(),
      'buffer_after': _bufferAfterController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedSafeArea(
      child: Scaffold(
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'slotConfiguration'.translate(context: context),
          statusBarColor: context.colorScheme.secondaryColor,
        ),
        backgroundColor: context.colorScheme.primaryColor,
        body:
            BlocListener<
              FetchSlotConfigurationsCubit,
              FetchSlotConfigurationsState
            >(
              listener: (context, state) {
                if (state is FetchSlotConfigurationsSuccess && !_initialized) {
                  setState(() {
                    _initFromSettings(state.data.slotSettings);
                    _initialized = true;
                  });
                }
                if (state is FetchSlotConfigurationsFailure) {
                  UiUtils.showMessage(
                    context,
                    state.errorMessage,
                    ToastificationType.error,
                  );
                }
              },
              child:
                  BlocConsumer<
                    ManageSlotConfigurationsCubit,
                    ManageSlotConfigurationsState
                  >(
                    listener: (context, state) {
                      if (state is ManageSlotConfigurationsSuccess) {
                        UiUtils.showMessage(
                          context,
                          state.message,
                          ToastificationType.success,
                        );
                      }
                      if (state is ManageSlotConfigurationsFailure) {
                        UiUtils.showMessage(
                          context,
                          state.errorMessage,
                          ToastificationType.error,
                        );
                      }
                    },
                    builder: (context, manageState) {
                      final fetchState = context
                          .watch<FetchSlotConfigurationsCubit>()
                          .state;
                      final isLoadingData =
                          fetchState is FetchSlotConfigurationsInProgress;
                      final isSaving =
                          manageState is ManageSlotConfigurationsInProgress;

                      if (isLoadingData) {
                        return const Center(
                          child: CustomCircularProgressIndicator(),
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _buildSlotBehaviorSection(context),
                                  const SizedBox(height: 12),
                                  _buildBookingWindowSection(context),
                                  const SizedBox(height: 12),
                                  _buildBufferSection(context),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: CustomRoundedButton(
                              showBorder: false,
                              widthPercentage: 1,
                              backgroundColor: context.colorScheme.accentColor,
                              titleColor: AppColors.whiteColors,
                              buttonTitleWidget: isSaving
                                  ? CustomCircularProgressIndicator(
                                      color: AppColors.whiteColors,
                                    )
                                  : null,
                              buttonTitle: isSaving
                                  ? null
                                  : 'saveBtn'.translate(context: context),
                              onTap: isSaving ? null : () => _save(context),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
            ),
      ),
    );
  }

  Widget _buildSlotBehaviorSection(BuildContext context) {
    return _SectionCard(
      title: 'slotBehavior'.translate(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(
            label: 'slotInterval'.translate(context: context),
            required: true,
          ),
          const SizedBox(height: 8),
          _NumberField(controller: _slotIntervalController),
          const SizedBox(height: 6),
          CustomText(
            'slotIntervalHint'.translate(context: context),
            fontSize: 12,
            color: context.colorScheme.lightGreyColor,
          ),
          if (context.read<ProviderDetailsCubit>().getProviderType() ==
              "1") ...[
            const SizedBox(height: 16),
            CustomCheckIconTextButton(
              title: 'allowMultipleConcurrentBookings',
              isSelected: _allowConcurrentBookings,
              onTap: () => setState(
                () => _allowConcurrentBookings = !_allowConcurrentBookings,
              ),
            ),

            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: CustomText(
                'allowMultipleConcurrentBookingsDesc'.translate(
                  context: context,
                ),
                fontSize: 12,
                color: context.colorScheme.lightGreyColor,
              ),
            ),
            if (_allowConcurrentBookings) ...[
              const SizedBox(height: 16),
              _FieldLabel(
                label: 'concurrentBookingCapacity'.translate(context: context),
                required: true,
              ),
              const SizedBox(height: 8),
              _NumberField(controller: _concurrentCapacityController),
              CustomText(
                'concurrentBookingCapacityHint'.translate(context: context),
                fontSize: 12,
                color: context.colorScheme.lightGreyColor,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildBookingWindowSection(BuildContext context) {
    return _SectionCard(
      title: 'bookingWindowRules'.translate(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(
                      label: 'minAdvanceBooking'.translate(context: context),
                      required: true,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _NumberField(
                            controller: _minAdvanceValueController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomContainer(
                          width: 100,
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          border: Border.all(
                            color: context.colorScheme.lightGreyColor,
                            width: 0.5,
                          ),
                          borderRadius: UiUtils.borderRadiusOf8,
                          color: context.colorScheme.secondaryColor,
                          child: DropdownButton<String>(
                            value: _minAdvanceUnit,
                            isExpanded: true,
                            icon: CustomSvgPicture(
                              svgImage: AppAssets.spDown,
                              color: context.colorScheme.accentColor,
                              height: 7,
                              width: 7,
                            ),
                            style: TextStyle(
                              color: context.colorScheme.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                            underline: const SizedBox.shrink(),
                            dropdownColor: context.colorScheme.secondaryColor,
                            items: ['hours', 'minutes', 'days'].map((u) {
                              return DropdownMenuItem<String>(
                                value: u,
                                child: CustomText(
                                  u.translate(context: context),
                                  fontSize: 13,
                                ),
                              );
                            }).toList(),
                            onChanged: (v) {
                              if (v != null)
                                setState(() => _minAdvanceUnit = v);
                            },
                          ),
                        ),
                      ],
                    ),
                    CustomText(
                      'minAdvanceBookingHint'.translate(context: context),
                      fontSize: 12,
                      color: context.colorScheme.lightGreyColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _FieldLabel(
            label: 'maxFutureBookingDays'.translate(context: context),
            required: true,
          ),
          const SizedBox(height: 8),
          _NumberField(controller: _maxFutureDaysController),
          CustomText(
            'maxFutureBookingDaysHint'.translate(context: context),
            fontSize: 12,
            color: context.colorScheme.lightGreyColor,
          ),
          const SizedBox(height: 16),
          CustomCheckIconTextButton(
            title: 'sameDayBooking',
            isSelected: _sameDayBooking,
            onTap: () => setState(() => _sameDayBooking = !_sameDayBooking),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CustomText(
              'sameDayBookingDesc'.translate(context: context),
              fontSize: 12,
              color: context.colorScheme.lightGreyColor,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBufferSection(BuildContext context) {
    return _SectionCard(
      title: 'defaultBufferRules'.translate(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FieldLabel(
                label: 'bufferBeforeBooking'.translate(context: context),
                required: false,
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _NumberField(controller: _bufferBeforeController),
                  ),
                  const SizedBox(width: 8),
                  CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    borderRadius: UiUtils.borderRadiusOf8,
                    border: Border.all(
                      color: context.colorScheme.lightGreyColor,
                      width: 0.5,
                    ),
                    color: context.colorScheme.secondaryColor,
                    child: CustomText(
                      'minutes'.translate(context: context),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FieldLabel(
                label: 'bufferAfterBooking'.translate(context: context),
                required: false,
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _NumberField(controller: _bufferAfterController),
                  ),
                  const SizedBox(width: 8),
                  CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    borderRadius: UiUtils.borderRadiusOf8,
                    border: Border.all(
                      color: context.colorScheme.lightGreyColor,
                      width: 0.5,
                    ),
                    color: context.colorScheme.secondaryColor,
                    child: CustomText(
                      'minutes'.translate(context: context),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          CustomText(
            'defultBufferRulesHint'.translate(context: context),
            fontSize: 12,
            color: context.colorScheme.lightGreyColor,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: UiUtils.borderRadiusOf10,
      color: context.colorScheme.secondaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(title, fontWeight: FontWeight.w600, fontSize: 15),
          CustomDivider(
            color: context.colorScheme.lightGreyColor,
            thickness: 0.3,
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.required});

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: context.colorScheme.blackColor,
            ),
          ),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.redColor,
              ),
            ),
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      textInputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      showFullBorder: true,
      bottomPadding: 0,
    );
  }
}
