[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 6. Đa luồng & Bất đồng bộ (Concurrency: GCD, Operation, Swift Concurrency)](./06-Concurrency-GCD-Operation-AsyncAwait.md) | [Bài tiếp: 8. Networking, Bảo mật, Reactive (RxSwift), Debug, Unit Test & Công cụ ›](./08-Networking-RxSwift-Debug-UnitTest.md)

---

# 7. Kiến trúc phần mềm (Architecture) & Design Patterns

## 7.1. Design Patterns (Mẫu thiết kế)
Design Patterns là các giải pháp mẫu chuẩn mực cho các bài toán thiết kế phần mềm phổ biến, chia làm 3 nhóm:
1. **Creational Patterns (Nhóm Khởi tạo):** Cách tạo object linh hoạt, tái sử dụng cao (ví dụ: **Singleton**, Factory Method, Builder).
2. **Structural Patterns (Nhóm Cấu trúc):** Cách kết hợp các class/object thành cấu trúc lớn hơn (ví dụ: Adapter, Decorator, Facade, Composite).
3. **Behavioral Patterns (Nhóm Hành vi):** Cách các object giao tiếp và phân chia trách nhiệm (ví dụ: **Delegation**, **Observer**, Strategy, Command).

- **Singleton Pattern:**
  - **Khái niệm:** Đảm bảo một class chỉ có **duy nhất một instance** trong suốt vòng đời ứng dụng và cung cấp điểm truy cập toàn cục tới instance đó.
  - **Cách cài đặt chuẩn & Thread-safe trong Swift:**
    ```swift
    final class NetworkManager {
        static let shared = NetworkManager() // Swift đảm bảo khởi tạo static let là lazy và thread-safe (dispatch_once)
        private init() {} // Ngăn không cho tạo thêm instance từ bên ngoài
    }
    ```
  - **Ưu điểm:** Truy cập nhanh, tiện lợi mọi lúc mọi nơi; tiết kiệm khởi tạo lặp lại cho các tài nguyên dùng chung (`URLSession.shared`, `UserDefaults.standard`, `NotificationCenter.default`).
  - **Nhược điểm:** Tạo trạng thái toàn cục (global state) gây phụ thuộc ẩn, **rất khó viết Unit Test** (khó mock), giữ bộ nhớ suốt vòng đời app, và **nguy hiểm về Race Condition** nếu nhiều thread cùng ghi dữ liệu vào Singleton mà không đồng bộ.

## 7.2. Các Architecture Patterns phổ biến trong iOS

### 1. MVC (Model - View - Controller)
- **Thành phần:**
  - **Model:** Định nghĩa dữ liệu, logic nghiệp vụ, networking, database, parsing.
  - **View:** Giao diện hiển thị và nhận tương tác trực tiếp từ người dùng (gửi sự kiện lên Controller qua `IBAction` / `Delegate`).
  - **Controller (`UIViewController`):** Trung gian nhận dữ liệu từ Model và điều phối hiển thị lên View; xử lý sự kiện từ View để tác động lại Model.
- **Tính chất:** Controller giữ tham chiếu `strong` tới Model và View; Model và View **không được giữ tham chiếu `strong` ngược lại Controller** (tránh retain cycle — Model giao tiếp bằng Notification/KVO/Closure, View giao tiếp bằng Delegate/Target-Action).
- **Ưu điểm:** Đơn giản, có sẵn theo kiến trúc mặc định của UIKit, phát triển nhanh cho màn hình nhỏ.
- **Nhược điểm:** **Massive View Controller** — vì `UIViewController` vừa gắn chặt với vòng đời `UIView` vừa xử lý quá nhiều logic nên file phình to nhanh chóng và **rất khó viết Unit Test**.

### 2. MVP (Model - View - Presenter)
- **Thành phần:**
  - **Model:** Giống MVC.
  - **View (gồm cả `UIView` và `UIViewController`):** Chỉ lo hiển thị UI và bắt sự kiện người dùng rồi chuyển cho Presenter.
  - **Presenter:** Chứa toàn bộ logic trình bày (presentation logic), nhận input từ View, xử lý với Model và đẩy kết quả ngược lại View thông qua **Protocol / Delegate**. Presenter **không import UIKit**.
