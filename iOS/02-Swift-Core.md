[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 1. Lập trình Hướng đối tượng (OOP) & Nguyên lý SOLID](./01-OOP-va-SOLID.md) | [Bài tiếp: 3. Quản lý bộ nhớ (ARC & Memory Management) ›](./03-ARC-va-Memory-Management.md)

---

# 2. Kiến thức cốt lõi về ngôn ngữ Swift (Swift Core)

## 2.1. Tổng quan về Swift & Optional
- **Swift là gì?** Ngôn ngữ lập trình do Apple phát triển (giới thiệu năm 2014) cho iOS, macOS, watchOS, tvOS và Linux; tương thích với Cocoa/Cocoa Touch và Objective-C. Swift là ngôn ngữ **statically typed** (kiểm tra kiểu tĩnh tại compile-time) và **compiled language** (biên dịch ra mã máy).
- **Optional là gì?** Dùng để biểu diễn một biến có thể chứa giá trị hoặc không có giá trị (`nil`). Về bản chất, Optional trong Swift là một `enum` generic gồm 2 case:
  ```swift
  enum Optional<Wrapped> {
      case none
      case some(Wrapped)
  }
  ```
- **5 cách Unwrap Optional:**
  1. **Force Unwrapping (`!`):** Ép lấy giá trị trực tiếp. Chỉ dùng khi **chắc chắn 100%** biến khác `nil`, nếu không sẽ **crash** app (`Fatal error: Unexpectedly found nil`).
  2. **Implicitly Unwrapped Optional (`var name: String!`):** Khai báo biến optional nhưng tự động unwrap khi dùng; phù hợp cho `@IBOutlet` hoặc biến chắc chắn có giá trị ngay sau khi khởi tạo.
  3. **Optional Binding (`if let` / `if var`, `guard let`):** Kiểm tra an toàn xem optional có giá trị hay không trước khi gán vào hằng/biến mới.
  4. **Optional Chaining (`?.`):** Truy cập property, method hoặc subscript trên optional (ví dụ: `person?.info?.address`). Nếu bất kỳ mắt xích nào là `nil`, cả biểu thức trả về `nil` thay vì crash.
  5. **Nil-Coalescing Operator (`??`):** Lấy giá trị nếu khác `nil`, ngược lại dùng giá trị mặc định (ví dụ: `let name = user.name ?? "Guest"`).

- **So sánh `if let` vs `guard let`:**

| Tiêu chí | `if let` | `guard let` |
| :--- | :--- | :--- |
| **Luồng ưu tiên** | Ưu tiên xử lý nhánh **có giá trị** (non-nil) trước. | Ưu tiên xử lý/thoát sớm nhánh **bị `nil`** (early exit) trước. |
| **Yêu cầu thoát scope** | Không bắt buộc `return` / `throw` / `break`. | Nhánh `else` **bắt buộc phải thoát scope** (`return`, `throw`, `break`, `continue`, `fatalError`). |
| **Phạm vi biến unwrap** | Chỉ tồn tại **bên trong** block `{ ... }` của `if let`. | Tồn tại ở **phạm vi bên ngoài** ngay sau câu lệnh `guard let` cho tới hết hàm/scope. |
| **Trường hợp sử dụng** | Kiểm tra 1 nhánh nhỏ, có giá trị hay không đều chạy tiếp. | Kiểm tra tuần tự nhiều điều kiện đầu vào (tránh lồng `if` sâu - pyramid of doom). |

## 2.2. Struct vs Class (Value Type vs Reference Type)

- **Điểm giống nhau:**
  - Đều có thể khai báo stored/computed properties và methods.
  - Đều hỗ trợ Subscripts, Initializers (`init`), Extensions, và Conform nhiều Protocols.
- **Bảng so sánh chi tiết:**

