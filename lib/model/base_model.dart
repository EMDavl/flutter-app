abstract class BaseModel {
  final int id;

  BaseModel(this.id);

  Map<String, Object?> toMap();
}