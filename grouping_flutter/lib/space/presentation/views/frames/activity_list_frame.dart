import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/activity_list_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/layout/activity_layout.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarFrame extends StatefulWidget {
  const CalendarFrame({super.key, required this.color});

  final Color color;

  @override
  State<CalendarFrame> createState() => _CalendarFrameState();
}

class _CalendarFrameState extends State<CalendarFrame> {
  // late final UserSpaceViewModel userPageViewModel;
  late final ActivityListViewModel activityListViewModel;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) =>  _buildBody();
  

  Widget _buildBody() {
    // DateFormat dateFormat = DateFormat("MM 月 dd 日 EEEE", "zh");
    return Consumer<ActivityListViewModel>(
      builder: (context, activityListViewModel, child) => DashboardFrameLayout(
        frameColor: widget.color,
        child: Column(
          children: [
            Padding(
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
                  activityListViewModel.setSelectedDay(calendarTapDetails.date ?? DateTime.now());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityListFrame extends StatefulWidget {
  const ActivityListFrame({super.key, required this.color});

  final Color color;

  @override
  State<ActivityListFrame> createState() => _ActivityListFrameState();
}

class _ActivityListFrameState extends State<ActivityListFrame> {

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  final dateFormat = DateFormat("MM 月 dd 日 EEEE", "zh");

  @override
  Widget build(BuildContext context) => _buildBody();

  Widget _buildBody() {
    return Consumer<ActivityListViewModel>(
      builder: (context, activityListViewModel, child) => DashboardFrameLayout(
        frameColor: widget.color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateFormat.format(activityListViewModel.getSelectedDay()),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: widget.color,
                    fontWeight: FontWeight.bold,   
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              child: ActivityLayout(
                title: "事件",
                isWorkspace: false,
                type: ActivityType.event,
                color: widget.color,
              )),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              child: ActivityLayout(
                title: "任務",
                isWorkspace: false,
                type: ActivityType.mission,
                color: widget.color,
              ))
          ],
        ),
      ),
    );
  }
}
