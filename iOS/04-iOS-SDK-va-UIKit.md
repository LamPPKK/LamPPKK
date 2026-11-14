[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 3. Quản lý bộ nhớ (ARC & Memory Management)](./03-ARC-va-Memory-Management.md) | [Bài tiếp: 5. Lưu trữ dữ liệu (Persistence) & Hệ thống File iOS ›](./05-Persistence-va-File-System.md)

---

# 4. Kiến thức iOS SDK & UIKit cơ bản & nâng cao

## 4.1. Application Lifecycle, AppDelegate & SceneDelegate

- **5 trạng thái của ứng dụng iOS:**

| Trạng thái | Mô tả |
| :--- | :--- |
| **Not Running** | Ứng dụng chưa được khởi chạy hoặc đã bị hệ thống/người dùng tắt (terminated). |
| **Inactive** | Ứng dụng đang chạy ở Foreground nhưng **không nhận sự kiện tương tác** (ví dụ: lúc đang chuyển cảnh mở app, kéo Notification Center, hoặc có cuộc gọi tới). |
| **Active** | Ứng dụng đang chạy ở Foreground và **nhận sự kiện tương tác bình thường** từ người dùng. |
| **Background** | Ứng dụng không hiển thị trên màn hình nhưng **vẫn thực thi code** (ví dụ: phát nhạc, theo dõi vị trí, hoặc xin thêm thời gian xử lý ngắn qua `beginBackgroundTask`). Sau một thời gian ngắn sẽ chuyển sang Suspended. |
| **Suspended** | Ứng dụng vẫn nằm trong bộ nhớ (RAM) ở nền nhưng **không thực thi code**. Nếu thiết bị thiếu RAM, hệ thống sẽ tự động kill app ở trạng thái này. |

- **Các phương thức chính trong `AppDelegate` (iOS < 13 & các sự kiện cấp App):**
  1. `application(_:willFinishLaunchingWithOptions:)`: Gọi đầu tiên khi khởi chạy thành công.
  2. `application(_:didFinishLaunchingWithOptions:)`: Gọi trước khi window hiển thị, nơi setup thư viện, cấu hình ban đầu (và tạo `UIWindow` nếu không dùng `SceneDelegate`).
  3. `applicationDidBecomeActive(_:)`: Chuyển từ `Inactive` -> `Active` (chạy lại timer, làm mới dữ liệu).
  4. `applicationWillResignActive(_:)`: Sắp chuyển từ `Active` -> `Inactive` (tạm dừng game, timer, ẩn thông tin nhạy cảm).
  5. `applicationDidEnterBackground(_:)`: App đã xuống nền (lưu dữ liệu, giải phóng tài nguyên nặng; có khoảng ~5s để hoàn tất hoặc gọi `beginBackgroundTask`).
  6. `applicationWillEnterForeground(_:)`: Chuẩn bị chuyển từ `Background` quay lại `Active`.
  7. `applicationWillTerminate(_:)`: App sắp bị hệ thống xóa khỏi bộ nhớ (dọn dẹp lần cuối).

- **Phân biệt `AppDelegate` vs `SceneDelegate` (từ iOS 13+):**
  - **Trước iOS 13:** Chỉ có `AppDelegate` quản lý cả vòng đời app lẫn cửa sổ hiển thị (`UIWindow`).
  - **Từ iOS 13 trở đi (hỗ trợ Multi-Window trên iPadOS):** Apple tách trách nhiệm ra làm đôi:
    - **`AppDelegate`:** Chỉ xử lý các sự kiện **cấp toàn ứng dụng** (app launch `didFinishLaunchingWithOptions`, push notification registration, lifecycle của `UISceneSession` như `configurationForConnecting`, `didDiscardSceneSessions`).
    - **`SceneDelegate`:** Quản lý **từng cửa sổ / giao diện hiển thị (`UIWindowScene`, `UIWindow`)** và các vòng đời trạng thái UI của scene đó:
      - `scene(_:willConnectTo:options:)`: Tạo `UIWindow`, gán `rootViewController` và `makeKeyAndVisible()`.
      - `sceneWillEnterForeground(_:)` -> `sceneDidBecomeActive(_:)`
      - `sceneWillResignActive(_:)` -> `sceneDidEnterBackground(_:)`
      - `sceneDidDisconnect(_:)`: Khi scene bị đóng/ngắt kết nối.

