import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/presentation/widgets/async_view.dart';
import 'package:pacial_2/presentation/widgets/catalog_dialog.dart';
import 'package:pacial_2/presentation/widgets/common.dart';
import 'package:pacial_2/presentation/widgets/feedback.dart';
import 'package:pacial_2/providers/data_providers.dart';
import 'package:pacial_2/services/catalog/catalog_service.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final t = AppLocalizations.of(context);
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => CatalogDialog(
        title: t.newCategory,
        onSubmit: (name, _) => CatalogService.createCategory(name),
      ),
    );
    if (created == true) {
      ref.invalidate(categoriesProvider);
      if (context.mounted) showSnack(context, t.categoryCreated);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final categories = ref.watch(categoriesProvider);
    final sneakers = ref.watch(allSneakersProvider).value ?? const [];

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref),
        icon: const Icon(Icons.add),
        label: Text(t.newCategory),
      ),
      body: AsyncView(
        value: categories,
        onRetry: () => ref.invalidate(categoriesProvider),
        builder: (list) => list.isEmpty
            ? EmptyState(icon: Icons.category_outlined, message: t.noCategories)
            : RefreshIndicator(
                onRefresh: () => ref.refresh(categoriesProvider.future),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  children: [
                    MaxWidth(
                      child: Card(
                        child: Column(
                          children: [
                            for (final category in list)
                              ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.category_outlined),
                                ),
                                title: Text(category.name),
                                subtitle: Text(
                                  t.sneakerCount(
                                    sneakers
                                        .where(
                                          (s) => s.category.id == category.id,
                                        )
                                        .length,
                                  ),
                                ),
                                trailing: Text('#${category.id}'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
