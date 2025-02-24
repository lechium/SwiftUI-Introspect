import SwiftUI

// MARK: SwiftUI.Form { ... }.formStyle(.grouped)

public struct FormWithGroupedStyleType: IntrospectableViewType {
    public enum Style {
        case grouped
    }
}

extension IntrospectableViewType where Self == FormWithGroupedStyleType {
    public static func form(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<FormWithGroupedStyleType, UITableView> {
    @available(*, unavailable, message: ".formStyle(.grouped) isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    @available(*, unavailable, message: ".formStyle(.grouped) isn't available on iOS 14")
    public static let v14 = Self.unavailable()
    @available(*, unavailable, message: ".formStyle(.grouped) isn't available on iOS 15")
    public static let v15 = Self.unavailable()
}

extension iOSViewVersion<FormWithGroupedStyleType, UICollectionView> {
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension tvOSViewVersion<FormWithGroupedStyleType, UITableView> {
    @available(*, unavailable, message: ".formStyle(.grouped) isn't available on tvOS 13")
    public static let v13 = Self.unavailable()
    @available(*, unavailable, message: ".formStyle(.grouped) isn't available on tvOS 14")
    public static let v14 = Self.unavailable()
    @available(*, unavailable, message: ".formStyle(.grouped) isn't available on tvOS 15")
    public static let v15 = Self.unavailable()
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}
#elseif canImport(AppKit)
extension macOSViewVersion<FormWithGroupedStyleType, NSScrollView> {
    @available(*, unavailable, message: ".formStyle(.grouped) isn't available on macOS 10.15")
    public static let v10_15 = Self.unavailable()
    @available(*, unavailable, message: ".formStyle(.grouped) isn't available on macOS 11")
    public static let v11 = Self.unavailable()
    @available(*, unavailable, message: ".formStyle(.grouped) isn't available on macOS 12")
    public static let v12 = Self.unavailable()
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}
#endif