- **Thứ tự Lifecycle từ lúc mở App -> Chuyển App -> Quay lại -> Tắt App (với `SceneDelegate`):**
  1. **Mở app:** `didFinishLaunchingWithOptions` -> `scene(_:willConnectTo:)` -> `VC1.viewDidLoad` -> `VC1.viewWillAppear` -> `sceneWillEnterForeground` -> `sceneDidBecomeActive` -> `VC1.viewDidAppear`.
  2. **Chuyển sang app khác / nhấn Home:** `sceneWillResignActive` -> `sceneDidEnterBackground`.
  3. **Quay lại app:** `sceneWillEnterForeground` -> `sceneDidBecomeActive`.
  4. **Vuốt tắt app:** `sceneWillResignActive` -> `sceneDidEnterBackground` -> `sceneDidDisconnect` -> `application(_:didDiscardSceneSessions:)` (hoặc `applicationWillTerminate`).

## 4.2. ViewController Lifecycle

| Thứ tự | Phương thức | Thời điểm gọi & Mục đích sử dụng |
| :---: | :--- | :--- |
| 1 | `loadView()` | Được gọi **khi `view` của VC đang là `nil` và được truy cập lần đầu**. Chịu trách nhiệm tạo root `view` (từ Storyboard/XIB hoặc code). *Chỉ override khi tạo root view hoàn toàn bằng code, không gọi `super.loadView()`.* |
| 2 | `viewDidLoad()` | Được gọi **1 lần duy nhất** ngay sau khi `view` đã load xong vào bộ nhớ. Dùng để setup UI ban đầu, đăng ký cell, khởi tạo dữ liệu / gọi API lần đầu. *(Lưu ý: lúc này kích thước `bounds` theo Auto Layout có thể chưa tính xong chuẩn xác).* |
| 3 | `viewWillAppear(_:)` | Được gọi **mỗi lần** ngay trước khi `view` được thêm vào view hierarchy và hiện ra. Dùng để cập nhật UI/dữ liệu cần làm mới mỗi khi quay lại màn hình, ẩn/hiện NavigationBar. |
| 4 | `viewWillLayoutSubviews()` / `viewDidLayoutSubviews()` | Được gọi khi view sắp/vừa bố trí lại kích thước các subview (sau khi Auto Layout tính xong). |
| 5 | `viewDidAppear(_:)` | Được gọi ngay sau khi `view` đã hiển thị hoàn toàn trên màn hình. Dùng để bắt đầu animation, phát video/âm thanh, bắt đầu timer, gửi tracking analytics. |
| 6 | `viewWillDisappear(_:)` | Được gọi trước khi `view` sắp bị gỡ khỏi view hierarchy. Dùng để ẩn bàn phím, dừng timer, hủy request không cần thiết, lưu thay đổi tạm. |
| 7 | `viewDidDisappear(_:)` | Được gọi sau khi `view` đã ẩn hoàn toàn khỏi màn hình. Dùng để dừng cảm biến, hủy listener không cần chạy ngầm. |
| 8 | `didReceiveMemoryWarning()` | Được gọi khi thiết bị thiếu RAM. Dùng để giải phóng cache ảnh, dữ liệu có thể tạo lại được. *(Lưu ý: `viewDidUnload` đã bị Apple deprecated từ iOS 6).* |
| 9 | `deinit` | Được gọi khi ViewController thực sự bị giải phóng khỏi bộ nhớ (`ARC == 0`). *Lưu ý: Một VC biến mất khỏi màn hình (`viewDidDisappear`) không đồng nghĩa nó đã bị `deinit` (ví dụ khi nằm trong Navigation stack).* |

