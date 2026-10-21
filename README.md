# Android Cloud Phone

Mục tiêu: Android Emulator điều khiển qua trình duyệt, dữ liệu AVD lưu trên ổ đĩa máy chủ và được giữ lại khi container khởi động lại.

## Quan trọng trước khi chạy

- GitHub chỉ lưu mã nguồn; GitHub Actions không phải máy chủ Android 24/7.
- Cần một máy chủ Linux có Docker, KVM/ảo hóa phần cứng và RAM/đĩa phù hợp. Với yêu cầu không có thẻ thanh toán, hiện chưa có máy chủ miễn phí nào được bảo đảm đáp ứng 24/7.
- Cấu hình này **không tự tạo máy chủ miễn phí**. Chỉ chạy khi đã có một máy Linux phù hợp.
- Không công khai cổng ADB (5554/5555) ra Internet. Giao diện web cũng cần được bảo vệ bằng VPN/tunnel hoặc proxy có xác thực.

## Các tệp

- `docker-compose.yml`: chạy Android Emulator trong container.
- `data/`: thư mục dữ liệu AVD được lưu trên máy chủ, không đưa vào Git.
- `scripts/start.sh`: tạo thư mục dữ liệu và khởi chạy.
- `scripts/stop.sh`: dừng container mà không xóa dữ liệu.

## Triển khai trên máy chủ Linux

1. Cài Docker Engine và Docker Compose plugin theo tài liệu chính thức của Docker.
2. Kiểm tra ảo hóa: `test -e /dev/kvm && echo "KVM available" || echo "KVM missing"`.
3. Clone repository:
   ```bash
   git clone https://github.com/Truc5738/android-cloud-phone.git
   cd android-cloud-phone
   ```
4. Khởi động:
   ```bash
   chmod +x scripts/*.sh
   ./scripts/start.sh
   ```
5. Mặc định giao diện chỉ bind vào localhost ở cổng 6080 để tránh phơi bày giao diện điều khiển. Tạo SSH tunnel từ thiết bị có hỗ trợ port forwarding:
   ```bash
   ssh -L 6080:127.0.0.1:6080 USER@SERVER_IP
   ```
   Sau đó mở `http://127.0.0.1:6080` trên thiết bị có tunnel.
6. Kiểm tra dữ liệu: cài ứng dụng thử, dừng bằng `./scripts/stop.sh`, rồi chạy lại `./scripts/start.sh`. Không xóa thư mục `data/`.

## Tự khởi động khi máy chủ reboot

Docker Compose đặt `restart: unless-stopped`. Sau khi Docker daemon khởi động, container sẽ tự chạy lại, miễn là Docker được bật lúc boot và thư mục repository/dữ liệu vẫn còn trên ổ đĩa.

## Xử lý lỗi

- Nếu báo không tìm thấy `/dev/kvm`, máy chủ không có KVM/ảo hóa phù hợp; đổi máy chủ. Không thể sửa bằng GitHub Actions.
- Nếu emulator không khởi động, xem log: `docker compose logs -f android`.
- Nếu image/tag không còn được hỗ trợ, kiểm tra tài liệu image upstream trước khi đổi tag.
- Sao lưu dữ liệu bằng cách dừng container trước, sau đó sao chép thư mục `data/` sang nơi an toàn.

## Giới hạn

Đây là bộ khung triển khai, không phải dịch vụ đã được khởi chạy. Không có địa chỉ Android trực tuyến cho đến khi có một máy chủ Linux tương thích.
