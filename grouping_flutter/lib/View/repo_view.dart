// /// this file is temporary
// /// it will be deleted after testing repo and new view has been designed

// import 'package:flutter/material.dart';
// import 'package:grouping_project/View/components/color_tag_chip.dart';
// import 'package:grouping_project/View/theme/theme_manager.dart';
// import 'package:grouping_project/ViewModel/workspace/event_view_model.dart';
// import 'package:grouping_project/model/workspace/workspace_model_lib.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:day_night_time_picker/day_night_time_picker.dart';
// import 'package:intl/intl.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<ThemeManager>(create: (_) => ThemeManager()),
//         ChangeNotifierProvider<EventSettingViewModel>(create: (_) => EventSettingViewModel())
//       ],
//       child: Consumer<ThemeManager>(
//         builder: (context, themeManager, child) => MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Flutter with Django',
//           // theme: ThemeData(
//           //   primarySwatch: Colors.blue,
//           // ),
//           theme: ThemeData(
//             brightness: themeManager.brightness,
//             useMaterial3: true,
//             colorSchemeSeed: themeManager.colorSchemeSeed,
//             fontFamily: 'NotoSansTC',
//           ),
//           home: MyHomePage(
//             title: 'Flutter with Django',
//             themeManager: themeManager,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage(
//       {super.key, required this.title, required this.themeManager});

//   final String title;
//   final ThemeManager themeManager;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   DateFormat dataformat = DateFormat('h:mm a, MMM d, y');
//   // static const navigateToAddPageButtonKey = Key('navigateToAddPageButtonKey');

//   @override
//   void initState() {
//     super.initState();
//   }

