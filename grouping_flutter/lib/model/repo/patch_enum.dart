// the file name is temporary

enum ActivityCategory {
  title(data: 'default title'),
  description(data: 'default description'),
  startTime(data: '2000-01-20T00:00:00'),
  endTime(data: '2000-01-20T00:00:00'),
  deadline(data: '2000-01-20T00:00:00');
  
  final String data;
  const ActivityCategory({required this.data});
}

enum UserCategory {
  realName(data: 'default name'),
  userName(data: 'default name'),
  slogan(data: 'default slogan'),
  introduction(data: 'default introduction');

  final String data;
  const UserCategory({required this.data});
}

// enum MissionStage {
//   progress(label: 'progress'),
//   pending(label: 'pending'),
//   close(label: 'close');
  
//   final String label;
//   const MissionStage({required this.label});

//   factory MissionStage.fromLabel(String label){
//     switch(label){
//       case 'progress':
//         return MissionStage.progress;
//       case 'pending':
//         return MissionStage.pending;
//       case 'close':
//         return MissionStage.close;
//       default:
//         return MissionStage.progress;
//     }
//   }
// }