extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}



// self note ============   EXTRA   ========
// self note ============   EXTRA   ========
// self note ============   EXTRA   ======== // "map" method and "where" method in dart
extension Filter2<T> on List<T> {
  // List<T> filter2(bool Function(T) where) => map((items) => items.where(where).toList());   // ERROR ------
}

bool myWhere(int foo) { 
  if (foo % 2 == 0) {
  return true;}
  else {
    return false;
  }
} 

var myList = [ [ 51, 6, 3, 21], [ 2, 60, 10, 20], [ 2, 1, 21]];
// var aa = myList.filter2((myWhere) => true);
// self note ============   EXTRA   ======//>>==

extension Filter3<T> on List<List<T>> {
//  List<List<T>> filter3() => map((items) => items.where((bar!) => (bar > 7)).toList()); // ERROR ------
}

// extension Filter3<T> on List<T> {
//   // List<T> filter2(bool Function(T) where) =>
//   //     map((items) => items.where(where).toList());
// }
