import SDL2

public final class Texture {
    let sdlPointer: OpaquePointer

    public init(renderer: Renderer, surface: Surface) throws {
        self.sdlPointer = try withThrowingSDL {
            SDL_CreateTextureFromSurface(renderer._sdlRendererPointer, surface.sdlPointer)
        }
    }

    deinit {
        SDL_DestroyTexture(sdlPointer)
    }
}
