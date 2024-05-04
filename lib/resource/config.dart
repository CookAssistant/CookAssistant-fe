import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final String? apiKey = dotenv.env['OPENAI_API_KEY'];
}