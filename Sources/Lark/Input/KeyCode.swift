import SDL2

public struct KeyCode: RawRepresentable, Hashable, Sendable {
    public var rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    internal init(_ sdlKeyCode: SDL_KeyCode) {
        self.rawValue = sdlKeyCode.rawValue
    }

    public static let backspace: Self = .init(SDLK_BACKSPACE)
    public static let tab: Self = .init(SDLK_TAB)
    public static let `return`: Self = .init(SDLK_RETURN)
    public static let escape: Self = .init(SDLK_ESCAPE)
    public static let space: Self = .init(SDLK_SPACE)
    public static let exclaim: Self = .init(SDLK_EXCLAIM)
    public static let doubleQuote: Self = .init(SDLK_QUOTEDBL)
    // TODO
}
