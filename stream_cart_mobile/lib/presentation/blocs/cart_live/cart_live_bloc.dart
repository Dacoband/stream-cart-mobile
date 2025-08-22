import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_live_event.dart';
import 'cart_live_state.dart';
import '../../../domain/usecases/cart_live/get_livestream_cart_usecase.dart';
import '../../../domain/usecases/cart_live/add_to_livestream_cart_usecase.dart';
import '../../../domain/usecases/cart_live/update_livestream_cart_item_quantity_usecase.dart';
import '../../../domain/usecases/cart_live/remove_livestream_cart_item_usecase.dart';
import '../../../domain/usecases/cart_live/clear_livestream_cart_usecase.dart';
import '../../../domain/usecases/cart_live/listen_livestream_cart_events_usecase.dart';
import '../../../data/models/cart_live/preview_order_live_model.dart';

class CartLiveBloc extends Bloc<CartLiveEvent, CartLiveState> {
	final GetLivestreamCartUsecase getCartUsecase;
	final AddToLivestreamCartUsecase addUsecase;
	final UpdateLivestreamCartItemQuantityUsecase updateQtyUsecase;
	final RemoveLivestreamCartItemUsecase removeItemUsecase;
	final ClearLivestreamCartUsecase clearUsecase;
	final ListenLivestreamCartEventsUsecase listenEventsUsecase;

		bool _listening = false;

	CartLiveBloc({
		required this.getCartUsecase,
		required this.addUsecase,
		required this.updateQtyUsecase,
		required this.removeItemUsecase,
		required this.clearUsecase,
		required this.listenEventsUsecase,
	}) : super(CartLiveInitial()) {
		on<LoadCartLiveEvent>(_onLoad);
		on<AddToCartLiveEvent>(_onAdd);
		on<UpdateCartLiveItemQuantityEvent>(_onUpdateQty);
		on<RemoveCartLiveItemEvent>(_onRemoveItem);
		on<ClearCartLiveEvent>(_onClear);
		on<ToggleSelectCartLiveItemEvent>(_onToggleSelectItem);
		on<SelectAllCartLiveItemsEvent>(_onSelectAllItems);
		on<UnselectAllCartLiveItemsEvent>(_onUnselectAllItems);
		on<CartLiveRealtimeLoadedInternalEvent>(_onRealtimeLoaded);
		on<CartLiveRealtimeUpdatedInternalEvent>(_onRealtimeUpdated);
		on<CartLiveRealtimeClearedInternalEvent>(_onRealtimeCleared);
		on<CartLiveRealtimeErrorInternalEvent>(_onRealtimeError);
	}

			Future<void> _ensureListening() async {
				if (_listening) return;
				listenEventsUsecase.listen(
					onLoaded: (cart) => add(CartLiveRealtimeLoadedInternalEvent(cart)),
					onUpdated: (action, cart, raw) => add(CartLiveRealtimeUpdatedInternalEvent(action, cart, raw)),
					onCleared: (payload) => add(CartLiveRealtimeClearedInternalEvent(payload)),
					onError: (msg) => add(CartLiveRealtimeErrorInternalEvent(msg)),
				);
				_listening = true;
			}

	Future<void> _onLoad(LoadCartLiveEvent event, Emitter<CartLiveState> emit) async {
		emit(CartLiveLoading());
		await _ensureListening();
		try {
			await getCartUsecase(event.livestreamId);
		} catch (e) {
			emit(CartLiveError('Không thể tải giỏ hàng live: $e'));
		}
	}

	Future<void> _onAdd(AddToCartLiveEvent event, Emitter<CartLiveState> emit) async {
		final current = state;
		if (current is CartLiveLoaded) {
		emit(CartLiveActionInProgress(previous: current.cart, selectedCartItemIds: current.selectedCartItemIds));
		}
		try {
			await addUsecase(
				livestreamId: event.livestreamId,
				livestreamProductId: event.livestreamProductId,
				quantity: event.quantity,
			);
		} catch (e) {
			emit(CartLiveError('Không thể thêm sản phẩm: $e'));
		}
	}

	Future<void> _onUpdateQty(UpdateCartLiveItemQuantityEvent event, Emitter<CartLiveState> emit) async {
			final current = state;
			if (current is CartLiveLoaded) {
				emit(CartLiveActionInProgress(previous: current.cart, selectedCartItemIds: current.selectedCartItemIds));
			}
			// Debounce per-item
			_debounceUpdate(event.cartItemId, event.quantity, emit);
	}

	Future<void> _onRemoveItem(RemoveCartLiveItemEvent event, Emitter<CartLiveState> emit) async {
		final current = state;
		if (current is CartLiveLoaded) {
		emit(CartLiveActionInProgress(previous: current.cart, selectedCartItemIds: current.selectedCartItemIds));
		}
		try {
			await removeItemUsecase(cartItemId: event.cartItemId);
		} catch (e) {
			emit(CartLiveError('Không thể xóa sản phẩm: $e'));
		}
	}

