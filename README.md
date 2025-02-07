# BEBEK360

Bebek360, çoklu platform desteği ile geliştirilmiş bir Flutter uygulamasıdır.

## Özellikler

- iOS, Android, Web ve macOS platform desteği
- Firebase entegrasyonu
  - Gerçek zamanlı veritabanı
  - Push bildirimleri
  - Hata takibi ve raporlama
- Modern ve kullanıcı dostu arayüz

## Gereksinimler

- Flutter SDK (son sürüm)
- Firebase CLI
- Xcode (iOS ve macOS için)
- Android Studio (Android için)
- VS Code veya IntelliJ IDEA (önerilen)

## Kurulum

1. Flutter SDK'yı yükleyin
2. Firebase CLI'ı yükleyin
3. Projeyi klonlayın
4. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```
5. Firebase yapılandırmasını tamamlayın:
   ```bash
   flutterfire configure
   ```
6. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

## Geliştirme

Proje yapısı:
- `lib/` - Dart kaynak kodları
- `lib/screens/` - Uygulama ekranları
- `lib/widgets/` - Yeniden kullanılabilir widget'lar
- `lib/services/` - Firebase ve diğer servisler
- `lib/models/` - Veri modelleri
- `lib/utils/` - Yardımcı fonksiyonlar
