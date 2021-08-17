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

  public struct Position: Equatable {
    private enum Kind: Equatable {
      case vector(Vector2)
      case system(UInt32, UInt32)
    }

    private var kind: Kind

    private init(kind: Kind) {
      self.kind = kind
    }

    public init(_ vector: Vector2) {
      self.kind = .vector(vector)
    }

    public var x: Double {
      switch kind {
      case .vector(let vector): return vector.x
      case .system(let x, _): return Double(x)
      }
    }

    public var y: Double {
      switch kind {
      case .vector(let vector): return vector.y
      case .system(_, let y): return Double(y)
      }
    }

    public static var undefined: Self {
      .init(kind: .system(SDL_WINDOWPOS_UNDEFINED_MASK, SDL_WINDOWPOS_UNDEFINED_MASK))
    }

    public static var centered: Self {
      .init(kind: .system(SDL_WINDOWPOS_CENTERED_MASK, SDL_WINDOWPOS_CENTERED_MASK))
    }

    private var system: (x: UInt32, y: UInt32)? {
      guard case .system(let x, let y) = kind else { return nil }
      return (x, y)
    }

    fileprivate var cPosition: (x: Int32, y: Int32) {
      system
        .map { (x, y) in (Int32(bitPattern: x), Int32(bitPattern: y)) }
        ?? (Int32(x), Int32(y))
    }
  }

  internal let pointer: OpaquePointer

  public var size: Size {
    var x = 0 as Int32
    var y = 0 as Int32
    SDL_GetWindowSize(pointer, &x, &y)
    return Size(x: Double(x), y: Double(y))
  }

  public var drawableSize: Size {
    var (w, h) = (0, 0) as (Int32, Int32)
    SDL_GL_GetDrawableSize(pointer, &w, &h)
    return Size(x: Double(w), y: Double(h))
  }

  public func displayMode() throws -> DisplayMode {
    var mode = SDL_DisplayMode()
    try Result(code: SDL_GetWindowDisplayMode(pointer, &mode)).get()
    return DisplayMode(mode)
  }

  public func setDisplayMode(_ mode: DisplayMode) throws {
    try withUnsafePointer(to: mode.rawValue) {
      try Result(code: SDL_SetWindowDisplayMode(pointer, $0)).get()
    }
  }

  public init(
    title: String = "",
    position: Position = .undefined,
    size: Size,
    options: Options = []
  ) throws {
    guard let pointer = title.withCString({ stringPtr in
      SDL_CreateWindow(
        stringPtr,
        position.cPosition.x,
        position.cPosition.y,
        Int32(size.x),
        Int32(size.y),
        options.rawValue
      )
    }) else {
      throw LarkError(code: nil, message: SDL_GetError().map(String.init(cString:)))
    }
    self.pointer = pointer
  }

  deinit {
    SDL_DestroyWindow(pointer)
  }
}
