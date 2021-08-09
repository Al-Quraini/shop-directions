
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shop_directs/models/filter/filter_sort.dart';


part 'counter_state.dart';
class CounterCubit extends Cubit<CounterState>{
  CounterCubit(): super(
    CounterState( selectedCategories: [],
        filterSortContent: FilterSortContent(
            filterSort: '', filterKey: '', descending: false
        ),
    ),
  );




  void updateFilter(FilterSortContent filterSortContent,
      List<String> selectedCategories, double minValue, double maxValue) =>
      emit(CounterState(filterSortContent: filterSortContent,
          selectedCategories: selectedCategories,
      )
      );



}
