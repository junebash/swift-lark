import SDL2

public final class Renderer {
    internal let _sdlRendererPointer: OpaquePointer

    public init(window: Window, options: Options = []) throws {
        self._sdlRendererPointer = try withThrowingSDL {
            SDL_CreateRenderer(window._sdlWindowPtr, -1, options.rawValue)
        }
    }

    deinit {
        SDL_DestroyRenderer(_sdlRendererPointer)
    }
}

extension Renderer {
    public struct Options: OptionSet {
        public var rawValue: UInt32

        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        init(_ flags: SDL_RendererFlags) {
            self.rawValue = flags.rawValue
        }

        public static let software: Self = .init(SDL_RENDERER_SOFTWARE)
        public static let accelerated: Self = .init(SDL_RENDERER_ACCELERATED)
        public static let presentVSync: Self = .init(SDL_RENDERER_PRESENTVSYNC)
        public static let targetTexture: Self = .init(SDL_RENDERER_TARGETTEXTURE)

        /*
         /**< The renderer is a software fallback */
         public var SDL_RENDERER_SOFTWARE: SDL_RendererFlags { get }
         /**< The renderer uses hardware acceleration */
         public var SDL_RENDERER_ACCELERATED: SDL_RendererFlags { get }
         /**< Present is synchronized with the refresh rate */
         public var SDL_RENDERER_PRESENTVSYNC: SDL_RendererFlags { get }
         /**< The renderer supports rendering to texture */
         public var SDL_RENDERER_TARGETTEXTURE: SDL_RendererFlags { get }
         */
    }
}
