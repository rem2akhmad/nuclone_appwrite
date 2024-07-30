import 'dart:async';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/enums.dart';

// This is your Appwrite function
// It's executed each time we get a request
Future<dynamic> main(final context) async {
  
  final client = Client()
     .setEndpoint('http://appwrite/v1')
     .setProject("6698e6f20001a4a59393")
     .setKey(Platform.environment["APPWRITE_FUNCTION_REG"]);

  try {
    var userId = context.req.body["\$id"];
    var email = context.req.body["email"];
    var username = context.req.body["name"];
    
    final dbApi = Databases(client);
    // create user's profile
    final users = await dbApi.createDocument(
      databaseId: "nuclone_db", 
      collectionId: "users", 
      documentId: userId,
      data: {
        "accountId": userId,
        "email": email,
        "username": username
        },
      permissions: [
        Permission.delete(Role.user(userId)),
        Permission.update(Role.user(userId))
      ]
    );
    // create user's bucket
    final storageApi = Storage(client);
    var bucket = await storageApi.createBucket(
      bucketId: userId, 
      name: userId,
      enabled: true,
      fileSecurity: false,
      allowedFileExtensions: ["jpg", "png", "jpeg"],
      compression: Compression.none,
      encryption: false,
      antivirus: false,
      permissions: [
        Permission.create(Role.user(userId)),
        Permission.update(Role.user(userId)),
        Permission.delete(Role.user(userId)),
        Permission.read(Role.user(userId)),
        Permission.read(Role.users()),
      ]);

    context.log("users document created: ${users.$id}");
    context.log("users bucket created: ${bucket.$id}");
    return context.res.empty();
  } catch (error) {
    context.error("something went wrong ${error}");
    return context.res.send("$error", 500, );
  }
}
