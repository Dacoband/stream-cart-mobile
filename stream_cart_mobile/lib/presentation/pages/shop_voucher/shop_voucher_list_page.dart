import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/shop_voucher/shop_voucher_bloc.dart';
import '../../blocs/shop_voucher/shop_voucher_event.dart';
import '../../blocs/shop_voucher/shop_voucher_state.dart';
import '../../theme/app_colors.dart';
import '../../../domain/entities/shop_voucher/shop_voucher_entity.dart';
import '../../widgets/shop_voucher/shop_voucher_list_tile.dart';

class ShopVoucherListPage extends StatefulWidget {
	final String shopId;
	const ShopVoucherListPage({super.key, required this.shopId});

	@override
	State<ShopVoucherListPage> createState() => _ShopVoucherListPageState();
}

class _ShopVoucherListPageState extends State<ShopVoucherListPage> {
	final ScrollController _scrollController = ScrollController();
	int _page = 1;
	final int _pageSize = 20;
	bool _isLoadingMore = false;
	List<ShopVoucherEntity> _items = [];
	bool _hasNext = true;

	@override
	void initState() {
		super.initState();
		context.read<ShopVoucherBloc>().add(LoadShopVouchersEvent(shopId: widget.shopId, pageNumber: _page, pageSize: _pageSize));
		_scrollController.addListener(_onScroll);
	}

	@override
	void dispose() {
		_scrollController.dispose();
		super.dispose();
	}

	void _onScroll() {
		if (!_hasNext || _isLoadingMore) return;
		if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
			_loadMore();
		}
	}

	Future<void> _refresh() async {
		_page = 1;
		_items.clear();
		_hasNext = true;
		context.read<ShopVoucherBloc>().add(LoadShopVouchersEvent(shopId: widget.shopId, pageNumber: _page, pageSize: _pageSize));
	}

	void _loadMore() {
		if (!_hasNext) return;
		setState(() => _isLoadingMore = true);
		_page += 1;
		context.read<ShopVoucherBloc>().add(LoadShopVouchersEvent(shopId: widget.shopId, pageNumber: _page, pageSize: _pageSize));
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Voucher của shop'),
				backgroundColor: AppColors.brandDark,
				foregroundColor: Colors.white,
			),
			body: BlocConsumer<ShopVoucherBloc, ShopVoucherState>(
				listener: (context, state) {
					if (state is ShopVouchersLoaded) {
						final page = state.vouchers.data;
						final newItems = page?.items ?? [];
						setState(() {
							if (_page == 1) {
								_items = newItems;
							} else {
								_items = [..._items, ...newItems];
							}
							_hasNext = page?.hasNext ?? false;
							_isLoadingMore = false;
						});
					}
					if (state is ShopVoucherError) {
						setState(() => _isLoadingMore = false);
						ScaffoldMessenger.of(context).showSnackBar(
							SnackBar(content: Text(state.message)),
						);
					}
				},
				builder: (context, state) {
					final isInitialLoading = state is ShopVoucherLoading && _page == 1 && _items.isEmpty;
					if (isInitialLoading) {
						return const Center(child: CircularProgressIndicator());
					}
					if (_items.isEmpty) {
						return RefreshIndicator(
							onRefresh: _refresh,
							child: ListView(
								children: const [
									SizedBox(height: 80),
									Icon(Icons.local_activity_outlined, size: 56, color: Colors.grey),
									SizedBox(height: 12),
									Center(child: Text('Chưa có voucher nào', style: TextStyle(color: Colors.grey))),
								],
							),
						);
					}
					return RefreshIndicator(
						onRefresh: _refresh,
						child: ListView.separated(
							controller: _scrollController,
							padding: const EdgeInsets.all(16),
							itemBuilder: (context, index) {
								if (index == _items.length) {
									return _isLoadingMore
											? const Padding(
													padding: EdgeInsets.symmetric(vertical: 16),
													child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
												)
											: const SizedBox.shrink();
								}
								final v = _items[index];
								return ShopVoucherListTile(voucher: v);
							},
							separatorBuilder: (_, __) => const SizedBox(height: 12),
							itemCount: _items.length + 1,
						),
					);
				},
			),
		);
	}
}