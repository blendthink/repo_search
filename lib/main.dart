import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_search/common/github_access_token.dart';
import 'package:repo_search/features/github_repo/ui/github_repo_screen.dart';
import 'package:repo_search/utils/device_preview_screenshot_helper.dart';

Future<void> main() async {
  // .evnから環境変数を読み込む
  await dotenv.load(fileName: '.env');

  runApp(
    ProviderScope(
      overrides: [
        // 環境変数からGithubのアクセストークンを取得する
        githubAccessTokenProvider.overrideWithValue(
          dotenv.get('GITHUB_ACCESS_TOKEN'),
        ),
      ],
      child: DevicePreview(
        enabled: const bool.fromEnvironment('enable_device_preview'),
        tools: const [
          ...DevicePreview.defaultTools,
          DevicePreviewScreenshot(
            onScreenshot: onScreenshot,
          ),
        ],
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Repo Search',
      // useInheritedMediaQuery、locale、builderは、DevicePreviewに必要
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const GithubRepoScreen(),
    );
  }
}
