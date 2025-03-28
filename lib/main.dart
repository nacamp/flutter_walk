import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class StepCountService {
  static const EventChannel _eventChannel = EventChannel('step_count_stream');

  // ✅ 한 번만 받아서 재사용하는 Stream
  static final Stream<int> _stream = _eventChannel.receiveBroadcastStream().map(
    (event) => event as int,
  );

  static Stream<int> get stepStream => _stream;
}

class StepServiceController {
  static const platform = MethodChannel('step_control');

  static Future<void> start() async {
    final result = await platform.invokeMethod('startService');
    print("startService result: $result");
  }

  static Future<void> stop() async {
    await platform.invokeMethod('stopService');
  }
}

class StepPermissionScreen extends StatefulWidget {
  const StepPermissionScreen({super.key});

  @override
  State<StepPermissionScreen> createState() => _StepPermissionScreenState();
}

class _StepPermissionScreenState extends State<StepPermissionScreen> {
  bool _isGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.activityRecognition.status;
    setState(() {
      _isGranted = status.isGranted;
    });
  }

  Future<void> _requestPermission() async {
    final status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      setState(() => _isGranted = true);
    } else {
      openAppSettings(); // 설정으로 이동 유도
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("걸음 수 권한 요청")),
      body: Center(
        child:
            _isGranted
                ? const Text("권한이 허용되었습니다 ✅", style: TextStyle(fontSize: 20))
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "걸음 수 측정을 위해 권한이 필요합니다",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _requestPermission,
                      child: const Text("권한 요청하기"),
                    ),
                  ],
                ),
      ),
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
      // decoration: BoxDecoration(
      //   color: Colors.white, // 배경색 (필요시)
      //   border: Border.all(color: Colors.grey, width: 1), // ✅ border 추가
      //   borderRadius: BorderRadius.circular(8), // 모서리 둥글게
      // ),
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
                  alignment: Alignment.centerLeft,
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

class ChattingCard extends StatelessWidget {
  const ChattingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity, // width: "100%" 와 동일
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ 배경 이미지
          Image.network("https://picsum.photos/300/200", fit: BoxFit.cover),

          // ✅ 반투명 오버레이
          Container(color: const Color.fromRGBO(155, 248, 155, 0.5)),

