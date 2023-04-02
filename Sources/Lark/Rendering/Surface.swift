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
    public convenience init?(path: String) {
        guard let pointer = path.withCString(IMG_Load(_:)) else { return nil }
        self.init(sdlPointer: pointer)
    }
}
