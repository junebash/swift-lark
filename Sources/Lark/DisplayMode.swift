import SDL2



public struct DisplayMode {
  internal var rawValue: SDL_DisplayMode = .init()

  public var refreshRate: Int {
    Int(rawValue.refresh_rate)
  }

  public var pixelFormat: PixelFormat {
    PixelFormat(SDL_PixelFormatEnum(rawValue: rawValue.format))
  }

  public var width: Int { Int(rawValue.w) }
  public var height: Int { Int(rawValue.h) }

  init(_ rawValue: SDL_DisplayMode) {
    self.rawValue = rawValue
  }

  public init() {}

  public static func current(_ displayIndex: Int = 0) throws -> DisplayMode {
    var mode = SDL_DisplayMode()
    try Result(code: SDL_GetCurrentDisplayMode(Int32(displayIndex), &mode)).get()
    return DisplayMode(mode)
  }
}
