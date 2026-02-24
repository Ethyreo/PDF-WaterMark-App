import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class GoogleDriveService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveReadonlyScope,
    ],
  );

  GoogleSignInAccount? _currentUser;

  Future<void> signIn() async {
    _currentUser = await _googleSignIn.signIn();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  Future<List<File>> downloadFolderFiles(String folderUrl, String outputDir, Function(int, int) onProgress) async {
    if (_currentUser == null) {
      await signIn();
    }
    if (_currentUser == null) return []; // Sign in failed/cancelled

    // Extract folder ID from URL
    final Uri uri = Uri.parse(folderUrl);
    String? folderId;
    
    if (uri.pathSegments.contains('folders')) {
      int idx = uri.pathSegments.indexOf('folders');
      if (idx + 1 < uri.pathSegments.length) {
        folderId = uri.pathSegments[idx + 1];
      }
    } else if (uri.queryParameters.containsKey('id')) {
      folderId = uri.queryParameters['id'];
    }

    if (folderId == null) {
      throw Exception('Invalid Google Drive folder link');
    }

    final Map<String, String> headers = await _currentUser!.authHeaders;
    final authenticateClient = _AuthClient(headers, http.Client());
    final driveApi = drive.DriveApi(authenticateClient);

    String pageToken = '';
    List<drive.File> allFiles = [];

    // Fetch all files
    do {
      var fileList = await driveApi.files.list(
        q: "'$folderId' in parents and mimeType='application/pdf'",
        spaces: 'drive',
        $fields: 'nextPageToken, files(id, name)',
        pageToken: pageToken.isEmpty ? null : pageToken,
        pageSize: 1000,
      );
      
      allFiles.addAll(fileList.files ?? []);
      pageToken = fileList.nextPageToken ?? '';
    } while (pageToken.isNotEmpty);

    List<File> downloadedFiles = [];
    int current = 0;

    for (var dFile in allFiles) {
      current++;
      onProgress(current, allFiles.length);

      if (dFile.id == null || dFile.name == null) continue;

      var media = await driveApi.files.get(dFile.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
      
      File localFile = File(p.join(outputDir, dFile.name));
      List<int> dataStore = [];
      await for (var data in media.stream) {
        dataStore.addAll(data);
      }
      await localFile.writeAsBytes(dataStore);
      downloadedFiles.add(localFile);
    }

    return downloadedFiles;
  }
}

class _AuthClient extends http.BaseClient {
  final Map<String, String> headers;
  final http.Client client;

  _AuthClient(this.headers, this.client);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(headers);
    return client.send(request);
  }
}
