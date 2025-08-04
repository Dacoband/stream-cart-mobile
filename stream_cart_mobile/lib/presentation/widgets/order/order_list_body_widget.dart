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
  
  // Order status values
  final List<int?> _orderStatuses = [null, 0, 1, 2, 3, 4]; // null = all, 0-4 = specific statuses
  final List<String> _tabTitles = [
    'Tất cả',
    'Chờ xác nhận',
    'Đang chuẩn bị',
    'Đang giao',
    'Hoàn thành',
    'Đã hủy',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    _scrollController.addListener(_onScroll);
    
    // Load initial orders
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
    final currentStatus = _orderStatuses[_tabController.index];
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
    switch (currentTab) {
      case 1:
        return 'Không có đơn hàng chờ xác nhận';
      case 2:
        return 'Không có đơn hàng đang chuẩn bị';
      case 3:
        return 'Không có đơn hàng đang giao';
      case 4:
        return 'Không có đơn hàng hoàn thành';
      case 5:
        return 'Không có đơn hàng đã hủy';
      default:
        return 'Chưa có đơn hàng nào';
    }
  }

  String _getEmptySubtitle() {
    final currentTab = _tabController.index;
    switch (currentTab) {
      case 1:
        return 'Các đơn hàng chờ xác nhận sẽ hiển thị ở đây.';
      case 2:
        return 'Các đơn hàng đang được chuẩn bị sẽ hiển thị ở đây.';
      case 3:
        return 'Các đơn hàng đang giao sẽ hiển thị ở đây.';
      case 4:
        return 'Các đơn hàng hoàn thành sẽ hiển thị ở đây.';
      case 5:
        return 'Các đơn hàng đã hủy sẽ hiển thị ở đây.';
      default:
        return 'Bạn chưa có đơn hàng nào.\nHãy bắt đầu mua sắm ngay!';
    }
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