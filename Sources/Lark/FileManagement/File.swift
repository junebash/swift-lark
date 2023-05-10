import SDL2

public enum File {
    public static func getBasePath() throws -> String {
        try withThrowingSDL {
            SDL_GetBasePath().map { cString in
                defer { SDL_free(cString) }
                return String(cString: cString)
            }
        }
    }
}
