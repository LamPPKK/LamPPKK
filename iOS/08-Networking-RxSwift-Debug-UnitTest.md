[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 7. Kiến trúc phần mềm (Architecture) & Design Patterns](./07-Architecture-va-Design-Patterns.md) | [Bài tiếp: 9. Bài Tập Thực Hành & Live Coding Phỏng Vấn iOS ›](./09-Bai-Tap-Thuc-Hanh-va-Thuat-Toan.md)

---

# 8. Networking, Bảo mật, Reactive (RxSwift), Debug, Unit Test & Công cụ

## 8.1. Networking, Parse JSON (`Codable`) & Quản lý Token
- **Tương tác API & Parse JSON trong Swift:**
  - Dùng `URLSession.shared.dataTask(with:)` (hoặc `async/await` với `URLSession.shared.data(for:)`) để gửi HTTP Request (`GET`, `POST`, `PUT`, `DELETE`) và nhận `Data`, `URLResponse`, `Error`.
  - **Encoding & Decoding (`Codable`):** `Codable` là typealias kết hợp giữa `Encodable` (chuyển Model Swift -> JSON/Data để gửi lên server) và `Decodable` (chuyển JSON/Data từ server -> Model Swift). Sử dụng `JSONDecoder` / `JSONEncoder` (tùy chỉnh tên key bằng `CodingKeys`).
- **Xử lý và Lưu trữ Token an toàn:**
  - **Trên ứng dụng iOS:**
    - **Lưu trữ:** Lưu Access Token và Refresh Token vào **iOS Keychain** (được mã hóa phần cứng bởi hệ điều hành — tuyệt đối **không lưu Token vào `UserDefaults`** vì `UserDefaults` là file `.plist` không mã hóa, dễ bị đọc trộm).
    - **Gửi lên Server:** Đính kèm Token vào HTTP Header dưới dạng `Authorization: Bearer <access_token>` qua HTTPS (TLS) kết hợp SSL Pinning nếu cần bảo mật cao.
    - **Refresh Token Flow:** Khi API trả về mã lỗi `401 Unauthorized` (Access Token hết hạn), interceptor/network layer khóa các request đến sau (dùng `NSLock`/Actor), gọi API cấp lại Access Token mới bằng Refresh Token, lưu vào Keychain rồi retry lại các request bị 401; nếu Refresh Token cũng hết hạn thì đăng xuất người dùng.
  - **Trên ứng dụng Web (nếu được hỏi mở rộng):** Tránh lưu vào `localStorage` / `sessionStorage` vì dễ bị tấn công **XSS**; ưu tiên lưu trong **Secure `HttpOnly` Cookie** (JavaScript không đọc được) hoặc gửi qua `Authorization` header kết hợp cơ chế chống CSRF.

## 8.2. Reactive Programming với RxSwift
- **`Observable` là gì?** Là một chuỗi sự kiện bất đồng bộ (*Event Sequence*) có thể phát ra các giá trị theo thời gian; có tính **bất biến (immutable)** (mỗi operator tạo ra một `Observable` mới chứ không sửa `Observable` cũ).
- **Khi nào `Observable` bắt đầu và kết thúc?**
  - **Bắt đầu (Cold Observable):** Chỉ thực sự bắt đầu chạy và phát sự kiện **khi có ít nhất một `Observer` gọi `.subscribe(...)`** tới nó.
  - **Kết thúc:** Khi nó phát ra sự kiện `.completed` hoặc `.error`, hoặc khi `Disposable` bị hủy (thêm vào `DisposeBag` và `DisposeBag` bị giải phóng).
- **3 loại sự kiện (Events) của `Observable`:**
  1. **`next(Element)`:** Phát ra một giá trị dữ liệu mới cho Observer.
  2. **`error(Error)`:** Phát ra lỗi và **kết thúc ngay lập tức** chuỗi `Observable` (không phát thêm bất kỳ sự kiện nào nữa).
  3. **`completed`:** Báo hiệu chuỗi đã hoàn thành bình thường và **kết thúc** (không phát thêm sự kiện nào nữa).
- **Các nhóm Operators phổ biến trong RxSwift:**
  - **Transformation:** `map` (biến đổi giá trị), `flatMap` / `flatMapLatest` (biến đổi phần tử thành một `Observable` khác rồi gộp lại — ví dụ gọi API nối tiếp hoặc search bar hủy request cũ bằng `flatMapLatest`).
  - **Filtering:** `filter` (lọc theo điều kiện), `take(n)` (chỉ lấy `n` phần tử đầu), `debounce` / `throttle` (chống bấm/nhập liên tục).
  - **Combining:** `merge` (gộp các stream cùng kiểu theo thời gian), `zip` (ghép đôi từng cặp phần tử tương ứng giữa các stream), `combineLatest` (phát mỗi khi một trong các stream có giá trị mới nhất).
  - **Error Handling:** `catch` / `catchError` (bắt lỗi trả về giá trị thay thế), `retry` (thử lại khi lỗi), `timeout` (báo lỗi nếu quá thời gian chờ).

