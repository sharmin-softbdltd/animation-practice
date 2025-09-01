import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/match_info_model.dart';

class HtmlSearchController extends GetxController {
  final scrollController = ScrollController();
  final searchController = TextEditingController();

  final content = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
</head>
<body>
  <h1>Big HTML Content</h1>

  <h2>Introduction to Flutter</h2>
  <p>
    Flutter is an open-source UI software development kit created by Google.
    It allows developers to create cross-platform applications with a single codebase
    for Android, iOS, Windows, Linux, macOS, and even web. The framework provides 
    widgets, rendering engine, and tools that help build modern apps faster.
  </p>
    <img src="https://www.w3schools.com/html/img_chania.jpg" alt="Flowers in Chania" width="460" height="345">


  <h2>Dart Programming Language</h2>
  <p>
    Dart is the programming language behind Flutter. It supports object-oriented 
    programming, async/await for asynchronous tasks, isolates for concurrency, and 
    strong typing. Dart is optimized for client-side development and compiles to both 
    native code and JavaScript.
  </p>

  <h2>State Management</h2>
  <h3>Popular Solutions</h3>
  <p>
    State management is a key concept in Flutter development. Popular solutions 
    include Provider, Riverpod, GetX, and BLoC. Each approach has its own strengths 
    and trade-offs depending on application complexity and developer preference.
  </p>

  <h2>Networking</h2>
  <p>
    Networking in Flutter is commonly done using HTTP, Dio, or WebSockets. 
    Developers use REST APIs, GraphQL endpoints, or Firebase Cloud Firestore. 
    Realtime communication can be handled using WebSockets or socket.io integrations.
  </p>
    <img src="https://www.w3schools.com/html/img_chania.jpg" alt="Flowers in Chania" width="460" height="345">
  <img src="https://www.w3schools.com/html/img_chania.jpg" alt="Flowers in Chania" width="460" height="345">


  <h2>Firebase Integration</h2>
  <p>
    Firebase integration is very popular in Flutter projects. It provides 
    authentication, Firestore, storage, hosting, analytics, and cloud functions. 
    Many startups and small teams adopt Firebase for rapid app development.
  </p>

  <h2>Algorithms and Data Structures</h2>
  <h3>Importance for Developers</h3>
  <p>
    Algorithms and data structures play an important role in performance. 
    Examples include binary search, hash maps, tries, graphs, trees, and dynamic 
    programming. Developers often prepare for coding interviews by practicing 
    algorithmic problems in C++ or Java.
  </p>

  <h2>CI/CD Pipelines</h2>
  <p>
    Continuous integration (CI/CD) pipelines ensure reliable deployment of apps. 
    Tools like GitHub Actions, GitLab CI, and Bitrise can be configured to run tests, 
    build APKs or IPAs, and push them to app stores automatically.
  </p>

  <h2>User Interface Design</h2>
  <p>
    User interface design in Flutter relies on widgets. Everything is a widget: 
    rows, columns, text, images, and buttons. Flutter’s hot reload makes UI 
    experimentation very efficient for developers.
  </p>
    <img src="https://www.w3schools.com/html/img_chania.jpg" alt="Flowers in Chania" width="460" height="345">


  <h2>Performance Optimization</h2>
  <p>
    Performance optimization involves profiling your app, reducing unnecessary 
    rebuilds, using const constructors, caching images, and minimizing overdraw. 
    Flutter’s DevTools help analyze frame rendering and memory usage.
  </p>

  <h2>Security Best Practices</h2>
  <p>
    Security is critical. Common practices include HTTPS requests, certificate 
    pinning, JWT tokens for authentication, and proper data encryption. 
    Storing sensitive information in secure storage plugins is also recommended.
  </p>

  <h2>Multimedia Support</h2>
  <p>
    Some apps require multimedia support. Flutter can handle images, audio, and 
    video playback using plugins like video_player, chewie, or better_player. 
    Live streaming can be implemented with HLS or DASH protocols.
  </p>

  <h2>Localization</h2>
  <p>
    Localization and internationalization are important for global reach. 
    Flutter supports localization with the intl package, allowing developers 
    to support multiple languages, date formats, and right-to-left scripts.
  </p>
    <img src="https://www.w3schools.com/html/img_chania.jpg" alt="Flowers in Chania" width="460" height="345">


  <h2>Testing</h2>
  <p>
    Testing ensures code quality. Unit tests check business logic, widget tests 
    validate UI behavior, and integration tests verify app flows. Flutter’s 
    testing framework is built-in and integrates with CI/CD pipelines.
  </p>

  <h2>বাংলা কনটেন্ট</h2>
  <p>
    কিছু বাংলা কনটেন্ট যোগ করা হলো। এটি ব্যবহার করে আপনি সার্চ সিস্টেমে ইউনিকোড 
    পরীক্ষা করতে পারবেন। বাংলা ভাষার সমর্থন একটি মোবাইল অ্যাপকে আরো বেশি 
    ব্যবহারবান্ধব করে তোলে।
  </p>

