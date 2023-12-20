import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/activity_list_view_model.dart';
import 'package:grouping_project/space/presentation/provider/user_data_provider.dart';
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
    DateFormat dateFormat = DateFormat("MM 月 d 日 EEEE", "zh");

    return Consumer<ActivityListViewModel>(
      builder: (context, activityListViewModel, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SfCalendar(
              view: CalendarView.month,
              headerDateFormat: "y 年 MM 月",
              // headerStyle: CalendarHeaderStyle(
              //     textStyle: TextStyle(fontSize: 15, color: widget.color)),
              // timeSlotViewSettings: TimeSlotViewSettings(
              //     timeInterval: Duration(hours: 1),
              //     timeIntervalHeight: 50,
              //     timeTextStyle: TextStyle(
              //         fontSize: 15,
              //         color: widget.color,
              //         fontWeight: FontWeight.bold),
              // ),
              monthViewSettings: const MonthViewSettings(
                numberOfWeeksInView: 4, 
                dayFormat: 'EEE', 
                // showAgenda: true,
                
              ),
              showDatePickerButton: true,
              showTodayButton: true,
              dataSource:
                  ActivityDataSource(activityListViewModel.activities!),
              onTap: (calendarTapDetails) {
                activityListViewModel.setSeletedDay(
                    calendarTapDetails.date ?? DateTime.now());
                // debugPrint((calendarTapDetails.date! == activityListViewModel.getSeletedDay()).toString());
          
          
          
          
                setState(() {
                  // TODO: I can't find out what happen here
                  // activityListViewModel should refresh the screen
                });
          
          
          
              },
            ),
          ),
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
