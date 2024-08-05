
# [flutter_custom_toast](https://pub.dev/packages/flutter_custom_toast)

Toast Library for Flutter


Now this toast library supports two kinds of toast messages one which requires `BuildContext` other with No `BuildContext`

## Toast with no context

> Supported Platforms
>
> - Android
> - IOS

This one has limited features and no control over UI


## Toast Which requires BuildContext

> Supported Platforms
>
> - ALL

1. Full Control of the Toast
2. Toasts will be queued
3. Remove a toast
4. Clear the queue


## How to Use

```yaml
# add this line to your dependencies
flutter_custom_toast: ^0.0.1
```

```dart
import 'package:flutter_custom_toast/export.dart';
```

## Toast with No Build Context (Android & iOS)

```dart
final _nativeToastPlugin = NativeToast();


await _nativeToastPlugin.showToast(
          message: message,
          backgroundColor: Colors.red,
          maxLines: 6,
          gravity: ToastGravity.bottom,
          textColor: Colors.white,
          fontSize: 16,
          showImage: withImage,
          imagePath: "assets/car_image.jpeg",
        );
```

| property        | description                                                        | default    |
| --------------- | ------------------------------------------------------------------ |------------|
| msg             | String (Not Null)(required)                                        |required    |
| toastLength     | Toast.LENGTH_SHORT or Toast.LENGTH_LONG (optional)                 |Toast.LENGTH_LONG  |
| gravity         | ToastGravity.TOP (or) ToastGravity.CENTER (or) ToastGravity.BOTTOM | ToastGravity.BOTTOM    |
| backgroundColor         | Colors.red                                                         |null   |
| textcolor       | Colors.white                                                       |null    |
| fontSize        | 16.0 (float)                                                       | null      |
| imagePath       | uploade image your asset folder and give the name like this :- "assets/car_image.jpeg"  | flutter_logo |
| showImage       | to show or hide image from toast message                           | true |
| maxLines        | Give toast message max line                                        | 2 |

### Custom Toast For Android

Create a file named `toast_custom.xml` in your project `app/res/layout` folder and do custom styling

```xml
<?xml version="1.0" encoding="utf-8"?>
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:layout_gravity="center_horizontal"
    android:layout_marginStart="50dp"
    android:background="@drawable/corner"
    android:layout_marginEnd="50dp">

    <TextView
        android:id="@+id/text"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:background="#CC000000"
        android:paddingStart="16dp"
        android:paddingTop="10dp"
        android:paddingEnd="16dp"
        android:paddingBottom="10dp"
        android:textStyle="bold"
        android:textColor="#FFFFFF"
        tools:text="Toast should be short." />
</FrameLayout>
```

## Toast with BuildContext (All Platforms)

Update your `MaterialApp` with `builder` like below for the use of Context globally check doc section Use NavigatorKey for Context(to access context globally)

```dart

///Globle 
/// The navigator key to be used throughout the app.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


MaterialApp(
    builder: flutterToastBuilder(),
    home: MyApp(),
    navigatorKey: navigatorKey,
),
```

```dart 
FToast fToast;

@override
void initState() {
    super.initState();
    fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    fToast.init(context);
}

 final _flutterToast = FlutterToast();

 _flutterToast.showCustomToast(
          message,
          navigatorKey: navigatorKey,
          maxLines: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          imagePath: "assets/car_image.jpeg",
          showImage: withImage,
        );

```  


For more details check `example` project

| property        | description                                                        | default    |
| --------------- | ------------------------------------------------------------------ |------------|
| child             | Widget (optional)                                        |    |
| toastDuration     | Duration (optional)                                                 |  |
| gravity         | ToastGravity.*    |  |
| NavigatorKey        | GlobalKey<NavigatorState>        |required|
|Message|        message   |required|

### Use NavigatorKey for Context(to access context globally)

To use NavigatorKey for Context first define the `GlobalKey<NavigatorState>` at top level in your `main.dart` file

```dart
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
```


## Preview Images (No BuildContext)

<img src="https://raw.githubusercontent.com/jenil6048/flutter_custom_toast/main/screenshot/1.png" width="320px" />
<img src="https://raw.githubusercontent.com/jenil6048/flutter_custom_toast/main/screenshot/2.png" width="320px" />

## Preview Images (BuildContext)

<img src="https://raw.githubusercontent.com/jenil6048/flutter_custom_toast/main/screenshot/3.png" width="320px" />
<img src="https://raw.githubusercontent.com/jenil6048/flutter_custom_toast/main/screenshot/4.png" width="320px" />


## If you need any features suggest

...
