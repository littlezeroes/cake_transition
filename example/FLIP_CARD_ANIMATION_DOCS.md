# Card Flip Animation - Technical Documentation

## Tổng quan

Animation lật card 3D với hiệu ứng co/nở, sử dụng perspective transform và dual-controller system.

## 1. Ý tưởng cơ bản

Tưởng tượng bạn cầm 1 tấm card và lật nó:
- Card xoay 180° (nửa vòng tròn)
- Trong lúc xoay, card "co lại" một chút rồi "nở ra" (giống như bóp card)

## 2. Hai Controller độc lập

### A. Rotation Controller (xoay card)

```dart
⏱️ Thời gian: 1000ms (1 giây)
🔄 Làm gì: Xoay card từ 0° → 180° (hoặc ngược lại)
```

**Cách hoạt động:**
- Click 1: `0° → -180°` (lật ngược)
- Click 2: `-180° → -360°` (lật tiếp)
- Click 3: `-360° → -540°` (cứ thế...)

**Tại sao dùng số âm?** Để xoay ngược chiều kim đồng hồ.

**Curve: Power2.easeInOut**
```
Cubic(0.455, 0.03, 0.515, 0.955)
```
- Đầu: chậm (khởi động nhẹ)
- Giữa: nhanh (xoay mượt)
- Cuối: chậm (dừng mềm)

### B. Z-depth Controller (co/nở card)

```dart
⏱️ Thời gian: 500ms (nửa thời gian xoay)
📏 Làm gì: Co nhỏ card rồi nở lại
```

**Timeline:**
```
0ms           225ms         500ms
scale=1   →   scale=0.92   →   scale=1
(bình thường)   (nhỏ nhất)    (về lại)
```

**Tại sao 45% - 55%?**
- 45% đầu: co vào (nhanh hơn)
- 55% sau: nở ra (chậm hơn một chút)

**TweenSequence:**
```dart
TweenSequenceItem(
  tween: Tween(begin: 1.0, end: 0.92)
    .chain(CurveTween(curve: Curves.easeInOut)),
  weight: 45,
),
TweenSequenceItem(
  tween: Tween(begin: 0.92, end: 1.0)
    .chain(CurveTween(curve: Curves.easeOut)),
  weight: 55,
),
```

## 3. Matrix Transform (phép biến đổi 3D)

```dart
final matrix = Matrix4.identity()
  ..setEntry(3, 2, 0.001)         // [1] Perspective
  ..rotateY(rotation)              // [2] Xoay
  ..scale(zScale, zScale*0.95, 1); // [3] Co/nở
```

### [1] Perspective = 0.001

- Tạo cảm giác 3D (xa/gần)
- Giống như nhìn qua camera
- `0.001 = 1/1000` (khoảng cách camera = 1000)

**Ví dụ:**
- Perspective nhỏ (0.002): 3D rõ, biến dạng nhiều
- Perspective lớn (0.0005): 3D nhẹ, gần 2D

### [2] RotateY (xoay quanh trục Y)

```
     Y (trục dọc)
     ↑
     |
     |____→ X
    /
   / Z
```

Card xoay quanh trục Y như lật trang sách.

**Cumulative Rotation:**
```dart
_currentRotation = 0
Click 1: _currentRotation = -180°
Click 2: _currentRotation = -360°
Click 3: _currentRotation = -540°
...
```

### [3] Scale (co/nở)

```dart
scaleX = zScale        // Co ngang: 1.0 → 0.92 → 1.0
scaleY = zScale * 0.95 // Co dọc nhiều hơn: 1.0 → 0.874 → 0.95
scaleZ = 1.0           // Độ dày không đổi
```

**Tại sao scaleY nhỏ hơn?**
- Giảm chiều cao để tránh card chạm cạnh màn hình
- 0.95 = giảm 5% chiều cao

## 4. Backface Visibility (ẩn mặt sau)

```dart
normalizedRotation = (rotation % (2 * π)).abs()
isShowingFront = normalizedRotation < π/2 || normalizedRotation > 3π/2
```

**Giải thích:**
```
Rotation    Normalized    Face Showing
0°      →   0°        →   Front ✅
90°     →   90°       →   Switching...
180°    →   180°      →   Back ✅
270°    →   270°      →   Switching...
360°    →   0°        →   Front ✅
-180°   →   180°      →   Back ✅
-360°   →   0°        →   Front ✅
```

**Implementation:**
```dart
frontOpacity = isShowingFront ? 1.0 : 0.0
backOpacity = isShowingFront ? 0.0 : 1.0
```

## 5. Timeline Tổng Hợp

```
User clicks card
      ↓
┌──────────────────────────────────────┐
│ Rotation Animation: 1000ms           │
│ ├─ 0-100ms: Ease in (chậm)          │
│ ├─ 100-900ms: Fast rotation         │
│ └─ 900-1000ms: Ease out (chậm)      │
└──────────────────────────────────────┘
         Power2.easeInOut

┌─────────────────────────┐
│ Scale Animation: 500ms  │
│ ├─ 0-225ms: 1.0→0.92   │
│ └─ 225-500ms: 0.92→1.0 │
└─────────────────────────┘
    easeInOut + easeOut
    (Kết thúc nửa chừng rotation)
```

**Tại sao scale kết thúc sớm?**
- Card đã về kích thước bình thường khi rotation chưa xong
- Tránh cảm giác "co rút kéo dài"
- Animation nhìn smooth hơn

## 6. Shadow (bóng đổ)

```dart
Transform.scale(
  scale: 0.98, // Shadow nhỏ hơn card 2%
  child: Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 20,
          spreadRadius: 2,
          offset: Offset(0, 8),
        ),
      ],
    ),
  ),
)
```

