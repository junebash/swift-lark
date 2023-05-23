// Copyright (c) 2023 June Bash
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SDL2

public struct Palette {
  internal var palettePointer: UnsafeMutablePointer<SDL_Palette>

  init(palettePointer: UnsafeMutablePointer<SDL_Palette>) {
    self.palettePointer = palettePointer
  }
}

public final class PixelFormat {
  internal var sdlPointer: UnsafeMutablePointer<SDL_PixelFormat>

  private var needsFree: Bool = false

  internal var sdlValue: SDL_PixelFormat { sdlPointer.pointee }

  public var kind: Kind { Kind(rawValue: sdlValue.format) }

  public var palette: Palette { Palette(palettePointer: sdlValue.palette) }

  public var bitsPerPixel: UInt8 { sdlValue.BitsPerPixel }
  public var bytesPerPixel: UInt8 { sdlValue.BytesPerPixel }

  public var rMask: UInt32 { sdlValue.Rmask }
  public var gMask: UInt32 { sdlValue.Gmask }
  public var bMask: UInt32 { sdlValue.Bmask }
  public var aMask: UInt32 { sdlValue.Amask }
  public var rLoss: UInt8 { sdlValue.Rloss }
  public var gLoss: UInt8 { sdlValue.Gloss }
  public var bLoss: UInt8 { sdlValue.Bloss }
  public var aLoss: UInt8 { sdlValue.Aloss }
  public var rShift: UInt8 { sdlValue.Rshift }
  public var gShift: UInt8 { sdlValue.Gshift }
  public var bShift: UInt8 { sdlValue.Bshift }
  public var aShift: UInt8 { sdlValue.Ashift }
  public var referenceCount: Int32 { sdlValue.refcount }

  public func next() -> PixelFormat? {
    PixelFormat(formatPointer: sdlValue.next)
  }

  internal init?(formatPointer: UnsafeMutablePointer<SDL_PixelFormat>?) {
    guard let formatPointer else { return nil }
    self.sdlPointer = formatPointer
  }

  public init(kind: Kind) throws {
    self.sdlPointer = try withThrowingSDL {
      SDL_AllocFormat(kind.rawValue)
    }
    self.needsFree = true
  }

  deinit {
    if needsFree {
      SDL_FreeFormat(sdlPointer)
    }
  }
}

// MARK: - Kind

public extension PixelFormat {
  enum Kind {
    case unknown
    case index1lsb
    case index1msb
    case index4lsb
    case index4msb
    case index8
    case rgb332
    case rgb444
    case rgb555
    case bgr555
    case argb4444
    case rgba4444
    case abgr4444
    case bgra4444
    case argb1555
    case rgba5551
    case abgr1555
    case bgra5551
    case rgb565
    case bgr565
    case rgb24
    case bgr24
    case rgb888
    case rgbx8888
    case bgr888
    case bgrx8888
    case argb8888
    case rgba8888
    case abgr8888
    case bgra8888
    case argb2101010
    case yv12
    case iyuv
    case yuy2
    case uyvy
    case yvyu

    public static let rgba32: Self = .init(bigEndian: .rgba8888, littleEndian: .abgr8888)
    public static let argb32: Self = .init(bigEndian: .argb8888, littleEndian: .bgra8888)
    public static let bgra32: Self = .init(bigEndian: .bgra8888, littleEndian: .argb8888)
    public static let abgr32: Self = .init(bigEndian: .abgr8888, littleEndian: .rgba8888)

    public var rawValue: UInt32 {
      sdlPixelFormat.rawValue
    }

    public init(rawValue: UInt32) {
      self.init(sdlPixelFormat: SDL_PixelFormatEnum(rawValue: rawValue))
    }

    // MARK: - Internal

