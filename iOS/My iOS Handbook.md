# My iOS Handbook

> Bộ tài liệu tổng hợp, chuẩn hóa và mở rộng từ 9 file ôn tập & đề thi thực hành phỏng vấn iOS (`Audit questions`, `CDG_iOS_Questions`, `Interview Question`, `Interview`, `Interview2`, `Swift`, `Swift(1)`, `eyeOS Question`, `iOS`), được chia thành 9 chuyên đề nhỏ để dễ học, tra cứu và ôn tập.

---

## Danh sách chuyên đề

### Phần I: Kiến thức lý thuyết phỏng vấn iOS

- **[1. Lập trình Hướng đối tượng (OOP) & Nguyên lý SOLID](./01-OOP-va-SOLID.md)**
  - 1.1. Các khái niệm nền tảng
  - 1.2. Tại sao dùng OOP & 4 tính chất của Lập trình Hướng đối tượng
  - 1.3. Overriding vs Overloading
  - 1.4. 5 Nguyên lý SOLID (OOD - Object-Oriented Design)
- **[2. Kiến thức cốt lõi về ngôn ngữ Swift (Swift Core)](./02-Swift-Core.md)**
  - 2.1. Tổng quan về Swift & Optional
  - 2.2. Struct vs Class (Value Type vs Reference Type)
  - 2.3. Khởi tạo (Initialization) chuyên sâu
  - 2.4. Properties, Subscripts, KeyPaths & Property Wrappers
  - 2.5. Function, Closure & Higher-Order Functions
  - 2.6. Protocol, Tuple & Generics
  - 2.7. Access Control (5 mức truy cập từ rộng nhất đến hẹp nhất)
- **[3. Quản lý bộ nhớ (ARC & Memory Management)](./03-ARC-va-Memory-Management.md)**
  - 3.1. ARC là gì? So sánh ARC và Non-ARC (MRC)
  - 3.2. Strong, Weak & Unowned
  - 3.3. Retain Cycle (Strong Reference Cycle) & Cách phòng tránh
- **[4. Kiến thức iOS SDK & UIKit cơ bản & nâng cao](./04-iOS-SDK-va-UIKit.md)**
  - 4.1. Application Lifecycle, AppDelegate & SceneDelegate
  - 4.2. ViewController Lifecycle
  - 4.3. Truyền dữ liệu (Passing Data) & Điều hướng (Navigation)
  - 4.4. Giao diện: View, Frame vs Bounds, Auto Layout, UIStackView, Custom View
  - 4.5. UITableView & UICollectionView (Cơ bản & Nâng cao)
  - 4.6. Animation & Core Graphics
- **[5. Lưu trữ dữ liệu (Persistence) & Hệ thống File iOS](./05-Persistence-va-File-System.md)**
  - 5.1. Cấu trúc thư mục Sandbox của ứng dụng iOS
  - 5.2. CRUD & Các lựa chọn Lưu trữ Dữ liệu (DBMS) trên iOS
  - 5.3. Core Data
  - 5.4. Realm Database
- **[6. Đa luồng & Bất đồng bộ (Concurrency: GCD, Operation, Swift Concurrency)](./06-Concurrency-GCD-Operation-AsyncAwait.md)**
  - 6.1. Các khái niệm nền tảng
  - 6.2. Grand Central Dispatch (GCD)
  - 6.3. Operation & OperationQueue
  - 6.4. Swift Concurrency hiện đại (`async/await`, `Task`, `TaskGroup`, `Actor`)
- **[7. Kiến trúc phần mềm (Architecture) & Design Patterns](./07-Architecture-va-Design-Patterns.md)**
  - 7.1. Design Patterns (Mẫu thiết kế)
  - 7.2. Các Architecture Patterns phổ biến trong iOS
- **[8. Networking, Bảo mật, Reactive (RxSwift), Debug, Unit Test & Công cụ](./08-Networking-RxSwift-Debug-UnitTest.md)**
  - 8.1. Networking, Parse JSON (`Codable`) & Quản lý Token
  - 8.2. Reactive Programming với RxSwift
  - 8.3. Push Notifications, Maps & Git
  - 8.4. Debugging & Unit Testing trên Xcode

### Phần II: Bài tập thực hành & Live Coding

- **[9. Bài Tập Thực Hành & Live Coding Phỏng Vấn iOS](./09-Bai-Tap-Thuc-Hanh-va-Thuat-Toan.md)**
  - Bài tập 1: Bài toán "CDG Zig" (Biến thể FizzBuzz)
  - Bài tập 2: Tìm chuỗi xuất hiện nhiều nhất trong mảng (Most Frequent String)
  - Bài tập 3: Tìm cặp chuỗi xuất hiện nhiều nhất (Most Common Pair)
  - Bài tập 4: Tính số Fibonacci thứ n
  - Bài tập 5: Kiểm tra tổ hợp phím `SpecialActions.matchKeyCombo`
  - Bài tập 6: Thiết kế hệ thống Ấp trứng Rồng (`Reptile` / `FireDragon` / `ReptileEgg`)
  - Bài tập 7: Tìm và sửa lỗi Memory Leak (Retain Cycle) giữa Class A và Class B
  - Bài tập 8: Đọc hiểu Code — Value Type & Copy-on-Write trên Array
  - Bài tập 9: Đọc hiểu Code — Higher-Order Functions (`sorted` + `map`) trên Array Tuple & Dictionary
  - Bài tập 10: Tư duy Toán tử & Biểu thức Logic
  - Bài tập 11: Các bài toán Thuật toán kinh điển trong phỏng vấn iOS

---

## Ghi chú cấu trúc thư mục

- [My iOS Handbook.md](./My%20iOS%20Handbook.md) — Trang mục lục điều hướng trung tâm.
- [01-OOP-va-SOLID.md](./01-OOP-va-SOLID.md) — 1. Lập trình Hướng đối tượng (OOP) & Nguyên lý SOLID.
- [02-Swift-Core.md](./02-Swift-Core.md) — 2. Kiến thức cốt lõi về ngôn ngữ Swift (Swift Core).
- [03-ARC-va-Memory-Management.md](./03-ARC-va-Memory-Management.md) — 3. Quản lý bộ nhớ (ARC & Memory Management).
- [04-iOS-SDK-va-UIKit.md](./04-iOS-SDK-va-UIKit.md) — 4. Kiến thức iOS SDK & UIKit cơ bản & nâng cao.
- [05-Persistence-va-File-System.md](./05-Persistence-va-File-System.md) — 5. Lưu trữ dữ liệu (Persistence) & Hệ thống File iOS.
- [06-Concurrency-GCD-Operation-AsyncAwait.md](./06-Concurrency-GCD-Operation-AsyncAwait.md) — 6. Đa luồng & Bất đồng bộ (Concurrency: GCD, Operation, Swift Concurrency).
- [07-Architecture-va-Design-Patterns.md](./07-Architecture-va-Design-Patterns.md) — 7. Kiến trúc phần mềm (Architecture) & Design Patterns.
- [08-Networking-RxSwift-Debug-UnitTest.md](./08-Networking-RxSwift-Debug-UnitTest.md) — 8. Networking, Bảo mật, Reactive (RxSwift), Debug, Unit Test & Công cụ.
- [09-Bai-Tap-Thuc-Hanh-va-Thuat-Toan.md](./09-Bai-Tap-Thuc-Hanh-va-Thuat-Toan.md) — 9. Bài Tập Thực Hành & Live Coding Phỏng Vấn iOS.
