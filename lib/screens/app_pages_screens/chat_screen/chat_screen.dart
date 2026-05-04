import 'dart:developer';
import '../../../config.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    log("data from previous screen------> $args");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatProvider.initializeChat(
        receiverId: args['userId'].toString(),
        receiverName: args['name'],
        senderName: args['senderName'],
        receiverImage: args['image'],
        receiverToken: args['token'],
        receiverPhone: args['phone'],
        receiverCode: args['code'],
        chatId: args['chatId'],
        bookingId: args['bookingId'],
        bookingNumber: args['bookingNumber'],
      );
    });
    return Consumer<ChatProvider>(
      builder: (context1, value, child) {
        // log("value.booking!.bookingStatus?.slug::${value.booking!.bookingStatus?.slug}////${appFonts.completed}");
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            value.onBack(context, false);
            if (didPop) return;
          },
          child: StatefulWrapper(
            onInit: () => Future.delayed(
              const Duration(milliseconds: 150),
              () => value.onReady(context),
            ),
            child: LoadingComponent(
              child: Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      ChatAppBarLayout(
                        onSelected: (index) {
                          if (index == 1) {
                            value.onClearChat(context, this, value);
                          } else {
                            value.onTapPhone(context);
                          }
                        },
                      ),
                      Expanded(
                        child: ListView(
                          reverse: true,
                          children: [
                            value
                                .timeLayout(context)
                                .marginOnly(bottom: Insets.i18),
                          ],
                        ),
                      ),
                      if (value.booking == null ||
                          value.booking!.bookingStatus?.slug !=
                              appFonts.completed)
                        Row(
                          children: [
                            // Text Field
                            Expanded(
                              child: TextFormField(
                                controller: value.controller,
                                maxLines: 4,
                                minLines: 1,
                                style: appCss.dmDenseMedium14.textColor(
                                  appColor(context).appTheme.darkText,
                                ),
                                cursorColor: appColor(
                                  context,
                                ).appTheme.darkText,
                                decoration: InputDecoration(
                                  fillColor: appColor(
                                    context,
                                  ).appTheme.whiteBg,
                                  filled: true,
                                  isDense: true,
                                  disabledBorder:
                                      CommonWidgetLayout().noneDecoration(
                                    color: appColor(
                                      context,
                                    ).appTheme.trans,
                                  ),
                                  focusedBorder:
                                      CommonWidgetLayout().noneDecoration(
                                    color: appColor(
                                      context,
                                    ).appTheme.trans,
                                  ),
                                  enabledBorder:
                                      CommonWidgetLayout().noneDecoration(
                                    color: appColor(
                                      context,
                                    ).appTheme.trans,
                                  ),
                                  border: CommonWidgetLayout().noneDecoration(
                                    color: appColor(
                                      context,
                                    ).appTheme.trans,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: Insets.i15,
                                    vertical: Insets.i15,
                                  ),
                                  prefixIcon: SvgPicture.asset(
                                    eSvgAssets.gallery,
                                    colorFilter: ColorFilter.mode(
                                      appColor(
                                        context,
                                      ).appTheme.lightText,
                                      BlendMode.srcIn,
                                    ),
                                  )
                                      .paddingSymmetric(
                                        horizontal: Insets.i20,
                                      )
                                      .inkWell(
                                        onTap: () => value.showLayout(
                                          context,
                                          value,
                                        ),
                                      ),
                                  hintStyle: appCss.dmDenseMedium14.textColor(
                                    appColor(
                                      context,
                                    ).appTheme.lightText,
                                  ),
                                  hintText: language(
                                    context,
                                    "Type here...",
                                  ),
                                  errorMaxLines: 2,
                                ),
                              ),
                            ),

                            // Send button
                            SizedBox(
                              child: SvgPicture.asset(
                                eSvgAssets.send,
                              ).paddingAll(Insets.i8),
                            )
                                .decorated(
                                  color: appColor(
                                    context,
                                  ).appTheme.primary,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(AppRadius.r6),
                                  ),
                                )
                                .marginSymmetric(horizontal: Insets.i20)
                                .inkWell(
                                  onTap: () => value.setMessage(
                                    value.controller.text,
                                    MessageType.text,
                                    context,
                                  ),
                                ),
                          ],
                        )
                            .boxBorderExtension(
                              context,
                              isShadow: true,
                              radius: 0,
                            )
                            .padding(bottom: Sizes.s10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
