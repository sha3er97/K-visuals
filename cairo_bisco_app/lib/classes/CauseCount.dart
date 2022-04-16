class CauseCount {
  final String causeName;
  int count;

  CauseCount(this.causeName, this.count);

  void incrementCount(int count) {
    this.count += count;
  }
}
