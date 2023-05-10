import SDL2

public struct SDLError: Error {
    public var code: Int32?
    public var description: String

    @inlinable
    init(code: Int32? = nil, description: String = "") {
        self.code = code
        self.description = description
    }

    @inlinable
    static func get(code: Int32? = nil) -> SDLError? {
        if let messagePointer = SDL_GetError(), messagePointer.pointee != 0 {
            defer { SDL_ClearError() }
            return .init(code: code, description: .init(cString: messagePointer))
        } else {
            return nil
        }
    }
}

@inlinable
func withThrowingSDL(_ operation: () -> Int32) throws {
    let opCode = operation()
    if opCode != 0, let error = SDLError.get(code: opCode) {
        throw LarkError.sdl(error)
    }
}

@inlinable
func withThrowingSDL<Output>(_ operation: () -> Output?) throws -> Output {
    guard let result = operation() else {
        throw SDLError.get().map(LarkError.sdl) ?? .unknown
    }
    return result
}
