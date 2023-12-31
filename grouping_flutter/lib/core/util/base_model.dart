///
/// [BaseModel] 是一個抽象 class
/// 理論上所有的 model 都需要繼承這個 class 來實現 [toEntity]
/// 在繼承時，給予的為該 [Model] 所對應的 [Entity]
///
abstract class BaseModel<T> {
  T toEntity();
}