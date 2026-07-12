import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../errors/app_exception.dart';

/// Hard ceiling on any single Storage upload/URL-fetch call. See the doc
/// comment on [uploadBytesWithTimeout] for why this exists.
const storageOperationTimeout = Duration(seconds: 25);

/// Uploads [bytes] to [ref] and returns its download URL — with a hard
/// timeout and debug logging at every stage.
///
/// Why the timeout is not optional: on Flutter Web, `putData()` can hang
/// forever with zero exception if the Storage bucket's CORS policy hasn't
/// been configured for the app's origin (see `cors.json` at the repo root).
/// CORS is a browser-level concern, entirely separate from Storage security
/// rules — rules decide *who* may write, CORS decides whether the *browser*
/// lets the JS SDK read the response at all. When a CORS preflight is
/// blocked, the underlying JS SDK's resumable-upload retry loop treats it as
/// a transient network error and keeps retrying silently instead of
/// rejecting, so the wrapped Dart `Future` never resolves *and* never
/// rejects. No `try`/`catch` can catch an exception that is never thrown —
/// only a timeout can force such a call to fail so the app can recover.
Future<String> uploadBytesWithTimeout({
  required Reference ref,
  required Uint8List bytes,
  required String contentType,
  required String label,
}) async {
  _log('[$label] Upload started -> ${ref.fullPath} (${bytes.lengthInBytes} bytes)');
  try {
    await ref.putData(bytes, SettableMetadata(contentType: contentType)).timeout(
      storageOperationTimeout,
      onTimeout: () {
        throw TimeoutException(
          'Upload timed out after ${storageOperationTimeout.inSeconds}s. This usually means '
          'Firebase Storage CORS is not configured for this app\'s origin — see cors.json '
          'at the project root and run the gsutil command described there.',
        );
      },
    );
    _log('[$label] Upload completed');

    final downloadUrl = await ref.getDownloadURL().timeout(
      storageOperationTimeout,
      onTimeout: () {
        throw TimeoutException(
          'Fetching the download URL timed out after ${storageOperationTimeout.inSeconds}s.',
        );
      },
    );
    _log('[$label] Download URL received: $downloadUrl');
    return downloadUrl;
  } on TimeoutException catch (e, st) {
    _logError(label, e, st);
    throw StorageException(e.message ?? 'Upload timed out. Please try again.');
  } on FirebaseException catch (e, st) {
    _logError(label, e, st);
    throw StorageException('Upload failed: ${e.message ?? e.code}');
  } catch (e, st) {
    _logError(label, e, st);
    throw StorageException('Upload failed: $e');
  }
}

void _log(String message) {
  if (kDebugMode) debugPrint('[StorageUpload] $message');
}

void _logError(String label, Object error, StackTrace stackTrace) {
  if (kDebugMode) {
    debugPrint('[StorageUpload] [$label] FAILED: $error');
    debugPrintStack(stackTrace: stackTrace, label: '[StorageUpload] [$label]');
  }
}
