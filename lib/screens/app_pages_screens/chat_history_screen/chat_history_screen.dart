import 'dart:developer';

import '../../../config.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ChatHistoryProvider>(
        builder: (context1, lang, value, child) {
      return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            value.onBack();

            if (didPop) return;
          },
          child: StatefulWrapper(
            onInit: () {
              value.onReady(context);
            },
            child: Scaffold(
                appBar:
                    ActionAppBar(title: translations!.chatHistory, actions: [
                  if (value.chatHistory.isNotEmpty)
                    MoreOptionLayout(
                            onSelected: (index) =>
                                value.onTapOption(index, context, this),
                            list: appArray.chatHistoryOptionList)
                        .paddingSymmetric(horizontal: Insets.i20)
                ]),
                body: value.chatHistory.isEmpty
                    ? EmptyLayout(
                        isButton: false,
                        title: translations!.youHaveNotStartedChatYet,
                        subtitle: translations!.noChatDesc,
                        buttonText: translations!.refresh,
                        widget: Stack(children: [
                          Image.asset(
                            eImageAssets.notiBoy,
                            height: Sizes.s346,
                            width: MediaQuery.of(context).size.width,
                          ),
                          if (value.animationController != null)
                            Positioned(
                                top: MediaQuery.of(context).size.height * 0.05,
                                left: MediaQuery.of(context).size.height * 0.07,
                                child: RotationTransition(
                                    turns: Tween(begin: 0.05, end: -.1)
                                        .chain(CurveTween(
                                            curve: Curves.elasticInOut))
                                        .animate(value.animationController!),
                                    child: Image.asset(eImageAssets.noChat,
                                        height: Sizes.s40, width: Sizes.s40)))
                        ]))
                    : SingleChildScrollView(
                        child: Column(children: [
                        Column(
                                children: value.chatHistory
                                    .asMap()
                                    .entries
                                    .map((e) => ChatHistoryLayout(
                                        onTap: () {
                                          log(" e.value::${e.value.data()}");
                                          value.onChatClick(context, e.value);
                                        },
                                        data: e.value.data(),
                                        index: e.key,
                                        list: value.chatHistory))
                                    .toList())
                            .paddingAll(Insets.i15)
                            .boxShapeExtension(
                                color: appColor(context).appTheme.fieldCardBg)
                      ]).paddingSymmetric(
                            horizontal: Insets.i20, vertical: Sizes.s15))),
          ));
    });
  }
}
