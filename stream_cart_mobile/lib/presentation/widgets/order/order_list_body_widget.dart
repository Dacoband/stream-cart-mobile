import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import 'order_tab_bar_widget.dart';
import 'order_card_widget.dart';
import 'order_loading_widget.dart';
import 'emty_order_widget.dart';
import 'pull_to_refresh_wrapper_widget.dart';

// Body content widget - chỉ handle tabs và content
class OrderListBodyWidget extends StatefulWidget {
  final String accountId;

  const OrderListBodyWidget({
    Key? key,
    required this.accountId,
  }) : super(key: key);

  @override
  State<OrderListBodyWidget> createState() => _OrderListBodyWidgetState();
}

class _OrderListBodyWidgetState extends State<OrderListBodyWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  int? _lastTabIndex; 
  
  final List<int?> _orderStatuses = [
    null, // Tất cả
    0,    // Chờ xác nhận (Waiting/Pending)
    2,    // Đang xử lý (Processing/Packed)
    7,    // Đang giao (OnDelivery)
    4,    // Đã giao (Delivered)
    3,    // Đã gửi (Shipped) - thay cho Hoàn thành (10) theo Option B
    5,    // Đã hủy (Cancelled)
    8,    // Trả hàng (Returning)
    9,    // Hoàn tiền (Refunded)
  ];
  final List<String> _tabTitles = [
    'Tất cả',
    'Chờ xác nhận',
    'Xử lý',
    'Đang giao',
    'Đã giao',
    'Đã gửi', // đổi từ Hoàn thành
    'Đã hủy',
    'Trả hàng',
    'Hoàn tiền',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    _scrollController.addListener(_onScroll);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (_lastTabIndex == _tabController.index) return;
      _onTabChanged();
    });
    
    // Load initial orders
    _lastTabIndex = 0;
    _loadOrders(status: _orderStatuses[0]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final currentStatus = _orderStatuses[_tabController.index];
      context.read<OrderBloc>().add(
        LoadMoreOrdersEvent(
          accountId: widget.accountId,
          status: currentStatus,
        ),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _loadOrders({int? status}) {
    context.read<OrderBloc>().add(
      GetOrdersByAccountEvent(
        accountId: widget.accountId,
        status: status,
      ),
    );
  }

  Future<void> _refreshOrders() async {
    final currentStatus = _orderStatuses[_tabController.index];
    context.read<OrderBloc>().add(
      RefreshOrdersEvent(
        accountId: widget.accountId,
        status: currentStatus,
      ),
    );
  }

  void _onTabChanged() {
    final newIndex = _tabController.index;
    if (_lastTabIndex == newIndex) return;
    _lastTabIndex = newIndex;
    final currentStatus = _orderStatuses[newIndex];
    _loadOrders(status: currentStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar section
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
          ),
          child: OrderTabBarWidget(
            tabController: _tabController,
            tabs: _tabTitles,
            onTap: _onTabChanged,
          ),
        ),
        
        // Tab content section
        Expanded(
          child: Container(
            color: Colors.grey[50],
            child: TabBarView(
              controller: _tabController,
              children: _tabTitles.map((title) => _buildOrderList()).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderList() {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is OrderOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is OrderLoading) {
          return const OrderLoadingWidget();
        }
        
        if (state is OrderRefreshing) {
          return PullToRefreshWrapperWidget(
            onRefresh: _refreshOrders,
            child: _buildOrdersList(state.currentOrders, isRefreshing: true),
          );
        }
        
        if (state is OrderLoadingMore) {
          return _buildOrdersList(state.currentOrders, isLoadingMore: true);
        }
        
        if (state is OrdersByAccountLoaded) {
          if (state.orders.isEmpty) {
            return PullToRefreshWrapperWidget(
              onRefresh: _refreshOrders,
              child: EmptyOrderWidget(
                title: _getEmptyTitle(),
                subtitle: _getEmptySubtitle(),
                onRefresh: _refreshOrders,
              ),
            );
          }
          
          return PullToRefreshWrapperWidget(
            onRefresh: _refreshOrders,
            child: _buildOrdersList(state.orders, hasReachedMax: state.hasReachedMax),
          );
        }
        
        if (state is OrderError) {
          return PullToRefreshWrapperWidget(
            onRefresh: _refreshOrders,
            child: EmptyOrderWidget(
              title: 'Đã xảy ra lỗi',
              subtitle: state.message,
              onRefresh: _refreshOrders,
            ),
          );
        }
        
        return PullToRefreshWrapperWidget(
          onRefresh: _refreshOrders,
          child: EmptyOrderWidget(onRefresh: _refreshOrders),
        );
      },
    );
  }

  Widget _buildOrdersList(
    List<dynamic> orders, {
    bool isRefreshing = false,
    bool isLoadingMore = false,
    bool hasReachedMax = false,
  }) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: orders.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= orders.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: OrderCardWidget(
            order: order,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/order-detail',
                arguments: order.id,
              );
            },
          ),
        );
      },
    );
  }

  String _getEmptyTitle() {
    final currentTab = _tabController.index;
  if (currentTab == 0) return 'Chưa có đơn hàng nào';
  return 'Không có đơn hàng ở trạng thái "${_tabTitles[currentTab]}"';
  }

  String _getEmptySubtitle() {
    final currentTab = _tabController.index;
    if (currentTab == 0) {
      return 'Bạn chưa có đơn hàng nào.\nHãy bắt đầu mua sắm ngay!';
    }
    return 'Các đơn hàng trạng thái "${_tabTitles[currentTab]}" sẽ hiển thị ở đây.';
  }
}

// Keep compatibility - Deprecated, use OrderListBodyWidget instead
@Deprecated('Use OrderListBodyWidget instead')
class OrderListViewWidget extends OrderListBodyWidget {
  const OrderListViewWidget({
    Key? key,
    required String accountId,
  }) : super(key: key, accountId: accountId);
}