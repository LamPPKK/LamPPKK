[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [Bài tiếp: 2. Kiến thức cốt lõi về ngôn ngữ Swift (Swift Core) ›](./02-Swift-Core.md)

---

# 1. Lập trình Hướng đối tượng (OOP) & Nguyên lý SOLID

## 1.1. Các khái niệm nền tảng
- **Lập trình (Programming) là gì?** Là quá trình thiết kế, viết mã nguồn theo cú pháp của một ngôn ngữ lập trình để mô tả các chỉ dẫn logic giúp máy tính giải quyết một bài toán cụ thể.
- **Programming Paradigm (Mô hình / Mẫu hình lập trình) là gì?** Là phong cách hoặc cách tiếp cận để cấu trúc và tổ chức code. Các paradigm phổ biến:
  - **Imperative (Mệnh lệnh):** Tập trung mô tả *từng bước* làm thế nào để đạt kết quả (ví dụ: C).
  - **Declarative (Khai báo):** Tập trung mô tả *kết quả mong muốn là gì* hơn là các bước thực hiện (ví dụ: SwiftUI, SQL).
  - **OOP (Object-Oriented Programming - Hướng đối tượng):** Tổ chức chương trình xoay quanh các đối tượng (Object) kết hợp dữ liệu và hành vi.
  - **POP (Protocol-Oriented Programming - Hướng giao thức):** Đặc trưng nổi bật của Swift, ưu tiên sử dụng `protocol` + `extension` + Value Type (`struct`, `enum`) để kết hợp hành vi linh hoạt thay vì cây kế thừa class sâu.
  - **Functional Programming (Lập trình hàm):** Coi hàm là công dân hạng nhất (first-class citizen), tránh thay đổi trạng thái (immutability), tận dụng Higher-Order Functions (`map`, `filter`, `reduce`).
- **Class vs Object:**
  - **Class (Lớp):** Là bản thiết kế (blueprint) định nghĩa các thuộc tính (*properties*) và phương thức (*methods*) chung cho một nhóm đối tượng.
  - **Object (Đối tượng):** Là một thể hiện (*instance*) cụ thể được tạo ra từ Class, ánh xạ một thực thể trong thực tế.
- **Model:** Là tầng/cấu trúc dữ liệu đại diện cho thực thể nghiệp vụ của ứng dụng (ví dụ `User`, `Product`), thường được khai báo bằng `struct` hoặc `class`.
- **Function:** Là một khối mã độc lập, có tên, nhận đầu vào (tham số), thực hiện một tác vụ cụ thể và có thể trả về kết quả.

## 1.2. Tại sao dùng OOP & 4 tính chất của Lập trình Hướng đối tượng

**Mục đích sử dụng OOP:**
- Mô phỏng các thực thể và mối quan hệ trong thực tế vào chương trình.
- Đóng gói dữ liệu và hành vi giúp code dễ bảo trì, mở rộng và tái sử dụng.
- Cho phép các đối tượng tương tác với nhau qua giao diện rõ ràng.

| Tính chất | Tên tiếng Anh | Định nghĩa & Ý nghĩa | Thực tế trong Swift / iOS |
| :--- | :--- | :--- | :--- |
| **Đóng gói** | Encapsulation | Gom dữ liệu và phương thức xử lý vào cùng một lớp; che giấu trạng thái bên trong, chỉ cho phép truy cập qua giao diện công khai. | Dùng Access Control (`private`, `fileprivate`, `internal`, `public`, `open`). |
| **Kế thừa** | Inheritance | Xây dựng lớp con (`subclass`) dựa trên lớp cha (`superclass`) để tái sử dụng và mở rộng thuộc tính, phương thức. | `class MyVC: UIViewController`. **Lưu ý:** Swift chỉ hỗ trợ **đơn kế thừa** cho Class. |
| **Đa hình** | Polymorphism | Một hành động/phương thức có thể được thực hiện theo nhiều cách khác nhau tùy vào đối tượng hoặc tham số truyền vào. | Overriding (`override func`), Overloading, hoặc các class khác nhau cùng conform 1 `protocol`. |
| **Trừu tượng** | Abstraction | Loại bỏ chi tiết triển khai phức tạp, chỉ giữ lại bản chất và các hành vi cốt lõi cần thiết ở mức thiết kế. | Swift **không có từ khóa `abstract class`** như Java/C#; tính trừu tượng trong Swift được thể hiện bằng **`protocol`**. |

> **Đính chính lỗi hay nhầm lẫn khi phỏng vấn (từ ghi chú gốc):**
> - **Swift là đơn kế thừa hay đa kế thừa?** Trong Swift, `class` chỉ hỗ trợ **đơn kế thừa** (1 class chỉ kế thừa tối đa 1 superclass). Cú pháp `class A: ClassB, ProtocolC, ProtocolD` có nghĩa là `A` kế thừa từ **1 class duy nhất là `ClassB`**, và **conform (tuân thủ) nhiều `Protocol`** (`ProtocolC`, `ProtocolD`) — *không thể viết `class A: ClassB, ClassC` nếu cả `ClassB` và `ClassC` đều là class*.
> - **Ví dụ thực tế về Đa hình (Polymorphism):**
>   - *Runtime Polymorphism (Overriding):* `Animal` có hàm `speak()`. `Dog` override trả về `"Gâu"`, `Cat` override trả về `"Meo"`.
>   - *Compile-time Polymorphism (Overloading):* Cùng tên hàm trong 1 class/struct nhưng khác tham số:
>     ```swift
>     class Service {
>         func fetch(_ id: String, isCached: Bool) { }
>         func fetch(_ isCached: Bool) -> Bool { return isCached }
>     }
>     ```

## 1.3. Overriding vs Overloading

- **Overriding (Ghi đè):** Subclass định nghĩa lại *instance method*, *type method*, *property* hoặc *subscript* đã được khai báo ở superclass sao cho phù hợp với hành vi riêng của subclass (dùng từ khóa `override`).
- **Overloading (Nạp chồng):** Cho phép trong cùng một phạm vi (class/struct/file) có nhiều hàm **cùng tên** nhưng khác nhau về chữ ký hàm:
  1. Khác **số lượng tham số** (`func add(a: Int)` vs `func add(a: Int, b: Int)`).
  2. Khác **kiểu dữ liệu tham số** (`func log(_ x: Int)` vs `func log(_ x: String)`).
  3. Khác **Argument Labels (nhãn tham số)** (ví dụ hàm `stride(from:to:by:)` vs `stride(from:through:by:)`).
  4. Khác **kiểu trả về** (`func getValue() -> Int` vs `func getValue() -> String`).

## 1.4. 5 Nguyên lý SOLID (OOD - Object-Oriented Design)

SOLID là tập hợp 5 nguyên lý thiết kế lớp do Robert C. Martin đề xuất nhằm tạo ra phần mềm dễ bảo trì, dễ test, mở rộng tốt và giảm phụ thuộc chéo (*loose coupling*, *high cohesion*).

| Chữ cái | Nguyên lý | Giải thích ngắn gọn (Anh / Việt) | Ví dụ thực tế trong iOS |
| :---: | :--- | :--- | :--- |
| **S** | **Single Responsibility Principle (SRP)** | *Đơn trách nhiệm:* Một class/module chỉ nên có **1 trách nhiệm duy nhất** và chỉ có 1 lý do để thay đổi. | Tách `NetworkManager`, `CacheManager` ra khỏi `ViewController` thay vì nhét hết vào VC. |
| **O** | **Open/Closed Principle (OCP)** | *Đóng với sửa đổi, mở với mở rộng:* Có thể mở rộng hành vi mới mà không cần sửa code đang chạy ổn định bên trong. | Dùng `protocol PaymentMethod` để thêm `ApplePay`, `Momo` mới mà không sửa `CheckoutService`. |
| **L** | **Liskov Substitution Principle (LSP)** | *Thay thế Liskov:* Đối tượng của subclass phải thay thế được cho superclass mà không làm sai lệch tính đúng đắn của chương trình. | Subclass khi override không được phá vỡ hợp đồng/hành vi kỳ vọng của superclass (ví dụ: không ném lỗi bất ngờ hoặc vô hiệu hóa tính năng vốn có của cha). |
| **I** | **Interface Segregation Principle (ISP)** | *Phân tách giao diện:* Không ép một class phải implement các phương thức trong protocol mà nó không sử dụng. | Thay vì 1 protocol `Worker` khổng lồ có `code()`, `design()`, `test()`, hãy chia nhỏ thành `CodableWorker`, `DesignableWorker`. |
| **D** | **Dependency Inversion Principle (DIP)** | *Đảo ngược phụ thuộc:* Module cấp cao không nên phụ thuộc trực tiếp vào module cấp thấp; cả hai nên phụ thuộc vào abstraction (`protocol`). | `UserViewModel` phụ thuộc vào `protocol UserRepositoryProtocol` thay vì phụ thuộc cứng vào `AlamofireUserRepository` — giúp dễ mock khi Unit Test. |


---

[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [Bài tiếp: 2. Kiến thức cốt lõi về ngôn ngữ Swift (Swift Core) ›](./02-Swift-Core.md)
