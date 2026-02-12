//
//  ResponsiveLayout.swift
//  DeenLearn
//
//  Responsive layout utilities for device-adaptive display
//

import SwiftUI

// MARK: - Device Layout

/// Provides responsive scaling factors based on screen size
struct DeviceLayout {
    
    /// Reference width (iPhone 14/15 — 393pt)
    static let referenceWidth: CGFloat = 393
    /// Reference height (iPhone 14/15 — 852pt)
    static let referenceHeight: CGFloat = 852
    
    /// Current screen bounds
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    /// Horizontal scale factor relative to reference device
    /// Capped at 1.5x to prevent excessive scaling on very large displays (iPads)
    static var widthScale: CGFloat {
        min(screenWidth / referenceWidth, 1.5)
    }
    
    /// Vertical scale factor relative to reference device
    /// Capped at 1.5x to prevent excessive scaling on very large displays (iPads)
    static var heightScale: CGFloat {
        min(screenHeight / referenceHeight, 1.5)
    }
    
    /// Whether this is a compact device (iPhone SE, iPod touch)
    static var isCompact: Bool {
        screenWidth < 375
    }
    
    /// Whether this is a large device (iPad, Pro Max)
    static var isLarge: Bool {
        screenWidth >= 428
    }
    
    /// Whether this is an iPad
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// Scale a value proportionally to screen width
    static func scaled(_ value: CGFloat) -> CGFloat {
        value * widthScale
    }
    
    /// Scale a font size proportionally to screen width
    /// Bounded to 75%-140% of original: 75% minimum preserves readability on small screens,
    /// 140% maximum prevents oversized text on iPads
    static func scaledFont(_ size: CGFloat) -> CGFloat {
        let scaled = size * widthScale
        return max(size * 0.75, min(scaled, size * 1.4))
    }
    
    /// Adaptive grid columns based on available width
    static func adaptiveColumns(minimum: CGFloat = 150) -> [GridItem] {
        [GridItem(.adaptive(minimum: scaled(minimum)), spacing: scaled(12))]
    }
    
    /// Fixed grid columns based on device width
    static func fixedColumns(count: Int? = nil) -> [GridItem] {
        let columns = count ?? (isIPad ? 4 : (isLarge ? 3 : 2))
        return Array(repeating: GridItem(.flexible(), spacing: scaled(12)), count: columns)
    }
}

// MARK: - Responsive View Modifiers

extension View {
    
    /// Apply responsive font sizing with a specific point size
    func responsiveFont(size: CGFloat) -> some View {
        self.font(.system(size: DeviceLayout.scaledFont(size)))
    }
    
    /// Apply responsive frame with scaled dimensions
    func responsiveFrame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        self.frame(
            width: width.map { DeviceLayout.scaled($0) },
            height: height.map { DeviceLayout.scaled($0) }
        )
    }
    
    /// Apply responsive padding
    func responsivePadding(_ edges: Edge.Set = .all, _ length: CGFloat = 16) -> some View {
        self.padding(edges, DeviceLayout.scaled(length))
    }
    
    /// Apply responsive corner radius
    func responsiveCornerRadius(_ radius: CGFloat = 12) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: DeviceLayout.scaled(radius)))
    }
}

// MARK: - Responsive Container

/// A container that provides size information to its content
struct ResponsiveContainer<Content: View>: View {
    let content: (CGSize) -> Content
    
    init(@ViewBuilder content: @escaping (CGSize) -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            content(geometry.size)
        }
    }
}

// MARK: - Adaptive Stack

/// A stack that switches between HStack and VStack based on available width
struct AdaptiveStack<Content: View>: View {
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    init(
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        if sizeClass == .regular {
            HStack(alignment: verticalAlignment, spacing: spacing) {
                content()
            }
        } else {
            VStack(alignment: horizontalAlignment, spacing: spacing) {
                content()
            }
        }
    }
}