- **Câu hỏi thường gặp:**
  - **Hàm nào gọi trước giữa `viewDidLoad` và `viewWillAppear`?** -> `viewDidLoad()` luôn được gọi trước `viewWillAppear(_:)`. `viewDidLoad()` chạy 1 lần khi load view vào RAM; `viewWillAppear(_:)` có thể chạy nhiều lần mỗi khi view hiện lại.
  - **Thứ tự Lifecycle khi Push từ `VC1` sang `VC2` rồi Pop quay lại `VC1` trong `UINavigationController`:**
    - Khởi tạo `VC1`: `VC1.viewDidLoad` -> `VC1.viewWillAppear` -> `VC1.viewDidAppear`.
    - Push sang `VC2`: `VC2.viewDidLoad` -> `VC1.viewWillDisappear` -> `VC2.viewWillAppear` -> `VC1.viewDidDisappear` -> `VC2.viewDidAppear`.
    - Back (Pop) về `VC1`: `VC2.viewWillDisappear` -> `VC1.viewWillAppear` -> `VC2.viewDidDisappear` -> `VC1.viewDidAppear` -> `VC2.deinit`.

## 4.3. Truyền dữ liệu (Passing Data) & Điều hướng (Navigation)

- **Các cơ chế truyền dữ liệu trong iOS:**

| Cơ chế | Mô hình quan hệ | Đặc điểm & Khi nào sử dụng |
| :--- | :---: | :--- |
| **Property / Initializer** | 1 - 1 (Thuận) | Truyền dữ liệu từ màn hình A sang màn hình B lúc khởi tạo B (hoặc trong `prepare(for:sender:)` của Segue). |
| **Delegate (Protocol)** | 1 - 1 (Ngược) | Truyền dữ liệu/sự kiện từ B về A. Protocol tách bạch logic, luôn khai báo `weak var delegate` để tránh retain cycle. |
| **Closure / Callback** | 1 - 1 (Ngược) | Ngắn gọn hơn Delegate khi chỉ có 1-2 hành động callback; nhớ dùng `[weak self]` ở nơi nhận. |
| **NotificationCenter** | 1 - Nhiều | Broadcast thông điệp (`post`) tới bất kỳ đối tượng nào đã đăng ký (`addObserver`), không cần tham chiếu trực tiếp tới nhau. Phải chú ý gỡ observer nếu dùng selector cũ. |
| **KVO (Key-Value Observing)** | 1 - Nhiều | Quan sát trực tiếp sự thay đổi giá trị của thuộc tính trên object (`@objc dynamic`). Cần hủy observation (hoặc lưu `NSKeyValueObservation` token) trước khi object giải phóng, tránh crash truy cập vùng nhớ đã hủy. |
| **UserDefaults** | Lưu trữ cục bộ | Lưu cài đặt đơn giản (`Bool`, `String`, `Int`...) tồn tại xuyên suốt giữa các lần mở app. Không dùng cho dữ liệu nhạy cảm hay dữ liệu lớn. |

- **Phân biệt `Delegate` vs `DataSource`:**
  - **Delegate:** Nhóm các phương thức xử lý **sự kiện / tương tác / hành vi** (ví dụ `didSelectRowAt`, truyền thông điệp khi có sự kiện xảy ra).
  - **DataSource:** Nhóm các phương thức **cung cấp dữ liệu** để hiển thị lên UI (ví dụ `numberOfRowsInSection`, `cellForRowAt`).
- **Các đối tượng điều hướng chính:**
  - **`UINavigationController`:** Quản lý luồng màn hình theo cấu trúc Stack (LIFO) bằng `pushViewController` / `popViewController`.
  - **`UITabBarController`:** Quản lý nhiều luồng độc lập song song qua thanh Tab ở đáy màn hình.
  - **Modal Presentation:** Hiển thị đè một màn hình mới bằng `present(_:animated:)` và đóng bằng `dismiss(animated:)`.
  - **Storyboard & Segue:** File giao diện trực quan chứa nhiều màn hình và liên kết chuyển màn bằng `Segue` (`performSegue(withIdentifier:sender:)`).

## 4.4. Giao diện: View, Frame vs Bounds, Auto Layout, UIStackView, Custom View

