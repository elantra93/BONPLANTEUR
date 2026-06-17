import 'package:flutter/material.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/upload_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class DemeterImagePicker extends StatefulWidget {
  const DemeterImagePicker({
    super.key,
    this.initialUrls = const [],
    required this.onChanged,
    this.storagePath = 'uploads',
    this.label = 'Photo',
    this.allowMultiple = false,
    this.maxImages = 5,
  });

  final List<String> initialUrls;
  final void Function(List<String> urls) onChanged;
  final String storagePath;
  final String label;
  final bool allowMultiple;
  final int maxImages;

  @override
  State<DemeterImagePicker> createState() => _DemeterImagePickerState();
}

class _DemeterImagePickerState extends State<DemeterImagePicker> {
  bool _isUploading = false;
  List<String> _urls = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _urls = List.from(widget.initialUrls);
  }

  Future<void> _pickAndUpload() async {
    if (!widget.allowMultiple && _urls.isNotEmpty) return;
    if (_urls.length >= widget.maxImages) return;

    final theme = FlutterFlowTheme.of(context);

    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      storageFolderPath: widget.storagePath,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
      allowPhoto: true,
      allowVideo: false,
      pickerFontFamily: 'Inter',
      textColor: theme.primaryText,
      backgroundColor: theme.secondaryBackground,
    );

    if (selectedMedia == null || selectedMedia.isEmpty || !mounted) return;

    setState(() {
      _isUploading = true;
      _error = null;
    });

    try {
      final newUrls = <String>[];
      for (final media in selectedMedia) {
        final url = await uploadData(media.storagePath, media.bytes);
        if (url != null) newUrls.add(url);
      }

      if (newUrls.length == selectedMedia.length) {
        setState(() {
          _urls = widget.allowMultiple
              ? [..._urls, ...newUrls].take(widget.maxImages).toList()
              : newUrls.take(1).toList();
        });
        widget.onChanged(_urls);
      } else {
        setState(() => _error = 'Échec de l\'envoi. Veuillez réessayer.');
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Erreur lors de l\'envoi de la photo.');
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _remove(int index) {
    setState(() => _urls.removeAt(index));
    widget.onChanged(_urls);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final canAdd = widget.allowMultiple
        ? _urls.length < widget.maxImages
        : _urls.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.photo_camera_outlined,
                    color: theme.secondaryText, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    color: theme.primaryText,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                if (widget.allowMultiple) ...[
                  const SizedBox(width: 4),
                  Text(
                    '(${_urls.length}/${widget.maxImages})',
                    style: GoogleFonts.inter(
                      color: theme.secondaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
            if (_isUploading)
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.primary,
                ),
              )
            else if (canAdd)
              GestureDetector(
                onTap: _pickAndUpload,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: theme.primary.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          color: theme.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Ajouter',
                        style: GoogleFonts.inter(
                          color: theme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: 4),
          Text(
            _error!,
            style: GoogleFonts.inter(color: theme.error, fontSize: 11),
          ),
        ],
        if (_urls.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _urls.asMap().entries.map((e) {
              final idx = e.key;
              final url = e.value;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 80,
                        height: 80,
                        color: theme.alternate,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.primary,
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: theme.alternate,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: theme.secondaryText,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: GestureDetector(
                      onTap: () => _remove(idx),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: theme.error,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(Icons.close,
                            size: 11, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
        if (_urls.isEmpty && !_isUploading) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickAndUpload,
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.alternate,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      color: theme.secondaryText, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    'Appuyer pour ajouter une photo',
                    style: GoogleFonts.inter(
                      color: theme.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
