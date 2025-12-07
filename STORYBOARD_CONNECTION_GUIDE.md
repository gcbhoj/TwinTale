# 🎯 XCODE STORYBOARD CONNECTION GUIDE

## Visual Guide for Connecting Elements in Xcode

---

## STEP 1: Connect ViewController Class

```
┌─────────────────────────────────────────────────────────┐
│  Main.storyboard → Cover Page Scene                     │
│                                                          │
│  1. Click on View Controller (yellow icon)              │
│     [📱]  ← This icon at the top of the scene           │
│                                                          │
│  2. Open Identity Inspector (⌥⌘3)                       │
│                                                          │
│  3. Set Custom Class:                                    │
│     ┌────────────────────────────┐                      │
│     │ Class:  ViewController     │                      │
│     │ Module: TwinTale          │                      │
│     └────────────────────────────┘                      │
└─────────────────────────────────────────────────────────┘
```

---

## STEP 2: Connect IBOutlets (Use Assistant Editor)

```
┌────────────────────────────┐       ┌──────────────────────────┐
│   STORYBOARD (Left)        │       │  ViewController.swift    │
│   Main.storyboard          │       │  (Right)                 │
├────────────────────────────┤       ├──────────────────────────┤
│                            │       │                          │
│  1. Logo Image             │──────→│  @IBOutlet weak var      │
│     [🖼️ TwinTale Logo]     │ Ctrl  │  logoImageView           │
│                            │ Drag  │                          │
│                            │       │                          │
│  2. Quote TextView         │──────→│  @IBOutlet weak var      │
│     [📝 "Every story..."]  │       │  quoteTextView           │
│                            │       │                          │
│  3. Facebook Button        │──────→│  @IBOutlet weak var      │
│     [🔵 FaceBook Login]    │       │  facebookLoginButton     │
│                            │       │                          │
│  4. Register Button        │──────→│  @IBOutlet weak var      │
│     [🔵 Register]          │       │  createAccountButton     │
│                            │       │                          │
│  5. Login Button           │──────→│  @IBOutlet weak var      │
│     [🔵 Login]             │       │  signInButton            │
│                            │       │                          │
└────────────────────────────┘       └──────────────────────────┘
```

### How to Control-Drag:
1. **Hold Control key** on your keyboard
2. **Click and drag** from the UI element (left side)
3. **Release on the @IBOutlet** line (right side)
4. Line will turn **green** when over correct outlet

---

## STEP 3: Connect IBAction

```
┌────────────────────────────┐       ┌──────────────────────────┐
│   STORYBOARD               │       │  ViewController.swift    │
├────────────────────────────┤       ├──────────────────────────┤
│                            │       │                          │
│  [🔵 FaceBook Login]       │       │  @IBAction func          │
│                            │──────→│  facebookLoginButtonTapped│
│  Right-click or            │ Touch │  (_ sender: UIButton)    │
│  Connections Inspector     │  Up   │                          │
│                            │ Inside│                          │
└────────────────────────────┘       └──────────────────────────┘
```

### Method A: Using Connections Inspector
1. Select **FaceBook Login button**
2. Open **Connections Inspector** (⌥⌘6)
3. Find **"Sent Events"** section
4. Find **"Touch Up Inside"** row
5. Drag circle (⭕) to View Controller
6. Select **facebookLoginButtonTapped:** from popup

### Method B: Control-Drag
1. Control-drag from button to `@IBAction` line
2. Select "Touch Up Inside" when prompted

---

## VISUAL CHECKLIST

### Before Connections (❌):
```
┌──────────────────────────────────────────────┐
│  Connections Inspector                       │
├──────────────────────────────────────────────┤
│  Referencing Outlets                         │
│    logoImageView          ⭕ (empty circle)  │
│    quoteTextView          ⭕                 │
│    facebookLoginButton    ⭕                 │
│                                              │
│  Sent Actions                                │
│    Touch Up Inside        ⭕                 │
└──────────────────────────────────────────────┘
```

### After Connections (✅):
```
┌──────────────────────────────────────────────┐
│  Connections Inspector                       │
├──────────────────────────────────────────────┤
│  Referencing Outlets                         │
│    logoImageView          ⦿→ View Controller│
│    quoteTextView          ⦿→ View Controller│
│    facebookLoginButton    ⦿→ View Controller│
│                                              │
│  Sent Actions                                │
│    Touch Up Inside        ⦿→ facebookLogin...│
└──────────────────────────────────────────────┘
```

**Filled circles (⦿) = Connected ✅**
**Empty circles (⭕) = Not Connected ❌**

---

## QUICK TIPS

💡 **Can't find Assistant Editor?**
   - Click the **two overlapping circles** icon (top right toolbar)
   - Or: Editor → Assistant

💡 **Wrong file showing in Assistant?**
   - Click the file name at the top of Assistant pane
   - Type "ViewController.swift"

💡 **Control-drag not working?**
   - Make sure View Controller class is set first (Step 1)
   - Try right-clicking instead and selecting "New Referencing Outlet"

💡 **Connection appears then disappears?**
   - The outlet name might not match
   - Check spelling in code matches storyboard

💡 **Want to verify connections?**
   - Select element in storyboard
   - Open Connections Inspector (⌥⌘6)
   - Should see filled circles (⦿) with arrows

---

## 🎬 TESTING YOUR CONNECTIONS

After making all connections:

1. **Build Project** (⌘B)
   - Should succeed with no errors about outlets

2. **Run in Simulator** (⌘R)
   - App should launch
   - Logo should appear
   - Buttons should be styled beautifully
   - Animations should play

3. **Test Facebook Button**
   - Tap "FaceBook Login"
   - Should see haptic feedback
   - Button should animate

---

## 🆘 TROUBLESHOOTING

**Problem:** "Could not insert new outlet connection"
- **Solution:** Make sure ViewController class is set in Identity Inspector

**Problem:** Outlets still showing as nil at runtime
- **Solution:** Check connections in Connections Inspector - should show ⦿ not ⭕

**Problem:** App crashes with "unrecognized selector sent to instance"
- **Solution:** Action might be connected to wrong method - re-check IBAction connection

**Problem:** UI elements don't appear styled
- **Solution:** viewDidLoad might not be called - verify ViewController class connection

---

✨ Once all 5 outlets and 1 action are connected, your app will work perfectly!
