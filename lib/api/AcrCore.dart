import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:http/http.dart';

import '../objects/Metadata.dart';
import 'HttpCore.dart';

class AcrCore {
  final String accessKey, accessSecret, host;
  const AcrCore({
    required this.accessKey,
    required this.accessSecret,
    required this.host,
  });

  static const dataType = "audio";
  static const String httpMethod = "POST";
  static const String signatureVersion = "1";
  static const String apiPath = "/v1/identify";

  // make constant to prevent from updating often
  static int timestamp = DateTime.now().millisecondsSinceEpoch;

  String get message => [
        httpMethod,
        apiPath,
        accessKey,
        dataType,
        signatureVersion,
        timestamp.toString(),
      ].join("\n");

  Future<String> get signature async {
    Mac mac = await Hmac(Sha1()).calculateMac(
      utf8.encode(message),
      secretKey: SecretKey(utf8.encode(accessSecret)),
    );

    return base64.encode(mac.bytes);
  }

  Future<Map<String, String>> getData(int length) async {
    return {
      "access_key": accessKey,
      "sample_bytes": length.toString(),
      "timestamp": timestamp.toString(),
      "signature": await signature,
      "data_type": dataType,
      "signature_version": signatureVersion,
    };
  }

  Future<Metadata> sendSample({required String path}) async {
    final MultipartFile sample = await MultipartFile.fromPath("sample", path);
    final MultipartRequest request = MultipartRequest(
      httpMethod,
      Uri.parse("http://$host$apiPath"),
    );

    request.files.add(sample);
    request.fields.addAll(await getData(sample.length));

    final StreamedResponse response = await request.send();

    Completer<Metadata> completer = Completer();

    response.stream.transform(utf8.decoder).listen(
      (String body) {
        final int statusCode = response.statusCode;
        if (statusCode == HttpStatus.ok) {
          Map<String, dynamic> data = jsonDecode(body);
          int status = data["status"]["code"];

          switch (status) {
            case 0:
              completer.complete(
                Metadata.fromJson(data["metadata"]),
              );
              break;
            case 1001:
              completer.completeError(
                HttpError(httpStatus: HttpStatus.notFound),
              );
              break;
          }
        } else {
          completer.completeError(
            HttpError(httpStatus: statusCode, message: "An unexpected error occurred, Try again."),
          );
        }
      },
    );

    return completer.future;
  }
}