| Tiêu chí | `Struct` (Value Type) | `Class` (Reference Type) |
| :--- | :--- | :--- |
| **Cơ chế truyền / gán** | **Assign-by-copy:** Tạo ra bản sao độc lập khi gán hoặc truyền vào hàm. Thay đổi bản sao không ảnh hưởng bản gốc. | **Assign-by-reference:** Truyền tham chiếu trỏ tới cùng vùng nhớ. Thay đổi qua biến này sẽ ảnh hưởng biến kia. |
| **Vùng nhớ lưu trữ** | Thường lưu trên **Stack** (cấp phát/giải phóng cực nhanh theo scope). *Lưu ý:* Nếu struct là thuộc tính bên trong 1 class, nó sẽ nằm trên **Heap** cùng class đó. | Instance luôn được cấp phát trên **Heap** (tốn chi phí quản lý và giải phóng chậm hơn Stack). |
| **Quản lý bộ nhớ** | Tự động giải phóng khi ra khỏi scope; **không dùng ARC**, **không có `deinit`**. | Quản lý bởi **ARC (Automatic Reference Counting)**; có hàm **`deinit`**. |
| **Kế thừa** | **Không hỗ trợ** kế thừa (chỉ conform protocol). | Hỗ trợ **đơn kế thừa** từ 1 superclass và conform nhiều protocol. |
| **Khởi tạo (`init`)** | Tự sinh **Memberwise Initializer** mặc định nếu chưa viết `init` riêng (viết `init` phụ trong `extension` để giữ lại memberwise init). | Không tự sinh memberwise `init`; phải gán giá trị mặc định, khai báo optional hoặc tự viết `init`. |
| **Method Dispatch** | **Static Dispatch** (xác định hàm ngay lúc compile -> chạy nhanh hơn). | **Dynamic Dispatch** (qua vtable / Obj-C message dispatch -> linh hoạt cho override nhưng chậm hơn). |
| **Biến khai báo bằng `let`** | **Bất biến hoàn toàn** (không thể đổi giá trị các property bên trong). | Tham chiếu cố định (không trỏ sang instance khác), nhưng **các `var` property bên trong vẫn thay đổi được**. |
| **Thay đổi property trong hàm** | Hàm làm thay đổi `self` bắt buộc phải đánh dấu **`mutating`**. | Không cần từ khóa `mutating`. |
| **Toán tử so sánh** | So sánh bằng giá trị qua **`==`** (khi conform `Equatable`). | Có khái niệm danh tính (*identity*): kiểm tra 2 biến có trỏ cùng 1 instance bằng **`===`** và **`!==`**. |
| **Thread-safety** | An toàn hơn với đa luồng vì mỗi nơi giữ bản sao riêng. | Dễ xảy ra Race Condition nếu nhiều thread cùng ghi vào 1 instance. |

- **Câu hỏi tình huống phỏng vấn (từ `CDG_iOS_Questions.docx`):**
  > *"Nếu có 1 Struct (hoặc Class) và 1 biến bên trong, ta dùng 1 function bên ngoài để modify biến đó thì nó thay đổi trên object gốc hay tạo bản mới?"*
  - **Với `Struct`:** Khi truyền biến `struct` vào một hàm thông thường, Swift truyền vào một **bản sao (copy)** ở dạng hằng số (`let`), nên không thể sửa trực tiếp — muốn sửa phải gán kết quả trả về cho biến mới, hoặc dùng từ khóa **`inout`** (truyền kèm `&` khi gọi hàm) để ghi ngược lại biến gốc (về mặt cơ chế gọi là *copy-in copy-out*). Nếu là hàm nội bộ của Struct sửa thuộc tính của chính nó thì dùng **`mutating func`**.
  - **Với `Class`:** Khi truyền instance của `class` vào hàm, hàm nhận được bản sao của **con trỏ tham chiếu** trỏ tới **cùng một instance gốc trên Heap**. Do đó mọi thay đổi lên thuộc tính của tham số đó sẽ **thay đổi trực tiếp lên object gốc**.

## 2.3. Khởi tạo (Initialization) chuyên sâu

- **Trong `Struct`:**
  1. Khởi tạo mặc định (nếu mọi property đều có giá trị sẵn) & Memberwise `init(...)`.
  2. Viết custom `init` trong `extension`: Giúp giữ nguyên Memberwise `init` mặc định của Swift.
  3. **Initializer Delegation:** Một `init` gọi `self.init(...)` khác. Không được truy cập `self` trước khi gọi `self.init(...)`.
- **Trong `Class`:**
  - **Designated Initializer (`init`):** Hàm khởi tạo chính, có trách nhiệm gán giá trị cho toàn bộ các non-optional stored properties của class đó và gọi `super.init(...)` lên lớp cha.
  - **Convenience Initializer (`convenience init`):** Hàm khởi tạo phụ, bắt buộc gọi `self.init(...)` tới một `init` khác trong cùng class (cuối cùng phải hội tụ về 1 Designated `init`). Không được gán trực tiếp `self.property` trước khi gọi `self.init(...)`.
