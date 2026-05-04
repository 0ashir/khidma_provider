import 'dart:developer';

import 'package:fixit_provider/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddFaq extends StatefulWidget {
  final List? faqList;
  const AddFaq({super.key, this.faqList});

  @override
  State<AddFaq> createState() => _AddFaqState();
}

class _AddFaqState extends State<AddFaq> {
  List<List<TextEditingController>> controllers = [];

  @override
  void initState() {
    super.initState();
    log("DATA :4${widget.faqList}");
    // Initialize with one row of two default text boxes
    if (widget.faqList!.isNotEmpty) {
      for (var d in widget.faqList!) {
        controllers.add([
          TextEditingController(text: d['question']),
          TextEditingController(text: d['answer'])
        ]);
      }
    } else {
      log("HADGH");
      controllers.add([TextEditingController(), TextEditingController()]);
    }
    setState(() {});
  }

  void _addTextBoxRow() {
    setState(() {
      controllers.add([TextEditingController(), TextEditingController()]);
    });
  }

  onAddTap(BuildContext context) {
    List<Map<String, String>> faqList = [];
    bool hasError = false; // Flag to track validation

    for (var element in controllers) {
      String question = element[0].text.trim();
      String answer = element[1].text.trim();

      // Validate input fields
      if (question.isEmpty || answer.isEmpty) {
        hasError = true;
        break; // Exit loop if validation fails
      }

      var data = {
        "question": question,
        "answer": answer,
      };
      faqList.add(data);
    }

    // If any field is empty, show an error and return
    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all FAQ fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Proceed if validation passes
    setState(() {});
    route.pop(context, arg: faqList);
    controllers = [];
  }

  removeRow(index) {
    controllers.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 80,
          title: Text(language(context, translations!.addFaq),
              style: appCss.dmDenseBold18
                  .textColor(appColor(context).appTheme.darkText)),
          centerTitle: true,
          leading: CommonArrow(
              arrow:
                  rtl(context) ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
              onTap: () => route.pop(context)).padding(vertical: Insets.i8)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.s20),
        children: [
          const VSpace(Sizes.s20),
          ...controllers.asMap().entries.map((e) => Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    children: [
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Question cannot be empty";
                            }
                            return null;
                          },
                          controller: e.value[0],
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.darkText),
                          decoration: InputDecoration(
                              fillColor: appColor(context).appTheme.fieldCardBg,
                              filled: true,
                              isDense: true,
                              disabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppRadius.r8)),
                                  borderSide: BorderSide.none),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppRadius.r8)),
                                  borderSide: BorderSide.none),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppRadius.r8)),
                                  borderSide: BorderSide.none),
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppRadius.r8)),
                                  borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Insets.i15, vertical: Insets.i15),
                              hintStyle: appCss.dmDenseMedium14.textColor(appColor(context).appTheme.lightText),
                              hintText: language(context, "Enter Question"),
                              errorMaxLines: 2)),
                      const HSpace(Sizes.s10),
                      const VSpace(Sizes.s15),
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Answer cannot be empty";
                            }
                            return null;
                          },
                          controller: e.value[1],
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.darkText),
                          maxLines: 3,
                          decoration: InputDecoration(
                              fillColor: appColor(context).appTheme.fieldCardBg,
                              filled: true,
                              isDense: true,
                              disabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppRadius.r8)),
                                  borderSide: BorderSide.none),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppRadius.r8)),
                                  borderSide: BorderSide.none),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppRadius.r8)),
                                  borderSide: BorderSide.none),
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppRadius.r8)),
                                  borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Insets.i15, vertical: Insets.i15),
                              hintStyle: appCss.dmDenseMedium14.textColor(appColor(context).appTheme.lightText),
                              hintText: language(context, "Enter Anser"),
                              errorMaxLines: 2))
                    ],
                  )
                      .paddingAll(Sizes.s20)
                      .boxBorderExtension(context, isShadow: true)
                      .paddingOnly(bottom: Sizes.s20, top: 10),
                  Icon(CupertinoIcons.minus_circle_fill,
                          size: 26, color: appColor(context).appTheme.darkText)
                      .inkWell(onTap: () => removeRow(e.key))
                ],
              )),
          Row(
            children: [
              if (controllers.isNotEmpty)
                Expanded(
                  child: ButtonCommon(
                      title: language(context, translations!.save),
                      onTap: () => onAddTap(context)),
                ),
              const HSpace(Sizes.s10),
              Expanded(
                child: ButtonCommon(
                    title: language(context, translations!.addFaq),
                    onTap: _addTextBoxRow),
              ),
            ],
          )
        ],
      ),
    );
  }
}
