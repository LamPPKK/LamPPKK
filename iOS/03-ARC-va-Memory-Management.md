[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 2. Kiến thức cốt lõi về ngôn ngữ Swift (Swift Core)](./02-Swift-Core.md) | [Bài tiếp: 4. Kiến thức iOS SDK & UIKit cơ bản & nâng cao ›](./04-iOS-SDK-va-UIKit.md)

---

# 3. Quản lý bộ nhớ (ARC & Memory Management)

## 3.1. ARC là gì? So sánh ARC và Non-ARC (MRC)
- **ARC (Automatic Reference Counting):** Cơ chế quản lý bộ nhớ tự động của Swift và Objective-C dành cho **Reference Type (`class`, `closure`)**. Trình biên dịch tự động chèn các lệnh tăng/giảm số đếm tham chiếu (*reference count*) tại compile-time. Khi `reference count == 0`, hệ thống sẽ gọi `deinit` và giải phóng vùng nhớ của instance khỏi Heap.
- **Non-ARC / MRC (Manual Reference Counting):** Lập trình viên Objective-C trước đây phải tự tay gọi `retain`, `release`, `autorelease` để quản lý bộ nhớ, rất dễ gây leak hoặc crash nếu quên/gọi thừa.
- **Khi nào ARC tăng / giảm Reference Count?**
  - **Tăng (+1):** Khi khởi tạo instance bằng `init` và gán vào biến/hằng `strong`, hoặc khi gán tham chiếu đó vào một biến/property/collection mới có thuộc tính `strong`.
  - **Giảm (-1):** Khi biến `strong` bị gán về `nil`, biến cục bộ ra khỏi scope, đối tượng chứa nó bị giải phóng, hoặc phần tử bị xóa khỏi mảng/collection.

## 3.2. Strong, Weak & Unowned

| Đặc điểm | `strong` (Mặc định) | `weak` | `unowned` |
| :--- | :--- | :--- | :--- |
| **Tác động lên Reference Count** | **Tăng (+1)** reference count. | **Không tăng** reference count. | **Không tăng** reference count. |
| **Kiểu khai báo** | Optional hoặc Non-optional. | **Bắt buộc là Optional (`var`)**, vì ARC tự động gán về `nil` khi object bị hủy. | **Thường là Non-optional** (hoặc Optional từ Swift 5), **không tự động về `nil`**. |
| **Nếu object đích đã bị giải phóng** | Object đích không thể bị giải phóng khi còn strong reference. | Tham chiếu tự trở thành **`nil`** -> An toàn, không crash. | Truy cập vào sẽ gây **Runtime Crash** ngay lập tức (dangling pointer). |
| **Khi nào sử dụng** | Sở hữu dữ liệu bình thường. | Khi đối tượng được tham chiếu có **vòng đời ngắn hơn hoặc có thể trở thành `nil`** (ví dụ: `delegate`, subview, `[weak self]` trong closure). | Chỉ dùng khi **chắc chắn 100%** đối tượng được tham chiếu **sống lâu hơn hoặc bằng** đối tượng tham chiếu tới nó (ví dụ: Child giữ `unowned` tới Parent). |

## 3.3. Retain Cycle (Strong Reference Cycle) & Cách phòng tránh

- **Retain Cycle là gì?** Là tình trạng 2 hay nhiều instance (hoặc 1 instance và 1 closure) giữ tham chiếu `strong` lẫn nhau. Khiến reference count của cả hai luôn $\ge 1$, không bao giờ về `0`, dẫn đến **Memory Leak** (bộ nhớ không được giải phóng dù không còn sử dụng).
- **2 trường hợp phổ biến gây Retain Cycle:**
  1. **Hai class giữ `strong` của nhau** (ví dụ: `ViewController` giữ `delegate`, `ChildVC` giữ `strong` ngược lại `ViewController`). -> *Cách sửa:* Khai báo `weak var delegate: SomeDelegate?`.
  2. **Closure capture `self` mạnh:** `ViewController` sở hữu một closure (hoặc network task/timer có `@escaping` closure), bên trong closure lại gọi `self.doSomething()` mà không có capture list. -> *Cách sửa:* Dùng `[weak self]`.
- **Giải thích `[weak self]` và `guard let self = self`:**
  - `[weak self]`: Capture list yêu cầu closure chỉ giữ tham chiếu yếu tới `self` (biến `self` bên trong closure trở thành kiểu Optional `Self?`), giúp `ViewController` có thể bị hủy bình thường nếu người dùng đóng màn hình trước khi closure chạy xong.
  - `guard let self = self else { return }`: Unwrap `self` từ Optional sang một hằng cục bộ `strong` trong thời gian thực thi thân closure. Giúp: (1) Không phải viết `self?.` lặp đi lặp lại, (2) Đảm bảo `self` không bị `nil` giữa chừng khi đang chạy các dòng lệnh trong closure, và (3) Tránh lỗi logic khi cần giá trị non-optional (như truyền tham số `Bool` không nhận `Bool?`).


---

[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 2. Kiến thức cốt lõi về ngôn ngữ Swift (Swift Core)](./02-Swift-Core.md) | [Bài tiếp: 4. Kiến thức iOS SDK & UIKit cơ bản & nâng cao ›](./04-iOS-SDK-va-UIKit.md)
