#if os(macOS)
import SwiftUI

// MARK: SwiftUI.Toggle(...).toggleStyle(.checkbox)

public struct ToggleWithCheckboxStyleType: IntrospectableViewType {
    public enum Style {
        case checkbox
    }
}

extension IntrospectableViewType where Self == ToggleWithCheckboxStyleType {
    public static func toggle(style: Self.Style) -> Self { .init() }
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension macOSViewVersion<ToggleWithCheckboxStyleType, NSButton> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}
#endif
#endif
