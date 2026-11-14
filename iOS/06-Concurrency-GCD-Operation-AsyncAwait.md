[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 5. Lưu trữ dữ liệu (Persistence) & Hệ thống File iOS](./05-Persistence-va-File-System.md) | [Bài tiếp: 7. Kiến trúc phần mềm (Architecture) & Design Patterns ›](./07-Architecture-va-Design-Patterns.md)

---

# 6. Đa luồng & Bất đồng bộ (Concurrency: GCD, Operation, Swift Concurrency)

## 6.1. Các khái niệm nền tảng
- **Process (Tiến trình):** Một chương trình đang chạy (ví dụ cả ứng dụng iOS), sở hữu không gian bộ nhớ riêng. Một Process có 1 hoặc nhiều Thread.
- **Thread (Luồng thực thi):** Đơn vị nhỏ nhất của CPU thực thi các chỉ thị (task). Các thread trong cùng một app dùng chung vùng nhớ Heap nhưng có Stack riêng.
- **Task:** Một khối công việc/đoạn mã cần được thực thi.
- **Main Thread:** Luồng chính của ứng dụng, nơi xử lý sự kiện người dùng và **cập nhật giao diện (UIKit / SwiftUI)**. **Quy tắc sống còn:** Mọi thao tác cập nhật UI **bắt buộc phải chạy trên Main Thread**; nếu chạy tác vụ nặng (tải mạng, decode ảnh lớn) trên Main Thread sẽ làm đơ/treo giao diện (UI freeze) và thậm chí bị Watchdog kill app.
- **Concurrency (Đồng thời) vs Parallelism (Song song):**
  - **Concurrency:** Nhiều tác vụ có thể bắt đầu, chạy xen kẽ (context switching trên 1 hoặc nhiều nhân CPU) và hoàn thành trong những khoảng thời gian gối đầu lên nhau.
  - **Parallelism:** Nhiều tác vụ thực sự chạy **cùng một thời điểm** trên nhiều nhân (cores) CPU khác nhau.
- **Synchronous (`sync`) vs Asynchronous (`async`):**
  - **`sync` (Đồng bộ):** **Khóa (block) luồng hiện tại** đang gọi nó cho đến khi task bên trong chạy xong hoàn toàn mới trả quyền điều khiển để chạy dòng code tiếp theo.
  - **`async` (Bất đồng bộ):** **Trả quyền điều khiển ngay lập tức** cho luồng hiện tại mà không cần đợi task hoàn thành -> không làm block luồng gọi.
- **Phân biệt `Thread` vs `DispatchQueue`:**
  - `Thread` là công cụ đa luồng ở cấp hệ điều hành (chi phí tạo và quản lý context switching cao nếu tự quản lý thủ công).
  - `DispatchQueue` là lớp trừu tượng cấp cao của GCD hoạt động theo cơ chế **FIFO** và **thread-safe**; lập trình viên chỉ cần đưa task vào Queue, GCD sẽ tự động quản lý một pool các Thread ở tầng dưới để thực thi tối ưu.

## 6.2. Grand Central Dispatch (GCD)
GCD là thư viện C cấp thấp của Apple giúp quản lý thực thi đồng thời thông qua các **Dispatch Queue (FIFO)**.

- **2 loại hành vi của Queue:**
  - **Serial Queue (Tuần tự):** Tại một thời điểm chỉ thực thi **duy nhất 1 task**; task trước kết thúc thì task sau mới bắt đầu. Rất hay dùng để đồng bộ truy cập tài nguyên chung, ngăn ngừa Race Condition.
  - **Concurrent Queue (Đồng thời):** Có thể khởi chạy **nhiều task gần như cùng lúc** trên nhiều thread khác nhau. Các task vẫn **bắt đầu** theo thứ tự FIFO, nhưng có thể **kết thúc** theo thứ tự bất kỳ.