- **3 Quy tắc Kênh khởi tạo (Initialization Funnel) giữa Superclass & Subclass:**
  1. `Designated init` của subclass **phải gọi** `Designated init` của superclass trực tiếp (`super.init(...)`).
  2. `Convenience init` **chỉ được gọi** một `init` khác trong **cùng class** (`self.init(...)`).
  3. `Convenience init` cuối cùng **phải kết thúc** bằng việc gọi một `Designated init` (không được gọi `super.init` trực tiếp).
- **Quy trình Khởi tạo 2 Pha (Two-Phase Initialization):**
  - **Pha 1 (Từ dưới lên - Bottom-up):** Gán giá trị cho tất cả stored properties của subclass -> gọi `super.init(...)` lên tới lớp gốc (base class). *Trong pha 1 không thể dùng `self`, gọi instance method hay đọc property chưa khởi tạo.*
  - **Pha 2 (Từ trên xuống - Top-down):** Sau khi lớp gốc hoàn tất pha 1, toàn bộ bộ nhớ đã hợp lệ -> lúc này mới có thể sử dụng `self`, truy cập/thay đổi lại property hoặc gọi các method của instance.
- **Un-inheriting & Overriding Initializers:**
  - Mặc định subclass không tự kế thừa `init` của cha (trừ 2 trường hợp tự động kế thừa: subclass không định nghĩa bất kỳ designated init nào, hoặc đã override toàn bộ designated init của cha).
  - Nếu subclass viết lại hàm trùng chữ ký với designated init của cha thì dùng `override init(...)`.
- **Xử lý lỗi khi khởi tạo:**
  - **Failable Initializer (`init?` hoặc `init!`):** Trả về `nil` nếu dữ liệu đầu vào không hợp lệ.
  - **Throwing Initializer (`init(...) throws`):** Ném ra `Error` cụ thể để biết rõ lý do khởi tạo thất bại.

## 2.4. Properties, Subscripts, KeyPaths & Property Wrappers

- **Các loại Property trong Swift:**
  1. **Stored Properties:** Lưu trữ trực tiếp giá trị trong bộ nhớ (`var` hoặc `let`).
  2. **Lazy Stored Properties (`lazy var`):** Chỉ được tính toán và cấp phát **1 lần duy nhất** vào thời điểm truy cập đầu tiên. Dùng cho các thuộc tính khởi tạo nặng hoặc phụ thuộc vào đối tượng khác chưa sẵn sàng lúc `init`. *(Lưu ý: `lazy` luôn phải dùng `var` và không tự động thread-safe).*
  3. **Computed Properties:** Không lưu giá trị trong bộ nhớ mà tính toán động mỗi lần được gọi thông qua `get` (read-only) hoặc cả `get` và `set` (read-write).
  4. **Property Observers (`willSet`, `didSet`):** Theo dõi sự thay đổi trước (`newValue`) và sau (`oldValue`) khi giá trị của stored property được gán mới *(không chạy trong `init`)*.
  5. **Type Properties (`static` vs `class`):** Thuộc về kiểu dữ liệu chứ không thuộc về từng instance.
     - `static`: Áp dụng cho cả `struct`, `enum`, `class`. **Không thể override** ở subclass.
     - `class`: Chỉ dùng trong `class` (áp dụng cho computed property và method). **Cho phép subclass `override`**.
- **Property Wrappers (`@propertyWrapper`)**:
  > **Đính chính lỗi sai trong file gốc:** Trong `eyeOS Question.docx`, Property Wrapper bị nhầm với Optional unwrapping (`if let`, `guard let`). **Định nghĩa chuẩn:**
  - **Property Wrapper** (giới thiệu từ Swift 5.1) là một cơ chế bọc logic quản lý (đọc/ghi/validate/lưu trữ) vào một kiểu riêng (`@propertyWrapper struct/class`) để tái sử dụng cho nhiều thuộc tính qua cú pháp `@TênWrapper`.
  - **Các Property Wrapper hay dùng trong iOS/SwiftUI:** `@State`, `@Binding`, `@ObservedObject`, `@StateObject`, `@EnvironmentObject`, `@Environment`, `@Published` (Combine), `@AppStorage`, hoặc tự viết `@UserDefault` để tự động đọc/ghi vào `UserDefaults`.