**Đặc điểm:**
- Shadow áp dụng **cùng matrix transform** với card
- Xoay theo card
- Co/nở theo card
- Tạo cảm giác depth (chiều sâu)

## 7. Code Flow

### Khởi tạo (initState)

```dart
_rotationController = AnimationController(
  duration: Duration(milliseconds: 1000),
)

_zController = AnimationController(
  duration: Duration(milliseconds: 500),
)

_rotationAnimation = Tween(begin: 0, end: 0)
  .animate(CurvedAnimation(
    parent: _rotationController,
    curve: Cubic(0.455, 0.03, 0.515, 0.955),
  ))

_zAnimation = TweenSequence([
  // 0 → -100 (45%)
  // -100 → 0 (55%)
])
```

### Khi Click (toggleCard)

```dart
void toggleCard() {
  // 1. Tính góc đích
  targetRotation = _currentRotation - 180°

  // 2. Tạo animation mới với begin/end
  _rotationAnimation = Tween(
    begin: _currentRotation,
    end: targetRotation,
  ).animate(...)

  // 3. Cập nhật current rotation
  _currentRotation = targetRotation

  // 4. Chạy animations
  _rotationController.forward(from: 0)
  _zController.forward(from: 0)
}
```

### Render (build)

```dart
AnimatedBuilder(
  animation: merge([_rotationController, _zController]),
  builder: (context, child) {
    // 1. Lấy giá trị rotation và scale
    rotation = _rotationAnimation.value
    zScale = _zAnimation.value

    // 2. Tính mặt nào đang hiện
    isShowingFront = checkBackfaceVisibility(rotation)

    // 3. Tạo matrix transform
    matrix = perspective + rotateY + scale

    // 4. Render stack
    Stack([
      Shadow(matrix),
      FrontCard(matrix, opacity),
      BackCard(matrix, opacity),
    ])
  }
)
```

## 8. Comparison với Option A (iOS Spring)

| Feature | Current (Cubic) | Option A (Spring) |
|---------|----------------|-------------------|
| **Timing** | Fixed 1000ms | Physics-based ~1000ms |
| **Curve** | Cubic Bezier | Spring Simulation |
| **Predictability** | 100% predictable | Slightly variable |
| **Feel** | Mechanical, precise | Natural, organic |
| **Parameters** | `Cubic(0.455, 0.03, 0.515, 0.955)` | `stiffness=50, damping=14.14` |
| **Scale Logic** | TweenSequence (45%-55%) | Dynamic based on progress |
| **Opacity** | No fade | Subtle 1.0→0.95→1.0 |

## 9. Key Parameters

### Rotation
- **Duration**: 1000ms
- **Curve**: `Cubic(0.455, 0.03, 0.515, 0.955)` (Power2.easeInOut)
- **Angle**: ±180° per click

### Scale
- **Duration**: 500ms
- **Range**: 1.0 → 0.92 → 1.0 (8% shrink)
- **Timing**: 45% down, 55% up
- **Curves**: `easeInOut` (down), `easeOut` (up)

### Transform
- **Perspective**: 0.001 (distance = 1000)
- **Scale X**: `zScale`
- **Scale Y**: `zScale * 0.95` (5% shorter)
- **Scale Z**: 1.0

### Shadow
- **Scale**: 0.98 (2% smaller than card)
- **Opacity**: 0.15
- **Blur**: 20
- **Spread**: 2
- **Offset**: (0, 8)

## 10. Tóm tắt đơn giản

**Khi click card:**

```
1. Card bắt đầu xoay (chậm)          ← easeIn
   ↓
2. Đồng thời card co nhỏ 8%          ← easeInOut (225ms)
   ↓
3. Xoay nhanh ở giữa                 ← fast rotation
   ↓
4. Card nở ra về size bình thường    ← easeOut (275ms)
   ↓
5. Rotation tiếp tục (500-1000ms)
   ↓
6. Card dừng lại mượt mà             ← easeOut

Total: 1000ms
```

**Visual Timeline:**

```
Front (0°)
   ↓ [100ms] ease in + co lại
   ↓ [400ms] xoay nhanh + nở ra
   ↓ [500ms] xoay chậm dần
Back (180°)
```

## 11. Troubleshooting

### Card chạm màn hình khi xoay
- **Nguyên nhân**: Scale không đủ nhỏ hoặc perspective quá lớn
- **Fix**: Giảm `zScale` min value (0.92 → 0.85) hoặc giảm perspective (0.001 → 0.0008)

### Mặt sau bị lộn ngược
- **Nguyên nhân**: Back card chưa được rotate -180° ban đầu
- **Fix**: Apply `Transform(rotateY(π))` cho back card

### Animation không smooth
- **Nguyên nhân**: Curve không phù hợp hoặc frame drop
- **Fix**: Thử curves khác hoặc giảm complexity

### Shadow không theo card
- **Nguyên nhân**: Shadow không áp dụng cùng matrix
- **Fix**: Wrap shadow với cùng Transform(matrix)

## 12. Performance Tips

1. **Avoid rebuilds**: Sử dụng `AnimatedBuilder` thay vì `setState`
2. **Cache transforms**: Tính matrix 1 lần, dùng cho cả front/back/shadow
3. **Opacity optimization**: Flutter optimize Opacity widget automatically
4. **Hardware acceleration**: Transform tự động dùng GPU

## 13. Files

- **Current version**: `lib/flip_card_widget.dart`
- **Option A (Spring)**: `lib/flip_card_widget_option_a.dart`
- **Comparison screen**: `lib/flip_comparison_screen.dart`
- **Usage example**: `lib/card_detail_screen.dart`

---

**Created**: 2025-10-01
**Version**: 1.0
**Author**: Animation Implementation Session
