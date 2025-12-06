# Facebook Login Setup Guide for TwinTale

## Overview
I've implemented Facebook Login for your TwinTale app. Follow these steps to complete the setup.

## What I've Done
✅ Updated `Info.plist` with Facebook configuration placeholders
✅ Updated `AppDelegate.swift` to initialize Facebook SDK
✅ Updated `SceneDelegate.swift` to handle Facebook URL redirects
✅ Implemented Facebook login functionality in `ViewController.swift`

## What You Need to Do

### Step 1: Install Facebook SDK
1. Open `TwinTale.xcodeproj` in Xcode
2. Go to **File → Add Package Dependencies**
3. Enter the URL: `https://github.com/facebook/facebook-ios-sdk`
4. Select version: **17.0.0** or latest
5. Click **Add Package**
6. Select the following packages:
   - **FacebookCore**
   - **FacebookLogin**
7. Click **Add Package**

### Step 2: Create a Facebook App
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Click **My Apps** → **Create App**
3. Choose **Consumer** or **None** as the app type
4. Enter app details:
   - **App Name**: TwinTale
   - **App Contact Email**: Your email
5. Click **Create App**
6. In the dashboard, go to **Settings → Basic**
7. Copy your **App ID** and **Client Token**

### Step 3: Configure Your App
1. In the Facebook App Dashboard:
   - Go to **Add Product** → **Facebook Login** → **Set Up**
   - Choose **iOS** platform
   - Enter your **Bundle ID**: Find this in Xcode under your project's target settings (e.g., `com.yourname.TwinTale`)

### Step 4: Update Info.plist
Open `TwinTale/Info.plist` and replace the placeholders:
- Replace `YOUR_FACEBOOK_APP_ID` with your actual Facebook App ID (in 2 places)
- Replace `YOUR_CLIENT_TOKEN` with your actual Client Token

Example:
```xml
<key>FacebookAppID</key>
<string>1234567890123456</string>
<key>FacebookClientToken</key>
<string>abcdef1234567890abcdef1234567890</string>
```

And in the URL schemes:
```xml
<string>fb1234567890123456</string>
```

### Step 5: Connect the Button in Storyboard
1. Open `Main.storyboard`
2. Find the "FaceBook Login" button in the initial view controller
3. Right-click on the button
4. Drag from the circle next to "Touch Up Inside" to the yellow "View Controller" icon at the top
5. Select **facebookLoginButtonTapped:** from the popup menu

### Step 6: Test Your Implementation
1. Build and run your app (⌘R)
2. Tap the "FaceBook Login" button
3. You should see the Facebook login flow
4. After successful login, you'll see a welcome message with your name

## Troubleshooting

### "Module 'FBSDKCoreKit' not found"
- Make sure you've added the Facebook SDK via Swift Package Manager (Step 1)
- Clean build folder: **Product → Clean Build Folder** (⌘⇧K)
- Rebuild the project

### Login doesn't work
- Verify your Facebook App ID and Client Token in `Info.plist`
- Make sure your Bundle ID matches what's configured in Facebook Developer Console
- Check that the URL scheme in Info.plist starts with "fb" followed by your App ID

### "Can't Load URL" error
- Make sure LSApplicationQueriesSchemes is properly configured in Info.plist
- This should already be set up, but verify it includes: fbapi, fbauth2, etc.

## Features Implemented

✅ **Facebook Login Button** - Triggers the Facebook authentication flow
✅ **User Data Retrieval** - Fetches user's name, email, and profile picture
✅ **Error Handling** - Shows alerts for any login errors
✅ **Success Message** - Displays welcome message after successful login
✅ **Cancel Handling** - Gracefully handles when user cancels login

## Next Steps

To complete the integration, you should:
1. Create a proper home screen view controller
2. Update the `navigateToHomeScreen()` method to segue to your home screen
3. Store the user's login state using UserDefaults or Keychain
4. Add a logout button in your app
5. Handle login state persistence across app launches

## Facebook App Dashboard Settings

Make sure to configure these in your Facebook App:
- **Privacy Policy URL**: Required before going live
- **Terms of Service URL**: Recommended
- **App Icon**: Required for production
- **Category**: Choose appropriate category for your app
- **iOS Bundle ID**: Must match your Xcode project

## Testing

For testing, add test users in Facebook Dashboard:
1. Go to **Roles → Test Users**
2. Click **Add** to create test users
3. Use these credentials during development

## Going Live

Before publishing:
1. Complete App Review for permissions (email, public_profile)
2. Switch app from **Development Mode** to **Live Mode**
3. Add Privacy Policy and Terms of Service URLs
4. Submit for review if requesting additional permissions

---

Need help? Check the [Facebook iOS SDK Documentation](https://developers.facebook.com/docs/ios/)
