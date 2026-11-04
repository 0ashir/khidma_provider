import 'package:edemand_partner/app/generalImports.dart';

class CustomAddButton extends StatelessWidget {
  const CustomAddButton({
    super.key,
    this.onTap,
    this.color,
    this.margin,
    this.padding,
    this.child,
  });
  final VoidCallback? onTap;
  final Color? color;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        borderRadius: UiUtils.borderRadiusOf10,
        margin: margin ?? const EdgeInsets.all(20),
        padding: padding ?? const EdgeInsets.all(16),
        color: color ?? context.colorScheme.accentColor,
        child: child,
      ),
    );
  }
}
