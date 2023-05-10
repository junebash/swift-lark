import SDL2
import SDL2Image

public final class Surface {
    let sdlPointer: UnsafeMutablePointer<SDL_Surface>

    init(sdlPointer: UnsafeMutablePointer<SDL_Surface>) {
        self.sdlPointer = sdlPointer
    }

    deinit {
        SDL_FreeSurface(sdlPointer)
    }
}

extension Surface {
    public convenience init(path: String) throws {
        let pointer = try withThrowingSDL {
            path.withCString({
                IMG_Load($0)
            })
        }
        self.init(sdlPointer: pointer)
    }
}