- **Subscripts:** Nạp chồng toán tử `[]` cho `class`, `struct`, `enum` để truy cập phần tử nhanh theo chỉ số hoặc khóa (ví dụ `matrix[row, col]`).
- **KeyPaths:** Cho phép lưu trữ **tham chiếu tới đường dẫn của một property** thay vì lưu giá trị của property đó (ví dụ: `let namePath = \User.name`, dùng với `user[keyPath: namePath]` hoặc trong `.map(\.name)`).
- **Từ khóa `dynamic`:** Yêu cầu Swift dùng cơ chế **Objective-C dynamic dispatch** thay vì static/vtable dispatch của Swift; thường kết hợp với `@objc` khi sử dụng **KVO** hoặc **Method Swizzling**.

## 2.5. Function, Closure & Higher-Order Functions

- **Phân biệt Function và Closure:**

| Tiêu chí | Function | Closure |
| :--- | :--- | :--- |
| **Định nghĩa** | Khối mã **có tên**, khai báo bằng từ khóa `func`. | Khối mã độc lập (**hàm ẩn danh** - anonymous function) định nghĩa bởi `{ (params) -> ReturnType in ... }`. |
| **Cách sử dụng** | Gọi trực tiếp qua tên hàm. Tham số mặc định là hằng số (`let`); muốn sửa biến truyền vào phải dùng **`inout`** và truyền **`&`**. | Thường gán vào biến/hằng hoặc truyền làm đối số (completion handler, callback) cho hàm khác. |
| **Capture giá trị** | Global function không capture biến bên ngoài; Nested function có thể capture. | Tự động capture và lưu trữ tham chiếu tới các biến ở ngữ cảnh xung quanh (*capturing values*). |
| **Kiểu dữ liệu** | Có thể là 1 trong 3 dạng của Closure trong Swift. | Là **Reference Type** (nếu gán cùng 1 closure cho 2 biến thì cả 2 dùng chung closure và capture list đó). |

- **3 loại Closure trong Swift:**
  1. **Global functions:** Closure có tên, không capture bất kỳ giá trị nào.
  2. **Nested functions:** Closure có tên, nằm trong hàm khác, có thể capture giá trị từ hàm bao ngoài.
  3. **Closure expressions:** Closure không tên với cú pháp rút gọn (`$0`, `$1`, trailing closure), có thể capture giá trị từ ngữ cảnh xung quanh.
- **Non-escaping vs `@escaping` Closure:**
  - **Non-escaping (mặc định):** Closure được thực thi ngay bên trong thân hàm và được giải phóng trước khi hàm `return`. Không bị retain cycle nếu không lưu trữ ra ngoài.
  - **`@escaping`:** Closure có thể **được giữ lại và gọi sau khi hàm đã `return`** (ví dụ: lưu vào một thuộc tính của class, gọi bất đồng bộ sau khi request API hoặc `DispatchQueue.async` hoàn tất). Bắt buộc phải viết tường minh `self.` (hoặc dùng `[weak self]`) bên trong `@escaping` closure để tránh vô tình tạo retain cycle.
- **Higher-Order Functions (Hàm bậc cao):** Là hàm nhận một hoặc nhiều hàm/closure làm tham số đầu vào hoặc trả về một hàm/closure. Các hàm thông dụng trên Collection:
  - `sorted(by:)`: Trả về mảng mới đã sắp xếp theo điều kiện trong closure (khác với `sort(by:)` làm thay đổi trực tiếp mảng gốc).
  - `filter(_:)`: Trả về mảng chứa các phần tử thỏa mãn điều kiện `Bool` trong closure.
  - `map(_:)`: Biến đổi **từng phần tử** của collection theo closure, giữ nguyên số lượng phần tử.
  - `compactMap(_:)`: Biến đổi từng phần tử đồng thời **tự động loại bỏ các giá trị `nil`** (từ Swift 4.1 thay thế cho `flatMap` trong trường hợp lọc `nil`).
  - `flatMap(_:)`: Biến đổi từng phần tử rồi **làm phẳng (flatten)** collection nhiều chiều thành collection 1 chiều.
  - `reduce(_:_:)`: Gộp toàn bộ phần tử thành một giá trị duy nhất từ `initialResult` và hàm kết hợp `nextPartialResult` (ví dụ tính tổng: `nums.reduce(0, +)`).

