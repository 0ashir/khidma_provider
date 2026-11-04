import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

enum _BidStatus { booked, notSelected, cancelled, waiting }

_BidStatus _getBidStatus(JobRequestModel model, String currentPartnerId) {
  final status = model.status?.toLowerCase() ?? '';
  if (status == 'booked') {
    return model.partnerId == currentPartnerId
        ? _BidStatus.booked
        : _BidStatus.notSelected;
  }
  if (status == 'cancelled') return _BidStatus.cancelled;
  // pending → waiting
  return _BidStatus.waiting;
}

class BidStatusBanner extends StatelessWidget {
  const BidStatusBanner({super.key, required this.model});

  final JobRequestModel model;

  @override
  Widget build(BuildContext context) {
    final currentPartnerId =
        context
            .read<ProviderDetailsCubit>()
            .providerDetails
            .providerInformation
            ?.partnerId ??
        '';
    final bidStatus = _getBidStatus(model, currentPartnerId);

    switch (bidStatus) {
      case _BidStatus.booked:
        return const _BannerTile(
          color: AppColors.greenColor,
          icon: Icons.check_circle_outline_rounded,
          messageKey: 'bidBookedMsg',
        );
      case _BidStatus.notSelected:
        return const _BannerTile(
          color: AppColors.redColor,
          icon: Icons.cancel_outlined,
          messageKey: 'bidNotSelectedMsg',
        );
      case _BidStatus.cancelled:
        return const _BannerTile(
          color: Color(0xFF9E9E9E),
          icon: Icons.do_not_disturb_outlined,
          messageKey: 'bidCancelledMsg',
        );
      case _BidStatus.waiting:
        // ── Timer (commented — uncomment to re-enable countdown) ──────────
        // if (model.requestEndDateTime != null)
        //   _WaitingTimerRow(endDateTime: model.requestEndDateTime!),
        // ──────────────────────────────────────────────────────────────────
        return const _BannerTile(
          color: Color(0xFFFF9800),
          icon: Icons.hourglass_top_rounded,
          messageKey: 'bidUnderReviewMsg',
        );
    }
  }
}

// ── Banner tile with left accent bar + icon circle ───────────────────────────

class _BannerTile extends StatelessWidget {
  const _BannerTile({
    required this.color,
    required this.icon,
    required this.messageKey,
  });

  final Color color;
  final IconData icon;
  final String messageKey;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: color),
            Expanded(
              child: Container(
                color: color.withValues(alpha: 0.07),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withValues(alpha: 0.15),
                      ),
                      child: Icon(icon, size: 17, color: color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomText(
                        messageKey.translate(context: context),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Waiting timer (commented — see BidStatusBanner.build to re-enable) ───────
//
// class _WaitingTimerRow extends StatefulWidget {
//   const _WaitingTimerRow({required this.endDateTime});
//   final DateTime endDateTime;
//   @override
//   State<_WaitingTimerRow> createState() => _WaitingTimerRowState();
// }
//
// class _WaitingTimerRowState extends State<_WaitingTimerRow>
//     with WidgetsBindingObserver {
//   late Duration _remaining;
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _recalculate();
//     _startTimer();
//   }
//
//   void _recalculate() {
//     final r = widget.endDateTime.difference(DateTime.now());
//     _remaining = r.isNegative ? Duration.zero : r;
//   }
//
//   void _startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (!mounted) return;
//       final r = widget.endDateTime.difference(DateTime.now());
//       setState(() {
//         _remaining = r.isNegative ? Duration.zero : r;
//       });
//       if (_remaining == Duration.zero) _timer?.cancel();
//     });
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       if (mounted) {
//         setState(_recalculate);
//         _startTimer();
//       }
//     } else if (state == AppLifecycleState.paused) {
//       _timer?.cancel();
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   Color _color() {
//     if (_remaining == Duration.zero) return AppColors.redColor;
//     if (_remaining.inHours < 1) return AppColors.redColor;
//     if (_remaining.inHours < 6) return const Color(0xFFFF9800);
//     return AppColors.greenColor;
//   }
//
//   String _formatted() {
//     if (_remaining == Duration.zero)
//       return 'expired'.translate(context: context);
//     final int d = _remaining.inDays;
//     final int h = _remaining.inHours % 24;
//     final int m = _remaining.inMinutes % 60;
//     final int s = _remaining.inSeconds % 60;
//     if (d > 0)
//       return '${d}d ${h.toString().padLeft(2, '0')}h ${m.toString().padLeft(2, '0')}m';
//     return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final color = _color();
//     return CustomContainer(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       borderRadius: UiUtils.borderRadiusOf5,
//       color: color.withValues(alpha: 0.1),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.timer_outlined, size: 13, color: color),
//           const SizedBox(width: 4),
//           CustomText(
//             '${'timeLeft'.translate(context: context)}: ${_formatted()}',
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             color: color,
//           ),
//         ],
//       ),
//     );
//   }
// }
