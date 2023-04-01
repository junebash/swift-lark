import SDL2

public struct SDLError: Error {
    public var code: Int32?
    public var description: String

    @inlinable
    init?(code: Int32) {
        guard code != 0 else { return nil }
        self.code = code
        if let messagePointer = SDL_GetError() {
            self.description = .init(cString: messagePointer)
            SDL_ClearError()
        } else {
            self.description = "Unknown error occurred"
        }
    }

    @inlinable
    init?() {
        if let messagePointer = SDL_GetError() {
            self.description = .init(cString: messagePointer)
            SDL_ClearError()
        } else {
            return nil
        }
    }
}

@inlinable
func withThrowingSDL(_ operation: () -> Int32) throws {
    let opCode = operation()
    if let error = SDLError(code: opCode) {
        throw LarkError.sdl(error)
    }
}

@inlinable
func withThrowingSDL<Output>(_ operation: () -> Output?) throws -> Output {
    guard let result = operation() else {
        throw SDLError().map(LarkError.sdl) ?? .unknown
    }
    return result
}
