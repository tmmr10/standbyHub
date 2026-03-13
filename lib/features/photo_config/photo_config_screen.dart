import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:standby_hub/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/providers.dart';
import '../../services/settings_service.dart';
import '../../services/widget_reload_service.dart';
import '../../shared/design_system.dart';
import '../../shared/ui_components.dart';

class PhotoConfigScreen extends ConsumerStatefulWidget {
  const PhotoConfigScreen({super.key});

  @override
  ConsumerState<PhotoConfigScreen> createState() => _PhotoConfigScreenState();
}

class _PhotoConfigScreenState extends ConsumerState<PhotoConfigScreen> {
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final settings = ref.read(settingsProvider);
    if (settings.photoWidgetImage.isEmpty) {
      if (mounted) setState(() => _imageBytes = null);
      return;
    }
    final path = await ref.read(settingsServiceProvider).getBackgroundImagePath(settings.photoWidgetImage);
    if (path != null && mounted) {
      final bytes = await File(path).readAsBytes();
      if (mounted) setState(() => _imageBytes = bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final hasImage = settings.photoWidgetImage.isNotEmpty;

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.photoWidgetTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Preview
          SBPreviewContainer(
            height: 200,
            child: Container(
              color: StandByColors.trueBlack,
              child: _imageBytes != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_photo_alternate_outlined,
                              color: StandByColors.textMuted, size: 48),
                          const SizedBox(height: 8),
                          Text(
                            l10n.noImageSelected,
                            style: const TextStyle(
                                color: StandByColors.textMuted, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),

          SBSectionHeader(l10n.photoSection),
          const SizedBox(height: 12),

          SBSettingRow(
            leading: Icon(
              hasImage ? Icons.swap_horiz_rounded : Icons.add_photo_alternate_rounded,
              color: StandByColors.accent,
            ),
            title: hasImage ? l10n.changeImage : l10n.selectImage,
            subtitle: l10n.selectPhotoSubtitle,
            onTap: () => _pickImage(),
          ),

          if (hasImage) ...[
            const SizedBox(height: 8),
            SBSettingRow(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: Colors.redAccent),
              title: l10n.removeImage,
              onTap: () => _removeImage(),
            ),
          ],

          const SizedBox(height: 24),
          SBSectionHeader(l10n.info),
          const SizedBox(height: 12),
          SBInfoBox(
            title: l10n.photoInfoTitle,
            items: [
              SBInfoItem(icon: Icons.image, text: l10n.photoInfoFill),
              SBInfoItem(icon: Icons.brightness_3, text: l10n.photoInfoOverlay),
            ],
            footnote: l10n.photoInfoFootnote,
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1024);
    if (picked == null) return;

    final service = ref.read(settingsServiceProvider);
    final filename = await service.saveBackgroundImage(picked.path, 'photo');
    if (filename == null) return;

    await ref.read(settingsProvider.notifier).update(
      (s) => s.copyWith(photoWidgetImage: filename),
    );
    await WidgetReloadService().reloadAllWidgets();
    await _loadImage();
  }

  Future<void> _removeImage() async {
    final settings = ref.read(settingsProvider);
    if (settings.photoWidgetImage.isNotEmpty) {
      await ref.read(settingsServiceProvider).removeBackgroundImage(settings.photoWidgetImage);
    }
    await ref.read(settingsProvider.notifier).update(
      (s) => s.copyWith(photoWidgetImage: ''),
    );
    setState(() => _imageBytes = null);
    await WidgetReloadService().reloadAllWidgets();
  }
}
