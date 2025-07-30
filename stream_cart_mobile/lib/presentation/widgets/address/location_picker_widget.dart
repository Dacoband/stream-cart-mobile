import 'package:flutter/material.dart';
import '../../../domain/entities/address_entity.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.provinces.isEmpty) {
      widget.onLoadProvinces();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown<ProvinceEntity>(
          label: 'Tỉnh/Thành phố',
          value: selectedProvince,
          items: widget.provinces,
          itemBuilder: (province) => province.fullName,
          onChanged: (province) {
            setState(() {
              selectedProvince = province;
              selectedDistrict = null;
              selectedWard = null;
            });
            
            if (province != null) {
              widget.onLoadDistricts(province.id);
            }
          },
        ),
        
        const SizedBox(height: 16),
        
        // District Dropdown
        _buildDropdown<ProvinceEntity>(
          label: 'Quận/Huyện',
          value: selectedDistrict,
          items: widget.districts,
          itemBuilder: (district) => district.fullName,
          onChanged: (district) {
            setState(() {
              selectedDistrict = district;
              selectedWard = null;
            });
            
            if (district != null) {
              widget.onLoadWards(district.id);
            }
          },
          enabled: selectedProvince != null,
        ),
        
        const SizedBox(height: 16),
        
        // Ward Dropdown
        _buildDropdown<WardEntity>(
          label: 'Phường/Xã',
          value: selectedWard,
          items: widget.wards,
          itemBuilder: (ward) => ward.fullName,
          onChanged: (ward) {
            setState(() {
              selectedWard = ward;
            });
            
            if (ward != null && selectedProvince != null && selectedDistrict != null) {
              widget.onLocationSelected(
                selectedProvince!.id,
                selectedProvince!.fullName,
                selectedDistrict!.id,
                selectedDistrict!.fullName,
                ward.id,
                ward.fullName,
                double.tryParse(ward.latitude) ?? 0.0,
                double.tryParse(ward.longitude) ?? 0.0,
              );
            }
          },
          enabled: selectedDistrict != null,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemBuilder,
    required void Function(T?) onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF202328),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: enabled 
                  ? const Color(0xFFE0E0E0)
                  : const Color(0xFFF5F5F5),
            ),
            borderRadius: BorderRadius.circular(8),
            color: enabled ? Colors.white : const Color(0xFFF9F9F9),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: Text(
                'Chọn $label',
                style: TextStyle(
                  fontSize: 14,
                  color: enabled 
                      ? const Color(0xFF999999)
                      : const Color(0xFFCCCCCC),
                ),
              ),
              isExpanded: true,
              onChanged: enabled ? onChanged : null,
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemBuilder(item),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF202328),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}