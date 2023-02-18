import '../api/AcrCore.dart';
import 'GenericRecord.dart';

class AcrSdk extends AcrCore {
  final GenericRecord record = GenericRecord();

  AcrSdk({
    required super.accessKey,
    required super.accessSecret,
    required super.host,
  });
}
