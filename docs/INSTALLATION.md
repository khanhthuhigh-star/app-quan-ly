# Cài đặt và chạy ứng dụng

## 1. Điều kiện cần

- Flutter SDK bản ổn định (Dart 3.3 trở lên).
- Android Studio, gồm **Android SDK**, Android SDK Command-line Tools và Android Emulator.
- Một thiết bị Android thật hoặc Android Emulator.
- Trên Windows, nên cài Flutter vào đường dẫn không có khoảng trắng/quyền hạn đặc biệt, ví dụ `C:\src\flutter`.

Kiểm tra môi trường sau khi cài:

```bash
flutter doctor
```

Xử lý mọi mục có dấu `X` liên quan tới Flutter/Android. Nếu Android licenses chưa được chấp nhận, chạy:

```bash
flutter doctor --android-licenses
```

## 2. Chuẩn bị dự án

Mở terminal tại thư mục gốc dự án (nơi có `pubspec.yaml`), sau đó chạy:

```bash
flutter pub get
```

Repository đã bao gồm thư mục nền tảng `android/`, nên không cần chạy
`flutter create` sau khi clone dự án.

## 3. Chạy trên Android Emulator

1. Mở Android Studio → **More Actions** → **Virtual Device Manager**.
2. Chọn **Create Device**, chọn một mẫu điện thoại (ví dụ Pixel), tải/chọn system image và hoàn tất.
3. Bấm nút Play để khởi động emulator.
4. Quay lại terminal dự án, kiểm tra thiết bị:

   ```bash
   flutter devices
   ```

5. Chạy ứng dụng:

   ```bash
   flutter run
   ```

Nếu có nhiều thiết bị, chỉ định ID hiển thị bởi `flutter devices`:

```bash
flutter run -d <device-id>
```

## 4. Chạy trên điện thoại Android thật

1. Trên điện thoại, bật **Developer options** và **USB debugging**.
2. Kết nối điện thoại qua USB, rồi chấp nhận hộp thoại cho phép debug trên điện thoại.
3. Kiểm tra kết nối:

   ```bash
   flutter devices
   ```

4. Cài/chạy bản debug:

   ```bash
   flutter run
   ```

Lần đầu chọn **Chụp ảnh** hoặc **Chọn từ thư viện**, Android sẽ hiển thị hộp thoại xin quyền. Hãy cho phép quyền cần thiết để dùng chức năng ảnh.

## 5. Tạo APK để cài thủ công

Tạo bản release:

```bash
flutter build apk --release
```

Tệp APK được tạo ở `build/app/outputs/flutter-apk/app-release.apk`. Chép tệp này vào điện thoại và mở nó để cài. Android có thể yêu cầu cho phép cài ứng dụng từ nguồn tương ứng.

> Bản release để phân phối chính thức cần được ký bằng keystore riêng. Xem tài liệu Flutter về Android deployment trước khi phát hành lên Google Play.

## 6. Lệnh kiểm tra trước khi chia sẻ mã

```bash
flutter analyze
flutter test
```

## Khắc phục nhanh

| Hiện tượng | Cách xử lý |
| --- | --- |
| Không thấy thiết bị | Khởi động emulator hoặc kiểm tra USB debugging/cáp, sau đó chạy lại `flutter devices`. |
| Thiếu Android SDK | Cài SDK từ Android Studio → Settings → Android SDK, rồi chạy `flutter doctor`. |
| Lỗi package | Chạy `flutter clean`, sau đó `flutter pub get`. |
| Không mở được camera/thư viện | Kiểm tra quyền ứng dụng trong Settings của Android và thử lại. |
