[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 8. Networking, Bảo mật, Reactive (RxSwift), Debug, Unit Test & Công cụ](./08-Networking-RxSwift-Debug-UnitTest.md)

---

# 9. Bài Tập Thực Hành & Live Coding Phỏng Vấn iOS

## Bài tập 1: Bài toán "CDG Zig" (Biến thể FizzBuzz)
*(Nguồn: `CDG_iOS_Questions.docx`, `Swift.docx`)*

- **Đề bài:** Viết chương trình in các số từ `1` đến `100`. Với số chia hết cho `3` in `"Zig"`, chia hết cho `5` in `"CDG"`, chia hết cho cả `3` và `5` in `"CDG Zig"`, các số còn lại in chính số đó.
- **Lưu ý bẫy phỏng vấn:** Điều kiện chia hết cho **cả 3 và 5** (`i % 3 == 0 && i % 5 == 0` hay `i % 15 == 0`) **bắt buộc phải đặt lên đầu tiên** trong chuỗi `if - else if`. Nếu đặt `i % 3 == 0` trước thì các số như `15, 30` sẽ rơi vào nhánh `"Zig"` và bỏ qua nhánh `"CDG Zig"`.

```swift
for i in 1...100 {
    if i % 3 == 0 && i % 5 == 0 {
        print("CDG Zig")
    } else if i % 3 == 0 {
        print("Zig")
    } else if i % 5 == 0 {
        print("CDG")
    } else {
        print(i)
    }
}
```

---

## Bài tập 2: Tìm chuỗi xuất hiện nhiều nhất trong mảng (Most Frequent String)
*(Nguồn: `CDG_iOS_Questions.docx`, `Swift.docx`)*

- **Đề bài:** Viết hàm nhận vào một mảng chuỗi `[String]`, trả về chuỗi xuất hiện nhiều lần nhất cùng số lần xuất hiện của nó.
  - *Ví dụ:* Input `["red", "yellow", "red", "green", "red"]` -> Output `("red", 3)`.
- **Phân tích:** Dùng `Dictionary [String: Int]` để đếm tần suất trong một lần duyệt $O(n)$, sau đó dùng `.max { $0.value < $1.value }` để tìm phần tử có tần suất lớn nhất. Độ phức tạp tổng thể: Thời gian $O(n)$, Không gian $O(k)$ (với $k$ là số chuỗi phân biệt).

```swift
func mostFrequentString(strings: [String]) -> (String, Int)? {
    guard !strings.isEmpty else { return nil }

    var counts: [String: Int] = [:]
    for str in strings {
        counts[str, default: 0] += 1
    }

    if let mostFrequent = counts.max(by: { $0.value < $1.value }) {
        return (mostFrequent.key, mostFrequent.value)
    }
    return nil
}

let input = ["red", "yellow", "red", "green", "red"]
if let result = mostFrequentString(strings: input) {
    print(result) // ("red", 3)
}
```

---

## Bài tập 3: Tìm cặp chuỗi xuất hiện nhiều nhất (Most Common Pair)
*(Nguồn: `CDG_iOS_Questions.docx`, `Swift.docx`)*

- **Đề bài:** Viết hàm nhận vào danh sách chuỗi `[String]`, tìm cặp chuỗi `(String, String)` xuất hiện nhiều nhất và số lần xuất hiện của cặp đó.
- **Phân tích & Cải tiến so với code gốc:**
  - Code gốc trong tài liệu ghép cặp thành chuỗi `"a,b"` rồi dùng `components(separatedBy: ",")` để tách lại — cách này sẽ **bị lỗi nếu bản thân chuỗi đầu vào có chứa dấu phẩy `","`** (ví dụ `"a,1"`).
  - **Cách chuẩn hơn:** Định nghĩa một `struct Pair: Hashable` làm Key cho Dictionary. Việc giữ lại cả bản gốc và bản tối ưu giúp bạn ghi điểm cao khi phỏng vấn.