- **UIView & Point:** `UIView` là thành phần cơ bản hiển thị trên màn hình và chứa các subviews. Đơn vị kích thước trong UIKit là **Point** (tự quy đổi sang Pixel dựa vào scale factor `@1x`, `@2x`, `@3x` của màn hình Retina).
- **Phân biệt `Frame` vs `Bounds`:**
  - **`frame`:** Vị trí `(x, y)` và kích thước `(width, height)` của view tính theo **hệ tọa độ của Superview (Parent view)**. Dùng khi muốn đặt vị trí view so với view cha hoặc chỉnh kích thước bên ngoài.
  - **`bounds`:** Vị trí `(x, y)` (mặc định `(0, 0)`) và kích thước `(width, height)` của view tính theo **hệ tọa độ của chính nó**.
  - **Lưu ý quan trọng:**
    1. Khi thay đổi `bounds.origin` (như trong `UIScrollView`), nội dung/subviews bên trong sẽ dịch chuyển tương đối so với khung view.
    2. Khi áp dụng **transform** (xoay `rotation`, phóng to `scale`), giá trị **`frame` sẽ thay đổi** thành hình chữ nhật bao ngoài (*bounding box*), còn **`bounds` giữ nguyên kích thước gốc thực tế** của view.
- **Auto Layout & Broken Constraints:**
  - Auto Layout tự động tính toán vị trí và kích thước của mọi view dựa trên hệ thống các ràng buộc (*constraints*) để hiển thị chuẩn trên mọi kích thước màn hình.
  - Công thức tuyến tính của `NSLayoutConstraint`:
    $$\text{item1.attribute1} = \text{multiplier} \times \text{item2.attribute2} + \text{constant}$$
  - Khi code bằng tay thường dùng **`NSLayoutAnchor`** (như `view.topAnchor.constraint(equalTo: ...)`).
  - **Constraint is "broken":** Xảy ra khi các ràng buộc **xung đột với nhau** (không thể đồng thời thỏa mãn, ví dụ 1 view vừa bắt `width == 100` vừa bắt `width == 200` cùng độ ưu tiên `1000`). Hệ thống sẽ tự động phá vỡ (bỏ qua) một ràng buộc để giải hệ phương trình và in log cảnh báo `Unable to simultaneously satisfy constraints`.
- **UIStackView:** Sắp xếp hàng loạt subviews theo chiều dọc hoặc ngang qua `arrangedSubviews`. 4 thuộc tính cốt lõi:
  - `axis`: Hướng xếp (`.vertical` / `.horizontal`).
  - `alignment`: Căn lề **vuông góc** với `axis` (`.fill`, `.leading`, `.center`, `.trailing`...).
  - `distribution`: Cách phân bổ kích thước **dọc theo** `axis` (`.fill`, `.fillEqually`, `.fillProportionally`, `.equalSpacing`, `.equalCentering`).
  - `spacing`: Khoảng cách giữa các view liền kề.
- **Custom View:** Là view tự thiết kế để tái sử dụng nhiều nơi. Có 2 cách tạo chính:
  1. **Only Code:** Subclass `UIView`, override `init(frame:)`, setup subviews và constraints bằng code.
  2. **File XIB + Class:** Thiết kế giao diện trên `.xib`, liên kết với class `UIView`, load giao diện bằng `Bundle.main.loadNibNamed(...)` trong `init(frame:)` và `init?(coder:)`.

## 4.5. UITableView & UICollectionView (Cơ bản & Nâng cao)

- **So sánh `UITableView` vs `UICollectionView`:**

| Tiêu chí | `UITableView` | `UICollectionView` |
| :--- | :--- | :--- |
| **Hướng cuộn** | Chỉ cuộn **dọc** (vertical). | Cuộn được **cả dọc và ngang** (hoặc cả hai chiều). |
| **Số cột & Layout** | Chỉ có **1 cột**, chiều rộng cell cố định theo tableView. | Hỗ trợ **nhiều cột**, tự do tùy biến layout qua `UICollectionViewLayout` / `CompositionalLayout`. |
| **Đường ngăn cách (Separator)** | Hỗ trợ sẵn separator giữa các row. | Không có sẵn, phải tự vẽ nếu cần. |
| **Phân nhóm (Section)** | Header & Footer cho mỗi section + Table Header/Footer. | Supplementary Views (`UICollectionReusableView`) cho Header, Footer, Decoration views. |

