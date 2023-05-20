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

@_exported import CSDL2Image
import SDL2

// public let IMG_INIT_ALL: Int32 = .init(
//    IMG_INIT_JPG.rawValue
//    | IMG_INIT_PNG.rawValue
//    | IMG_INIT_TIF.rawValue
//    | IMG_INIT_WEBP.rawValue
// )

public extension SDL_Surface {
  /// https://sdl.beuc.net/sdl.wiki/Pixel_Access
  @inlinable
  func getPixel(x: Int, y: Int) -> UInt32 {
    let bpp = format.pointee.BytesPerPixel
    let p = pixels.advanced(by: y * Int(pitch) + x * Int(bpp))

    switch bpp {
    case 1:
      return UInt32(p.assumingMemoryBound(to: Uint8.self).pointee)

    case 2:
      return UInt32(p.assumingMemoryBound(to: Uint16.self).pointee)

    case 3:
      let mp = p.assumingMemoryBound(to: UInt32.self)
      if SDL_BYTEORDER == BIG_ENDIAN {
        return mp[0] << 16 | mp[1] << 8 | mp[2]
      } else {
        return mp[0] | mp[1] << 8 | mp[2] << 16
      }

    case 4:
      return p.assumingMemoryBound(to: UInt32.self).pointee

    default:
      assertionFailure("Unexpected bytes per pixel: \(bpp)")
      return 0
    }
  }

  @inlinable
  func getPixelRGBA(x: Int, y: Int) -> (UInt8, UInt8, UInt8, UInt8) {
    let pixel = getPixel(x: x, y: y)
    var r: UInt8 = 0
    var g: UInt8 = 0
    var b: UInt8 = 0
    var a: UInt8 = 0
    SDL_GetRGBA(pixel, format, &r, &g, &b, &a)
    return (r, g, b, a)
  }

  @inlinable
  func getPixelRGB(x: Int, y: Int) -> (UInt8, UInt8, UInt8) {
    let pixel = getPixel(x: x, y: y)
    var r: UInt8 = 0
    var g: UInt8 = 0
    var b: UInt8 = 0
    SDL_GetRGB(pixel, format, &r, &g, &b)
    return (r, g, b)
  }

  @inlinable var pixelBuffer: UnsafeMutableRawBufferPointer {
    let count = Int(Int32(pitch) * h * Int32(format.pointee.BytesPerPixel))
    return UnsafeMutableRawBufferPointer(
      start: pixels,
      count: count
    )
  }
}
