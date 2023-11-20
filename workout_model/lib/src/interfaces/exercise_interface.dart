sealed class Identifiable {
  String get id;
}

abstract class IExerciseDescription extends Identifiable {
  String get name;
  String get description;
}

abstract class IExerciseDescriptionRepository<T extends IExerciseDescription> {
  Future<bool> create(T exerciseDescription);
  Future<T?> read(String id);
  T update(
    T exerciseDescription,
    String? name,
    String? description,
  );
  Future<bool> delete(String id);
  void clear();
  Future<List<T>> list();
}

abstract interface class IExercise extends Identifiable
    implements IExerciseDescription {
  int? get repetitions;
  int? get restTime; // in seconds
  int? get sets;
  double? get weight; // in kgs
}

abstract interface class IExceriseRepository<T extends IExercise> {
  Future<bool> create(T exercise);
  Future<T?> read(String id);
  Future<T> update({
    required T exercise,
    String? name,
    String? description,
    int? repetitions,
    int? restTime,
    int? sets,
    double? weight,
  });
  Future<bool> delete(String id);
  Future<void> clear();
  Future<List<T>> list();
}
