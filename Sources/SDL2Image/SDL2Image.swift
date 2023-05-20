import SDL2
@_exported import CSDL2Image

//public let IMG_INIT_ALL: Int32 = .init(
//    IMG_INIT_JPG.rawValue
//    | IMG_INIT_PNG.rawValue
//    | IMG_INIT_TIF.rawValue
//    | IMG_INIT_WEBP.rawValue
//)

extension SDL_Surface {
    /// https://sdl.beuc.net/sdl.wiki/Pixel_Access
    @inlinable
    public func getPixel(x: Int, y: Int) -> UInt32 {
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
    public func getPixelRGBA(x: Int, y: Int) -> (UInt8, UInt8, UInt8, UInt8) {
        let pixel = getPixel(x: x, y: y)
        var r: UInt8 = 0
        var g: UInt8 = 0
        var b: UInt8 = 0
        var a: UInt8 = 0
        SDL_GetRGBA(pixel, format, &r, &g, &b, &a)
        return (r, g, b, a)
    }

    @inlinable
    public func getPixelRGB(x: Int, y: Int) -> (UInt8, UInt8, UInt8) {
        let pixel = getPixel(x: x, y: y)
        var r: UInt8 = 0
        var g: UInt8 = 0
        var b: UInt8 = 0
        SDL_GetRGB(pixel, format, &r, &g, &b)
        return (r, g, b)
    }

    @inlinable public var pixelBuffer: UnsafeMutableRawBufferPointer {
        let count = Int(Int32(pitch) * h * Int32(format.pointee.BytesPerPixel))
        return UnsafeMutableRawBufferPointer(
            start: pixels,
            count: count
        )
    }
}