```swift
// Cách tối ưu, an toàn (dùng Struct Pair: Hashable làm Key)
struct StringPair: Hashable {
    let first: String
    let second: String
}

func findMostCommonPair(strings: [String]) -> (String, String, Int)? {
    guard strings.count >= 2 else { return nil }

    var pairCounts: [StringPair: Int] = [:]
    for i in 0..<strings.count {
        for j in (i + 1)..<strings.count {
            let pair = StringPair(first: strings[i], second: strings[j])
            pairCounts[pair, default: 0] += 1
        }
    }

    guard let best = pairCounts.max(by: { $0.value < $1.value }) else {
        return nil
    }
    return (best.key.first, best.key.second, best.value)
}
```

---

## Bài tập 4: Tính số Fibonacci thứ n
*(Nguồn: `Swift.docx`)*

- **Đề bài:** Viết hàm tính số Fibonacci thứ $n$ (với $F(0) = 0, F(1) = 1, F(n) = F(n-1) + F(n-2)$).
- **Phân tích:**
  - **Cách 1 (Đệ quy thuần - trong file gốc):** Rất ngắn gọn nhưng độ phức tạp thời gian là $O(2^n)$ vì tính lặp lại cùng một nhánh con nhiều lần (với `n = 50` sẽ cực chậm).
  - **Cách 2 (Vòng lặp tối ưu - khuyên dùng khi phỏng vấn):** Độ phức tạp thời gian **$O(n)$**, bộ nhớ **$O(1)$**.

```swift
// Cách 1: Đệ quy cơ bản (O(2^n))
func fibonacciRecursive(n: Int) -> Int {
    if n <= 0 { return 0 }
    if n == 1 { return 1 }
    return fibonacciRecursive(n: n - 1) + fibonacciRecursive(n: n - 2)
}

// Cách 2: Vòng lặp tối ưu (Time: O(n), Space: O(1))
func fibonacciIterative(n: Int) -> Int {
    guard n > 0 else { return 0 }
    if n == 1 { return 1 }

    var prev = 0
    var curr = 1
    for _ in 2...n {
        let next = prev + curr
        prev = curr
        curr = next
    }
    return curr
}

print(fibonacciIterative(n: 10)) // 55
```

---

## Bài tập 5: Kiểm tra tổ hợp phím `SpecialActions.matchKeyCombo`
*(Nguồn: `Swift.docx` - Test 1)*

- **Đề bài:** Viết phương thức `SpecialActions.matchKeyCombo(sequence: String) -> Bool` kiểm tra xem trong chuỗi `sequence` (không phân biệt chữ hoa/thường), số lần xuất hiện tổ hợp `"QEE"` và tổ hợp `"ZCC"` có bằng nhau hay không.
- **Code trong tài liệu gốc & Phân tích Edge Case:**

```swift
public class SpecialActions {
    public static func matchKeyCombo(sequence: String) -> Bool {
        let lowercasedSequence = sequence.lowercased()
        let comboQEE = lowercasedSequence.components(separatedBy: "qee").count - 1
        let comboZCC = lowercasedSequence.components(separatedBy: "zcc").count - 1

        if comboQEE == comboZCC {
            return true
        } else if comboQEE == 0 || comboZCC == 0 {
            return false
        } else {
            return false
        }
    }
}

print(SpecialActions.matchKeyCombo(sequence: "QEEAZCC")) // true (1 == 1)
```

- **Lưu ý quan trọng khi phỏng vấn:**
  1. Trong code gốc, nhánh `if comboQEE == comboZCC` nằm trước nên nếu **cả hai đều bằng `0`** (chuỗi không chứa `"qee"` lẫn `"zcc"`, ví dụ `"ABC"`), hàm vẫn trả về `true` (nhánh `else if comboQEE == 0 || comboZCC == 0` thực tế chỉ chạy khi một cái bằng `0` và cái kia `> 0`, vốn gộp chung với `else return false`).
  2. Nếu đề bài yêu cầu *"phải có ít nhất 1 cặp hoặc bằng 0 thì trả về true/false"*, hãy hỏi lại interviewer để xác nhận điều kiện biên `sequence` không chứa tổ hợp nào (ví dụ `return comboQEE == comboZCC` nếu `0 == 0` tính là hợp lệ, hoặc thêm `guard comboQEE > 0 && comboZCC > 0 else { return false }` nếu bắt buộc phải xuất hiện).

