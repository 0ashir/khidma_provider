import '../../../../config.dart';

class ServicemanDocImageList extends StatelessWidget {
  const ServicemanDocImageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddServicemenProvider>(builder: (context1, value, child) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            ...appArray.servicemanDocImageList
                .asMap()
                .entries
                .map((e) => AddServiceImageLayout(
                    image: e.value,
                    onDelete: () {
                      appArray.servicemanDocImageList.removeAt(e.key);
                      value.notifyListeners();
                    })),
            if (appArray.servicemanDocImageList.length < 2)
              AddNewBoxLayout(onAdd: () => value.onImagePick(context, false))
          ]).padding(horizontal: Insets.i20));
    });
  }
}
