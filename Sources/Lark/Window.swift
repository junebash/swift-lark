import SDL2

public final class Window {
  public struct Options: OptionSet {
    public var rawValue: UInt32

    public init(rawValue: UInt32) {
      self.rawValue = rawValue
    }

    public init(_ cWindowFlags: SDL_WindowFlags) {
      self.rawValue = cWindowFlags.rawValue
    }

    public static let fullscreen = Options(SDL_WINDOW_FULLSCREEN)
    public static let openGL = Options(SDL_WINDOW_OPENGL)
    public static let hidden = Options(SDL_WINDOW_HIDDEN)
    public static let borderless = Options(SDL_WINDOW_BORDERLESS)
    public static let resizable = Options(SDL_WINDOW_RESIZABLE)
    public static let maximized = Options(SDL_WINDOW_MAXIMIZED)
    public static let minimized = Options(SDL_WINDOW_MINIMIZED)
    public static let grabbed = Options(SDL_WINDOW_INPUT_GRABBED)
    public static let allowHighDPI = Options(SDL_WINDOW_ALLOW_HIGHDPI)
    public static let vulkan = Options(SDL_WINDOW_VULKAN)
    public static let metal = Options(SDL_WINDOW_METAL)
  }

  internal let pointer: OpaquePointer

  public var size: Size {
    var x = 0 as Int32
    var y = 0 as Int32
    SDL_GetWindowSize(pointer, &x, &y)
    return Size(x: Double(x), y: Double(y))
  }

  public init(
    title: String = "",
    position: Vector2 = .undefinedWindowPosition,
    size: Size,
    options: Options = []
  ) {
    guard let pointer = title.withCString({ stringPtr in
      SDL_CreateWindow(stringPtr, Int32(position.x), Int32(position.y), Int32(size.x), Int32(size.y), options.rawValue)
    }) else {
      preconditionFailure("Failed to create SDL Window.")
    }
    self.pointer = pointer
  }

  deinit {
    SDL_DestroyWindow(pointer)
  }
}