- **Cơ chế Dequeue / Reuse Cell (`dequeueReusableCell(withIdentifier:for:)`):**
  - **Cách hoạt động:** Thay vì khởi tạo 1.000 cell cho 1.000 dòng dữ liệu, `UITableView`/`UICollectionView` chỉ tạo một lượng cell vừa đủ hiển thị trên màn hình (cộng thêm vài cell đệm). Khi người dùng cuộn, các cell trượt ra khỏi vùng nhìn thấy được đưa vào hàng đợi tái sử dụng (*reuse pool*) để cấp phát lại cho các dòng mới sắp hiện lên.
  - **Lợi ích:** Tiết kiệm tối đa bộ nhớ RAM (tránh spike/crash), giảm số lượng view/layer phải render, giúp thao tác cuộn mượt mà (60/120 fps).
  - **Lỗi hay gặp & Cách khắc phục:** Khi cuộn nhanh kết hợp tải ảnh bất đồng bộ (mạng chậm), cell tái sử dụng có thể hiển thị nhầm ảnh/dữ liệu cũ của dòng trước đó.
    - *Khắc phục:* Override **`prepareForReuse()`** trong subclass Cell để reset trạng thái (`imageView.image = nil`, hủy task tải ảnh cũ), đồng thời kiểm tra lại `indexPath` hoặc URL trước khi gán ảnh khi tải xong.
  - Lưu ý: Phải gọi `register(_:forCellReuseIdentifier:)` (hoặc đặt Reuse Identifier trên Storyboard) trước khi `dequeue`.

- **Kỹ thuật nâng cao với TableView & CollectionView:**
  - **Pull to refresh:** Gắn `UIRefreshControl` vào `tableView.refreshControl`.
  - **Thêm / Xóa / Cập nhật dòng & section:** Dùng `beginUpdates()` ... `endUpdates()` (hoặc `performBatchUpdates` cho animation mượt mà; trong iOS hiện đại dùng `DiffableDataSource`). Lưu ý phải cập nhật mảng dữ liệu (Model) khớp với số lượng dòng thêm/xóa trước khi gọi `insertRows`/`deleteRows` để tránh crash `NSInternalInconsistencyException`.
  - **Swipe to delete:** Implement `trailingSwipeActionsConfigurationForRowAt` (hoặc `commit editingStyle`).
  - **Multi-type cell:** Khai báo `enum RowType` cho các loại cell khác nhau, đăng ký nhiều cell identifier và dùng `switch case` trong `cellForRowAt`.
  - **Custom Layout CollectionView:** Subclass `UICollectionViewLayout` (hoặc `UICollectionViewFlowLayout` / `UICollectionViewCompositionalLayout`) để tùy chỉnh kích thước, vị trí từng item, header/footer (`UICollectionReusableView`).

## 4.6. Animation & Core Graphics
- **`UIView.animate`:** Hỗ trợ animate các thuộc tính như `frame`, `bounds`, `center`, `transform` (scale, rotation, translation), `backgroundColor`, `alpha`.
  - **Spring animation:** `UIView.animate(withDuration:delay:usingSpringWithDamping:initialSpringVelocity:...)` tạo hiệu ứng đàn hồi/rung nhẹ tự nhiên.
  - **`UIView.animateKeyframes`:** Kết hợp nhiều giai đoạn animation nối tiếp hoặc xen kẽ nhau theo khung thời gian tương đối.
- **Core Animation Timing Curves:**
  - `curveEaseIn`: Bắt đầu chậm, nhanh dần.
  - `curveEaseOut`: Bắt đầu nhanh, chậm dần khi kết thúc.
  - `curveEaseInOut`: Chậm lúc đầu, nhanh ở giữa, chậm dần về cuối.
  - `curveLinear`: Tốc độ đều từ đầu đến cuối.
- **Core Graphics:** Làm việc với các cấu trúc hình học 2D cơ bản: `CGPoint(x, y)`, `CGSize(width, height)`, `CGRect(origin, size)`, vẽ đồ họa custom trong `draw(_ rect: CGRect)`.


---

[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 3. Quản lý bộ nhớ (ARC & Memory Management)](./03-ARC-va-Memory-Management.md) | [Bài tiếp: 5. Lưu trữ dữ liệu (Persistence) & Hệ thống File iOS ›](./05-Persistence-va-File-System.md)
