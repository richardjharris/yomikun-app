enum KakiYomi { kaki, yomi }

extension KakiYomiMethods on KakiYomi {
  KakiYomi inverse() {
    return this == KakiYomi.kaki ? KakiYomi.yomi : KakiYomi.kaki;
  }
}
