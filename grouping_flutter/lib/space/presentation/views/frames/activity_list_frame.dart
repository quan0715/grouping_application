import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/activity_list_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/user_data_provider.dart';
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
  // late final UserSpaceViewModel userPageViewModel;
  late final ActivityListViewModel activityListViewModel;

  @override
  void initState() {
    super.initState();
    // userPageViewModel = UserSpaceViewModel();
    var userData = Provider.of<UserDataProvider>(context, listen: false);
    // userPageViewModel.userDataProvider = userData;
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
      ),
    ], child: _buildBody());
    // return ChangeNotifierProvider<ActivityListViewModel>(
    //       create: (context) => activityListViewModel..init(),
    //       child: _buildBody(),);
  }

  Widget _buildBody() {
    DateFormat dateFormat = DateFormat("MM 月 dd 日 EEEE", "zh");

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
                  firstDayOfWeek: 1,        // first day of week, this is Monday, should let the user set the first day of week?
                  headerDateFormat: "y 年 MM 月",
                  headerHeight: 25,
                  headerStyle: CalendarHeaderStyle(
                      textStyle: TextStyle(fontSize: 15, color: widget.color)),
                  monthViewSettings: const MonthViewSettings(
                      numberOfWeeksInView: 4, dayFormat: 'EEE'),
                  showDatePickerButton: true,
                  showTodayButton: true,
                  initialDisplayDate: activityListViewModel.setInitialDate(),
                  dataSource:
                      ActivityData(activityListViewModel.activities!),
                  onTap: (calendarTapDetails) {
                    if(calendarTapDetails.targetElement == CalendarElement.header) {
                      return;
                    }
                    activityListViewModel.setSeletedDay(
                        calendarTapDetails.date ?? DateTime.now());
                    // debugPrint((calendarTapDetails.date! == activityListViewModel.getSeletedDay()).toString());




                    setState(() {
                      // TODO: I can't find out what happen here
                      // activityListViewModel should refresh the screen
                    });



                  },
                ),
              )),
          const Divider(),
          Text(
            dateFormat.format(activityListViewModel.getSeletedDay()),
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: widget.color),
          ),
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
