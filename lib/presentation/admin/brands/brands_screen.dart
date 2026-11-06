import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/presentation/widgets/async_view.dart';
import 'package:pacial_2/presentation/widgets/catalog_dialog.dart';
import 'package:pacial_2/presentation/widgets/common.dart';
import 'package:pacial_2/presentation/widgets/feedback.dart';
import 'package:pacial_2/providers/data_providers.dart';
import 'package:pacial_2/services/catalog/catalog_service.dart';

class BrandsScreen extends ConsumerWidget {
  const BrandsScreen({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final t = AppLocalizations.of(context);
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => CatalogDialog(
        title: t.newBrand,
        withLogo: true,
        onSubmit: CatalogService.createBrand,
      ),
    );
    if (created == true) {
      ref.invalidate(brandsProvider);
      if (context.mounted) showSnack(context, t.brandCreated);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final brands = ref.watch(brandsProvider);
    final sneakers = ref.watch(allSneakersProvider).value ?? const [];

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref),
        icon: const Icon(Icons.add),
        label: Text(t.newBrand),
      ),
      body: AsyncView(
        value: brands,
        onRetry: () => ref.invalidate(brandsProvider),
        builder: (list) => list.isEmpty
            ? EmptyState(icon: Icons.sell_outlined, message: t.noBrands)
            : RefreshIndicator(
                onRefresh: () => ref.refresh(brandsProvider.future),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  children: [
                    MaxWidth(
                      child: Card(
                        child: Column(
                          children: [
                            for (final brand in list)
                              ListTile(
                                leading: CircleAvatar(
                                  child: ClipOval(
                                    child: SizedBox.expand(
                                      child: SneakerImage(
                                        url: brand.logo,
                                        label: brand.name,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(brand.name),
                                subtitle: Text(
                                  t.sneakerCount(
                                    sneakers
                                        .where((s) => s.brand.id == brand.id)
                                        .length,
                                  ),
                                ),
                                trailing: Text('#${brand.id}'),
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
