# FLIP CARD ANIMATION - TIMELINE ĐẦY ĐỦ

## TỔNG QUAN

```
0ms ──────────────── 250ms ──────────────── 500ms
│                      │                      │
├─ Rotation ──────────────────────────────────┤ (500ms)
│  Curve: Cubic(0.455, 0.03, 0.515, 0.955)    │
│  Power2.easeInOut: chậm → nhanh → chậm      │
│                                              │
│  0° ────────────→ 90° ─────────────→ 180°   │
│  👁️ Front        👁️ Edge           👁️ Back   │
│  slow ▁▁▂▃▅▆▇██████▇▆▅▃▂▁▁ slow             │
│       ↑ tăng tốc  ↑ giảm tốc                │
│                                              │
├─ Z-scale ─────────┤                          (250ms)
│  Phase 1 (45%): Curves.easeInOut             │
│  1.0 → 0.92  ▁▂▃▅▇█▇▅▃▂▁                     │
│                                              │
│  Phase 2 (55%): Curves.easeOut               │
│  0.92 → 1.0  ███▇▆▅▃▂▁                       │
│              ↑ nhanh → chậm                  │
│                                              │
├─ Camera/Perspective ──────────────────────── │ (500ms)
│  🎥 Fixed: 1000 units, P=0.001 (constant)    │
│                                              │
│  Camera View (với curve):                    │
│                                              │
│  0ms:   |═══════|  ← z=0, Rotation slow     │
│          FRONT     Scale=1.0                 │
│                                              │
│  62ms:  /═══|     ← Rotation tăng tốc       │
│        /═══/       Scale=0.96 (đang nhún)   │
│         ~22°                                 │
│                                              │
│  125ms: /═══|     ← Rotation NHANH NHẤT     │
│        /══/        Scale=0.92 (nhỏ nhất)    │
│         ~45°       Depth + Scale max!       │
│                                              │
│  187ms:  \═══|    ← Rotation vẫn nhanh      │
│          \══\      Scale=0.96 (đang phồng)  │
│          ~68°                                │
│                                              │
│  250ms:   |       ← Rotation giảm tốc       │
│           |═|      Scale=1.0 (về lại)       │
│           90°      Z-scale XONG ✓           │
│                                              │
│  375ms:  \═══|    ← Rotation chậm lại       │
│           \══\     Scale=1.0                │
│           135°     Chỉ còn perspective      │
│                                              │
│  500ms: |═══════| ← Rotation dừng hẳn       │
│          BACK      z=0, Scale=1.0           │
│          180°                                │
│                                              │
└─ Timeline:                                   │
   0ms: Tap → HapticFeedback.lightImpact()    │
   0-125ms: Rotation tăng tốc + Z nhún vào    │
   125-250ms: Rotation max speed + Z phồng ra │
   250-500ms: Rotation giảm tốc (chỉ rotate) │
   500ms: Hoàn thành                          │
```

---

## 1. ROTATION ANIMATION

### Thông số:
- **Duration**: 500ms
- **Easing**: `Cubic(0.455, 0.03, 0.515, 0.955)` - Power2.easeInOut
- **Value**: 0° → 180° (cumulative rotation)

### Mô tả curve:
```
Speed
  ^
  │         ████████████         ← Max speed (125-250ms)
  │      ███            ███
  │    ██                  ██
  │  ██                      ██
  │██                          ██
  └──────────────────────────────> Time
  0ms   125ms   250ms   375ms 500ms
```

**Đặc điểm:**
- **Ease In (0-125ms)**: Tăng tốc dần - thẻ bắt đầu xoay chậm rồi nhanh dần
- **Peak (125-250ms)**: Tốc độ đỉnh - xoay nhanh nhất
- **Ease Out (250-500ms)**: Giảm tốc dần - xoay chậm lại và dừng mềm

### Giải thích Cubic Bezier:
- `Cubic(0.455, 0.03, 0.515, 0.955)` là cubic bezier curve với 4 control points
- Tạo chuyển động: **chậm → nhanh → chậm**
- Giống như đẩy cánh cửa: đẩy nhẹ → đà mạnh → dừng từ từ