          // ✅ 텍스트 내용
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "메세지를 남겨 보세요",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "상담실",
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
                SizedBox(height: 10),
                Text(
                  "운영시간 9시 ~ 6시",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final int currentValue;
  final int maxValue;

  const ProgressBar({
    super.key,
    required this.currentValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final double progressPercent = currentValue / maxValue;
    final double marker4000Percent = 4000 / maxValue;

    return Column(
      children: [
        // 숫자 라벨 영역
        SizedBox(
          height: 20,
          child: Stack(
            children: [
              Positioned(
                left:
                    MediaQuery.of(context).size.width * marker4000Percent - 10,
                child: const Text(
                  "4,000",
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
              const Positioned(
                right: 0,
                child: Text(
                  "10,000",
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),

        // 프로그레스 바
        Stack(
          children: [
            // 회색 배경
            Container(
              height: 15,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // 진행률 표시
            FractionallySizedBox(
              widthFactor: progressPercent.clamp(0.0, 1.0),
              child: Container(
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFF72CAA5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // 4,000 마커
            Positioned(
              left: MediaQuery.of(context).size.width * marker4000Percent - 5,
              child: Container(
                width: 10,
                height: 15,
                color: const Color(0xFF72CAA5),
              ),
            ),

            // 10,000 마커 (오른쪽 끝)
            const Positioned(
              right: 0,
              child: SizedBox(
                width: 10,
                height: 15,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFF72CAA5),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TodayWalkingCard extends StatelessWidget {
  final int steps;

  const TodayWalkingCard({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          NumberFormat('#,###').format(steps),
          style: const TextStyle(
            color: Color(0xFF72CAA5),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ProgressBar(currentValue: steps, maxValue: 10000),
        const SizedBox(height: 10),
        const Text("매일 4000보만 걸어 주세요", style: TextStyle(fontSize: 20)),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _steps = 0;
  bool _isPermissionGranted = false;

  // @override
  // void initState() {
  //   super.initState();
  //   // 더 안전하게 context 쓰기
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (mounted) {
  //       _showPermissionDialog();
  //     }
  //   });
  //   StepServiceController.start();
  //   // Future.microtask(() => _showPermissionDialog());
  //   StepCountService.stepStream.listen((event) {
  //     if (mounted) {
  //       setState(() {
  //         _steps = event;
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handlePermissionAndStart();
    });
  }

  Future<void> _handlePermissionAndStart() async {
    final status = await Permission.activityRecognition.status;

    if (status.isGranted) {
      _startStepService(); // 권한이 있을 경우만 시작
    } else {
      final result = await _showPermissionDialog();
      if (result == true) {
        _startStepService(); // 사용자가 허용했을 경우만 시작
      } else {
        debugPrint("⛔️ 권한 거부됨, 서비스 시작 안함");
      }
    }
  }

  void _startStepService() {
    StepServiceController.start();
    setState(() {
      _isPermissionGranted = true;
    });
    StepCountService.stepStream.listen((event) {
      if (mounted) {
        setState(() {
          _steps = event;
        });
      }
    });
  }

  Future<bool> _showPermissionDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("걸음 수 권한 요청"),
          content: const Text("걸음 수 측정을 위해 권한이 필요합니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("취소"),
            ),
            ElevatedButton(
              onPressed: () async {
                final status = await Permission.activityRecognition.request();
                Navigator.of(context).pop(status.isGranted);
              },
              child: const Text("권한 허용"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200, // 최대로 펼쳐졌을 때 높이
            pinned: true, // 스크롤해도 AppBar 고정 여부
            flexibleSpace: FlexibleSpaceBar(
              title: Text("치매예방교실"), // 스크롤 시 작아지는 타이틀
              background: Image.network(
                "https://picsum.photos/300/200",
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            // 일반 위젯 넣을 수 있는 래퍼
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Section(
                    title: "오늘의 걸음수",
                    child:
                        _isPermissionGranted
                            ? TodayWalkingCard(steps: _steps % 10000)
                            : Column(
                              children: const [
                                Icon(Icons.block, size: 40, color: Colors.red),
                                SizedBox(height: 10),
                                Text(
                                  "권한이 없어 걸음 수를 측정할 수 없습니다.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    // child: StreamBuilder<int>(
                    //   stream: Stream<int>.periodic(
                    //     Duration(seconds: 1),
                    //     (x) => x * 500,
                    //   ),
                    //   builder: (context, snapshot) {
                    //     final steps = snapshot.data ?? 0;
                    //     print("🔥 StreamBuilder steps: $steps");
                    //     return TodayWalkingCard(steps: steps);
                    //   },
                    // ),
                    // child: StreamBuilder<int>(
                    //   stream: StepCountService.stepStream,
                    //   builder: (context, snapshot) {
                    //     final steps = snapshot.data ?? 0;
                    //     print("StreamBuilder steps: $steps");
                    //     return TodayWalkingCard(steps: steps);
                    //   },
                    // ),
                  ),
                  Section(
                    title: "오늘의 목표",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 상단 텍스트
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("활동을 완료해주세요", style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // 하단 이미지 2개
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.network(
                                  "https://picsum.photos/50/50",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.network(
                                  "https://picsum.photos/50/50",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Section(
                    title: "오늘의 활동",
                    child: Column(
                      children:
                          [
                                "이것은 매우 긴 텍스트로 테스트하는 예제입니다. 너무 길어지면 두 줄로 표시됩니다. ddd ddd ddd ddd ddd, 1111",
                                "색깔 맞추기",
                                "색깔 맞추기 색깔 맞추기, ooooooooooo",
                                "기억력 테스트",
                                "퍼즐 맞추기",
                              ]
                              .map(
                                (title) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: TodayActionCard(
                                    title: title,
                                    category: "기억력",
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  Section(
                    title: "",
                    noPadding: true,
                    child: const ChattingCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

void main() {
  runApp(const MyApp());
}
