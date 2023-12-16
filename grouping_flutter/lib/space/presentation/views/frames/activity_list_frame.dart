import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/activity_list_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/layout/activity_layout.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ActivityListFrame extends StatefulWidget {
  const ActivityListFrame({super.key, required this.color});

  final Color color;

  @override
  State<ActivityListFrame> createState() => _ActivityListFrameState();
}

class _ActivityListFrameState extends State<ActivityListFrame> {
  late final UserSpaceViewModel userPageViewModel;
  late final ActivityListViewModel activityListViewModel;

  @override
  void initState() {
    super.initState();
    userPageViewModel = UserSpaceViewModel();
    var userData = Provider.of<UserDataProvider>(context, listen: false);
    userPageViewModel.userDataProvider = userData;
    activityListViewModel = ActivityListViewModel(userDataProvider: userData);
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProxyProvider<UserDataProvider, ActivityListViewModel>(
        create: (context) => activityListViewModel..init(),
        update: (context, userDataProvider, activityListViewModel) =>
            activityListViewModel!..update(userDataProvider),
      )
    ], child: _buildBody());
  }

  Widget _buildBody() {
    DateFormat dateFormat = DateFormat("MM 月 d 日 EEEE", "zh");

    return Consumer<ActivityListViewModel>(
      builder: (context, activityListViewModel, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SfCalendar(
                  view: CalendarView.month,
                  headerDateFormat: "y 年 MM 月",
                  headerHeight: 25,
                  headerStyle: CalendarHeaderStyle(
                      textStyle: TextStyle(fontSize: 15, color: widget.color)),
                  monthViewSettings:
                      const MonthViewSettings(numberOfWeeksInView: 2, dayFormat: 'EEE'),
                  showDatePickerButton: true,
                  showTodayButton: true,
                  dataSource: ActivityDataSource(activityListViewModel.activities!),
                ),
              )),
          const Divider(),
          Text(dateFormat.format(DateTime.now()), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: widget.color),),
          Expanded(
              flex: 6,
              child: ActivityLayOut(
                title: "事件",
                isWorkspace: false,
                type: ActivityType.event,
                color: widget.color,
              )),
          Expanded(
              flex: 8,
              child: ActivityLayOut(
                title: "任務",
                isWorkspace: false,
                type: ActivityType.mission,
                color: widget.color,
              ))
        ],
      ),
    );
  }
}
