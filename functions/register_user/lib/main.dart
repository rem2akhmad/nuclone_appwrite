import 'dart:async';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

// This is your Appwrite function
// It's executed each time we get a request
Future<dynamic> main(final context) async {
  
  final client = Client()
     .setEndpoint('http://appwrite/v1')
     .setProject("6698e6f20001a4a59393")
     .setKey(Platform.environment["APPWRITE_FUNCTION_REG"]);

  try {
    var userId = context.req.body["\$id"];
    final dbApi = Databases(client);
    final users = await dbApi.createDocument(
      databaseId: "nuclone_db", 
      collectionId: "users", 
      documentId: ID.unique(),
      data: {"accountId": userId},
      permissions: [
        Permission.delete(Role.user(userId)),
        Permission.update(Role.user(userId))
      ]
    );
      context.log("users document created: ${users.$id}");
      return context.res.empty();
  } catch (error) {
    context.error("something went wrong ${error}");
    context.res.send("$error", 500, );
  }
}
