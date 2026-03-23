import 'package:fixit_provider/screens/app_pages_screens/custom_job_request/job_request_list/layouts/job_request_list_card.dart';

import '../../../../config.dart';
import '../../../../providers/app_pages_provider/job_request_providers/job_request_list_provider.dart';

class JobRequestList extends StatefulWidget {
  const JobRequestList({super.key});

  @override
  State<JobRequestList> createState() => _JobRequestListState();
}

class _JobRequestListState extends State<JobRequestList>
    with TickerProviderStateMixin {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final dash = Provider.of<UserDataApiProvider>(context,listen: false);
    dash.getJobRequest(context);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<JobRequestListProvider>(builder: (context1, value, child) {
      return LoadingComponent(
        child: Scaffold(
            appBar: AppBarCommon(title: translations!.customJobRequest),
            body: RefreshIndicator(
              onRefresh: () async {
                value.onRefresh(context);
              },
              child: jobRequestList.isNotEmpty
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ListView(children: [
                          Column(
                            children: [
                              if (jobRequestList != null &&
                                  jobRequestList.isNotEmpty)
                                ...jobRequestList.asMap().entries.map(
                                    (data) =>
                                        JobRequestListCard(data: data.value))
                              else
                                // Optionally show empty state
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text("No job requests found."),
                                ),
                              /*  ...jobRequestList
                                  .asMap()
                                  .entries
                                  .map((data) => JobRequestListCard(
                                        data: data.value,
                                      )) */
                            ],
                          )
                        ]).paddingSymmetric(horizontal: Insets.i20),
                        //  ButtonCommon(title: translations!.requestNewJob,margin: 20,onTap: ()=>route.pushNamed(context,routeName.addJobRequestList),).marginOnly(bottom: 20)
                      ],
                    )
                  : EmptyLayout(
                      widget: Image.asset(eImageAssets.noSearch,
                          height: Sizes.s380),
                      title: translations!.oopsYour,
                      subtitle: translations!.noDataFound,
                      // isButtonShow: false,
                    ).center(),
            )),
      );
    });
  }
}