  <h2>Conclusion</h2>
  <h3>Final Notes</h3>
  <p>
    This is the final paragraph in this demo file. It combines Flutter keywords, 
    programming languages like C++, Java, and Kotlin, and technologies such as 
    Docker, Kubernetes, and microservices — all in one place to test searching.
  </p>

</body>
</html>
""";

  //   final content = '''
  // <!DOCTYPE html>
  // <html lang="en">
  // <head>
  //   <meta charset="UTF-8">
  // </head>
  // <body>
  //   <p>This is para new</p>
  //   <p>This is para</p>
  //   <p>This is para</p>
  //   <p>This is new</p>
  //   <p>This is para</p>
  //   <p>This is para</p>
  // </body>
  // </html>
  // ''';

  final activeMatchIndex = 0.obs, totalMatchedWord = 0.obs;
  final blockKeys = <GlobalKey>[].obs;
  final blocks = <String>[].obs;
  final searchTerm = "".obs;
  final allMatches = <MatchInfo>[].obs;

  @override
  void onInit() {
    parseBlocks();
    super.onInit();
  }

  void parseBlocks() {
    final regex = RegExp(
      // r"<(p|h1|img).*?>.*?</\1>|<img.*?>",
      r"<(p|h[1-6]|div|ul|ol|li|blockquote)>.*?</\1>|<img[^>]*>",
      dotAll: true,
      caseSensitive: false,
    );
    blocks.value = regex
        .allMatches(content)
        .map((m) => m.group(0) ?? "")
        .toList();
    blockKeys.value = List.generate(blocks.length, (_) => GlobalKey());
    blocks.refresh();
    blockKeys.refresh();
  }

  void onSearchChanged(String value) {
    searchTerm.value = value.trim();
    activeMatchIndex.value = 0;
    findAllMatches();
  }

  void findAllMatches() {
    allMatches.clear();
    if (searchTerm.isEmpty) {
      return;
    }

    for (int i = 0; i < blocks.length; i++) {
      final blockText =
          RegExp(
                r"<p>(.*?)</p>|<h[1-6]>(.*?)</h[1-6]>",
                dotAll: true,
                caseSensitive: false,
              )
              .firstMatch(blocks[i])
              ?.groups([1, 2])
              .whereType<String>()
              .join(" ") ??
          "";

      final regex = RegExp(
        RegExp.escape(searchTerm.value),
        caseSensitive: false,
      );
      for (final m in regex.allMatches(blockText)) {
        allMatches.add(MatchInfo(blockIndex: i, start: m.start, end: m.end));
      }
    }
    totalMatchedWord.value = allMatches.length;
    print("allMatches.length ${allMatches.length}");

    if (allMatches.isNotEmpty) scrollToActive();
  }

  void nextMatch() {
    if (allMatches.isEmpty) return;
    activeMatchIndex.value = (activeMatchIndex.value + 1) % allMatches.length;
    scrollToActive();
  }

  void prevMatch() {
    if (allMatches.isEmpty) return;
    activeMatchIndex.value =
        (activeMatchIndex.value - 1 + allMatches.length) % allMatches.length;
    scrollToActive();
  }

  void scrollToActive() {
    if (allMatches.isEmpty) return;
    final key = blockKeys[allMatches[activeMatchIndex.value].blockIndex];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.2,
      );
    } else {
      Future.delayed(const Duration(milliseconds: 50), scrollToActive);
    }
  }

  String highlightBlock(String html, int blockIndex) {
    // ✅ If it's an <img>, don't modify, just return
    if (html.trimLeft().toLowerCase().startsWith("<img")) {
      return html;
    }

    if (searchTerm.isEmpty) return html;

    final match = RegExp(
      // r"<(p|h[1-6])>(.*?)</\1>",
      r"<(p|h[1-6]|div|ul|ol|li|blockquote)>(.*?)</\1>",
      dotAll: true,
      caseSensitive: false,
    ).firstMatch(html);

    final tag = match?.group(1) ?? "p";
    final text = match?.group(2) ?? "";

    final buffer = StringBuffer();
    int lastIndex = 0;

    final blockMatches = allMatches
        .where((m) => m.blockIndex == blockIndex)
        .toList();
    for (int i = 0; i < blockMatches.length; i++) {
      final m = blockMatches[i];
      buffer.write(text.substring(lastIndex, m.start));
      bool isActiveMatch = allMatches[activeMatchIndex.value] == m;
      buffer.write(
        '<span style="background-color:${isActiveMatch ? 'red' : 'yellow'};">${text.substring(m.start, m.end)}</span>',
      );
      lastIndex = m.end;
    }
    buffer.write(text.substring(lastIndex));
    return "<$tag>${buffer.toString()}</$tag>";
  }

  void clearSearch() {
    searchController.clear();
    searchTerm.value = "";
    activeMatchIndex.value = 0;
    allMatches.clear();
  }
}
