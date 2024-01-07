///
/// [BaseEntity] 是一個抽象 class
/// 理論上所有的 model 都需要繼承這個 class 來實現 [toModel]
/// 在繼承時，給予的為該 [Entity] 所對應的 [Model]
///
abstract class BaseEntity<T> {
  T toModel();
}