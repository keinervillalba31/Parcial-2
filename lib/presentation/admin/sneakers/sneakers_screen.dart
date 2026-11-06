import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/helpers/labels.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/presentation/admin/sneakers/widgets/sneaker_card.dart';
import 'package:pacial_2/presentation/widgets/async_view.dart';
import 'package:pacial_2/providers/data_providers.dart';

/// Catálogo con búsqueda y filtros. El ADMIN además puede crear tenis.
class SneakersScreen extends ConsumerStatefulWidget {
  const SneakersScreen({super.key});

  @override
  ConsumerState<SneakersScreen> createState() => _SneakersScreenState();
}

class _SneakersScreenState extends ConsumerState<SneakersScreen> {
  late final _search = TextEditingController(
    text: ref.read(sneakerFilterProvider).query,
  );
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  /// Espera a que el usuario deje de escribir para no llamar a la API por letra.
  void _onSearch(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => ref.read(sneakerFilterProvider.notifier).setQuery(value),
    );
  }

  void _clearFilters() {
    _search.clear();
    ref.read(sneakerFilterProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final filter = ref.watch(sneakerFilterProvider);
    final notifier = ref.read(sneakerFilterProvider.notifier);
    final sneakers = ref.watch(sneakersProvider);
    final isAdmin = ref.watch(profileProvider).value?.isAdmin ?? false;
    final brands = ref.watch(brandsProvider).value ?? const [];
    final categories = ref.watch(categoriesProvider).value ?? const [];

    return Scaffold(
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/admin/sneakers/new'),
              icon: const Icon(Icons.add),
              label: Text(t.newSneaker),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: _onSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: t.searchSneakers,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _search.clear();
                          _onSearch('');
                        },
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterMenu(
                  label: t.brand,
                  selectedId: filter.brandId,
                  options: [for (final b in brands) (b.id, b.name)],
                  onSelected: notifier.setBrand,
                ),
                const SizedBox(width: 8),
                _FilterMenu(
                  label: t.category,
                  selectedId: filter.categoryId,
                  options: [for (final c in categories) (c.id, c.name)],
                  onSelected: notifier.setCategory,
                ),
                const SizedBox(width: 8),
                for (final gender in genders)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(genderLabel(t, gender)),
                      selected: filter.gender == gender,
                      onSelected: (selected) =>
                          notifier.setGender(selected ? gender : null),
                    ),
                  ),
                if (filter.isActive)
                  TextButton.icon(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.filter_alt_off_outlined),
                    label: Text(t.clearFilters),
                  ),
              ],
            ),
          ),
          Expanded(
            child: AsyncView(
              value: sneakers,
              onRetry: () => ref.invalidate(sneakersProvider),
              builder: (list) => list.isEmpty
                  ? EmptyState(
                      icon: Icons.search_off,
                      message: t.noSneakers,
                      action: filter.isActive
                          ? TextButton(
                              onPressed: _clearFilters,
                              child: Text(t.clearFilters),
                            )
                          : null,
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.refresh(sneakersProvider.future),
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 260,
                              mainAxisExtent: 310,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: list.length,
                        itemBuilder: (context, index) => SneakerCard(
                          sneaker: list[index],
                          onTap: () =>
                              context.push('/admin/sneakers/${list[index].id}'),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip que abre un menú para elegir una marca o categoría (o "Todas").
class _FilterMenu extends StatelessWidget {
  final String label;
  final int? selectedId;
  final List<(int, String)> options;
  final ValueChanged<int?> onSelected;

  const _FilterMenu({
    required this.label,
    required this.selectedId,
    required this.options,
    required this.onSelected,
  });

  static const _all = -1;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final selectedName = options
        .where((o) => o.$1 == selectedId)
        .map((o) => o.$2)
        .firstOrNull;

    return PopupMenuButton<int>(
      tooltip: label,
      onSelected: (id) => onSelected(id == _all ? null : id),
      itemBuilder: (_) => [
        PopupMenuItem(value: _all, child: Text(t.all)),
        for (final option in options)
          CheckedPopupMenuItem(
            value: option.$1,
            checked: option.$1 == selectedId,
            child: Text(option.$2),
          ),
      ],
      child: Chip(
        backgroundColor: selectedName == null
            ? null
            : scheme.secondaryContainer,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedName == null ? label : '$label: $selectedName'),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }
}