- **Ưu điểm:** Tách biệt logic khỏi UIKit -> **dễ viết Unit Test** cho Presenter hơn MVC rất nhiều.
- **Nhược điểm:** Phải viết khá nhiều boilerplate code (Protocol/Delegate) cho mỗi màn hình; Presenter vẫn có nguy cơ phình to nếu không tách Service/UseCase.

### 3. MVVM (Model - View - ViewModel)
- **Thành phần:**
  - **Model:** Giống MVC/MVP.
  - **View (`UIView` / `UIViewController`):** Hiển thị UI, lắng nghe thay đổi từ ViewModel để tự động cập nhật giao diện.
  - **ViewModel:** Cầu nối giữa Model và View; chịu trách nhiệm convert/format dữ liệu sẵn sàng cho View hiển thị và chứa logic tương tác. **ViewModel không biết gì về View và không import UIKit.**
- **Cơ chế giao tiếp (Data Binding):** ViewModel không giữ tham chiếu tới View mà phát sự kiện thay đổi thông qua **Observer / Data Binding** (dùng Closure/Boxing generic, KVO, RxSwift, hoặc **Combine** `@Published` / SwiftUI).
- **Ưu điểm:**
  - Một ViewModel không phụ thuộc View nên dễ **tái sử dụng** và **Unit Test** độc lập.
  - Giảm bớt các protocol/delegate rườm rà so với MVP; 1 View có thể kết nối với nhiều ViewModel.
- **Nhược điểm:** Khi dùng reactive binding phức tạp (RxSwift/Combine), luồng chạy bất đồng bộ có thể **khó debug** hơn so với lời gọi hàm trực tiếp của MVP; dễ bị retain cycle nếu quên `[weak self]` / `DisposeBag`.

### 4. VIPER & Clean Swift (VIP)
- **5 thành phần của VIPER:**
  - **V (View):** Hiển thị UI, nhận thao tác người dùng và chuyển cho Presenter.
  - **I (Interactor):** *"Bộ não"* xử lý logic nghiệp vụ (business logic), gọi API/DB qua Worker/Service và thao tác với Entity.
  - **P (Presenter):** Nhận kết quả thô từ Interactor, format dữ liệu thành dạng hiển thị (ViewModel) rồi đẩy ra View; hoặc yêu cầu Router điều hướng.
  - **E (Entity):** Các cấu trúc dữ liệu (Model thuần túy) được Interactor sử dụng.
  - **R (Router / Wireframe):** Chịu trách nhiệm **điều hướng (navigation)** chuyển màn hình và khởi tạo module.
- **Điểm khác nhau giữa VIPER và Clean Swift (VIP):**
  - Trong **VIPER**, **Presenter là trung tâm điều phối** (View <-> Presenter <-> Interactor, Presenter -> Router).
  - Trong **Clean Swift (VIP)**, luồng dữ liệu đi theo **chu trình khép kín một chiều (Unidirectional Cycle)**: **ViewController -> Interactor -> Presenter -> ViewController**, và **ViewController gọi thẳng tới Router** để chuyển màn hình. Tất cả các tầng đều liên kết qua Protocol để đảm bảo nguyên lý SOLID (đặc biệt là SRP và DIP).

- **Bảng so sánh nhanh các Kiến trúc:**

| Tiêu chí | MVC | MVP | MVVM | VIPER / Clean Swift |
| :--- | :---: | :---: | :---: | :---: |
| **Độ phức tạp & Boilerplate** | Thấp | Trung bình | Trung bình | Rất cao (nhiều file/protocol) |
| **Khả năng Unit Test** | Kém | Tốt | Rất tốt | Xuất sắc |
| **Cách View nhận cập nhật** | Trực tiếp từ Controller | Qua Protocol / Delegate | Data Binding (Rx/Combine/Closure) | Protocol / Delegate |
| **Tách biệt Navigation** | Trong ViewController | Thường trong VC/Presenter | Thường dùng Coordinator | Có hẳn tầng **Router** |
| **Phù hợp với dự án** | Nhỏ, prototype nhanh | Trung bình | Trung bình -> Lớn (chuẩn phổ biến nhất) | Dự án rất lớn, nhiều team làm song song |


---

[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 6. Đa luồng & Bất đồng bộ (Concurrency: GCD, Operation, Swift Concurrency)](./06-Concurrency-GCD-Operation-AsyncAwait.md) | [Bài tiếp: 8. Networking, Bảo mật, Reactive (RxSwift), Debug, Unit Test & Công cụ ›](./08-Networking-RxSwift-Debug-UnitTest.md)