- **Phân biệt nhanh `map` vs `flatMap` / `compactMap`:**
  - `let nums = [1, 2, 3]; nums.map { $0 * 2 }` -> `[2, 4, 6]`
  - `let nested = [[1, 2], [3, 4]]; nested.flatMap { $0 }` -> `[1, 2, 3, 4]` *(làm phẳng mảng 2 chiều thành 1 chiều)*
  - `let withNil = [1, nil, 2, nil, 3]; withNil.compactMap { $0 }` -> `[1, 2, 3]` *(trước Swift 4.1 gọi bằng `flatMap`, hiện tại chuẩn Swift là `compactMap`)*.

## 2.6. Protocol, Tuple & Generics

- **Protocol:**
  - Là bản thiết kế định nghĩa danh sách thuộc tính và phương thức mà `class`, `struct`, `enum` phải tuân thủ (*conform/adopt*).
  - **Khai báo Property trong Protocol:** Bắt buộc phải dùng `var` (không được dùng `let` hay gán giá trị mặc định) kèm quyền `{ get }` hoặc `{ get set }`. Hỗ trợ `static` cho Type property/method.
  - **Mutating trong Protocol:** Nếu phương thức có thể làm thay đổi thuộc tính của `struct`/`enum`, cần đánh dấu `mutating func` trong protocol (`class` khi implement không cần ghi `mutating`).
  - **Protocol Extension & Optional Methods:** Cho phép cung cấp **triển khai mặc định (Default Implementation)** hoặc bổ sung hàm mới cho mọi kiểu conform protocol. Đây cũng là cách tạo **Optional Protocol Method** thuần Swift (không cần `@objc optional`).
  - **`associatedtype`:** Tạo một kiểu giữ chỗ (placeholder type) trong protocol; kiểu cụ thể sẽ được xác định khi class/struct conform protocol đó.
  - **Ứng dụng:** Delegation pattern, Protocol-Oriented Programming, các protocol chuẩn của Swift (`Equatable`, `Comparable`, `Hashable`, `Codable`), và dùng Protocol như một kiểu dữ liệu.
- **Tuple:** Nhóm nhiều giá trị (có thể khác kiểu) vào một giá trị phức hợp bằng ngoặc đơn `()`, dùng phổ biến để hàm trả về nhiều giá trị cùng lúc. Có 2 loại: có đặt tên `(code: 200, message: "OK")` và không đặt tên `(200, "OK")`. Tuple không thể conform protocol hay khai báo method.
- **Generics:** Giúp viết các hàm, `class`, `struct`, `enum` tổng quát hoạt động với nhiều kiểu dữ liệu khác nhau mà không phải lặp lại code (ví dụ `func swapValues<T>(_ a: inout T, _ b: inout T)`). Có thể ràng buộc kiểu dữ liệu bằng **Type Constraint**, ví dụ `class Keeper<Animal: Pet>`.

## 2.7. Access Control (5 mức truy cập từ rộng nhất đến hẹp nhất)

1. **`open`** *(rộng nhất - chỉ dùng cho class và thành phần của class)*: Truy cập từ mọi nơi (cùng module và module khác import vào), **cho phép subclass và override từ bên ngoài module** (ví dụ `UICollectionView` trong `UIKit`).
2. **`public`**: Truy cập từ mọi nơi (cùng module và module khác), nhưng **không thể subclass hoặc override từ module bên ngoài**.
3. **`internal`** *(mặc định nếu không khai báo)*: Truy cập từ bất kỳ file nào **trong cùng một module/target**.
4. **`fileprivate`**: Chỉ được sử dụng **trong cùng một file `.swift`**.
5. **`private`** *(hẹp nhất)*: Chỉ truy cập được **bên trong phạm vi khai báo bao quanh nó** và các `extension` của kiểu đó nằm **trong cùng file**.

*(Mở rộng từ Swift 6: có thêm mức `package` nằm giữa `public` và `internal` — cho phép truy cập giữa các target thuộc cùng một Swift Package).*


---

[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 1. Lập trình Hướng đối tượng (OOP) & Nguyên lý SOLID](./01-OOP-va-SOLID.md) | [Bài tiếp: 3. Quản lý bộ nhớ (ARC & Memory Management) ›](./03-ARC-va-Memory-Management.md)
