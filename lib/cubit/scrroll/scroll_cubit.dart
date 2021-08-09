

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_directs/utils/enums.dart';

part 'scroll_state.dart';

class ScrollCubit extends Cubit<ScrollState>{
  ScrollCubit() :
        super(ScrollState(scroll: ScrollType.ScrollUp));

  void emitScrollDown(){
    emit(ScrollState(scroll: ScrollType.ScrollDown));
  }
  void emitScrollUp(){
    emit(ScrollState(scroll:  ScrollType.ScrollUp));
  }

}