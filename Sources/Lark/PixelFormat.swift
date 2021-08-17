import SDL2

public struct PixelFormat {
  internal var rawValue: SDL_PixelFormatEnum

  internal init(_ rawValue: SDL_PixelFormatEnum) {
    self.rawValue = rawValue
  }

  public static var unknown: PixelFormat { .init(SDL_PIXELFORMAT_UNKNOWN) }
  public static var index1lsb: PixelFormat { .init(SDL_PIXELFORMAT_INDEX1LSB) }
  public static var index1msb: PixelFormat { .init(SDL_PIXELFORMAT_INDEX1MSB) }
  public static var index4lsb: PixelFormat { .init(SDL_PIXELFORMAT_INDEX4LSB) }
  public static var index4msb: PixelFormat { .init(SDL_PIXELFORMAT_INDEX4MSB) }
  public static var index8: PixelFormat { .init(SDL_PIXELFORMAT_INDEX8) }
  public static var rgb332: PixelFormat { .init(SDL_PIXELFORMAT_RGB332) }
  public static var xrgb4444: PixelFormat { .init(SDL_PIXELFORMAT_XRGB4444) }
  public static var rgb444: PixelFormat { .init(SDL_PIXELFORMAT_RGB444) }
  public static var xbgr4444: PixelFormat { .init(SDL_PIXELFORMAT_XBGR4444) }
  public static var bgr444: PixelFormat { .init(SDL_PIXELFORMAT_BGR444) }
  public static var xrgb1555: PixelFormat { .init(SDL_PIXELFORMAT_XRGB1555) }
  public static var rgb555: PixelFormat { .init(SDL_PIXELFORMAT_RGB555) }
  public static var xbgr1555: PixelFormat { .init(SDL_PIXELFORMAT_XBGR1555) }
  public static var bgr555: PixelFormat { .init(SDL_PIXELFORMAT_BGR555) }
  public static var argb4444: PixelFormat { .init(SDL_PIXELFORMAT_ARGB4444) }
  public static var rgba4444: PixelFormat { .init(SDL_PIXELFORMAT_RGBA4444) }
  public static var abgr4444: PixelFormat { .init(SDL_PIXELFORMAT_ABGR4444) }
  public static var bgra4444: PixelFormat { .init(SDL_PIXELFORMAT_BGRA4444) }
  public static var argb1555: PixelFormat { .init(SDL_PIXELFORMAT_ARGB1555) }
  public static var rgba5551: PixelFormat { .init(SDL_PIXELFORMAT_RGBA5551) }
  public static var abgr1555: PixelFormat { .init(SDL_PIXELFORMAT_ABGR1555) }
  public static var bgra5551: PixelFormat { .init(SDL_PIXELFORMAT_BGRA5551) }
  public static var rgb565: PixelFormat { .init(SDL_PIXELFORMAT_RGB565) }
  public static var bgr565: PixelFormat { .init(SDL_PIXELFORMAT_BGR565) }
  public static var rgb24: PixelFormat { .init(SDL_PIXELFORMAT_RGB24) }
  public static var bgr24: PixelFormat { .init(SDL_PIXELFORMAT_BGR24) }
  public static var xrgb8888: PixelFormat { .init(SDL_PIXELFORMAT_XRGB8888) }
  public static var rgb888: PixelFormat { .init(SDL_PIXELFORMAT_RGB888) }
  public static var rgbx8888: PixelFormat { .init(SDL_PIXELFORMAT_RGBX8888) }
  public static var xbgr8888: PixelFormat { .init(SDL_PIXELFORMAT_XBGR8888) }
  public static var bgr888: PixelFormat { .init(SDL_PIXELFORMAT_BGR888) }
  public static var bgrx8888: PixelFormat { .init(SDL_PIXELFORMAT_BGRX8888) }
  public static var argb8888: PixelFormat { .init(SDL_PIXELFORMAT_ARGB8888) }
  public static var rgba8888: PixelFormat { .init(SDL_PIXELFORMAT_RGBA8888) }
  public static var abgr8888: PixelFormat { .init(SDL_PIXELFORMAT_ABGR8888) }
  public static var bgra8888: PixelFormat { .init(SDL_PIXELFORMAT_BGRA8888) }
  public static var argb2101010: PixelFormat { .init(SDL_PIXELFORMAT_ARGB2101010) }
  public static var rgba32: PixelFormat { .init(SDL_PIXELFORMAT_RGBA32) }
  public static var argb32: PixelFormat { .init(SDL_PIXELFORMAT_ARGB32) }
  public static var bgra32: PixelFormat { .init(SDL_PIXELFORMAT_BGRA32) }
  public static var abgr32: PixelFormat { .init(SDL_PIXELFORMAT_ABGR32) }
  public static var yv12: PixelFormat { .init(SDL_PIXELFORMAT_YV12) }
  public static var iyuv: PixelFormat { .init(SDL_PIXELFORMAT_IYUV) }
  public static var yuy2: PixelFormat { .init(SDL_PIXELFORMAT_YUY2) }
  public static var uyvy: PixelFormat { .init(SDL_PIXELFORMAT_UYVY) }
  public static var yvyu: PixelFormat { .init(SDL_PIXELFORMAT_YVYU) }
  public static var nv12: PixelFormat { .init(SDL_PIXELFORMAT_NV12) }
  public static var nv21: PixelFormat { .init(SDL_PIXELFORMAT_NV21) }
  public static var externalOES: PixelFormat { .init(SDL_PIXELFORMAT_EXTERNAL_OES) }
}
