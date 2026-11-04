import '../../app/generalImports.dart';

class CustomCheckIconTextButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final String? subtitle;
  final String? startDate;
  final VoidCallback? onStartDateTap;
  final String? endDate;
  final VoidCallback? onEndDateTap;

  const CustomCheckIconTextButton({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
    this.startDate,
    this.onStartDateTap,
    this.endDate,
    this.onEndDateTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? context.colorScheme.accentColor
                : context.colorScheme.lightGreyColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSvgPicture(
                  svgImage: AppAssets.checkCircle,
                  height: 20,
                  width: 20,
                  color: isSelected
                      ? context.colorScheme.accentColor
                      : context.colorScheme.lightGreyColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomText(
                    title.translate(context: context),
                    color: context.colorScheme.blackColor,
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Center(
                child: CustomText(
                  subtitle!,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? context.colorScheme.accentColor
                      : context.colorScheme.lightGreyColor,
                ),
              ),
            ],
            if (startDate != null && endDate != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: isSelected ? onStartDateTap : null,
                    child: Row(
                      children: [
                        CustomText(
                          'openAt'.translate(context: context),
                          color: isSelected
                              ? context.colorScheme.accentColor
                              : context.colorScheme.lightGreyColor,
                          showUnderline: true,
                          underlineOrLineColor: isSelected
                              ? context.colorScheme.accentColor
                              : context.colorScheme.lightGreyColor,
                          fontSize: 12,
                        ),
                        if (startDate != '')
                          CustomText(
                            ' ${startDate!}',
                            color: isSelected
                                ? context.colorScheme.accentColor
                                : context.colorScheme.lightGreyColor,
                            showUnderline: true,
                            underlineOrLineColor: isSelected
                                ? context.colorScheme.accentColor
                                : context.colorScheme.lightGreyColor,
                            fontSize: 12,
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: isSelected ? onEndDateTap : null,
                    child: Row(
                      children: [
                        CustomText(
                          'closeAt'.translate(context: context),
                          color: isSelected
                              ? context.colorScheme.accentColor
                              : context.colorScheme.lightGreyColor,
                          showUnderline: true,
                          underlineOrLineColor: isSelected
                              ? context.colorScheme.accentColor
                              : context.colorScheme.lightGreyColor,
                          fontSize: 12,
                        ),
                        if (endDate != '')
                          CustomText(
                            ' ${endDate!}',
                            color: isSelected
                                ? context.colorScheme.accentColor
                                : context.colorScheme.lightGreyColor,
                            showUnderline: true,
                            underlineOrLineColor: isSelected
                                ? context.colorScheme.accentColor
                                : context.colorScheme.lightGreyColor,
                            fontSize: 12,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
