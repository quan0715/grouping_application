// the file name is temporary

enum PatchCategory {
  title(data: 'default title'),
  description(data: 'default description'),
  startTime(data: '2000-01-20T00:00:00'),
  endTime(data: '2000-01-20T00:00:00'),
  deadline(data: '2000-01-20T00:00:00');
  
  final String data;
  const PatchCategory({required this.data});
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