---

## 2. Z-DEPTH ANIMATION

### Thông số:
- **Duration**: 250ms (yoyo - nhún vào rồi ra)
- **Scale**: 1.0 → 0.92 → 1.0
- **2 Phases với curve khác nhau**

### Phase 1 (45% = 112ms):
```
Scale
1.0  █
0.96    ██                    ← Nhún đều
0.92      ███                 ← Đến đáy
     └──────────────> Time
     0ms  56ms  112ms
```

- **Scale**: 1.0 → 0.92
- **Curve**: `Curves.easeInOut`
- **Mô tả**: Thẻ **nhún vào** (co lại 8%)
- **Đặc điểm**: Symmetric - nhún vào đều đều

### Phase 2 (55% = 138ms):
```
Scale
1.0            ███            ← Về nhanh
0.96          ██
0.92        ██                ← Từ đáy
     └──────────────> Time
     112ms  181ms  250ms
```

- **Scale**: 0.92 → 1.0
- **Curve**: `Curves.easeOut`
- **Mô tả**: Thẻ **nhún ra** (phồng lên về kích thước ban đầu)
- **Đặc điểm**: Fast start - nhả nhanh rồi chậm lại (như lò xo)

---

## 3. TRANSFORM MATRIX

### Perspective:
```dart
Matrix4.identity()
  ..setEntry(3, 2, 0.001)  // Perspective projection
  ..rotateY(rotation)       // Xoay theo trục Y
  ..scale(zScale, zScale * 0.95, 1.0); // Co dãn
```

### Perspective Effect:
- **setEntry(3, 2, 0.001)**: Tạo perspective projection
- **Camera distance**: 1/0.001 = 1000 units
- **Công thức**: `scale = 1 / (1 + z × 0.001)`

### Camera View qua các frame:

#### Frame 0ms (0°):
```
🎥 Camera
    ↓ 1000 units
┌─────────┐
│  FRONT  │  z = 0 (không depth)
└─────────┘
Scale: 1.0
```

#### Frame 125ms (45°):
```
🎥 Camera
    ↓
    /────\     Mép trái: z = -50 → scale 1.05x
   /FRONT \    Mép phải: z = +50 → scale 0.95x
  /────────\   Perspective effect rõ
Scale: 0.92 (nhỏ nhất) ← PEAK MOMENT!
```

#### Frame 250ms (90°):
```
🎥 Camera
    ↓
    │        Mép trái: z = -100 → scale 1.11x
    │█       Mép phải: z = +100 → scale 0.91x
    │        Depth tối đa
Scale: 1.0 (về lại)
```

#### Frame 375ms (135°):
```
🎥 Camera
    ↓
    \────/     Mép phải: z = -50 → scale 1.05x
     \BACK/    Mép trái: z = +50 → scale 0.95x
      \──/     Perspective đảo ngược
Scale: 1.0
```

#### Frame 500ms (180°):
```
🎥 Camera
    ↓
┌─────────┐
│  BACK   │  z = 0 (không depth)
└─────────┘
Scale: 1.0
```

### Scale Transform:
- **ScaleX**: Theo z-depth (1.0 → 0.92 → 1.0)
- **ScaleY**: z-depth × 0.95 (ép thấp hơn một chút)
- **ScaleZ**: 1.0 (không đổi)

**Lý do ScaleY × 0.95:**
- Tạo cảm giác thẻ bị **nén xuống** khi xoay
- Tăng hiệu ứng 3D depth

---

## 4. SHADOW

### Thông số:
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.15),
  blurRadius: 20,
  spreadRadius: 2,
  offset: const Offset(0, 8),
)
```

### Chi tiết:
- **Color**: Black @ 15% opacity - bóng nhẹ, tự nhiên
- **Blur**: 20px - bóng mờ dần ra ngoài
- **Spread**: 2px - bóng to hơn thẻ một chút
- **Offset**: (0, 8) - bóng rơi xuống dưới 8px (nguồn sáng ở trên)

---

## 5. COMBINED EFFECT

```
                    PEAK MOMENT (125ms)
                         ↓
