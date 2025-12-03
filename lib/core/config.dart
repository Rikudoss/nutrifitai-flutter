import 'package:flutter/foundation.dart';

/// Base URL for the NutriFit AI backend.
/// On Android emulators the backend is reachable via 10.0.2.2,
/// while on web/desktop localhost works.
const String BASE_URL = kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';