## 8.3. Push Notifications, Maps & Git
- **Phân biệt Local Notification vs Remote Push Notification:**
  - **Local Notification:** Do chính ứng dụng **tự lên lịch và kích hoạt cục bộ** trên thiết bị thông qua `UNUserNotificationCenter` (ví dụ: báo thức, nhắc lịch uống nước, đếm ngược) — hoạt động không cần internet hay server.
  - **Remote Push Notification:** Được gửi từ **Backend Server -> APNs (Apple Push Notification service) -> Thiết bị người dùng** dựa trên `deviceToken` (ví dụ: tin nhắn mới, trạng thái đơn hàng, khuyến mãi) — cần kết nối mạng và cấu hình chứng chỉ/key APNs.
- **Các loại Map dùng trong iOS:**
  - **`MapKit` (Apple):** Miễn phí, tích hợp sâu vào hệ sinh thái iOS/Swift, tối ưu pin và hiệu năng.
  - **`Google Maps SDK` (`GMSMapView`):** Dữ liệu địa điểm (POI) và bản đồ chi tiết tại Việt Nam/toàn cầu rất mạnh, tính phí theo quota API.
  - **`Mapbox`:** Cho phép tùy biến sâu giao diện bản đồ (custom style), dẫn đường turn-by-turn.
- **Git (`git merge` vs `git rebase`):**
  - **`git merge`:** Giữ nguyên toàn bộ lịch sử commit của cả 2 nhánh và tạo thêm một **merge commit** mới để hợp nhất. An toàn khi làm việc trên nhánh chung (shared branch) nhưng cây lịch sử có nhiều nhánh rẽ.
  - **`git rebase`:** Di chuyển/viết lại toàn bộ commit của nhánh hiện tại nối tiếp lên đỉnh mới nhất của nhánh đích, tạo ra **lịch sử thẳng hàng (linear history)** sạch đẹp. *Lưu ý: Tuyệt đối không `rebase` trên các nhánh public/chung (như `main`/`develop`) đã có người khác kéo về vì nó làm thay đổi hash commit.*

## 8.4. Debugging & Unit Testing trên Xcode

- **Các kỹ thuật Debug trong iOS:**
  - **Debug Log:** `print()`, `OSLog` / `Logger`.
  - **Breakpoints:** Regular Breakpoint (dừng tại dòng code), **Conditional Breakpoint** (chỉ dừng khi thỏa điều kiện), **Exception Breakpoint** (tự động dừng ngay tại dòng gây crash thay vì dừng ở `AppDelegate`), Symbolic Breakpoint, Action Breakpoint (in log mà không dừng app).
  - **Lệnh LLDB thông dụng trong Console:**
    - `po <object>`: Print Object (gọi `debugDescription` in thông tin chi tiết đối tượng).
    - `p <variable>`: Print giá trị/kiểu dữ liệu thô (dùng tốt cho struct/primitive).
    - `expr <variable> = <value>`: Thay đổi giá trị biến ngay lúc đang chạy debug.
    - `bt [number]`: In Backtrace (stacktrace các lời gọi hàm).
    - `thread return`: Thoát sớm khỏi hàm hiện tại trong lúc debug.
  - **Debug UI:** **Debug View Hierarchy** (xem phân tầng 3D các view để phát hiện view bị che, sai kích thước, thiếu constraint).
  - **Debug Memory:** **Debug Memory Graph** & Instruments (**Leaks**, **Allocations**) để phát hiện Retain Cycle và Memory Leak.
  - **Debug Network & Database:** **Charles Proxy** / **Proxyman** / **Wireshark** (bắt gói tin HTTP/HTTPS); CoreData Editor / DB Browser for SQLite.

- **Unit Testing (`XCTest` / `Swift Testing`):**
  - **3 loại Test chính:**
    1. **Functional / Unit Test:** Kiểm tra tính đúng đắn của một đơn vị code nhỏ nhất (hàm, logic ViewModel, Model).
    2. **Performance Test (`measure { ... }`):** Đo thời gian thực thi tác vụ để phát hiện suy giảm hiệu năng.
    3. **UI Test (`XCUITest`):** Giả lập thao tác người dùng thực tế (tap, scroll, nhập text) để kiểm tra luồng giao diện.
  - **Vòng đời một Test Case:** `setUp()` (chuẩn bị dữ liệu/trạng thái trước mỗi test) -> `test...()` (chạy hàm kiểm thử với các `XCTAssert...`) -> `tearDown()` (dọn dẹp tài nguyên sau mỗi test).
  - **Tiêu chí một Unit Test tốt (FIRST):** Nhanh (Fast), Độc lập (Independent), Lặp lại được (Repeatable), Tự kiểm chứng kết quả (Self-Validating - có thể pass hoặc fail rõ ràng), Viết kịp thời (Timely) và giữ code test sạch sẽ.
  - **3 cách chạy Test trong Xcode:**
    1. Menu **Product -> Test** (phím tắt `Cmd + U`) để chạy toàn bộ test suite.
    2. Nhấn nút Play ở **Test Navigator** (`Cmd + 6`).
    3. Nhấn trực tiếp vào biểu tượng hình thoi (diamond) bên cạnh tên class test hoặc từng hàm `test...()`.


---

[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 7. Kiến trúc phần mềm (Architecture) & Design Patterns](./07-Architecture-va-Design-Patterns.md) | [Bài tiếp: 9. Bài Tập Thực Hành & Live Coding Phỏng Vấn iOS ›](./09-Bai-Tap-Thuc-Hanh-va-Thuat-Toan.md)