Rotation:    ▁▂▃▅▇████████████▇▆▅▃▂▁
Z-Scale:     █▇▆▅▃▂▁ ▁▂▃▅▆▇█
Camera:      🎥═══════════════════════
             │                        │
          Slow start              Slow end
          + Nhún vào              + Chỉ xoay
```

### Điểm hay của animation:

1. **0-125ms**:
   - Rotation tăng tốc
   - Z-scale nhún vào
   - → Tạo "lực" khi bắt đầu flip

2. **125-250ms**:
   - Rotation ở tốc độ max
   - Z-scale phồng lên
   - → Smooth transition qua edge

3. **250-500ms**:
   - Rotation giảm tốc
   - Z-scale giữ nguyên 1.0
   - → Dừng mềm mại

4. **Camera (0-500ms)**:
   - Perspective cố định suốt quá trình
   - Tạo depth 3D liên tục
   - Làm thẻ có chiều sâu thực tế

---

## 6. CODE IMPLEMENTATION

### Toggle Function:
```dart
void toggleCard() {
  // Haptic feedback
  HapticFeedback.lightImpact();

  // Update rotation (cumulative -180°)
  final targetRotation = _currentRotation - 3.14159;

  // Start both animations simultaneously
  _rotationController.forward(from: 0);  // 500ms
  _zController.forward(from: 0);         // 250ms

  _currentRotation = targetRotation;
}
```

### Controllers:
```dart
// Rotation: 500ms
_rotationController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 500),
);

// Z-depth: 250ms
_zController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 250),
);
```

### Animations:
```dart
// Rotation animation
_rotationAnimation = Tween<double>(
  begin: _currentRotation,
  end: targetRotation,
).animate(CurvedAnimation(
  parent: _rotationController,
  curve: const Cubic(0.455, 0.03, 0.515, 0.955),
));

// Z-depth animation
_zAnimation = TweenSequence<double>([
  // Phase 1 (45%): Nhún vào
  TweenSequenceItem(
    tween: Tween<double>(begin: 1.0, end: 0.92)
        .chain(CurveTween(curve: Curves.easeInOut)),
    weight: 45,
  ),
  // Phase 2 (55%): Nhún ra
  TweenSequenceItem(
    tween: Tween<double>(begin: 0.92, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOut)),
    weight: 55,
  ),
]).animate(_zController);
```

---

## 7. CÔNG THỨC TOÁN HỌC

### Perspective Projection:
```
P = 0.001
Distance = 1/P = 1000 units

Tại góc xoay θ:
- z_left = -width/2 × sin(θ)
- z_right = +width/2 × sin(θ)

Scale factor:
scale(z) = 1 / (1 + z × P)

Ví dụ θ = 90°, width = 200:
- z_left = -100  → scale = 1/(1-0.1) = 1.11x (+11%)
- z_right = +100 → scale = 1/(1+0.1) = 0.91x (-9%)
```

### Transform Matrix:
```
Matrix4 = [
  1   0   0   0
  0   1   0   0
  0   0   1   P    ← P = 0.001 tại entry(3,2)
  0   0   0   1
]

Transformation order:
1. Identity matrix
2. Apply perspective (setEntry)
3. Apply rotation (rotateY)
4. Apply scale (scale)
```

---

## 8. HIỆU ỨNG CUỐI CÙNG

Animation này tạo ra hiệu ứng giống như:
- **Lật thẻ bài poker trên bàn**
- **Thẻ vừa xoay vừa nhún xuống rồi nhô lên**
- **Có chiều sâu 3D thực tế nhờ perspective**
- **Chuyển động mượt mà với easing hợp lý**

### So sánh với Material Design:
- ❌ Duration 500ms hơi nhanh (Material khuyến nghị 400-600ms cho flip)
- ❌ Curve không chuẩn Material (nên dùng `Curves.fastOutSlowIn`)
- ✅ Z-depth scale hợp lý (8% co lại)
- ✅ Haptic feedback tốt
- ✅ Perspective effect chuyên nghiệp

---

**File**: `flip_card_widget.dart`
**Duration tổng**: 500ms
**Hiệu ứng**: 3D flip với depth và scale animation
