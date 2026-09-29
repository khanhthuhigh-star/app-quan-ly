# Sổ thu chi

Ứng dụng Flutter quản lý thu chi cá nhân bằng tiếng Việt. Dữ liệu và ảnh được lưu **cục bộ trên chính thiết bị**, phù hợp cho một người dùng và không cần tài khoản.

> Hướng dẫn cài đặt, chạy trên Android và Android Emulator nằm ở [docs/INSTALLATION.md](docs/INSTALLATION.md).

## Chức năng

- Thêm, sửa và xóa khoản thu hoặc chi.
- Chọn ngày/giờ, danh mục, số tiền, ghi chú và ảnh hóa đơn cho mỗi giao dịch.
- Quản lý danh mục thu/chi; không cho xóa danh mục đang được giao dịch sử dụng.
- Xem tổng thu, tổng chi, số dư và các giao dịch gần đây theo ngày, tuần hoặc tháng.
- Xem báo cáo chi theo danh mục với tỷ trọng trực quan.
- Chụp ảnh bằng camera hoặc chọn ảnh từ thư viện; ảnh được sao chép vào vùng lưu trữ riêng của ứng dụng.
- Lưu dữ liệu với SQLite, hoạt động ngoại tuyến.

## Phạm vi hiện tại

Đây là ứng dụng local-first: chưa có đăng nhập, đồng bộ đám mây, xuất/nhập dữ liệu hoặc sao lưu. Gỡ ứng dụng hay xóa dữ liệu ứng dụng có thể làm mất dữ liệu đã lưu.

## Cấu trúc mã nguồn

```text
lib/
├── app/          # Cấu hình MaterialApp và theme
├── core/         # Tiện ích tiền tệ và khoảng thời gian
├── data/         # SQLite và quản lý tệp ảnh
├── models/       # Đối tượng dữ liệu
├── screens/      # Các màn hình/chức năng chính
└── widgets/      # Thành phần giao diện dùng lại
```

`lib/main.dart` là entry point duy nhất; nó chỉ khởi tạo Flutter, database và ứng dụng. Mỗi lớp được đặt trong file riêng để dễ kiểm thử, bảo trì và mở rộng. Repository cũng bao gồm sẵn thư mục `android/`, vì vậy có thể chạy trên Android ngay sau khi cài dependencies.

## Công nghệ

- Flutter / Material 3
- SQLite (`sqflite`)
- `image_picker`, `path_provider`, `intl`

## Kiểm tra mã

Sau khi cài dependency, chạy:

```bash
flutter analyze
flutter test
```
