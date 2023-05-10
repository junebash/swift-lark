import SDL2

@MainActor
public final class Renderer {
    @usableFromInline
    internal let _sdlRendererPointer: OpaquePointer

    public init(window: Window, options: Options) throws {
        self._sdlRendererPointer = try withThrowingSDL {
            SDL_CreateRenderer(window._sdlWindowPtr, -1, options.rawValue)
        }
    }

    deinit {
        SDL_DestroyRenderer(_sdlRendererPointer)
    }
}

extension Renderer {
    @inlinable
    public func setColor(_ color: Color) {
        SDL_SetRenderDrawColor(
            _sdlRendererPointer,
            color.red,
            color.green,
            color.blue,
            color.alpha
        )
    }

    @inlinable
    public func clear() throws {
        try withThrowingSDL {
            SDL_RenderClear(_sdlRendererPointer)
        }
    }

    @inlinable
    public func present() {
        SDL_RenderPresent(_sdlRendererPointer)
    }

    public func fillRect(_ rect: IRect2) throws {
        try withThrowingSDL {
            withUnsafePointer(to: rect) { ptr in
                ptr.withMemoryRebound(to: SDL_Rect.self, capacity: 1) { sdlPtr in
                    SDL_RenderFillRect(_sdlRendererPointer, sdlPtr)
                }
            }
        }
    }

    public func fillRect(_ rect: FRect2) throws {
        try withThrowingSDL {
            withUnsafePointer(to: rect) { ptr in
                ptr.withMemoryRebound(to: SDL_FRect.self, capacity: 1) { sdlPtr in
                    SDL_RenderFillRectF(_sdlRendererPointer, sdlPtr)
                }
            }
        }
    }

    public func renderCopy(_ texture: Texture, source: IRect2? = nil, destination: IRect2?) throws {
        try withThrowingSDL {
            withUnsafeOptionalSDLPointer(to: source, reboundTo: SDL_Rect.self) { srcPtr in
                withUnsafeOptionalSDLPointer(to: destination, reboundTo: SDL_Rect.self) { dstPtr in
                    SDL_RenderCopy(_sdlRendererPointer, texture.sdlPointer, srcPtr, dstPtr)
                }
            }
        }
    }

    public func renderCopy(_ texture: Texture, source: IRect2? = nil, destination: FRect2?) throws {
        try withThrowingSDL {
            withUnsafeOptionalSDLPointer(to: source, reboundTo: SDL_Rect.self) { srcPtr in
                withUnsafeOptionalSDLPointer(to: destination, reboundTo: SDL_FRect.self) { dstPtr in
                    SDL_RenderCopyF(_sdlRendererPointer, texture.sdlPointer, srcPtr, dstPtr)
                }
            }
        }
    }
}

// MARK: - Options

extension Renderer {
    public struct Options: OptionSet, Sendable {
        public var rawValue: UInt32

        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        init(_ flags: SDL_RendererFlags) {
            self.rawValue = flags.rawValue
        }

        /// The renderer is a software fallback.
        public static let software: Self = .init(SDL_RENDERER_SOFTWARE)

        /// The renderer uses hardware acceleration.
        public static let accelerated: Self = .init(SDL_RENDERER_ACCELERATED)

        /// Present is synchronized with the refresh rate.
        public static let presentVSync: Self = .init(SDL_RENDERER_PRESENTVSYNC)

        /// The renderer supports rendering to texture.
        public static let targetTexture: Self = .init(SDL_RENDERER_TARGETTEXTURE)
    }
}
