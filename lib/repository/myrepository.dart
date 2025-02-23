abstract class MyRepository<T>{
  Future<T> getById(dynamic id);
  Future<T> update(dynamic id, T object);
  Future<T> create(T object);
  Future<List<T>> readAll();
  Future<void> delete(dynamic id);
}