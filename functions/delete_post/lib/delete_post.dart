
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

/// 
/// Appwrite function executes each time when post is being deleted
/// 
Future<dynamic> main(final context) async {
  final client = Client()
    .setEndpoint("http://appwrite/v1")
    .setProject("6698e6f20001a4a59393")
    .setKey(Platform.environment["APPWRITE_FUNCTION_REG"]);
  
  try {
    var postId = context.req.body["\$id"];
    var fileId = context.req.body["photoUrl"];
    var userId = context.req.body["user"]["\$id"];

    var storageApi = Storage(client);
    var file = await storageApi.deleteFile(bucketId: userId, fileId: fileId);
    context.log("files from post: $postId has been deleted. FileId: $fileId, file: $file");
    return context.res.send("file $file with fileId: $fileId has been deleted", 200,);
  } catch (error) {
    context.error("something went wrong $error");
    return context.res.send("$error", 500, );
  }

}