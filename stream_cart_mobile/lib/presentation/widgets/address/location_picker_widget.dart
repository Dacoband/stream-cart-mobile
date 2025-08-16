import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/address/address_entity.dart';
import '../../blocs/address/address_bloc.dart';
import '../../blocs/address/address_state.dart';
import '../../theme/app_colors.dart';

class LocationPicker extends StatefulWidget {
  final String? initialProvinceId;
  final String? initialDistrictId;
  final String? initialWardId;
  final List<ProvinceEntity> provinces;
  final List<ProvinceEntity> districts;
  final List<WardEntity> wards;
  final Function(String provinceId, String provinceName, String districtId, String districtName, String wardId, String wardName, double latitude, double longitude) onLocationSelected;
  final Function() onLoadProvinces;
  final Function(String provinceId) onLoadDistricts;
  final Function(String districtId) onLoadWards;
  
  const LocationPicker({
    Key? key,
    this.initialProvinceId,
    this.initialDistrictId,
    this.initialWardId,
    required this.provinces,
    required this.districts,
    required this.wards,
    required this.onLocationSelected,
    required this.onLoadProvinces,
    required this.onLoadDistricts,
    required this.onLoadWards,
  }) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  ProvinceEntity? selectedProvince;
  ProvinceEntity? selectedDistrict;
  WardEntity? selectedWard;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.provinces.isEmpty) {
      widget.onLoadProvinces();
    }
  }

  @override
  void didUpdateWidget(covariant LocationPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Backfill selections from initial IDs when the lists arrive
    if (selectedProvince == null && widget.initialProvinceId != null && widget.provinces.isNotEmpty) {
      selectedProvince = widget.provinces.firstWhere(
        (p) => p.id == widget.initialProvinceId,
        orElse: () => selectedProvince ?? widget.provinces.first,
      );
    }
    if (selectedDistrict == null && widget.initialDistrictId != null && widget.districts.isNotEmpty) {
      selectedDistrict = widget.districts.firstWhere(
        (d) => d.id == widget.initialDistrictId,
        orElse: () => selectedDistrict ?? widget.districts.first,
      );
    }
    if (selectedWard == null && widget.initialWardId != null && widget.wards.isNotEmpty) {
      selectedWard = widget.wards.firstWhere(
        (w) => w.id == widget.initialWardId,
        orElse: () => selectedWard ?? widget.wards.first,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedProvince != null && selectedDistrict != null && selectedWard != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Khu vực',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF202328),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _openBottomSheet,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.bubbleNeutral,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.location_on_outlined, color: AppColors.brandDark, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasSelection ? '${selectedWard!.fullName}, ${selectedDistrict!.fullName}, ${selectedProvince!.fullName}' : 'Chọn Tỉnh/Thành, Quận/Huyện, Phường/Xã',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: hasSelection ? const Color(0xFF202328) : const Color(0xFF999999),
                          fontWeight: hasSelection ? FontWeight.w600 : FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                      if (hasSelection)
                        const SizedBox(height: 2),
                      if (hasSelection)
                        const Text(
                          'Nhấn để thay đổi',
                          style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF999999)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openBottomSheet() async {
    _searchCtrl.clear();
    _SheetStep current = _SheetStep.province;
    ProvinceEntity? tempProvince = selectedProvince;
    ProvinceEntity? tempDistrict = selectedDistrict;
    WardEntity? tempWard = selectedWard;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: StatefulBuilder(
              builder: (ctx, setSheetState) {
                void toStep(_SheetStep step) {
                  setSheetState(() {
                    current = step;
                    _searchCtrl.clear();
                  });
                }

                List<dynamic> currentItems;
                if (current == _SheetStep.province) {
                  currentItems = widget.provinces;
                } else if (current == _SheetStep.district) {
                  currentItems = widget.districts;
                } else {
                  currentItems = widget.wards;
                }

                final query = _searchCtrl.text.trim().toLowerCase();
                if (query.isNotEmpty) {
                  currentItems = currentItems.where((item) {
                    final name = (item as dynamic).fullName?.toLowerCase() ?? '';
                    return name.contains(query);
                  }).toList();
                }

                Widget buildStepChip(String label, _SheetStep step, bool enabled) {
                  final active = current == step;
                  return Expanded(
                    child: InkWell(
                      onTap: enabled ? () => toStep(step) : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: active ? AppColors.brandAccent : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: active ? AppColors.brandDark : const Color(0xFFE5E7EB)),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: active ? AppColors.brandDark : const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: MediaQuery.of(ctx).size.height * 0.75,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Chọn khu vực',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            buildStepChip('Tỉnh/Thành', _SheetStep.province, true),
                            const SizedBox(width: 8),
                            buildStepChip('Quận/Huyện', _SheetStep.district, tempProvince != null),
                            const SizedBox(width: 8),
                            buildStepChip('Phường/Xã', _SheetStep.ward, tempDistrict != null),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (_) => setSheetState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm theo tên...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            filled: true,
                            fillColor: const Color(0xFFF3F4F6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: BlocBuilder<AddressBloc, AddressState>(
                          builder: (context, state) {
                            final isLoading = (state is AddressLoading);
                            if (isLoading && currentItems.isEmpty) {
                              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                            }

                            if (currentItems.isEmpty) {
                              return const Center(
                                child: Text('Không có dữ liệu', style: TextStyle(color: Color(0xFF9CA3AF))),
                              );
                            }

                            return ListView.separated(
                              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                              itemCount: currentItems.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (ctx, index) {
                                final item = currentItems[index];
                                final name = (item as dynamic).fullName as String;

                                bool checked = false;
                                if (current == _SheetStep.province) {
                                  checked = tempProvince?.id == (item as ProvinceEntity).id;
                                } else if (current == _SheetStep.district) {
                                  checked = tempDistrict?.id == (item as ProvinceEntity).id;
                                } else {
                                  checked = tempWard?.id == (item as WardEntity).id;
                                }

                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                                  title: Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                  trailing: checked
                                      ? const Icon(Icons.check_circle, color: AppColors.brandDark)
                                      : const Icon(Icons.radio_button_unchecked, color: Color(0xFF9CA3AF)),
                                  onTap: () {
                                    if (current == _SheetStep.province) {
                                      tempProvince = item as ProvinceEntity;
                                      tempDistrict = null;
                                      tempWard = null;
                                      widget.onLoadDistricts(tempProvince!.id);
                                      toStep(_SheetStep.district);
                                    } else if (current == _SheetStep.district) {
                                      tempDistrict = item as ProvinceEntity; // district entity shares same type
                                      tempWard = null;
                                      widget.onLoadWards(tempDistrict!.id);
                                      toStep(_SheetStep.ward);
                                    } else {
                                      tempWard = item as WardEntity;
                                      // finalize selection
                                      if (tempProvince != null && tempDistrict != null && tempWard != null) {
                                        setState(() {
                                          selectedProvince = tempProvince;
                                          selectedDistrict = tempDistrict;
                                          selectedWard = tempWard;
                                        });
                                        widget.onLocationSelected(
                                          selectedProvince!.id,
                                          selectedProvince!.fullName,
                                          selectedDistrict!.id,
                                          selectedDistrict!.fullName,
                                          selectedWard!.id,
                                          selectedWard!.fullName,
                                          double.tryParse(selectedWard!.latitude) ?? 0.0,
                                          double.tryParse(selectedWard!.longitude) ?? 0.0,
                                        );
                                        Navigator.of(ctx).pop();
                                      }
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

enum _SheetStep { province, district, ward }