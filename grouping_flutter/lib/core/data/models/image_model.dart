/// ## the type for [WorkspaceModel.photo]
/// * [imageId] : the id of the photo
/// * [imageUri] : the data(url) of the photo
/// * [updateAt] : the update time of the photo 
class ImageModel {
  int imageId;
  String imageUri;
  DateTime updateAt;

  ImageModel({required this.imageId, required this.imageUri, required this.updateAt});

  factory ImageModel.fromJson(Map<String, dynamic> data) =>
    ImageModel(
      imageId: data['id'], 
      imageUri: data['image_uri'],
      updateAt: DateTime.parse(data['updated_at'])
    );
  
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': imageId,
    'image_uri': imageUri,
    'updated_at': updateAt.toIso8601String(),
  };

  @override
  String toString() {
    return 'photoId: $imageId, image_uri: $imageUri, update time: $updateAt';
  }
}