	Future<void> _onClear(ClearCartLiveEvent event, Emitter<CartLiveState> emit) async {
		final current = state;
		if (current is CartLiveLoaded) {
		emit(CartLiveActionInProgress(previous: current.cart, selectedCartItemIds: current.selectedCartItemIds));
		}
		try {
			await clearUsecase(livestreamId: event.livestreamId);
		} catch (e) {
			emit(CartLiveError('Không thể xóa giỏ live: $e'));
		}
	}

		void _onRealtimeLoaded(CartLiveRealtimeLoadedInternalEvent event, Emitter<CartLiveState> emit) {
			final previousSelection = _extractSelectionFromState();
			emit(CartLiveLoaded(cart: event.cart, selectedCartItemIds: _filterExistingSelection(previousSelection, event.cart)));
	}

		void _onRealtimeUpdated(CartLiveRealtimeUpdatedInternalEvent event, Emitter<CartLiveState> emit) {
			final previousSelection = _extractSelectionFromState();
			final filtered = _filterExistingSelection(previousSelection, event.cart);
			emit(CartLiveUpdated(action: event.action, cart: event.cart, raw: event.raw, selectedCartItemIds: filtered));
	}

		void _onRealtimeCleared(CartLiveRealtimeClearedInternalEvent event, Emitter<CartLiveState> emit) {
		emit(CartLiveCleared(event.payload));
	}

		void _onRealtimeError(CartLiveRealtimeErrorInternalEvent event, Emitter<CartLiveState> emit) {
		emit(CartLiveError(event.message));
	}

			// Selection handlers
			void _onToggleSelectItem(ToggleSelectCartLiveItemEvent event, Emitter<CartLiveState> emit) {
				final current = state;
				if (current is CartLiveLoaded) {
					final newSet = Set<String>.from(current.selectedCartItemIds);
					if (newSet.contains(event.cartItemId)) {
						newSet.remove(event.cartItemId);
					} else {
						newSet.add(event.cartItemId);
					}
					emit(current.copyWith(selectedCartItemIds: newSet));
				} else if (current is CartLiveUpdated) {
					final newSet = Set<String>.from(current.selectedCartItemIds);
					if (newSet.contains(event.cartItemId)) {
						newSet.remove(event.cartItemId);
					} else {
						newSet.add(event.cartItemId);
					}
					emit(current.copyWith(selectedCartItemIds: newSet));
				}
			}

			void _onSelectAllItems(SelectAllCartLiveItemsEvent event, Emitter<CartLiveState> emit) {
				final current = state;
				final allIds = _currentAllItemIds();
				if (current is CartLiveLoaded) {
					emit(current.copyWith(selectedCartItemIds: allIds.toSet()));
				} else if (current is CartLiveUpdated) {
					emit(current.copyWith(selectedCartItemIds: allIds.toSet()));
				}
			}

			void _onUnselectAllItems(UnselectAllCartLiveItemsEvent event, Emitter<CartLiveState> emit) {
				final current = state;
				if (current is CartLiveLoaded) {
					emit(current.copyWith(selectedCartItemIds: {}));
				} else if (current is CartLiveUpdated) {
					emit(current.copyWith(selectedCartItemIds: {}));
				}
			}

			Set<String> _extractSelectionFromState() {
				final current = state;
				if (current is CartLiveLoaded) return current.selectedCartItemIds;
				if (current is CartLiveUpdated) return current.selectedCartItemIds;
				if (current is CartLiveActionInProgress) return current.selectedCartItemIds;
				return {};
			}

			Set<String> _filterExistingSelection(Set<String> original, PreviewOrderLiveModel cart) {
				final existing = _currentAllItemIds(cart: cart);
				return original.where(existing.contains).toSet();
			}

			List<String> _currentAllItemIds({PreviewOrderLiveModel? cart}) {
				final c = cart ?? _currentCart();
				if (c == null) return [];
				final ids = <String>[];
				for (final shop in c.listCartItem) {
					for (final p in shop.products) {
						ids.add(p.cartItemId);
					}
				}
				return ids;
			}

			PreviewOrderLiveModel? _currentCart() {
				final current = state;
				if (current is CartLiveLoaded) return current.cart;
				if (current is CartLiveUpdated) return current.cart;
				if (current is CartLiveActionInProgress) return current.previous;
				return null;
			}

			// Debounce logic for quantity updates
			final Map<String, Timer> _qtyTimers = {};
			void _debounceUpdate(String cartItemId, int quantity, Emitter<CartLiveState> emit) {
				_qtyTimers[cartItemId]?.cancel();
				_qtyTimers[cartItemId] = Timer(const Duration(milliseconds: 400), () async {
					try {
						await updateQtyUsecase(cartItemId: cartItemId, newQuantity: quantity);
					} catch (e) {
						emit(CartLiveError('Không thể cập nhật số lượng: $e'));
					}
				});
			}

		@override
		Future<void> close() {
			return super.close();
		}
}
