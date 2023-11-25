/// ## the type for [WorkspaceModel.photo]
/// * [imageId] : the id of the photo
/// * [data] : the data(url) of the photo
/// * [updateAt] : the update time of the photo 
class ImageModel {
  int imageId;
  String data;
  DateTime updateAt;

  ImageModel({required this.imageId, required this.data, required this.updateAt});

  factory ImageModel.fromJson(Map<String, dynamic> data) =>
    ImageModel(imageId: data['id'], data: data['data'], updateAt: DateTime.parse(data['updated_at']));
  
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': imageId,
    'data': data,
    'updated_at': updateAt.toIso8601String(),
  };

  @override
  String toString() {
    return 'photoId: $imageId, data: $data, update time: $updateAt';
  }
}