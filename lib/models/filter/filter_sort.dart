import 'package:meta/meta.dart';

class FilterSortContent{
   String filterSort;
   String filterKey;
   bool descending;
   bool isSelected;


   FilterSortContent({this.filterSort, this.filterKey,
     this.descending, this.isSelected=false});

}

