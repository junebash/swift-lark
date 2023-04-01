import SDL2

public struct ScanCode: RawRepresentable {
    public var rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    internal init(_ sdlScanCode: SDL_Scancode) {
        self.rawValue = sdlScanCode.rawValue
    }
}
