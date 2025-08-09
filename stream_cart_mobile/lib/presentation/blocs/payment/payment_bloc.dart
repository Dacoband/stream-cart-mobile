import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/payment/payment_entity.dart';
import '../../../domain/usecases/payment/generate_payment_qr_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
	final GeneratePaymentQrUseCase _generatePaymentQrUseCase;

	PaymentQrEntity? _lastQr; // Cache the last generated QR

	PaymentBloc({required GeneratePaymentQrUseCase generatePaymentQrUseCase})
			: _generatePaymentQrUseCase = generatePaymentQrUseCase,
				super(const PaymentInitial()) {
		on<GeneratePaymentQrEvent>(_onGeneratePaymentQr);
		on<ResetPaymentStateEvent>(_onResetPaymentState);
	}

	Future<void> _onGeneratePaymentQr(
		GeneratePaymentQrEvent event,
		Emitter<PaymentState> emit,
	) async {
		emit(PaymentGenerating(request: event.request));
		final result = await _generatePaymentQrUseCase(
			GeneratePaymentQrParams(request: event.request),
		);

		result.fold(
			(failure) => emit(PaymentError(message: failure.message)),
			(qr) {
				_lastQr = qr;
				emit(PaymentQrLoaded(qr: qr));
				emit(const PaymentOperationSuccess(message: 'Tạo QR thanh toán thành công'));
			},
		);
	}

	void _onResetPaymentState(
		ResetPaymentStateEvent event,
		Emitter<PaymentState> emit,
	) {
		_lastQr = null;
		emit(const PaymentInitial());
	}

	PaymentQrEntity? get lastQr => _lastQr;
}

