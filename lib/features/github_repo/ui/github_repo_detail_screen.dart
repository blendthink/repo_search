import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:repo_search/features/github_repo/data/gihub_repo_repository.dart';
import 'package:repo_search/features/github_repo/model/github_repo.dart';
import 'package:repo_search/features/github_repo/ui/owner_image.dart';
import 'package:repo_search/utils/build_context_extension.dart';

final watchersCountFutureProviderFamily =
    FutureProvider.family.autoDispose<int, String>((
  ref,
  repositoryUrl,
) {
  final result = ref.watch(githubRepoRepositoryProvider).getWatchersCount(
        repositoryUrl: repositoryUrl,
      );
  ref.keepAlive();
  return result;
});

class GithubRepoDetailScreen extends HookConsumerWidget {
  final GithubRepo githubRepo;
  const GithubRepoDetailScreen({required this.githubRepo, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countFormat = NumberFormat.decimalPattern();
    final watchersCountAsync =
        ref.watch(watchersCountFutureProviderFamily(githubRepo.url));

    return Scaffold(
      appBar: AppBar(
        title: Text(githubRepo.fullName),
      ),
      // ListViewデフォルトのpaddingを書き換えているので、SafeAreaを使う
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            // ListViewの制約を解除する
            UnconstrainedBox(
              child: OwnerImage(
                githubRepo: githubRepo,
                radius: 50,
              ),
            ),
            const Gap(32),
            SectionTitle(
              title: context.l10n.githubRepoFullName,
            ),
            Text(githubRepo.fullName),
            const Gap(16),
            SectionTitle(
              title: context.l10n.githubRepoDescription,
            ),
            Text(
              githubRepo.description ?? context.l10n.githubRepoDescriptionEmpty,
              style: githubRepo.description == null
                  ? TextStyle(
                      color: Theme.of(context).disabledColor,
                    )
                  : null,
            ),
            const Gap(16),
            SectionTitle(
              title: context.l10n.githubRepoLanguage,
            ),
            Text(
              githubRepo.language ?? context.l10n.githubRepoDescriptionEmpty,
              style: githubRepo.language == null
                  ? TextStyle(
                      color: Theme.of(context).disabledColor,
                    )
                  : null,
            ),
            const Gap(16),
            SectionTitle(
              title: context.l10n.githubRepoStar,
            ),
            Text(countFormat.format(githubRepo.stargazersCount)),
            const Gap(16),
            SectionTitle(
              title: context.l10n.githubRepoWatch,
            ),
            watchersCountAsync.when(
              data: (data) => Text(countFormat.format(data)),
              error: (error, stackTrace) => Text('Error: $error'),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
            const Gap(16),
            SectionTitle(
              title: context.l10n.githubRepoFork,
            ),
            Text(countFormat.format(githubRepo.forksCount)),
            const Gap(16),
            SectionTitle(
              title: context.l10n.githubRepoOpenIssues,
            ),
            Text(countFormat.format(githubRepo.openIssuesCount)),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: context.textTheme.titleMedium,
      ),
    );
  }
}
