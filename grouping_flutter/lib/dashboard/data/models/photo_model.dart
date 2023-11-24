/// ## the type for [WorkspaceModel.photo]
/// * [photoId] : the id of the photo
/// * [data] : the data(url) of the photo
/// * [updateAt] : the update time of the photo 
class Photo {
  int photoId;
  String data;
  DateTime updateAt;

  Photo({required this.photoId, required this.data, required this.updateAt});

  factory Photo.fromJson(Map<String, dynamic> data) =>
    Photo(photoId: data['id'], data: data['data'], updateAt: DateTime.parse(data['updated_at']));
  
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': photoId,
    'data': data,
    'updated_at': updateAt.toIso8601String(),
  };

  @override
  String toString() {
    return 'photoId: $photoId, data: $data, update time: $updateAt';
  }
}