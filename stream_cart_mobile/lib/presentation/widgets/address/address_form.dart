import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../core/enums/address_type.dart';
import '../../blocs/address/address_bloc.dart';
import '../../blocs/address/address_event.dart';
import '../../blocs/address/address_state.dart';
import 'location_picker_widget.dart';
import 'address_type_selector.dart';

class AddressForm extends StatefulWidget {
  final AddressEntity? initialAddress; 
  final Function(Map<String, dynamic>) onSubmit;
  final bool isLoading;
  
  const AddressForm({
    Key? key,
    this.initialAddress,
    required this.onSubmit,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final _recipientNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  
  AddressType _selectedType = AddressType.residential;
  bool _isDefaultShipping = false;
  
  // Location data arrays
  List<ProvinceEntity> _provinces = [];
  List<ProvinceEntity> _districts = [];
  List<WardEntity> _wards = [];
  
  // Location selection
  String? _selectedProvinceId;
  String? _selectedProvinceName;
  String? _selectedDistrictId;
  String? _selectedDistrictName;
  String? _selectedWardId;
  String? _selectedWardName;
  double _selectedLatitude = 0.0;
  double _selectedLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeForm();
    // Load provinces when form initializes
    context.read<AddressBloc>().add(const GetProvincesEvent());
  }

  void _initializeForm() {
    if (widget.initialAddress != null) {
      final address = widget.initialAddress!;
      _recipientNameController.text = address.recipientName;
      _phoneController.text = address.phoneNumber;
      _streetController.text = address.street;
      _selectedType = address.type;
      _isDefaultShipping = address.isDefaultShipping;
      
      _selectedProvinceName = address.city;
      _selectedDistrictName = address.district;
      _selectedWardName = address.ward;
      _selectedLatitude = address.latitude;
      _selectedLongitude = address.longitude;
    }
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  void _onLocationSelected(
    String provinceId,
    String provinceName,
    String districtId,
    String districtName,
    String wardId,
    String wardName,
    double latitude,
    double longitude,
  ) {
    setState(() {
      _selectedProvinceId = provinceId;
      _selectedProvinceName = provinceName;
      _selectedDistrictId = districtId;
      _selectedDistrictName = districtName;
      _selectedWardId = wardId;
      _selectedWardName = wardName;
      _selectedLatitude = latitude;
      _selectedLongitude = longitude;
    });
  }

  void _onLoadProvinces() {
    context.read<AddressBloc>().add(const GetProvincesEvent());
  }

  void _onLoadDistricts(String provinceId) {
    context.read<AddressBloc>().add(GetDistrictsEvent(provinceId: provinceId));
  }

  void _onLoadWards(String districtId) {
    context.read<AddressBloc>().add(GetWardsEvent(districtId: districtId));
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedProvinceId == null || _selectedDistrictId == null || _selectedWardId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn đầy đủ tỉnh/thành, quận/huyện, phường/xã'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final formData = {
        'recipientName': _recipientNameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'street': _streetController.text.trim(),
        'ward': _selectedWardName!,
        'district': _selectedDistrictName!,
        'city': _selectedProvinceName!,
        'type': _selectedType,
        'isDefaultShipping': _isDefaultShipping,
        // Add default values
        'country': 'Việt Nam',
        'postalCode': '70000',
        'latitude': _selectedLatitude, // ✅ Use ward coordinates
        'longitude': _selectedLongitude, // ✅ Use ward coordinates
      };

      widget.onSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is ProvincesLoaded) {
          setState(() {
            _provinces = state.provinces;
          });
        } else if (state is DistrictsLoaded) {
          setState(() {
            _districts = state.districts;
            _wards.clear(); // Clear wards when districts change
          });
        } else if (state is WardsLoaded) {
          setState(() {
            _wards = state.wards;
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipient Name Field
            _buildTextField(
              controller: _recipientNameController,
              label: 'Tên người nhận',
              hint: 'Nhập tên người nhận',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tên người nhận';
                }
                if (value.trim().length < 2) {
                  return 'Tên người nhận phải có ít nhất 2 ký tự';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Phone Number Field
            _buildTextField(
              controller: _phoneController,
              label: 'Số điện thoại',
              hint: 'Nhập số điện thoại',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value.trim())) {
                  return 'Số điện thoại không hợp lệ (10-11 số)';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Location Picker - Updated to use new interface
            LocationPicker(
              initialProvinceId: _selectedProvinceId,
              initialDistrictId: _selectedDistrictId,
              initialWardId: _selectedWardId,
              provinces: _provinces,
              districts: _districts,
              wards: _wards,
              onLocationSelected: _onLocationSelected,
              onLoadProvinces: _onLoadProvinces,
              onLoadDistricts: _onLoadDistricts,
              onLoadWards: _onLoadWards,
            ),
            
            const SizedBox(height: 20),
            
            // Street Address Field
            _buildTextField(
              controller: _streetController,
              label: 'Địa chỉ chi tiết',
              hint: 'Số nhà, tên đường...',
              icon: Icons.location_on_outlined,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập địa chỉ chi tiết';
                }
                if (value.trim().length < 5) {
                  return 'Địa chỉ chi tiết phải có ít nhất 5 ký tự';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Address Type Selector
            AddressTypeSelector(
              selectedType: _selectedType,
              onTypeSelected: (type) {
                setState(() {
                  _selectedType = type;
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            // Default Shipping Checkbox
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _isDefaultShipping,
                      onChanged: (value) {
                        setState(() {
                          _isDefaultShipping = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đặt làm địa chỉ mặc định',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF202328),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Địa chỉ này sẽ được chọn mặc định khi đặt hàng',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  disabledBackgroundColor: const Color(0xFFE0E0E0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.initialAddress != null ? 'Cập nhật địa chỉ' : 'Thêm địa chỉ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
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
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: const Color(0xFF666666),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF202328),
          ),
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