---

## Bài tập 6: Thiết kế hệ thống Ấp trứng Rồng (`Reptile` / `FireDragon` / `ReptileEgg`)
*(Nguồn: `Swift.docx` - Test 2)*

- **Đề bài:**
  - Tạo `protocol Reptile` có hàm `lay() -> ReptileEgg`.
  - Tạo `class FireDragon` tuân thủ `Reptile`, khi `lay()` sẽ trả về một `ReptileEgg` có khả năng nở ra một `FireDragon` mới.
  - Tạo `class ReptileEgg` nhận closure `createReptile: @escaping () -> Reptile`. Khi gọi `hatch() throws -> Reptile` lần đầu sẽ nở ra `Reptile`; nếu gọi `hatch()` từ lần thứ 2 trở đi phải ném ra lỗi `AlreadyHatchedError.alreadyHatched`.
- **Phân tích lỗi tinh tế giữa code nháp gốc và chuẩn đề bài:**
  - Trong file nháp gốc, `ReptileEgg.init` gọi `reptile = createReptile()` ngay lúc khởi tạo trứng (chưa nở đã tạo con rồng), nên thực chất chưa cần `@escaping`.
  - **Cách làm chuẩn:** Lưu trữ closure `createReptile` trong thuộc tính `private let createReptile: () -> Reptile` (lúc này **bắt buộc phải có `@escaping`**) và **chỉ gọi `createReptile()` khi `hatch()` được gọi** — đúng với ý nghĩa *"trứng chỉ nở thành cá thể mới khi `hatch()` được gọi"*.

```swift
public enum AlreadyHatchedError: Error {
    case alreadyHatched
}

public protocol Reptile {
    func lay() -> ReptileEgg
}

public class FireDragon: Reptile {
    public init() {}

    public func lay() -> ReptileEgg {
        return ReptileEgg {
            return FireDragon()
        }
    }
}

public class ReptileEgg {
    private let createReptile: () -> Reptile
    private var hasHatched = false

    public init(createReptile: @escaping () -> Reptile) {
        self.createReptile = createReptile
    }

    public func hatch() throws -> Reptile {
        if hasHatched {
            throw AlreadyHatchedError.alreadyHatched
        }
        hasHatched = true
        return createReptile()
    }
}

// Kiểm tra
let fireDragon = FireDragon()
let egg = fireDragon.lay()
let babyDragon = try? egg.hatch()      // Thành công -> trả về FireDragon mới
let secondTry = try? egg.hatch()       // Thất bại -> ném AlreadyHatchedError.alreadyHatched
```

---

## Bài tập 7: Tìm và sửa lỗi Memory Leak (Retain Cycle) giữa Class A và Class B
*(Nguồn: Ảnh chụp màn hình trong `CDG_iOS_Questions.docx`)*

- **Đề bài:** Cho đoạn code sau, hãy phân tích lỗi và sửa lại cho đúng:

```swift
class A {
    var b = B()

    func doSomething() {
        b.didComplete = continueSomething
        b.doSomething()
    }

    func continueSomething() {
        print("Continue computing...")
    }

    deinit {
        print("got deallocated")
    }
}

class B {
    var didComplete: () -> Void = {}

    func doSomething() {
        print("doing something")
        sleep(2)
        didComplete()
    }
}
```

