import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_search/features/settings/ui/settings_notifier.dart';
import 'package:repo_search/resource/assets.gen.dart';
import 'package:repo_search/utils/build_context_extension.dart';

/// 設定画面
///
/// アプリ全体に関する設定を行う
class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
      ),
      body: ListView(
        children: [
          // テーマの切り替え
          ListTile(
            title: Text(context.l10n.settingsTheme),
            trailing: DropdownButton<ThemeMode>(
              value: ref
                  .watch(settingsProvider.select((value) => value.themeMode)),
              onChanged: (value) async {
                if (value != null) {
                  await ref.read(settingsProvider.notifier).setThemeMode(value);
                }
              },
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(context.l10n.settingsThemeSystem),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(context.l10n.settingsThemeLight),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(context.l10n.settingsThemeDark),
                ),
              ],
            ),
          ),
          // OOSライセンス
          ListTile(
            title: const Text('OOS License'),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Repo Search',
                applicationVersion: '1.0.0',
                applicationIcon: SizedBox(
                  width: 100,
                  height: 100,
                  child: Assets.images.appIcon.image(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
