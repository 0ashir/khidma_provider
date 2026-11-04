import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class AssignHandymanBottomSheet extends StatefulWidget {
  const AssignHandymanBottomSheet({
    super.key,
    required this.orderId,
    required this.assignableHandymen,
    required this.alreadyAssignedIds,
  });

  final String orderId;
  final List<AssignedHandymanModel> assignableHandymen;
  final List<String> alreadyAssignedIds;

  @override
  State<AssignHandymanBottomSheet> createState() =>
      _AssignHandymanBottomSheetState();
}

class _AssignHandymanBottomSheetState extends State<AssignHandymanBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  List<AssignedHandymanModel> get _filtered {
    final String query = _searchQuery.toLowerCase();
    if (query.isEmpty) return widget.assignableHandymen;
    return widget.assignableHandymen
        .where((h) => h.username.toLowerCase().contains(query))
        .toList();
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssignHandymanCubit, AssignHandymanState>(
      listener: (context, state) {
        if (state is AssignHandymanSuccess) {
          Navigator.pop(context);
        } else if (state is AssignHandymanFailure) {
          UiUtils.showMessage(
            context,
            state.errorMessage,
            ToastificationType.error,
          );
        }
      },
      child: BottomSheetLayout(
        title: 'assignHandyman'.translate(context: context),
        child: CustomContainer(
          margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                controller: _searchController,
                bottomPadding: 0,
                hintText: 'search'.translate(context: context),
                prefix: const Icon(Icons.search, size: 20),
              ),
              CustomContainer(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45,
                ),
                child: _filtered.isEmpty
                    ? Center(
                        child: CustomText(
                          'noDataFound'.translate(context: context),
                          color: context.colorScheme.lightGreyColor,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: _filtered.map((h) {
                            final bool alreadyAssigned = widget
                                .alreadyAssignedIds
                                .contains(h.id);
                            final bool isSelected = _selectedIds.contains(h.id);
                            return Opacity(
                              opacity: alreadyAssigned ? 0.4 : 1.0,
                              child: CustomInkWellContainer(
                                onTap: alreadyAssigned
                                    ? null
                                    : () => _toggleSelection(h.id),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.accentColor,
                                      child: CustomText(
                                        h.username.isNotEmpty
                                            ? h.username[0].toUpperCase()
                                            : '?',
                                        color: AppColors.whiteColors,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomText(
                                            h.username,
                                            color:
                                                context.colorScheme.blackColor,
                                            fontSize: 14,
                                          ),
                                          if (h.hasConflict)
                                            CustomText(
                                              'handymanHasConflict'.translate(
                                                context: context,
                                              ),
                                              color: Colors.orange,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        ],
                                      ),
                                    ),
                                    CustomCheckBox(
                                      value: isSelected || alreadyAssigned,
                                      onChanged: (_) {
                                        if (!alreadyAssigned) {
                                          _toggleSelection(h.id);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),
              BlocBuilder<AssignHandymanCubit, AssignHandymanState>(
                builder: (context, state) {
                  final bool isLoading = state is AssignHandymanInProgress;
                  return Row(
                    children: [
                      Expanded(
                        child: CustomRoundedButton(
                          showBorder: true,
                          buttonTitle: 'cancel'.translate(context: context),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondaryColor,
                          titleColor: Theme.of(context).colorScheme.blackColor,
                          borderColor: Theme.of(context).colorScheme.blackColor,
                          widthPercentage: 1,
                          height: 50,
                          textSize: 14,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomRoundedButton(
                          showBorder: false,
                          buttonTitle: isLoading
                              ? ''
                              : 'assign'.translate(context: context),
                          backgroundColor: (_selectedIds.isEmpty || isLoading)
                              ? Theme.of(
                                  context,
                                ).colorScheme.accentColor.withValues(alpha: 0.5)
                              : Theme.of(context).colorScheme.accentColor,
                          widthPercentage: 1,
                          height: 50,
                          textSize: 14,
                          onTap: (_selectedIds.isEmpty || isLoading)
                              ? () {}
                              : () {
                                  context.read<AssignHandymanCubit>().assign(
                                    orderId: widget.orderId,
                                    handymanIds: _selectedIds.toList(),
                                  );
                                },
                          child: isLoading
                              ? CustomCircularProgressIndicator(
                                  color: AppColors.whiteColors,
                                )
                              : null,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