- **Phân tích lỗi:**
  1. **Retain Cycle (Memory Leak):** Khi gọi `a.doSomething()`, dòng `b.didComplete = continueSomething` gán trực tiếp tham chiếu của instance method `self.continueSomething` vào closure `b.didComplete`. Trong Swift, việc truyền trực tiếp một instance method như vậy sẽ **ngầm capture `self` (instance của `A`) dưới dạng `strong` reference**!
  2. Lúc này: **`A` giữ `strong` tới `b` (`var b = B()`)**, đồng thời **`b.didComplete` giữ `strong` ngược lại `A`**. Tạo thành vòng lặp tham chiếu (`A <-> B`). Khi đối tượng `A` hết vòng đời, `deinit` (`"got deallocated"`) sẽ **không bao giờ được gọi**.
  3. *(Điểm cộng thêm khi trả lời):* Hàm `sleep(2)` làm block hoàn toàn thread hiện tại trong 2 giây; nếu gọi trên Main Thread sẽ gây đơ UI. Trong thực tế nên chạy tác vụ nặng ở background queue rồi callback lại.

- **Cách sửa lỗi Memory Leak:** Dùng closure với capture list **`[weak self]`** thay vì truyền trực tiếp tên method `continueSomething`:

```swift
class A {
    var b = B()

    func doSomething() {
        b.didComplete = { [weak self] in
            self?.continueSomething()
        }
        b.doSomething()
    }

    func continueSomething() {
        print("Continue computing...")
    }

    deinit {
        print("got deallocated") // Sẽ được gọi bình thường khi instance A giải phóng
    }
}
```

---

## Bài tập 8: Đọc hiểu Code — Value Type & Copy-on-Write trên Array
*(Nguồn: `CDG_iOS_Questions.docx`)*

- **Đề bài:** Cho đoạn code sau, giá trị của `len` là bao nhiêu? Giải thích tại sao?

```swift
var array1 = [1, 2, 3, 4, 5]
var array2 = array1
array2.append(6)
var len = array1.count
```

- **Đáp án:** `len = 5`.
- **Giải thích:** Trong Swift, `Array` là kiểu **`Struct` (Value Type)**. Khi gán `var array2 = array1`, `array2` hoạt động độc lập về mặt giá trị với `array1`. Nhờ cơ chế tối ưu **Copy-on-Write (CoW)** của Swift, lúc mới gán cả hai tạm dùng chung vùng nhớ đệm, nhưng ngay khi `array2.append(6)` làm thay đổi dữ liệu của `array2`, Swift tự động sao chép sang vùng nhớ mới cho `array2`. Do đó `array1` hoàn toàn không bị thay đổi và vẫn có `5` phần tử.

---

## Bài tập 9: Đọc hiểu Code — Higher-Order Functions (`sorted` + `map`) trên Array Tuple & Dictionary
*(Nguồn: Văn bản & Ảnh chụp màn hình trong `CDG_iOS_Questions.docx`)*

- **Câu 9a (Mảng Tuple):** Kết quả của `x` là gì?

```swift
let array = [("1", 1), ("2", 3), ("3", 2)]
let x = array.sorted { $0.1 < $1.1 }.map { $0.0 }
```

- **Đáp án 9a:** `x = ["1", "3", "2"]` (kiểu `[String]`).
  - *Giải thích:* `sorted { $0.1 < $1.1 }` sắp xếp các tuple tăng dần theo phần tử thứ hai (`1 < 2 < 3`) -> `[("1", 1), ("3", 2), ("2", 3)]`. Sau đó `.map { $0.0 }` lấy phần tử đầu tiên của mỗi tuple -> `["1", "3", "2"]`.

- **Câu 9b (Dictionary — từ ảnh chụp màn hình):** Cho đoạn code sau, kiểu dữ liệu và giá trị đúng của `x` là gì?

```swift
let d = ["john": 23, "james": 24, "vincent": 34, "louis": 29]
let x = d.sorted { $0.1 < $1.1 }.map { $0.0 }
```

- **Đáp án 9b:**
  - **Kiểu dữ liệu của `x`:** `[String]` (Array of String).
  - **Giá trị đúng của `x`:** `["john", "james", "louis", "vincent"]`.
