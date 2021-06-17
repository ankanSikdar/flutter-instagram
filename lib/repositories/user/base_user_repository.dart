import 'package:instagram_clone/models/models.dart';
import 'package:meta/meta.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({@required String userId});
  Future<void> updateUser({@required User user});
}
