class PlayerBombSettings {
  PlayerBombSettings({
    this.grams = initialGrams,
    this.numbCount = 0,
    this.spicyCount = 0,
  });

  static const int initialGrams = 10;
  static const int maxGrams = 180;
  static const int baseFrequency = 50;
  static const int maxFrequency = 100;
  static const int seasoningFrequency = 5;
  static const int maxSeasoningCount =
      (maxFrequency - baseFrequency) ~/ seasoningFrequency;

  int grams;
  int numbCount;
  int spicyCount;

  int get seasoningCount => numbCount + spicyCount;
  int get remainingGrams => maxGrams - grams;
  bool get canAddSeasoning => seasoningCount < maxSeasoningCount;

  // 每次加麻或加辣小幅提高频率，允许多轮累计到设备上限。
  int get frequency {
    return (baseFrequency + seasoningCount * seasoningFrequency).clamp(
      baseFrequency,
      maxFrequency,
    );
  }

  bool addGrams(int amount) {
    if (amount < 1 || amount > remainingGrams) return false;
    grams += amount;
    return true;
  }

  bool addNumb() {
    if (!canAddSeasoning) return false;
    numbCount++;
    return true;
  }

  bool addSpicy() {
    if (!canAddSeasoning) return false;
    spicyCount++;
    return true;
  }

  void reset() {
    grams = initialGrams;
    numbCount = 0;
    spicyCount = 0;
  }
}