//   List<EventModel> objects = [];
// void onClick(EventSettingViewModel eventSettingVM) async {
//     // debugPrint('open event page');
//     context.read<ThemeManager>().updateColorSchemeSeed(Colors.amber);
//     const animationDuration = Duration(milliseconds: 400);
//     final isNeedRefresh = await Navigator.push(
//         context,
//         PageRouteBuilder(
//             transitionDuration: animationDuration,
//             reverseTransitionDuration: animationDuration,
//             pageBuilder: (BuildContext context, __, ___) =>
//                 MultiProvider(providers: [
//                   ChangeNotifierProvider<EventSettingViewModel>.value(
//                       value: eventSettingVM),
//                 ], child: const AddEventPage())));
//   }
//   @override
//   Widget build(BuildContext context) {
//           ThemeData themeData = ThemeData(
//               colorSchemeSeed: Colors.amber,
//               brightness: context.watch<ThemeManager>().brightness);
//     return Consumer<EventSettingViewModel>(
//       builder: (context, provider, child) => Scaffold(
//           appBar: AppBar(
//             backgroundColor: Theme.of(context).colorScheme.surface,
//             elevation: 2,
//             // Here we take the value from the MyHomePage object that was created by
//             // the App.build method, and use it to set our appbar title.
//             title: Text(widget.title),
//             actions: [
//               IconButton(
//                   //temp remove async for quick test
//                   onPressed: widget.themeManager.toggleTheme,
//                   icon: Icon(widget.themeManager.icon,
//                       color: Theme.of(context).colorScheme.onSurfaceVariant)),
//               IconButton(
//                   onPressed: () {
//                     Navigator.of(context)
//                         .push(MaterialPageRoute(
//                             builder: ((context) => const AddEventPage())))
//                         .then(
//                             (value) => {if (value != null) objects.add(value)});
//                   },
//                   icon: Icon(Icons.add,
//                       color: Theme.of(context).colorScheme.onSurfaceVariant)),
//               IconButton(
//                   onPressed: () => setState(() {}),
//                   icon: const Icon(Icons.refresh))
//             ],
//           ),
//           body: ListView.builder(
//             shrinkWrap: true,
//             itemCount: objects.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Hero(
//             tag: "${objects[index].id}",
//             child: Padding(
//               padding: const EdgeInsets.all(5.0),
//               // TODO: delete ratio?
//               child: AspectRatio(
//                 aspectRatio: 3.3,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: themeData.colorScheme.surface,
//                       foregroundColor: themeData.colorScheme.primary,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       elevation: 4,
//                       padding: const EdgeInsets.all(3)),
//                   onPressed: () => onClick(provider),
//                   child: Row(
//                     children: [
//                       Container(
//                         clipBehavior: Clip.hardEdge,
//                         decoration: BoxDecoration(
//                             borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 bottomLeft: Radius.circular(10)),
//                             color: themeData.colorScheme.surfaceVariant),
//                         width: 12,
//                         // color: Theme.of(context).colorScheme.primary
//                       ),
//                       const SizedBox(width: 5),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Row(
//                               children: [
//                                 ColorTagChip(
//                                     tagString: objects[index].creatorAccount.nickname,
//                                     color: themeData.colorScheme.primary),
//                               ],
//                             ),
//                             Text(objects[index].title,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: themeData.textTheme.titleMedium!
//                                     .copyWith(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14)),
//                             Text(
//                               objects[index].introduction,
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               style: themeData.textTheme.titleSmall!.copyWith(
//                                   // color: themeData.colorScheme.secondary,
//                                   fontSize: 12),
//                             ),
//                             Row(
//                               children: [
//                                 Text(dataformat.format(objects[index].startTime),
//                                     style: themeData.textTheme.titleSmall!
//                                         .copyWith(fontSize: 12, color: themeData.colorScheme.primary)),
//                                 const Icon(Icons.arrow_right_rounded),
//                                 Expanded(
//                                   child: Text(dataformat.format(objects[index].endTime),
//                                       style: themeData.textTheme.titleSmall!
//                                           .copyWith(fontSize: 12, color: themeData.colorScheme.primary),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis),
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//               );
//             },
//           )),
//     );
//   }
// }

// class AddEventPage extends StatefulWidget {
//   const AddEventPage({super.key});

//   static const titleKey = Key('title');
//   static const introductionKey = Key('introduction');
//   static const createButtonKey = Key('create_event');

//   @override
//   AddEventPageState createState() => AddEventPageState();
// }

// class AddEventPageState extends State<AddEventPage> {
//   String title = "事件標題";
//   String introduction = "事件介紹";

//   DateFormat dataformat = DateFormat('h:mm a, MMM d, y');
//   DateTime startTime = DateTime.now();
//   DateTime endTime = DateTime.now().add(const Duration(days: 1));

//   Widget generateContentDisplayBlock(String blockTitle, Widget child) {
//     TextStyle blockTitleTextStyle = Theme.of(context)
//         .textTheme
//         .titleMedium!
//         .copyWith(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//             color: Theme.of(context).colorScheme.secondary);
//     return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(blockTitle, style: blockTitleTextStyle),
//             const Divider(thickness: 3),
//             child
//           ],
//         ));
//   }

//   void showTimePicker(
//       Function callBack, BuildContext context, DateTime initialTime) {
//     showDialog(
//         context: context,
//         builder: ((BuildContext context) {
//           return AlertDialog(
//             title: const Text('選擇時間'),
//             content: SizedBox(
//               height: MediaQuery.of(context).size.height * 0.4,
//               width: MediaQuery.of(context).size.height * 0.8,
//               child: SfDateRangePicker(
//                 onSubmit: (value) {
//                   debugPrint(value.toString());
//                   Navigator.pop(context);
//                   Navigator.of(context).push(
//                     showPicker(
//                         is24HrFormat: true,
//                         value: Time(
//                             hour: initialTime.hour, minute: initialTime.minute),
//                         onChange: (newTime) {
//                           debugPrint(value.runtimeType.toString());
//                           debugPrint(newTime.toString());
//                           // startTime = (value as DateTime).copyWith(hour: newTime.hour, minute: newTime.minute);
//                           callBack((value as DateTime).copyWith(
//                               hour: newTime.hour,
//                               minute: newTime.minute,
//                               second: 0));
//                           setState(() {});
//                         }),
//                   );
//                 },
//                 onCancel: () {
//                   Navigator.pop(context);
//                 },
//                 initialSelectedDate: initialTime,
//                 showActionButtons: true,
//               ),
//             ),
//           );
//         }));
//   }

//   Widget getInformationDisplay() {
//     TextStyle titleTextStyle = Theme.of(context)
//         .textTheme
//         .titleMedium!
//         .copyWith(fontWeight: FontWeight.bold, fontSize: 28);
//     Widget eventOwnerLabel = Row(
//       children: [
//         ColorTagChip(
//             tagString: "事件 - NoName 的工作區",
//             color: Theme.of(context).colorScheme.primary,
//             fontSize: 14),
//       ],
//     );
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         eventOwnerLabel,
//         TextFormField(
//           key: AddEventPage.titleKey,
//           initialValue: title == "事件標題" ? "" : title,
//           style: titleTextStyle,
//           onChanged: (value) => title = value,
//           decoration: const InputDecoration(
//               hintText: "事件標題",
//               isDense: true,
//               contentPadding: EdgeInsets.symmetric(vertical: 2),
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   width: 0,
//                   style: BorderStyle.none,
//                 ),
//               )),
//         ),
//       ],
//     );
//   }

//   Widget getEventDescriptionDisplay() {
//     TextStyle textStyle = Theme.of(context)
//         .textTheme
//         .titleMedium!
//         .copyWith(fontWeight: FontWeight.bold, fontSize: 16);
//     return generateContentDisplayBlock(
//         '事件介紹',
//         TextFormField(
//           key: AddEventPage.introductionKey,
//           initialValue: introduction == "事件介紹" ? "" : introduction,
//           style: textStyle,
//           onChanged: (value) => introduction = value,
//           maxLines: null,
//           decoration: const InputDecoration(
//               hintText: "事件介紹",
//               isDense: true,
//               contentPadding: EdgeInsets.symmetric(vertical: 2),
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   width: 0,
//                   style: BorderStyle.none,
//                 ),
//               )),
//         ));
//   }

//   Widget getStartTimeBlock() {
//     return generateContentDisplayBlock(
//         '開始時間',
//         ElevatedButton(
//             onPressed: () => showTimePicker((value) {
//                   startTime = value;
//                 }, context, startTime),
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.access_time),
//                 const SizedBox(width: 10),
//                 Text(dataformat.format(startTime)),
//               ],
//             )));
//   }

