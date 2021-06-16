import 'dart:io';
import 'package:meta/meta.dart';

abstract class BaseStorageRepository {
  Future<String> uploadProfileImage(
      {@required String url, @required File image});
  Future<String> uploadPostImage({@required File image});
}
