
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

/// 
/// Appwrite function executes each time when user is being deleted
/// 
Future<dynamic> main(final context) async {
  final client = Client()
    .setEndpoint("http://appwrite/v1")
    .setProject(Platform.environment["PROJECT_ID"])
    .setKey(Platform.environment["APPWRITE_FUNCTION_REG"]);
  
  try {
    var userId = context.req.body["\$id"];
    var dbApi = Databases(client);

    // delete user's profile
    var userProfile = await dbApi.getDocument(
      databaseId: "nuclone_db", 
      collectionId: "users",
      documentId: userId);
    await dbApi.deleteDocument(
        databaseId: "nuclone_db", 
        collectionId: "users", 
        documentId: userId);
    context.log("document $userId from collection users has been deleted");

    // delete user's avatar file
    var fileId = userProfile.data["avatar"];
    if (fileId != null) {
      var storageApi = Storage(client);
      var file = await storageApi.deleteFile(bucketId: "avatars", fileId: fileId);
      context.log("avatar file: $fileId has been deleted. user: $userId");
    }

    // do not delete user's posts yet
    //  delete user's bucket 
    // var bucket = await storageApi.deleteBucket(bucketId: userId);
    // context.log("bucket $bucket with id $userId has been deleted");
    return context.res.send("user and avatar has been deleted", 200,);
  } catch (error, stacktrace) {
    context.error("something went wrong $error, stacktrace: $stacktrace");
    return context.res.send("$error", 500, );
  }
}