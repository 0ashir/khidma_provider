import '../../../../config.dart';

class CustomTimePicker extends StatelessWidget {
  final Function(int) onScroll;
  final CarouselSliderController carouselController;
  final List<String> itemList;

  const CustomTimePicker(
      {super.key,
      required this.onScroll,
      required this.carouselController,
      required this.itemList});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeSlotProvider>(builder: (context, dateTimePvr, child) {
      return SizedBox(
          height: 100,
          width: 100,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const VSpace(6),
            Expanded(
              child: CarouselSlider.builder(
                  carouselController: carouselController,
                  itemCount: itemList.length,
                  itemBuilder: (context, index, realIndex) {
                    return Text(
                        textAlign: TextAlign.center,
                        itemList[index],
                        style: TextStyle(
                            color: appColor(context).appTheme.primary,
                            fontSize: 22));
                  },
                  options: CarouselOptions(
                      aspectRatio: 16 / 4,
                      onPageChanged: (index, reason) => onScroll(index),
                      autoPlay: false,
                      scrollDirection: Axis.vertical)),
            ),
          ]));
    });
  }
}
