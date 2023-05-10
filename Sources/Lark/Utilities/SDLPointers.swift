@inlinable
public func withUnsafeSDLPointer<Value, SDLType, ResultType>(
    to value: Value,
    reboundTo: SDLType.Type,
    capacity: Int = 1,
    _ work: (UnsafePointer<SDLType>) throws -> ResultType
) rethrows -> ResultType {
    try withUnsafePointer(to: value) { ptr in
        try ptr.withMemoryRebound(to: SDLType.self, capacity: capacity) { sdlPtr in
            try work(sdlPtr)
        }
    }
}

@inlinable
public func withUnsafeOptionalSDLPointer<Value, SDLType, ResultType>(
    to value: Value?,
    reboundTo: SDLType.Type,
    capacity: Int = 1,
    _ work: (UnsafePointer<SDLType>?) throws -> ResultType
) rethrows -> ResultType {
    try value.map { value in
        try withUnsafeSDLPointer(to: value, reboundTo: SDLType.self, capacity: capacity) { sdlPtr in
            try work(sdlPtr)
        }
    } ?? work(nil)
}
