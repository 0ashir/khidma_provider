import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';
import '../../../../cubits/providerOnlineStatusCubit.dart';

/// Home dashboard block: the provider's own online/offline switch and a
/// "Team status" strip with an ON/OFF switch per handyman.
///
/// Provider offline = hidden from customers, no new bookings (server side).
/// Handyman OFF = account inactive (existing toggle_handyman_status), which
/// the server refuses while the handyman still has an open booking.
class ProviderTeamStatusSection extends StatefulWidget {
  const ProviderTeamStatusSection({super.key});

  @override
  State<ProviderTeamStatusSection> createState() =>
      ProviderTeamStatusSectionState();
}

class ProviderTeamStatusSectionState extends State<ProviderTeamStatusSection>
    with WidgetsBindingObserver {
  /// Handymen can go online/offline from their own app, so the team strip
  /// re-reads their status periodically and when the app is resumed.
  static const Duration _teamRefreshInterval = Duration(seconds: 30);
  Timer? _teamRefreshTimer;

  static const Color _green = Color(0xFF22A447);
  static const Color _grey = Color(0xFF9CA3AF);

  final ProviderOnlineStatusCubit _statusCubit = ProviderOnlineStatusCubit();
  final ManageHandymanRepository _repository = ManageHandymanRepository();

  List<HandymanModel> _team = [];
  bool _teamLoaded = false;
  final Set<String> _togglingIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    refresh();
    _teamRefreshTimer = Timer.periodic(_teamRefreshInterval, (_) {
      if (_togglingIds.isEmpty) _loadTeam();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _togglingIds.isEmpty) {
      _loadTeam();
    }
  }

  @override
  void dispose() {
    _teamRefreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _statusCubit.close();
    super.dispose();
  }

  /// Reloads both the provider status and the team list.
  Future<void> refresh() async {
    _statusCubit.fetch();
    await _loadTeam();
  }

  Future<void> _loadTeam() async {
    try {
      final result = await _repository.getHandymen(offset: 0, limit: 50);
      // A switch tapped while this was loading wins over the older data.
      if (!mounted || _togglingIds.isNotEmpty) return;
      setState(() {
        _team = result.modelList;
        _teamLoaded = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _teamLoaded = true);
    }
  }

  String _t(String key, String fallback) {
    final String value = key.translate(context: context);
    return (value.isEmpty || value == key) ? fallback : value;
  }

  void _setActiveLocally(String id, int active) {
    setState(() {
      _team = _team
          .map((e) => e.id == id ? e.copyWith(active: active) : e)
          .toList();
    });
  }

  void _setOnlineLocally(String id, {required int active, required int available}) {
    setState(() {
      _team = _team
          .map((e) => e.id == id
              ? e.copyWith(active: active, isAvailable: available)
              : e)
          .toList();
    });
  }

  /// The switch shows the handyman's online status (account on AND online).
  /// ON sets them online (re-activating the account if needed), OFF sets them
  /// offline; either way it overrides the handyman's own dashboard switch.
  Future<void> _toggleHandyman(HandymanModel handyman) async {
    if (_togglingIds.contains(handyman.id)) return;
    final bool wasOnline = handyman.isActive && handyman.available;
    final bool goOnline = !wasOnline;
    _togglingIds.add(handyman.id);
    _setOnlineLocally(
      handyman.id,
      active: goOnline ? 1 : handyman.active,
      available: goOnline ? 1 : 0,
    );
    try {
      await _repository.setHandymanOnline(handyman.id, online: goOnline);
      if (!mounted) return;
      if (goOnline && !handyman.isActive) {
        // Keep the Manage Handymen list in sync with the re-activation.
        context.read<FetchHandymenCubit>().setActive(handyman.id, 1);
      }
      UiUtils.showMessage(
        context,
        goOnline
            ? _t('handymanSetOnline', 'Handyman is now online')
            : _t('handymanSetOffline', 'Handyman is now offline'),
        ToastificationType.success,
      );
    } catch (e) {
      if (!mounted) return;
      _setOnlineLocally(
        handyman.id,
        active: handyman.active,
        available: handyman.isAvailable,
      );
      UiUtils.showMessage(context, e.toString(), ToastificationType.error);
    } finally {
      _togglingIds.remove(handyman.id);
      if (mounted) setState(() {});
    }
  }

  void _onProviderSwitch(bool currentlyOnline) {
    _statusCubit.setOnline(!currentlyOnline);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Toggles made on the Manage Handymen screen.
        BlocListener<HandymanToggleCubit, HandymanToggleState>(
          listener: (context, state) {
            if (state is HandymanToggleSuccess &&
                state.kind == HandymanToggleKind.status) {
              _setActiveLocally(state.id, state.value);
            }
          },
        ),
        BlocListener<ProviderOnlineStatusCubit, ProviderOnlineStatusState>(
          bloc: _statusCubit,
          listenWhen: (a, b) => a.messageId != b.messageId,
          listener: (context, state) {
            final String message = state.message ?? '';
            if (message.isEmpty) return;
            UiUtils.showMessage(
              context,
              message,
              state.isError
                  ? ToastificationType.error
                  : ToastificationType.success,
            );
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProviderRow(),
            const SizedBox(height: 12),
            _buildTeam(),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderRow() {
    return BlocBuilder<ProviderOnlineStatusCubit, ProviderOnlineStatusState>(
      bloc: _statusCubit,
      builder: (context, state) {
        final bool? online = state.isOnline;
        return Row(
          children: [
            Expanded(
              child: CustomText(
                _t('providerStatusLbl', 'Provider status'),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.colorScheme.blackColor,
              ),
            ),
            if (online != null) ...[
              CustomText(
                online
                    ? _t('onlineLbl', 'Online')
                    : _t('offlineLbl', 'Offline'),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: online ? _green : _grey,
              ),
              const SizedBox(width: 8),
              StatusPillSwitch(
                value: online,
                width: 52,
                height: 28,
                onText: _t('onToggleLbl', 'ON'),
                offText: _t('offToggleLbl', 'OFF'),
                isBusy: state.isUpdating,
                onTap: () => _onProviderSwitch(online),
              ),
            ] else
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTeam() {
    final String lang = HiveRepository.getCurrentLanguage()?.languageCode ?? 'en';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          _t('teamStatusLbl', 'Team status'),
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: context.colorScheme.blackColor,
        ),
        const SizedBox(height: 8),
        if (!_teamLoaded)
          const SizedBox(
            height: 58,
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (_team.isEmpty)
          GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(Routes.manageHandymen)
                .then((_) => _loadTeam()),
            child: CustomText(
              _t('noTeamMembersLbl', 'No handymen yet. Tap to add your team.'),
              fontSize: 12,
              color: context.colorScheme.lightGreyColor,
            ),
          )
        else
          SizedBox(
            height: 58,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _team.length,
              separatorBuilder: (_, __) => VerticalDivider(
                width: 14,
                thickness: 0.8,
                indent: 4,
                endIndent: 4,
                color: context.colorScheme.lightGreyColor.withAlpha(60),
              ),
              itemBuilder: (context, index) =>
                  _buildMember(_team[index], lang),
            ),
          ),
      ],
    );
  }

  Widget _buildMember(HandymanModel handyman, String lang) {
    final bool active = handyman.isActive;
    // Online = account switched on by the provider AND the handyman is
    // online on their own dashboard.
    final bool online = active && handyman.available;
    final String statusText =
        online ? _t('onlineLbl', 'Online') : _t('offlineLbl', 'Offline');
    final Color statusColor = online ? _green : _grey;

    return SizedBox(
      width: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatusPillSwitch(
            value: online,
            width: 40,
            height: 20,
            onText: _t('onToggleLbl', 'ON'),
            offText: _t('offToggleLbl', 'OFF'),
            isBusy: _togglingIds.contains(handyman.id),
            onTap: () => _toggleHandyman(handyman),
          ),
          const SizedBox(height: 5),
          CustomText(
            handyman.usernameForLanguage(lang),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            maxLines: 1,
            textAlign: TextAlign.center,
            color: context.colorScheme.blackColor,
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: CustomText(
                  statusText,
                  fontSize: 10,
                  maxLines: 1,
                  color: context.colorScheme.lightGreyColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Pill-shaped ON/OFF switch: green with the knob on the end side when on,
/// light grey with the knob on the start side when off.
class StatusPillSwitch extends StatelessWidget {
  const StatusPillSwitch({
    super.key,
    required this.value,
    required this.onTap,
    required this.onText,
    required this.offText,
    this.width = 44,
    this.height = 22,
    this.isBusy = false,
  });

  final bool value;
  final VoidCallback onTap;
  final String onText;
  final String offText;
  final double width;
  final double height;
  final bool isBusy;

  static const Color _onColor = Color(0xFF22A447);
  static const Color _offColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final double knob = height - 6;
    return GestureDetector(
      onTap: isBusy ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: isBusy ? 0.6 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,
          height: height,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? _onColor : _offColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            children: [
              Align(
                alignment: value
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.18),
                  child: Text(
                    value ? onText : offText,
                    style: TextStyle(
                      fontSize: height * 0.4,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      color: value ? Colors.white : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: value
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: Container(
                  width: knob,
                  height: knob,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: isBusy
                      ? Padding(
                          padding: EdgeInsets.all(knob * 0.2),
                          child: const CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: _onColor,
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