- **Cảnh báo bẫy từ tài liệu gốc:** Trong ảnh chụp màn hình gốc ở `CDG_iOS_Questions.docx` có ghi nhầm kết quả là `["vincent", "louis", "james", "john"]`. Đây là **kết quả sai** cho phép toán `<`:
  - Vì điều kiện trong closure là **`$0.1 < $1.1`** (sắp xếp **tăng dần** theo tuổi: `23 -> 24 -> 29 -> 34`), nên thứ tự đúng phải là `["john", "james", "louis", "vincent"]`.
  - Chỉ khi dùng dấu **`$0.1 > $1.1`** (sắp xếp **giảm dần**: `34 -> 29 -> 24 -> 23`) thì mới ra `["vincent", "louis", "james", "john"]`.
  - *(Lưu ý thêm: Khi gọi `.sorted` trên `Dictionary`, mỗi phần tử truyền vào closure là tuple `(key: Key, value: Value)`, nên `$0.0` là `key` và `$0.1` là `value`).*

---

## Bài tập 10: Tư duy Toán tử & Biểu thức Logic
*(Nguồn: `eyeOS Question.docx`)*

- **Câu 10a:** Theo thứ tự ưu tiên của máy tính, `1 + 2 * 3` bằng bao nhiêu?
  - **Đáp án:** **`7`**. Vì phép nhân `*` có độ ưu tiên cao hơn phép cộng `+`, nên máy tính thực hiện `2 * 3 = 6` trước, sau đó `1 + 6 = 7`.

- **Câu 10b:** `print(true && false || true || false && false)` in ra kết quả gì? Giải thích?
  - **Đáp án:** In ra **`true`**.
  - **Giải thích:**
    1. **Độ ưu tiên toán tử:** Toán tử AND (`&&`) có độ ưu tiên **cao hơn** toán tử OR (`||`), tương đương với việc nhóm ngoặc:
       `(true && false) || true || (false && false)`
    2. **Tính toán từng cụm & Short-circuit evaluation (Đánh giá đoản mạch):**
       - Cụm 1: `true && false` -> `false`.
       - Cụm 2: `false || true` -> **`true`**.
       - Vì gặp phép `||` mà vế trái đã là `true`, theo cơ chế **Short-circuit evaluation**, Swift có thể kết luận ngay toàn bộ biểu thức là **`true`** mà không cần xét tiếp vế sau (`false && false` vốn cũng là `false`).

---

## Bài tập 11: Các bài toán Thuật toán kinh điển trong phỏng vấn iOS
*(Nguồn: `eyeOS Question.docx`)*

### 11.1. Các thuật toán sắp xếp (Sorting Algorithms)
Các thuật toán sắp xếp phổ biến thường được hỏi trong phỏng vấn:

| Thuật toán | Độ phức tạp Thời gian (Trung bình) | Tệ nhất | Bộ nhớ (Space) | Đặc điểm nổi bật |
| :--- | :---: | :---: | :---: | :--- |
| **Bubble Sort** | $O(n^2)$ | $O(n^2)$ | $O(1)$ | So sánh từng cặp kề nhau và đổi chỗ để đẩy phần tử lớn về cuối. Dễ viết, chậm với mảng lớn. |
| **Selection Sort** | $O(n^2)$ | $O(n^2)$ | $O(1)$ | Mỗi lượt tìm phần tử nhỏ nhất ở phần chưa sắp xếp đưa lên đầu. |
| **Insertion Sort** | $O(n^2)$ | $O(n^2)$ | $O(1)$ | Chèn từng phần tử vào đúng vị trí trong phần đã sắp xếp (rất nhanh nếu mảng gần như đã sắp xếp sẵn). |
| **Merge Sort** | $O(n \log n)$ | $O(n \log n)$ | $O(n)$ | Chia để trị (Divide & Conquer), tách đôi mảng rồi trộn lại. Ổn định (stable), luôn là $O(n \log n)$ nhưng tốn thêm RAM. |
| **Quick Sort** | $O(n \log n)$ | $O(n^2)$ | $O(\log n)$ | Chọn phần tử chốt (*pivot*), phân hoạch nhỏ hơn sang trái, lớn hơn sang phải. Thực tế rất nhanh. |