    internal var sdlPixelFormat: SDL_PixelFormatEnum {
      switch self {
      case .unknown: return SDL_PIXELFORMAT_UNKNOWN
      case .index1lsb: return SDL_PIXELFORMAT_INDEX1LSB
      case .index1msb: return SDL_PIXELFORMAT_INDEX1MSB
      case .index4lsb: return SDL_PIXELFORMAT_INDEX4LSB
      case .index4msb: return SDL_PIXELFORMAT_INDEX4MSB
      case .index8: return SDL_PIXELFORMAT_INDEX8
      case .rgb332: return SDL_PIXELFORMAT_RGB332
      case .rgb444: return SDL_PIXELFORMAT_RGB444
      case .rgb555: return SDL_PIXELFORMAT_RGB555
      case .bgr555: return SDL_PIXELFORMAT_BGR555
      case .argb4444: return SDL_PIXELFORMAT_ARGB4444
      case .rgba4444: return SDL_PIXELFORMAT_RGBA4444
      case .abgr4444: return SDL_PIXELFORMAT_ABGR4444
      case .bgra4444: return SDL_PIXELFORMAT_BGRA4444
      case .argb1555: return SDL_PIXELFORMAT_ARGB1555
      case .rgba5551: return SDL_PIXELFORMAT_RGBA5551
      case .abgr1555: return SDL_PIXELFORMAT_ABGR1555
      case .bgra5551: return SDL_PIXELFORMAT_BGRA5551
      case .rgb565: return SDL_PIXELFORMAT_RGB565
      case .bgr565: return SDL_PIXELFORMAT_BGR565
      case .rgb24: return SDL_PIXELFORMAT_RGB24
      case .bgr24: return SDL_PIXELFORMAT_BGR24
      case .rgb888: return SDL_PIXELFORMAT_RGB888
      case .rgbx8888: return SDL_PIXELFORMAT_RGBX8888
      case .bgr888: return SDL_PIXELFORMAT_BGR888
      case .bgrx8888: return SDL_PIXELFORMAT_BGRX8888
      case .argb8888: return SDL_PIXELFORMAT_ARGB8888
      case .rgba8888: return SDL_PIXELFORMAT_RGBA8888
      case .abgr8888: return SDL_PIXELFORMAT_ABGR8888
      case .bgra8888: return SDL_PIXELFORMAT_BGRA8888
      case .argb2101010: return SDL_PIXELFORMAT_ARGB2101010
      case .yv12: return SDL_PIXELFORMAT_YV12
      case .iyuv: return SDL_PIXELFORMAT_IYUV
      case .yuy2: return SDL_PIXELFORMAT_YUY2
      case .uyvy: return SDL_PIXELFORMAT_UYVY
      case .yvyu: return SDL_PIXELFORMAT_YVYU
      }
    }

    internal init(sdlPixelFormat: SDL_PixelFormatEnum) {
      switch sdlPixelFormat {
      case SDL_PIXELFORMAT_INDEX1LSB: self = .index1lsb
      case SDL_PIXELFORMAT_INDEX1MSB: self = .index1msb
      case SDL_PIXELFORMAT_INDEX4LSB: self = .index4lsb
      case SDL_PIXELFORMAT_INDEX4MSB: self = .index4msb
      case SDL_PIXELFORMAT_INDEX8: self = .index8
      case SDL_PIXELFORMAT_RGB332: self = .rgb332
      case SDL_PIXELFORMAT_RGB444: self = .rgb444
      case SDL_PIXELFORMAT_RGB555: self = .rgb555
      case SDL_PIXELFORMAT_BGR555: self = .bgr555
      case SDL_PIXELFORMAT_ARGB4444: self = .argb4444
      case SDL_PIXELFORMAT_RGBA4444: self = .rgba4444
      case SDL_PIXELFORMAT_ABGR4444: self = .abgr4444
      case SDL_PIXELFORMAT_BGRA4444: self = .bgra4444
      case SDL_PIXELFORMAT_ARGB1555: self = .argb1555
      case SDL_PIXELFORMAT_RGBA5551: self = .rgba5551
      case SDL_PIXELFORMAT_ABGR1555: self = .abgr1555
      case SDL_PIXELFORMAT_BGRA5551: self = .bgra5551
      case SDL_PIXELFORMAT_RGB565: self = .rgb565
      case SDL_PIXELFORMAT_BGR565: self = .bgr565
      case SDL_PIXELFORMAT_RGB24: self = .rgb24
      case SDL_PIXELFORMAT_BGR24: self = .bgr24
      case SDL_PIXELFORMAT_RGB888: self = .rgb888
      case SDL_PIXELFORMAT_RGBX8888: self = .rgbx8888
      case SDL_PIXELFORMAT_BGR888: self = .bgr888
      case SDL_PIXELFORMAT_BGRX8888: self = .bgrx8888
      case SDL_PIXELFORMAT_ARGB8888: self = .argb8888
      case SDL_PIXELFORMAT_RGBA8888: self = .rgba8888
      case SDL_PIXELFORMAT_ABGR8888: self = .abgr8888
      case SDL_PIXELFORMAT_BGRA8888: self = .bgra8888
      case SDL_PIXELFORMAT_ARGB2101010: self = .argb2101010
      case SDL_PIXELFORMAT_YV12: self = .yv12
      case SDL_PIXELFORMAT_IYUV: self = .iyuv
      case SDL_PIXELFORMAT_YUY2: self = .yuy2
      case SDL_PIXELFORMAT_UYVY: self = .uyvy
      case SDL_PIXELFORMAT_YVYU: self = .yvyu
      default: self = .unknown
      }
    }

    internal init(
      bigEndian: @autoclosure () -> Self,
      littleEndian: @autoclosure () -> Self
    ) {
      if Endianness.current == .big {
        self = bigEndian()
      } else {
        self = littleEndian()
      }
    }
  }
}
