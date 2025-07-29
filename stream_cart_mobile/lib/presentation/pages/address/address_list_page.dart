import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/entities/address_entity.dart';
import '../../blocs/address/address_bloc.dart';
import '../../blocs/address/address_event.dart';
import '../../blocs/address/address_state.dart';
import '../../widgets/address/address_card_widget.dart';
import '../../widgets/address/empty_address.dart';
import 'add_edit_address_page.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({Key? key}) : super(key: key);

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  @override
  void initState() {
    super.initState();
    // Load addresses and default address when page opens
    context.read<AddressBloc>().add(const GetAddressesEvent());
    context.read<AddressBloc>().add(const GetDefaultShippingAddressEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Địa chỉ giao hàng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202328),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF202328),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Color(0xFF4CAF50),
            ),
            onPressed: () => _navigateToAddAddress(),
          ),
        ],
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is AddressCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Thêm địa chỉ thành công'),
                backgroundColor: Color(0xFF4CAF50),
              ),
            );
            // Reload addresses
            context.read<AddressBloc>().add(const GetAddressesEvent());
            context.read<AddressBloc>().add(const GetDefaultShippingAddressEvent());
          } else if (state is AddressUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật địa chỉ thành công'),
                backgroundColor: Color(0xFF4CAF50),
              ),
            );
            // Reload addresses
            context.read<AddressBloc>().add(const GetAddressesEvent());
            context.read<AddressBloc>().add(const GetDefaultShippingAddressEvent());
          } else if (state is AddressDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Xóa địa chỉ thành công'),
                backgroundColor: Color(0xFF4CAF50),
              ),
            );
            // Reload addresses
            context.read<AddressBloc>().add(const GetAddressesEvent());
            context.read<AddressBloc>().add(const GetDefaultShippingAddressEvent());
          } else if (state is DefaultShippingAddressSet) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã đặt làm địa chỉ mặc định'),
                backgroundColor: Color(0xFF4CAF50),
              ),
            );
            // Reload addresses
            context.read<AddressBloc>().add(const GetAddressesEvent());
            context.read<AddressBloc>().add(const GetDefaultShippingAddressEvent());
          }
        },
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4CAF50),
              ),
            );
          }

          return _buildAddressList();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddAddress(),
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        List<AddressEntity> addresses = [];
        AddressEntity? defaultAddress;

        // Extract addresses from different states
        if (state is AddressesLoaded) {
          addresses = state.addresses;
        }

        // Get default address from previous state or current state
        final blocState = context.read<AddressBloc>().state;
        if (blocState is DefaultShippingAddressLoaded) {
          defaultAddress = blocState.address;
        }

        if (addresses.isEmpty) {
          return EmptyAddress(
            onAddAddress: () => _navigateToAddAddress(),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<AddressBloc>().add(const GetAddressesEvent());
            context.read<AddressBloc>().add(const GetDefaultShippingAddressEvent());
          },
          color: const Color(0xFF4CAF50),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Default Address Section
              if (defaultAddress != null) ...[
                const Text(
                  'Địa chỉ mặc định',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202328),
                  ),
                ),
                const SizedBox(height: 12),
                AddressCard(
                  address: defaultAddress,
                  isDefault: true,
                  onEdit: () => _navigateToEditAddress(defaultAddress!),
                  onDelete: () => _showDeleteDialog(defaultAddress!),
                ),
                const SizedBox(height: 24),
              ],

              // Other Addresses Section
              if (addresses.where((addr) => addr.id != defaultAddress?.id).isNotEmpty) ...[
                const Text(
                  'Địa chỉ khác',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202328),
                  ),
                ),
                const SizedBox(height: 12),
                ...addresses
                    .where((addr) => addr.id != defaultAddress?.id)
                    .map((address) => AddressCard(
                          address: address,
                          isDefault: false,
                          onEdit: () => _navigateToEditAddress(address),
                          onDelete: () => _showDeleteDialog(address),
                          onSetDefault: () => _setDefaultAddress(address),
                        ))
                    .toList(),
              ],

              // Bottom spacing for FAB
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  void _navigateToAddAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => GetIt.instance<AddressBloc>(),
          child: const AddEditAddressPage(),
        ),
      ),
    );
  }

  void _navigateToEditAddress(AddressEntity address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => GetIt.instance<AddressBloc>(),
          child: AddEditAddressPage(
            initialAddress: address,
          ),
        ),
      ),
    );
  }

  void _setDefaultAddress(AddressEntity address) {
    context.read<AddressBloc>().add(
      SetDefaultShippingAddressEvent(id: address.id),
    );
  }

  void _showDeleteDialog(AddressEntity address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Xóa địa chỉ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF202328),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bạn có chắc chắn muốn xóa địa chỉ này?',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.recipientName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF202328),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${address.street}, ${address.ward}, ${address.district}, ${address.city}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Hủy',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AddressBloc>().add(
                  DeleteAddressEvent(id: address.id),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Xóa',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}