//   Widget getEndTimeBlock() {
//     return generateContentDisplayBlock(
//         '結束時間',
//         ElevatedButton(
//             onPressed: () => showTimePicker((value) {
//                   endTime = value;
//                 }, context, endTime),
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.access_time),
//                 const SizedBox(width: 10),
//                 Text(dataformat.format(endTime)),
//               ],
//             )));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<EventSettingViewModel>(builder: (context, provider, child) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.surface,
//           elevation: 2,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back_ios_rounded,
//                 color: Theme.of(context).colorScheme.onSurfaceVariant),
//           ),
//           actions: [
//             IconButton(
//               key: AddEventPage.createButtonKey,
//               onPressed: () {
//                 Navigator.pop(
//                     context,
//                     EventModel(
//                       title: title,
//                       introduction: introduction,
//                       startTime: startTime,
//                       endTime: endTime,
//                       // tags: [3, 2147483647],
//                       id: -1,
//                     ));
//               },
//               icon: Icon(Icons.check,
//                   color: Theme.of(context).colorScheme.onSurfaceVariant),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Form(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     getInformationDisplay(),
//                     getEventDescriptionDisplay(),
//                     getStartTimeBlock(),
//                     getEndTimeBlock(),
//                     generateContentDisplayBlock('參與者', const Text('沒有參與者')),
//                     generateContentDisplayBlock('子任務', const Text('沒有子任務')),
//                     // relation note
//                     generateContentDisplayBlock('關聯筆記', const Text('沒有關聯筆記')),
//                     // relation message
//                     generateContentDisplayBlock('關聯話題', const Text('沒有關聯話題')),
//                   ]),
//             ),
//           ),
//         ),
//       );
//     });
//     /*
//     return Consumer<StudentProvider>(
//       builder: (context, provider, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Add new student'),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('name'),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width/3,
//                     // height: MediaQuery.of(context).size.height / 25,
//                     child: TextField(
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Mary',
//                         isDense: true
//                       ),
//                       onChanged: (value) => name = value,
//                     ),
//                   )
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('email'),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width/3,
//                     child: TextField(
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Mary@mail.com',
//                         isDense: true
//                       ),
//                       onChanged: (value) => email = value,
//                     ),
//                   )
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('nickname'),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width/3,
//                     child: TextField(
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Mary',
//                         isDense: true
//                       ),
//                       onChanged: (value) => nickname = value,
//                     ),
//                   )
//                 ],
//               ),
//               TextButton(
//                   onPressed: () {
//                     provider.addStudent(Student(
//                         DateTime.now().second,
//                         name,
//                         email,
//                         nickname));
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Submit'))
//             ]),
//           ),
//         );
//       },
//     );
//     */
//   }
// }
