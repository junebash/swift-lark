// Copyright (c) 2023 June Bash
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