*(Ngoài ra còn Heap Sort $O(n \log n)$, Timsort — thuật toán lai giữa Merge Sort & Insertion Sort được Swift sử dụng trong hàm `.sort()`).*

```swift
// Cài đặt Quick Sort bằng Swift
func quickSort(_ array: [Int]) -> [Int] {
    guard array.count > 1 else { return array }
    let pivot = array[array.count / 2]
    let less = array.filter { $0 < pivot }
    let equal = array.filter { $0 == pivot }
    let greater = array.filter { $0 > pivot }
    return quickSort(less) + equal + quickSort(greater)
}

// Cài đặt Merge Sort bằng Swift
func mergeSort(_ array: [Int]) -> [Int] {
    guard array.count > 1 else { return array }
    let mid = array.count / 2
    let left = mergeSort(Array(array[..<mid]))
    let right = mergeSort(Array(array[mid...]))
    return merge(left, right)
}

func merge(_ left: [Int], _ right: [Int]) -> [Int] {
    var result: [Int] = []
    var i = 0, j = 0
    while i < left.count && j < right.count {
        if left[i] <= right[j] {
            result.append(left[i])
            i += 1
        } else {
            result.append(right[j])
            j += 1
        }
    }
    if i < left.count { result.append(contentsOf: left[i...]) }
    if j < right.count { result.append(contentsOf: right[j...]) }
    return result
}
```

### 11.2. Thuật toán Tìm kiếm nhị phân (Binary Search)
- **Điều kiện tiên quyết (Rất hay bị hỏi bẫy!):** Mảng đầu vào **BẮT BUỘC PHẢI ĐƯỢC SẮP XẾP TRƯỚC** (tăng dần hoặc giảm dần). Nếu chưa sắp xếp thì thuật toán không hoạt động đúng.
- **Nguyên lý:** So sánh giá trị cần tìm `target` với phần tử ở giữa (`mid`). Nếu bằng thì trả về `mid`; nếu nhỏ hơn thì tìm ở nửa trái; nếu lớn hơn thì tìm ở nửa phải. Độ phức tạp thời gian: **$O(\log n)$**, bộ nhớ: **$O(1)$**.

```swift
func binarySearch(_ sortedArray: [Int], target: Int) -> Int? {
    var left = 0
    var right = sortedArray.count - 1

    while left <= right {
        // Tránh tràn số (overflow) so với (left + right) / 2
        let mid = left + (right - left) / 2
        if sortedArray[mid] == target {
            return mid
        } else if sortedArray[mid] < target {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    return nil
}
```

### 11.3. Thuật toán "Tìm Lớp Trưởng" (Majority Element — Boyer-Moore Majority Vote)
- **Phát biểu bài toán:** Trong một lớp có $n$ học sinh, mỗi người bỏ phiếu cho một ứng viên. Tìm người nhận được **nhiều hơn $n/2$ số phiếu** (giả sử người đó tồn tại, hoặc kiểm tra lại xem có thực sự $> n/2$ hay không).
- **Ý tưởng tối ưu (Boyer-Moore):**
  - Duy trì 1 ứng viên `candidate` và biến đếm `count = 0`.
  - Khi `count == 0`, chọn phần tử hiện tại làm `candidate`.
  - Nếu phần tử tiếp theo giống `candidate` -> `count += 1`; khác -> `count -= 1` (triệt tiêu từng cặp phiếu khác nhau).
  - Người chiến thắng thực sự (> $n/2$ phiếu) chắc chắn sẽ là `candidate` còn sót lại cuối cùng. Kiểm tra lại một vòng để xác nhận `occurrences > n / 2`.
- **Độ phức tạp:** Thời gian **$O(n)$**, Không gian **$O(1)$** (tối ưu hơn nhiều so với dùng Dictionary $O(n)$ bộ nhớ hay sort $O(n \log n)$).

