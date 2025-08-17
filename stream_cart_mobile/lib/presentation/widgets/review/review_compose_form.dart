import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/image_upload_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../../theme/app_colors.dart';

class ReviewComposeForm extends StatefulWidget {
  final int? initialRating;
  final String? initialText;
  final List<String>? initialImages;
  final bool isSubmitting;
  final Future<void> Function({required int rating, required String text, required List<String> images}) onSubmit;

  const ReviewComposeForm({
    super.key,
    this.initialRating,
    this.initialText,
    this.initialImages,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  @override
  State<ReviewComposeForm> createState() => _ReviewComposeFormState();
}

class _ReviewComposeFormState extends State<ReviewComposeForm> {
  final _formKey = GlobalKey<FormState>();
  late int _rating;
  late TextEditingController _textController;
  List<TextEditingController> _imageControllers = [];
  final ImagePicker _imagePicker = ImagePicker();
  final ImageUploadService _imageUploadService = getIt<ImageUploadService>();
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 5;
    _textController = TextEditingController(text: widget.initialText ?? '');
    final images = widget.initialImages ?? const <String>[];
    _imageControllers = images.map((e) => TextEditingController(text: e)).toList();
  }

  @override
  void dispose() {
    _textController.dispose();
    for (final c in _imageControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addImageField() {
    setState(() {
      _imageControllers.add(TextEditingController());
    });
  }

  void _removeImageField(int index) {
    setState(() {
      final c = _imageControllers.removeAt(index);
      c.dispose();
    });
  }

  Future<void> _pickAndUploadImage() async {
    try {
      // Chọn nguồn ảnh
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Chọn nguồn ảnh'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Thư viện ảnh'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Chụp ảnh'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final XFile? picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (picked == null) return;

      setState(() => _isUploadingImage = true);
      final url = await _imageUploadService.uploadImage(picked);
      if (!mounted) return;
      setState(() => _isUploadingImage = false);

      if (url == null || url.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tải ảnh thất bại, vui lòng thử lại'), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() {
        _imageControllers.add(TextEditingController(text: url));
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tải ảnh thành công'), backgroundColor: Color(0xFF4CAF50)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploadingImage = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra khi tải ảnh'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.isSubmitting,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Đánh giá của bạn', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _RatingPicker(value: _rating, onChanged: (v) => setState(() => _rating = v)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _textController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Nội dung đánh giá',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập nội dung' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Hình ảnh (URL)', style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addImageField,
                  icon: const Icon(Icons.add_link),
                  label: const Text('Thêm URL'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _isUploadingImage ? null : _pickAndUploadImage,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brandPrimary,
                    foregroundColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: _isUploadingImage
                      ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.file_upload_outlined, size: 18),
                  label: const Text('Tải ảnh'),
                ),
              ],
            ),
            ...List.generate(_imageControllers.length, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_imageControllers[i].text.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              _imageControllers[i].text.trim(),
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 44,
                                height: 44,
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: const Icon(Icons.broken_image, size: 18, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: TextFormField(
                          controller: _imageControllers[i],
                          decoration: const InputDecoration(hintText: 'https://...'),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      IconButton(onPressed: () => _removeImageField(i), icon: const Icon(Icons.close))
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final images = _imageControllers.map((e) => e.text.trim()).where((e) => e.isNotEmpty).toList();
                  await widget.onSubmit(rating: _rating, text: _textController.text.trim(), images: images);
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandPrimary, foregroundColor: Colors.white),
                child: widget.isSubmitting
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Gửi đánh giá'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _RatingPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _RatingPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final idx = i + 1;
        final filled = idx <= value;
        return IconButton(
          onPressed: () => onChanged(idx),
          icon: Icon(filled ? Icons.star_rounded : Icons.star_border_rounded),
          color: filled ? AppColors.brandPrimary : Colors.grey.shade400,
        );
      }),
    );
  }
}
