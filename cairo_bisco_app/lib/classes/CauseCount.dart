import 'dart:collection';

class CauseCount {
  final String causeName;
  num count;

  CauseCount(this.causeName, this.count);

  void incrementCount(num count) {
    this.count += count;
  }

  void decrementCount(num count) {
    this.count -= count;
  }

  static List<CauseCount> mergeCauseCounts(
    List<List<CauseCount>> countsList,
  ) {
    HashMap<String, CauseCount> tempMap = HashMap<String, CauseCount>();
    for (List<CauseCount> areaList in countsList) {
      for (CauseCount count in areaList) {
        if (tempMap[count.causeName] == null) {
          tempMap[count.causeName] = count;
        } else {
          tempMap[count.causeName]!.incrementCount(count.count);
        }
      }
    }
    return tempMap.values.toList();
  }
}
