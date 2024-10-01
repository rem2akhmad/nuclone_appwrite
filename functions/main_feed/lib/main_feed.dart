import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';

/// At this point feed is just ordered by time list of posts.
Future<dynamic> main(final context) async {
    final client = Client()
    .setEndpoint("http://appwrite/v1")
    .setProject(Platform.environment["PROJECT_ID"])
    .setKey(Platform.environment["APPWRITE_FUNCTION_REG"]);

  try {
    String? id = context.req.query["id"];
    int limit = int.tryParse(context.req.query["limit"]) ?? 10; // if {limit} is not presented default value is 10 
    context.log("offset=$id, limit=$limit");

    var dbApi = Databases(client);
    DocumentList list;
    if (id == null) {
      list = await dbApi.listDocuments(
        databaseId: "nuclone_db", 
        collectionId: "posts",
        queries: [
          Query.limit(limit),
          Query.orderDesc("\$createdAt")
        ]
      );
    } else {
      list = await dbApi.listDocuments(
        databaseId: "nuclone_db", 
        collectionId: "posts",
        queries: [
          Query.limit(limit),
          Query.cursorAfter(id),
          Query.orderDesc("\$createdAt")
        ]
      );
    }
    context.log("response = ${list.toMap()}");
    return context.res.json(list.toMap());
  } catch (error, stacktrace) {
    context.error("something went wrong $error. Stack: $stacktrace");
    return context.res.send("$error", 500);
  }
}