- **3 loại DispatchQueue:**
  1. **`DispatchQueue.main`:** Là một **Serial Queue** duy nhất gắn với Main Thread -> chuyên dùng để cập nhật UI.
  2. **`DispatchQueue.global(qos:)`:** Các **Concurrent Queue** có sẵn của hệ thống chạy ở nền (background), phân chia theo 5 mức độ ưu tiên **QoS (Quality of Service)** từ cao xuống thấp:
     - `.userInteractive`: Cao nhất — việc cần phản hồi ngay lập tức liên quan trực tiếp tới trải nghiệm UI mượt mà (animation, tính toán giao diện).
     - `.userInitiated`: Việc do người dùng chủ động kích hoạt và cần kết quả sau vài giây (mở tài liệu, bấm nút tải dữ liệu hiển thị ngay).
     - `.default`: Mức mặc định nằm giữa `.userInitiated` và `.utility` (thường không cần chỉ định tường minh).
     - `.utility`: Tác vụ chạy hơi lâu, thường đi kèm thanh tiến trình (tải file, tính toán dữ liệu lớn, đồng bộ API).
     - `.background`: Thấp nhất — tác vụ chạy ngầm người dùng không nhìn thấy (backup dữ liệu, dọn cache, prefetch).
     - *(Ngoài ra còn `.unspecified` để tương thích các API legacy).*
  3. **Custom Queue:** Queue tự tạo (`DispatchQueue(label: "com.app.myqueue", attributes: .concurrent)`). Mặc định nếu không truyền `attributes: .concurrent` thì là **Serial Queue**.

- **Các công cụ điều phối nâng cao trong GCD:**
  - **`DispatchGroup`:** Gom nhiều task bất đồng bộ (có thể ở nhiều queue khác nhau) và nhận thông báo khi **tất cả đã hoàn thành**.
    - Dùng `group.enter()` trước khi bắt đầu mỗi task bất đồng bộ và `group.leave()` khi xong (**bắt buộc số lần `enter` phải bằng `leave`**, nếu lệch sẽ crash hoặc treo mãi).
    - Dùng `group.notify(queue: .main) { ... }` để chạy code sau khi xong hết, hoặc `group.wait()` / `group.wait(timeout:)` để block luồng hiện tại chờ *(không gọi `wait()` trên Main Thread)*.
  - **`DispatchWorkItem`:** Đóng gói một khối code thành đối tượng có thể chạy hoặc hủy bằng `workItem.cancel()` *(lưu ý: chỉ hủy tự động nếu task chưa bắt đầu chạy; nếu đang chạy phải tự kiểm tra `workItem.isCancelled` bên trong)*. Hỗ trợ `workItem.notify(queue:)`.
  - **`DispatchBarrier` (`flags: .barrier`):** Khi gửi một task ghi dữ liệu kèm `.barrier` vào **Custom Concurrent Queue** (không dùng trên Global Queue), GCD sẽ đợi các task đọc trước đó chạy xong, thực thi task barrier **một mình** như serial, rồi mới cho các task đọc tiếp theo chạy song song tiếp -> Rất chuẩn cho bài toán **Multiple Readers - Single Writer**.
  - **`DispatchSemaphore`:** Giới hạn tối đa $N$ thread được truy cập cùng lúc vào một tài nguyên. Khởi tạo `DispatchSemaphore(value: N)`, gọi `semaphore.wait()` (giảm bộ đếm đi 1, nếu $< 0$ thì đợi) và `semaphore.signal()` (tăng bộ đếm lên 1 khi xong).

- **Các vấn đề thường gặp trong Đa luồng & Cách khắc phục:**

| Vấn đề | Định nghĩa | Cách khắc phục |
| :--- | :--- | :--- |
| **Race Condition & Critical Section** | Nhiều thread cùng truy cập vào đoạn mã/tài nguyên dùng chung (*Critical Section*), trong đó có ít nhất 1 thread **ghi dữ liệu**, dẫn đến sai lệch kết quả hoặc crash bộ nhớ. | Dùng **Mutual Exclusion** (khóa `NSLock`, `os_unfair_lock`), **Serial Queue**, **Dispatch Barrier**, hoặc **Actor** trong Swift Concurrency. |
| **Deadlock (Tắc nghẽn)** | Hai hoặc nhiều thread/queue **đợi lẫn nhau** giải phóng tài nguyên/khóa mãi mãi -> app đứng hình hoặc crash. Ví dụ kinh điển: gọi `DispatchQueue.main.sync { ... }` ngay khi đang chạy trên Main Thread! | Không gọi `.sync` lên chính queue hiện tại (đặc biệt là `main.sync` từ main thread); thống nhất thứ tự khóa tài nguyên; dùng `.async` khi không cần chờ. |
| **Priority Inversion** | Tác vụ có QoS thấp đang giữ một tài nguyên/lock khiến tác vụ có QoS cao phải ngồi chờ tác vụ thấp chạy xong trước. | Phân chia đúng mức QoS cho các tác vụ liên quan, tránh để queue ưu tiên cao `wait` trên tài nguyên bị giữ bởi queue ưu tiên thấp (hoặc dựa vào cơ chế nâng ưu tiên tự động của GCD/Lock). |

