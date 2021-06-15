import 'package:instagram_clone/models/user_model.dart';
import 'package:meta/meta.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({@required String userId});
  Future<void> updateUser({@required User user});
}
