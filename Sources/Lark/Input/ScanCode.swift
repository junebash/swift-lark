import SDL2

public struct ScanCode: RawRepresentable, Sendable, Hashable {
    public var rawValue: UInt32

    @inlinable
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    @inlinable
    internal init(_ sdlScanCode: SDL_Scancode) {
        self.rawValue = sdlScanCode.rawValue
    }
}
