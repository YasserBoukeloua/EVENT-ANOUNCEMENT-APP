import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/cubits/navigation/navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  // Change selected page
  void changePage(int index) {
    if (index >= 0 && index <= 3) {
      emit(state.copyWith(selectedIndex: index));
    }
  }

  // Reset to home
  void resetToHome() {
    emit(const NavigationState(selectedIndex: 0));
  }
}
