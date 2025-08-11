import 'package:flutter_dotenv/flutter_dotenv.dart';

class LiveKitConfig {
  static String get serverUrl {
    final envVal = dotenv.maybeGet('LIVEKIT_URL');
    if (envVal != null && envVal.trim().isNotEmpty) return envVal.trim();
    const defineVal = String.fromEnvironment('LIVEKIT_URL', defaultValue: '');
    if (defineVal.isNotEmpty) return defineVal;
    throw StateError('LIVEKIT_URL not configured. Set in .env or via --dart-define.');
  }
}
