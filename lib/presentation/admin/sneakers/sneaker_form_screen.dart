import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/helpers/api_error.dart';
import 'package:pacial_2/helpers/labels.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/model/sneaker/sneaker_model.dart';
import 'package:pacial_2/presentation/widgets/async_view.dart';
import 'package:pacial_2/presentation/widgets/common.dart';
import 'package:pacial_2/presentation/widgets/feedback.dart';
import 'package:pacial_2/providers/data_providers.dart';
import 'package:pacial_2/services/sneakers/sneaker_service.dart';

/// Crear (sin [id]) o editar (con [id]) un tenis. Solo ADMIN.
class SneakerFormScreen extends ConsumerWidget {
  final int? id;

  const SneakerFormScreen({super.key, this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(id == null ? t.newSneaker : t.editSneaker)),
      body: id == null
          ? const _SneakerForm()
          : AsyncView(
              value: ref.watch(sneakerProvider(id!)),
              onRetry: () => ref.invalidate(sneakerProvider(id!)),
              builder: (sneaker) => _SneakerForm(initial: sneaker),
            ),
    );
  }
}

class _SneakerForm extends ConsumerStatefulWidget {
  final Sneaker? initial;

  const _SneakerForm({this.initial});

  @override
  ConsumerState<_SneakerForm> createState() => _SneakerFormState();
}

class _SneakerFormState extends ConsumerState<_SneakerForm> {
  /// Tallas que se ofrecen como opciones (más las que ya tenga el tenis).
  static const _sizeRange = [
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
  ];

  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _description = TextEditingController(
    text: widget.initial?.description,
  );
  late final _price = TextEditingController(
    text: widget.initial == null ? '' : _formatNumber(widget.initial!.price),
  );
  late final _stock = TextEditingController(
    text: widget.initial?.stock.toString(),
  );
  late final _colors = TextEditingController(text: widget.initial?.colors);
  late final List<TextEditingController> _images = [
    for (final url in widget.initial?.images ?? const <String>[])
      TextEditingController(text: url),
  ];
  late String _gender = widget.initial?.gender ?? 'UNISEX';
  late int? _brandId = widget.initial?.brand.id;
  late int? _categoryId = widget.initial?.category.id;
  late final Set<int> _sizes = {...?widget.initial?.sizes};

  bool _saving = false;
  bool _submitted = false;

  static String _formatNumber(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';

  @override
  void dispose() {
    for (final c in [
      _name,
      _description,
      _price,
      _stock,
      _colors,
      ..._images,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);

    if (!_formKey.currentState!.validate() || _sizes.isEmpty) {
      showSnack(context, t.completeFields, isError: true);
      return;
    }

    final data = {
      'name': _name.text.trim(),
      'description': _description.text.trim(),
      'price': double.parse(_price.text),
      'stock': int.parse(_stock.text),
      'gender': _gender,
      'colors': _colors.text.trim(),
      'sizes': (_sizes.toList()..sort()),
      'images': [
        for (final c in _images)
          if (c.text.trim().isNotEmpty) c.text.trim(),
      ],
      'brandId': _brandId,
      'categoryId': _categoryId,
    };

    setState(() => _saving = true);
    try {
      final initial = widget.initial;
      if (initial == null) {
        await SneakerService.create(data);
      } else {
        await SneakerService.update(initial.id, data);
        ref.invalidate(sneakerProvider(initial.id));
      }
      invalidateSneakerLists(ref);
      if (!mounted) return;
      showSnack(context, t.sneakerSaved);
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showSnack(context, apiErrorMessage(e, t), isError: true);
    }
  }

  String? _required(String? value) => (value == null || value.trim().isEmpty)
      ? AppLocalizations.of(context).requiredField
      : null;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final brands = ref.watch(brandsProvider);
    final categories = ref.watch(categoriesProvider);
    final sizeOptions = {..._sizeRange, ..._sizes}.toList()..sort();

    return Form(
      key: _formKey,
      child: MaxWidth(
        width: 720,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: t.name),
              validator: _required,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _price,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    decoration: InputDecoration(
                      labelText: t.price,
                      prefixText: r'$ ',
                    ),
                    validator: (value) {
                      final price = double.tryParse(value ?? '');
                      if (price == null) return t.requiredField;
                      if (price <= 0) return t.priceInvalid;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _stock,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: t.stock),
                    validator: (value) => int.tryParse(value ?? '') == null
                        ? t.requiredField
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: brands.when(
                    data: (list) => DropdownButtonFormField<int>(
                      initialValue: _brandId,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: t.brand),
                      items: [
                        for (final b in list)
                          DropdownMenuItem(value: b.id, child: Text(b.name)),
                      ],
                      onChanged: (value) => setState(() => _brandId = value),
                      validator: (value) =>
                          value == null ? t.requiredField : null,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text(apiErrorMessage(e, t)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: categories.when(
                    data: (list) => DropdownButtonFormField<int>(
                      initialValue: _categoryId,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: t.category),
                      items: [
                        for (final c in list)
                          DropdownMenuItem(value: c.id, child: Text(c.name)),
                      ],
                      onChanged: (value) => setState(() => _categoryId = value),
                      validator: (value) =>
                          value == null ? t.requiredField : null,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text(apiErrorMessage(e, t)),
                  ),
                ),
              ],
            ),
            SectionTitle(t.gender),
            SegmentedButton<String>(
              segments: [
                for (final g in genders)
                  ButtonSegment(value: g, label: Text(genderLabel(t, g))),
              ],
              selected: {_gender},
              onSelectionChanged: (value) =>
                  setState(() => _gender = value.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _colors,
              decoration: InputDecoration(
                labelText: t.colors,
                hintText: t.colorsHint,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: t.description,
                alignLabelWithHint: true,
              ),
            ),
            SectionTitle(t.sizes),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final size in sizeOptions)
                  FilterChip(
                    label: Text('$size'),
                    selected: _sizes.contains(size),
                    onSelected: (selected) => setState(
                      () => selected ? _sizes.add(size) : _sizes.remove(size),
                    ),
                  ),
              ],
            ),
            if (_submitted && _sizes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  t.sizesRequired,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            SectionTitle(
              t.images,
              trailing: TextButton.icon(
                onPressed: () =>
                    setState(() => _images.add(TextEditingController())),
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text(t.addImage),
              ),
            ),
            if (_images.isEmpty)
              Text(
                t.noImages,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            for (final controller in _images)
              Padding(
                key: ObjectKey(controller),
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: ValueListenableBuilder(
                          valueListenable: controller,
                          builder: (_, value, _) =>
                              SneakerImage(url: value.text),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(labelText: t.imageUrl),
                      ),
                    ),
                    IconButton(
                      tooltip: t.delete,
                      onPressed: () => setState(() {
                        _images.remove(controller);
                        controller.dispose();
                      }),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(t.save),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
