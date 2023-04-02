public enum LarkError: Error {
    case sdl(SDLError)
    case gameSetup(Error)
    case unknown
}
