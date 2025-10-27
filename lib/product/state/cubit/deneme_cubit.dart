import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'deneme_state.dart';

class DenemeCubit extends Cubit<DenemeState> {
  DenemeCubit() : super(DenemeInitial());
}