## 6.3. Operation & OperationQueue
- **Operation:** Là một lớp trừu tượng (xây dựng trên GCD) đóng gói một đơn vị công việc hướng đối tượng. Không dùng trực tiếp `Operation` mà dùng **`BlockOperation`** hoặc **subclass `Operation`** (override hàm `main()`).
- **4 Trạng thái vòng đời của Operation (read-only):**
  1. `isReady`: Đã sẵn sàng thực thi (tất cả dependencies đã xong).
  2. `isExecuting`: Đang thực thi.
  3. `isFinished`: Đã hoàn thành.
  4. `isCancelled`: Đã bị gọi `cancel()`. *(Lưu ý: Gọi `cancel()` chỉ bật cờ `isCancelled = true`; khi tự viết subclass phải tự kiểm tra `if isCancelled { return }` bên trong `main()`, và một operation đã ở trạng thái `isFinished` hoặc `isCancelled` thì không thể chạy lại).*
- **`OperationQueue`:**
  - `maxConcurrentOperationCount`: Giới hạn số operation chạy đồng thời (`= 1` sẽ biến nó thành Serial Queue).
  - `addOperation(_:)` / `addOperations(_:waitUntilFinished:)`: Thêm tác vụ vào hàng đợi (tự động xóa khỏi queue sau khi xong).
  - `addDependency(_:)`: Thiết lập phụ thuộc giữa các operation (Operation B chỉ chạy sau khi Operation A hoàn thành) — điểm mạnh vượt trội so với GCD thuần.
  - `isSuspended`: Tạm dừng việc bắt đầu các operation mới trong hàng đợi (`cancelAllOperations()` để hủy toàn bộ).

- **Khi nào chọn `GCD` vs `OperationQueue`?**
  - Dùng **GCD** cho các tác vụ bất đồng bộ gọn nhẹ, đơn giản, hiệu năng cao (gọi network rồi đẩy về main thread update UI).
  - Dùng **OperationQueue** khi cần quản lý sâu vòng đời task: thiết lập **dependency phức tạp giữa các task**, giới hạn `maxConcurrentOperationCount`, **hủy/tạm dừng** hàng loạt task đang xếp hàng, hoặc theo dõi trạng thái KVO (`isExecuting`, `isFinished`).

## 6.4. Swift Concurrency hiện đại (`async/await`, `Task`, `TaskGroup`, `Actor`)
- **`async` / `await`:** Cho phép viết code bất đồng bộ tuần tự, dễ đọc như code đồng bộ, loại bỏ "callback hell" (lồng nhiều closure) và giảm lỗi quên gọi completion handler.
- **`Task`:** Tạo ra một đơn vị công việc bất đồng bộ có thể chạy đồng thời, hỗ trợ hủy có cấu trúc (`task.cancel()`, `Task.isCancelled`) và truyền mức độ ưu tiên (`TaskPriority`).
- **`TaskGroup` (`withTaskGroup` / `withThrowingTaskGroup`):** Cho phép tạo động một nhóm các `Task` con chạy song song, thu thập kết quả và đợi tất cả hoàn thành (Structured Concurrency — tự động hủy các task con nếu task cha bị hủy hoặc ném lỗi).
- **`Actor`:** Là một **Reference Type** mới trong Swift giúp **cô lập trạng thái (state isolation)**. Mỗi `actor` bảo vệ các dữ liệu nội bộ của nó bằng cách chỉ cho phép **1 tác vụ truy cập vào state của nó tại một thời điểm** (bên ngoài muốn đọc/ghi property hoặc gọi method của actor phải dùng `await`). Nhờ vậy loại bỏ hoàn toàn **Data Race** ở mức trình biên dịch. (`@MainActor` là một global actor đặc biệt đảm bảo code luôn chạy trên Main Thread để cập nhật UI).


---

[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 5. Lưu trữ dữ liệu (Persistence) & Hệ thống File iOS](./05-Persistence-va-File-System.md) | [Bài tiếp: 7. Kiến trúc phần mềm (Architecture) & Design Patterns ›](./07-Architecture-va-Design-Patterns.md)
