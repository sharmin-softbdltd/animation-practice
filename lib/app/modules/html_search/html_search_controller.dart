import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HtmlSearchController extends GetxController {
  final searchController = TextEditingController();
  final content = """
  <!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Searchable HTML</title>
</head>
<body>
  <h1>Big HTML Content</h1>

  <p>
    Flutter is an open-source UI software development kit created by Google.
    It allows developers to create cross-platform applications with a single codebase
    for Android, iOS, Windows, Linux, macOS, and even web. The framework provides 
    widgets, rendering engine, and tools that help build modern apps faster.
  </p>

  <p>
    Dart is the programming language behind Flutter. It supports object-oriented 
    programming, async/await for asynchronous tasks, isolates for concurrency, and 
    strong typing. Dart is optimized for client-side development and compiles to both 
    native code and JavaScript.
  </p>

  <p>
    State management is a key concept in Flutter development. Popular solutions 
    include Provider, Riverpod, GetX, and BLoC. Each approach has its own strengths 
    and trade-offs depending on application complexity and developer preference.
  </p>

  <p>
    Networking in Flutter is commonly done using HTTP, Dio, or WebSockets. 
    Developers use REST APIs, GraphQL endpoints, or Firebase Cloud Firestore. 
    Realtime communication can be handled using WebSockets or socket.io integrations.
  </p>

  <p>
    Firebase integration is very popular in Flutter projects. It provides 
    authentication, Firestore, storage, hosting, analytics, and cloud functions. 
    Many startups and small teams adopt Firebase for rapid app development.
  </p>

  <p>
    Algorithms and data structures play an important role in performance. 
    Examples include binary search, hash maps, tries, graphs, trees, and dynamic 
    programming. Developers often prepare for coding interviews by practicing 
    algorithmic problems in C++ or Java.
  </p>

  <p>
    Continuous integration (CI/CD) pipelines ensure reliable deployment of apps. 
    Tools like GitHub Actions, GitLab CI, and Bitrise can be configured to run tests, 
    build APKs or IPAs, and push them to app stores automatically.
  </p>

  <p>
    User interface design in Flutter relies on widgets. Everything is a widget: 
    rows, columns, text, images, and buttons. Flutter’s hot reload makes UI 
    experimentation very efficient for developers.
  </p>

  <p>
    Performance optimization involves profiling your app, reducing unnecessary 
    rebuilds, using const constructors, caching images, and minimizing overdraw. 
    Flutter’s DevTools help analyze frame rendering and memory usage.
  </p>

  <p>
    Security is critical. Common practices include HTTPS requests, certificate 
    pinning, JWT tokens for authentication, and proper data encryption. 
    Storing sensitive information in secure storage plugins is also recommended.
  </p>

  <p>
    Some apps require multimedia support. Flutter can handle images, audio, and 
    video playback using plugins like video_player, chewie, or better_player. 
    Live streaming can be implemented with HLS or DASH protocols.
  </p>

  <p>
    Localization and internationalization are important for global reach. 
    Flutter supports localization with the intl package, allowing developers 
    to support multiple languages, date formats, and right-to-left scripts.
  </p>

  <p>
    Testing ensures code quality. Unit tests check business logic, widget tests 
    validate UI behavior, and integration tests verify app flows. Flutter’s 
    testing framework is built-in and integrates with CI/CD pipelines.
  </p>

  <p>
    কিছু বাংলা কনটেন্ট যোগ করা হলো। এটি ব্যবহার করে আপনি সার্চ সিস্টেমে ইউনিকোড 
    পরীক্ষা করতে পারবেন। বাংলা ভাষার সমর্থন একটি মোবাইল অ্যাপকে আরো বেশি 
    ব্যবহারবান্ধব করে তোলে।
  </p>

  <p>
    This is the final paragraph in this demo file. It combines Flutter keywords, 
    programming languages like C++, Java, and Kotlin, and technologies such as 
    Docker, Kubernetes, and microservices — all in one place to test searching.
  </p>

</body>
</html>


  """;
  final highLightedContent = "".obs;

  @override
  void onInit() {
    highLightedContent.value = content;
    searchController.addListener(() {
      search(searchController.text);
    });
    super.onInit();
  }

  void search(String query) {
    if (query.isEmpty) {
      highLightedContent.value = content;
      return;
    }
    final escapedQuery = RegExp.escape(query);
    final regex = RegExp(escapedQuery, caseSensitive: false);

    final parts = RegExp(r'(<[^>]+>|[^<]+)').allMatches(content);
    String matchedContent = parts.map((part) {
      String str = part.group(0) ?? '';
      if (str.startsWith('<')) {
        return str;
      } else {
        return str.replaceAllMapped(regex, (match) {
          return '<mark>${match.group(0)}</mark>';
        });
      }
    }).join();

    highLightedContent.value = matchedContent;
  }
}
