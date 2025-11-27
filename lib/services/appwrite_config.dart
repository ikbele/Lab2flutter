import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Initialize Appwrite client
Client getClient() {
  Client client = Client();
  return client
    .setEndpoint(dotenv.env['https://nyc.cloud.appwrite.io/v1']!)
    .setProject(dotenv.env['692637f80020222ffb5c']!);
}
