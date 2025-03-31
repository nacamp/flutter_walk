# dev
## case: native inferface using MethodChannel, EventChannel
- https://docs.flutter.dev/platform-integration/platform-channels
- https://github.com/flutter/flutter/tree/main/examples/platform_channel
아래것은 나중에 보자
- https://seosh817.tistory.com/301#google_vignette

## case: NumberFormat
- https://pub.dev/packages/intl

## case: permission
- https://pub.dev/packages/permission_handler


# operation
## 특정 디바이스에 실행
```
flutter devices
flutter run
flutter run -d R39M302P6PV
```
## 프로젝트 만들기
- vscode에서 :  cmd + shift + p

## 설치 - 안드로이드
```bash
# 설치 검증
flutter doctor -v
flutter doctor --android-licenses

# cmdline-tools 이 설치가 안되서
# https://developer.android.com/studio#downloads 에서 cmdline-tools 을 다운로드 받아서
cd ~/Library/Android/sdk
mkdir -p cmdline-tools
cp -r /Users/jimmy/Downloads/cmdline-tools  cmdline-tools/latest
~/Library/Android/sdk/cmdline-tools/latest/bin/sdkmanager

# 참조
# https://docs.flutter.dev/get-started/install/macos/mobile-android
```

## site
- https://dart-ko.dev/language
- https://api.flutter.dev/flutter/material/
- https://docs.flutter.dev/ui/widgets
아래것은 확인 안함
- https://github.com/flutter/gallery
- https://github.com/Solido/awesome-flutter
