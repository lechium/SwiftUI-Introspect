SwiftUIIntrospect
=================

[![CI Status Badge](https://github.com/siteline/SwiftUI-Introspect/actions/workflows/ci.yml/badge.svg)](https://github.com/siteline/SwiftUI-Introspect/actions/workflows/ci.yml)
[![Platform Compatibility Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsiteline%2FSwiftUI-Introspect%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/siteline/SwiftUI-Introspect)

> **Note**
>
> `SwiftUIIntrospect` is an all-new module based off the original `Introspect` module that improves on stability, predictability, and ergonomics.
>
> Both modules currently live together under this repo, but the plan is to ultimately obsolete `Introspect` in favor of `SwiftUIIntrospect` as part of a 1.0 release.
>
> While `Introspect` supports Swift 5.5 or higher, `SwiftUIIntrospect` requires Swift 5.7 or higher due to the use of more recent language features which partially enable the aforementioned improvements over the original.

SwiftUIIntrospect allows you to get the underlying UIKit or AppKit element of a SwiftUI view.

For instance, with SwiftUIIntrospect you can access `UITableView` to modify separators, or `UINavigationController` to customize the tab bar.

How it works
------------

SwiftUIIntrospect works by adding an invisible `IntrospectionView` on top of the selected view, and an invisible "anchor" view underneath it, then looking through the UIKit/AppKit view hierarchy between the two to find the relevant view.

For instance, when introspecting a `ScrollView`...

```swift
ScrollView {
    Text("Item 1")
}
.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
    // do something with UIScrollView
}
```

... it will:

- Add `IntrospectionView` as an overlay of `TextField`
- Add `IntrospectionAnchorView` as the background of `TextField`.
- Traverse through all the subviews between both views until a `UIScrollView` instance (if any) is found.

> **Warning**
> Although the introspection method itself is very solid and unlikely to break in SwiftUI releases, future OS releases require explicit opt-in for introspection (`.iOS(.vXYZ)`), given differences between major OS versions which might not use the same UIKit/AppKit elements that are being looked for in previous OS versions.

By default, `.introspect` works directly on its _receiver_. This means calling `.introspect` from inside the view you're trying to introspect won't have any effect. This is different to the original `Introspect` module in which some views would implicitly allow introspection from within. This is because most of the time it's more stable and predictable to introspect views directly, but there are times when it's not possible or simply too inflexible for library developers. You **can** introspect an _ancestor_ with `SwiftUIIntrospect`, but you must opt into this explicitly by overriding the introspection `scope`:

```swift
ScrollView {
    Text("Item 1")
        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17), scope: .ancestor) { scrollView in
            // do something with UIScrollView
        }
}
```

### Usage in production

`SwiftUIIntrospect` is meant to be used in production. It does not use any private API. It only inspects the view hierarchy using publicly available methods. The library takes a defensive approach to inspecting the view hierarchy: there is no hard assumption that elements are laid out a certain way, there is no force-cast to UIKit/AppKit classes, and the `introspect()` methods are simply ignored if UIKit/AppKit views cannot be found.

Install
-------

### Swift Package Manager

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "0.4.0"),
    ],
    targets: [
        .target(name: <#Target Name#>, dependencies: [
            .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
        ]),
    ]
)
```

### CocoaPods

```ruby
pod 'SwiftUIIntrospect'
```

Introspection
-------------

### Implemented

_WIP_

`SwiftUIIntrospect` already supports all the view types that `Introspect` supports, and more (e.g. `ProgressView`, `Table`). However, listing them all in a table is an arduous task that I'm still thinking of how to best accomplish (perhaps it's possible to automate via SwiftSyntax?). For now, I suggest diving into the desired view type's code file to figure out which platforms and underlying views are supported. I also suggest checking out the showcase app and tests for example use cases.

**Missing an element?** Please [create an issue](https://github.com/timbersoftware/SwiftUI-Introspect/issues). As a temporary solution, you can [implement your own introspectable view type](#implement-your-own-view-type).

### Cannot implement

SwiftUI | Affected Frameworks | Why
--- | --- | ---
Text | UIKit, AppKit | Not a UILabel / NSLabel
Image | UIKit, AppKit | Not a UIImageView / NSImageView
Button | UIKit | Not a UIButton

Examples
--------

### List

```swift
List {
    Text("Item")
}
.introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17)) { tableView in
    tableView.backgroundView = UIView()
    tableView.backgroundColor = .cyan
}
.introspect(.list, on: .iOS(.v16, .v17)) { collectionView in
    collectionView.backgroundView = UIView()
    collectionView.subviews.dropFirst(1).first?.backgroundColor = .cyan
}
```

### ScrollView

```swift
ScrollView {
    Text("Item")
}
.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
    scrollView.refreshControl = UIRefreshControl()
}
```

### NavigationView

```swift
NavigationView {
    Text("Item")
}
.navigationViewStyle(.stack)
.introspect(.navigationView(style: .stack), on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) { navigationController in
    navigationController.navigationBar.backgroundColor = .cyan
}
```

### TextField

```swift
TextField("Text Field", text: <#Binding<String>#>)
    .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) { textField in
        textField.backgroundColor = .red
    }
```

Implement your own selector
---------------------------

**Missing an element?** Please [create an issue](https://github.com/timbersoftware/SwiftUI-Introspect/issues).

In case SwiftUIIntrospect doesn't support the SwiftUI element that you're looking for, you can implement your own selector. For example, to introspect a `TextField`:

```swift
@_spi(Internals) import SwiftUIIntrospect

public struct TextFieldType: IntrospectableViewType {}

extension IntrospectableViewType where Self == TextFieldType {
    public static var textField: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<TextFieldType, UITextField> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<TextFieldType, UITextField> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
extension macOSViewVersion<TextFieldType, NSTextField> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
```

Releasing
---------

1. Update changelog with new version
2. PR as 'Bump to X.Y.Z' and merge it
3. Tag new version:

    ```sh
    $ git tag X.Y.Z
    $ git push origin --tags
    ```
