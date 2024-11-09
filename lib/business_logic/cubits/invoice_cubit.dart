import 'package:flutter_bloc/flutter_bloc.dart';

part 'invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit() : super(InvoiceState(false));

  setImage() => emit(InvoiceState(true));

  removeImage() => emit(InvoiceState(false));
}
