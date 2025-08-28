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
  final activeWordIndexInBlock = 0.obs,
      totalMatchedWord = 0.obs,
      activeBlockIndex = 0.obs,
      globalBlockIndex = 0.obs,
      currentWordCount = 0.obs;

  final Map<int, GlobalKey> blockKeys =
      {}; //for para and global key of that para
  final Map<int, int> perBlockMatchedWords =
      {}; // for para and how many words found which match

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
      activeWordIndexInBlock.value = 0;
      activeBlockIndex.value = 0;
      totalMatchedWord.value = 0;
      perBlockMatchedWords.clear();
      blockKeys.clear();
      return;
    }
    perBlockMatchedWords.clear();

    final escapedQuery = RegExp.escape(query);
    final regex = RegExp(escapedQuery, caseSensitive: false);

    // LIST OF BLOCKS LIKE H1, H2, H3, IMAGE
    final blockList = RegExp(
      r'(<p\b[^>]*>.*?</p>|<h[1-6]\b[^>]*>.*?</h[1-6]>|<div\b[^>]*>.*?</div>|<img\b[^>]*>)',
      caseSensitive: false,
      dotAll: true,
    ).allMatches(content);

    int matchWordCounter = 0; // FOR TOTAL WORD IN WHOLE HTML
    int blockIndex = 0; // FOR ASSIGN KEY

    String newContent = blockList.map((blockMatch) {
      String block = blockMatch.group(0) ?? '';
      if (!blockKeys.containsKey(blockIndex)) {
        blockKeys[blockIndex] = GlobalKey(); // create key only once
      }

      if (block.startsWith('<p') || block.startsWith('<h')) {
        if (regex.hasMatch(block)) {
          int blockWordCounter = 0;

          String highlighted = block.replaceAllMapped(regex, (match) {
            print('block index = $blockIndex');
            print('block activeBlockIndex = ${activeBlockIndex.value}');
            print('block blockWordCounter = $blockWordCounter');
            print(
              'block activeWordIndexInBlock = ${activeWordIndexInBlock.value}',
            );
            final color =
                (blockIndex == activeBlockIndex.value &&
                    blockWordCounter == activeWordIndexInBlock.value)
                ? "red"
                : "yellow";

            blockWordCounter++;
            matchWordCounter++;

            return '<mark style="background-color:$color;">${match.group(0)}</mark>';
          });

          //IF WORD MATCH THEN COUNT HOW MANY WORDS ARE THERE
          perBlockMatchedWords[blockIndex] = blockWordCounter;

          if (block.startsWith('<p')) {
            final result = '<p id="$blockIndex">$highlighted</p>';
            blockIndex++;
            return result;
          } else {
            final result = '<h1 id="$blockIndex">$highlighted</h1>';
            blockIndex++;
            return result;
          }
        } else {
          blockIndex++;
          return blockMatch.group(0)!;
        }
      } else {
        blockIndex++;
        return blockMatch.group(0)!;
      }
    }).join();

    highLightedContent.value = newContent;
    totalMatchedWord.value = matchWordCounter;
  }

  void nextMatch() {
    if (totalMatchedWord.value == 0) return;

    currentWordCount.value =
        (currentWordCount.value + 1) % totalMatchedWord.value;

    final paraKeys = perBlockMatchedWords.keys.toList()..sort();

    int currentWord = activeWordIndexInBlock.value;
    int currentPara = activeBlockIndex.value;
    int paraMatchCount = perBlockMatchedWords[currentPara] ?? 0;
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

    activeBlockIndex.value = currentPara;
    activeWordIndexInBlock.value = currentWord;

    print('⬅️ Now at para $currentPara, word $currentWord');

    search(searchController.text);

    scrollToActivePara();
  }

  void prevMatch() {
    if (totalMatchedWord.value == 0) return;
    currentWordCount.value =
        (currentWordCount.value - 1 + totalMatchedWord.value) %
        totalMatchedWord.value;

    // Sorted list of all paras that have matches
    final paraKeys = perBlockMatchedWords.keys.toList()..sort();

    int currentPara = activeBlockIndex.value;
    int currentWord = activeWordIndexInBlock.value;

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
      currentWord = (perBlockMatchedWords[currentPara] ?? 1) - 1;
    }

    // Update active trackers
    activeBlockIndex.value = currentPara;
    activeWordIndexInBlock.value = currentWord;

    print('⬅️ Now at para $currentPara, word $currentWord');

    // Refresh highlighted content
    search(searchController.text);

    // Scroll to the current paragraph
    scrollToActivePara();
  }

  void scrollToActivePara() {
    final key = blockKeys[activeBlockIndex.value];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
