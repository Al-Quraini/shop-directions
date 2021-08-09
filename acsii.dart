
import 'dart:convert';

void main(){
  List<Map<String , String>> alot = [{
    'userId' : 'Hello'
  },
  {
    'userId' : 'hellll'
  }];
 print(alot.where((element)
  => element['userId'] != 'Hello').first['userId']);
}