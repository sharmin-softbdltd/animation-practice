import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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
  <img src="https://www.w3schools.com/html/img_chania.jpg" alt="Flowers in Chania" width="460" height="345">
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

  final highLightedContent = "".obs;
  final activeWordIndex = 0.obs,
      totalMatchedWord = 0.obs,
      activeParaIndex = 0.obs;
  final Map<int, GlobalKey> paragraphKeys =
      {}; //for para and global key of that para
  final Map<int, int> perParaMatchCounter =
      {}; // for para and how many words found which match

  @override
  void onInit() {
    highLightedContent.value = content;
    searchController.addListener(() {
      activeWordIndex.value = 0;
      search(searchController.text);
    });
    super.onInit();
  }

  void search(String query) {
    if (query.isEmpty) {
      highLightedContent.value = content;
      activeWordIndex.value = 0;
      activeParaIndex.value = 0;
      totalMatchedWord.value = 0;
      perParaMatchCounter.clear();
      paragraphKeys.clear();
      return;
    }
    perParaMatchCounter.clear();

    final escapedQuery = RegExp.escape(query);
    final regex = RegExp(escapedQuery, caseSensitive: false);

    final paragraphList = RegExp(
      r'<p\b[^>]*>(.*?)</p>',
      caseSensitive: false,
      dotAll: true,
    ).allMatches(content);

    int matchWordCounter = 0;
    int paraIndex = 0;

    String newContent = paragraphList.map((paraMatch) {
      String paraText = paraMatch.group(1) ?? '';
      if (!paragraphKeys.containsKey(paraIndex)) {
        paragraphKeys[paraIndex] = GlobalKey(); // create key only once
      }

      if (regex.hasMatch(paraText)) {
        //IF WORD EXIST IN THAT PARA THEN STORE GLOBAL KEY FOR THAT PARA WITH INDEX
        int paraWordCounter = 0;

        String highlighted = paraText.replaceAllMapped(regex, (match) {
          final color =
              (paraIndex == activeParaIndex.value &&
                  paraWordCounter == activeWordIndex.value)
              ? "red"
              : "yellow";

          paraWordCounter++;
          matchWordCounter++;

          return '<mark style="background-color:$color;">${match.group(0)}</mark>';
        });

        //IF WORD MATCH THEN INCREASE HOW MANY WORDS ARE THERE
        perParaMatchCounter[paraIndex] = paraWordCounter;

        final result = '<p id="$paraIndex">$highlighted</p>';
        paraIndex++;
        return result;
      } else {
        paraIndex++;
        return paraMatch.group(0)!;
      }
    }).join();

    highLightedContent.value = newContent;
    totalMatchedWord.value = matchWordCounter;
  }

  void nextMatch() {
    if (totalMatchedWord.value == 0) return;

    final paraKeys = perParaMatchCounter.keys.toList()..sort();

    int currentWord = activeWordIndex.value;
    int currentPara = activeParaIndex.value;
    int paraMatchCount = perParaMatchCounter[currentPara] ?? 0;
    currentWord++;

    if (currentWord >= paraMatchCount) {
      // Find index of currentPara in the list of keys
      int currentKeyIndex = paraKeys.indexOf(currentPara);

      // Move to next para (wrap around with %)
      int nextKeyIndex = (currentKeyIndex + 1) % paraKeys.length;
      currentPara = paraKeys[nextKeyIndex];

      // Reset word index for that para
      currentWord = 0;
    }

    activeParaIndex.value = currentPara;
    activeWordIndex.value = currentWord;

    print('⬅️ Now at para $currentPara, word $currentWord');

    search(searchController.text);

    scrollToActivePara();
  }

  void prevMatch() {
    if (totalMatchedWord.value == 0) return;

    // Sorted list of all paras that have matches
    final paraKeys = perParaMatchCounter.keys.toList()..sort();

    int currentPara = activeParaIndex.value;
    int currentWord = activeWordIndex.value;

    // Step back one word
    currentWord--;

    if (currentWord < 0) {
      // Find current para position in the keys list
      int currentKeyIndex = paraKeys.indexOf(currentPara);

      // Move to previous para (wrap around)
      int prevKeyIndex =
          (currentKeyIndex - 1 + paraKeys.length) % paraKeys.length;
      currentPara = paraKeys[prevKeyIndex];

      // Set to last word of that para
      currentWord = (perParaMatchCounter[currentPara] ?? 1) - 1;
    }

    // Update active trackers
    activeParaIndex.value = currentPara;
    activeWordIndex.value = currentWord;

    print('⬅️ Now at para $currentPara, word $currentWord');

    // Refresh highlighted content
    search(searchController.text);

    // Scroll to the current paragraph
    scrollToActivePara();
  }

  void scrollToActivePara() {
    final key = paragraphKeys[activeParaIndex.value];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
