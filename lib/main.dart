import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final Widget child;
  final bool noPadding;

  const Section({
    super.key,
    required this.title,
    required this.child,
    this.noPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    final padding = noPadding ? EdgeInsets.zero : const EdgeInsets.all(16);

    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}

class TodayActionCard extends StatelessWidget {
  final String title;
  final String category;

  const TodayActionCard({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      // padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, // 배경색 (필요시)
        border: Border.all(color: Colors.grey, width: 1), // ✅ border 추가
        borderRadius: BorderRadius.circular(8), // 모서리 둥글게
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ 왼쪽 원형 이미지
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage("https://picsum.photos/50/50"),
          ),
          const SizedBox(width: 10),

          // ✅ 가운데 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          // ✅ 오른쪽 원형 이미지
          CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage("https://picsum.photos/50/50"),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        // 안전 영역 대응
        child: SingleChildScrollView(
          // ✅ 스크롤 가능하게 만들기
          padding: const EdgeInsets.all(16), // 원하는 여백
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Section(
                title: "오늘의 활동",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final text in [
                      "이것은 매우 긴 텍스트로 테스트하는 예제입니다. 너무 길어지면 두 줄로 표시됩니다.",
                      "색깔 맞추기",
                      "색깔 맞추기 색깔 맞추기, ooooooooooo",
                      "기억력 테스트",
                      "퍼즐 맞추기",
                      "이것은 매우 긴 텍스트로 테스트하는 예제입니다. 너무 길어지면 두 줄로 표시됩니다.",
                      "색깔 맞추기",
                      "색깔 맞추기 색깔 맞추기, ooooooooooo",
                      "기억력 테스트",
                      "퍼즐 맞추기",
                      "이것은 매우 긴 텍스트로 테스트하는 예제입니다. 너무 길어지면 두 줄로 표시됩니다.",
                      "색깔 맞추기",
                      "색깔 맞추기 색깔 맞추기, ooooooooooo",
                      "기억력 테스트",
                      "퍼즐 맞추기",
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: TodayActionCard(title: text, category: "기억력"),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Section(
      //         title: "오늘의 활동",
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           children: [
      //             for (final text in [
      //               "이것은 매우 긴 텍스트로 테스트하는 예제입니다. 너무 길어지면 두 줄로 표시됩니다.",
      //               "색깔 맞추기",
      //               "색깔 맞추기 색깔 맞추기, ooooooooooo",
      //               "기억력 테스트",
      //               "퍼즐 맞추기",
      //             ])
      //               Padding(
      //                 padding: const EdgeInsets.only(bottom: 30),
      //                 child: TodayActionCard(title: text, category: "기억력"),
      //               ),
      //           ],
      //         ),
      //       ),
      //     ],

      //     // <Widget>[
      //     //   const Text('You have pushed the button this many times:'),
      //     //   Text(
      //     //     '$_counter',
      //     //     style: Theme.of(context).textTheme.headlineMedium,
      //     //   ),
      //     // ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