```swift
func findClassMonitor(votes: [Int]) -> Int? {
    guard !votes.isEmpty else { return nil }

    var candidate = votes[0]
    var count = 0

    // Bước 1: Tìm ứng viên tiềm năng
    for vote in votes {
        if count == 0 {
            candidate = vote
            count = 1
        } else if vote == candidate {
            count += 1
        } else {
            count -= 1
        }
    }

    // Bước 2: Xác minh ứng viên có thực sự chiếm > n/2 phiếu hay không
    let totalVotes = votes.filter { $0 == candidate }.count
    return totalVotes > votes.count / 2 ? candidate : nil
}
```

### 11.4. Bài toán tìm chuỗi con trong chuỗi mẹ (Substring Search)
- **Đề bài:** Cho chuỗi mẹ `haystack` và chuỗi con `needle`, tìm vị trí (index) xuất hiện đầu tiên của `needle` trong `haystack` (trả về `-1` hoặc `nil` nếu không tìm thấy), tự cài đặt không phụ thuộc `.range(of:)`.

```swift
func findSubstringIndex(haystack: String, needle: String) -> Int? {
    let hChars = Array(haystack)
    let nChars = Array(needle)

    if nChars.isEmpty { return 0 }
    guard hChars.count >= nChars.count else { return nil }

    for i in 0...(hChars.count - nChars.count) {
        var matched = true
        for j in 0..<nChars.count {
            if hChars[i + j] != nChars[j] {
                matched = false
                break
            }
        }
        if matched {
            return i
        }
    }
    return nil
}
```
*(Ghi chú: Độ phức tạp cách duyệt trực tiếp là $O(n \times m)$. Nếu cần tối ưu xuống $O(n + m)$ trong phỏng vấn chuyên sâu có thể dùng thuật toán KMP - Knuth-Morris-Pratt).*

### 11.5. Thuật toán tìm đường đi ngắn nhất (Shortest Path)
Tùy vào loại đồ thị (graph) mà chọn thuật toán phù hợp:
1. **Đồ thị không trọng số (Unweighted Graph):** Dùng **BFS (Breadth-First Search - Tìm kiếm theo chiều rộng)** với `Queue` -> đảm bảo tìm được đường đi ít cạnh nhất với độ phức tạp $O(V + E)$.
2. **Đồ thị có trọng số không âm (Non-negative Weighted Graph):** Dùng **Thuật toán Dijkstra** (tham lam luôn chọn đỉnh chưa xét có khoảng cách ngắn nhất từ đỉnh nguồn để cập nhật cho các đỉnh kề — *Relaxation*).
3. **Đồ thị có trọng số âm:** Dùng **Bellman-Ford**.

```swift
// Minh họa thuật toán Dijkstra tìm khoảng cách ngắn nhất từ đỉnh start (Đồ thị trọng số không âm)
func dijkstra(graph: [String: [(node: String, weight: Int)]], start: String) -> [String: Int] {
    var distances: [String: Int] = [start: 0]
    var unvisited = Set(graph.keys)

    while !unvisited.isEmpty {
        // Chọn đỉnh chưa thăm có khoảng cách nhỏ nhất hiện tại
        guard let current = unvisited.min(by: {
            (distances[$0] ?? Int.max) < (distances[$1] ?? Int.max)
        }), let currentDist = distances[current], currentDist < Int.max else {
            break
        }

        unvisited.remove(current)

        for edge in graph[current] ?? [] {
            let newDist = currentDist + edge.weight
            if newDist < (distances[edge.node] ?? Int.max) {
                distances[edge.node] = newDist
            }
        }
    }
    return distances
}

// Ví dụ sử dụng
let roadMap: [String: [(String, Int)]] = [
    "A": [("B", 4), ("C", 2)],
    "B": [("C", 5), ("D", 10)],
    "C": [("B", 1), ("D", 8)],
    "D": []
]
print(dijkstra(graph: roadMap, start: "A"))
// ["A": 0, "C": 2, "B": 3 (qua A->C->B), "D": 10 (qua A->C->D)]
```


---

[← Mục lục My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Bài trước: 8. Networking, Bảo mật, Reactive (RxSwift), Debug, Unit Test & Công cụ](./08-Networking-RxSwift-Debug-UnitTest.md)
