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

public final class Texture {
  public struct Metadata {
    public var size: ISize2
    public var formatKind: PixelFormat.Kind
    public var accessRawValue: Int32 // TODO: Add actual 'access' type
  }

  let sdlPointer: OpaquePointer

  public var size: ISize2 {
    var size = ISize2()
    SDL_QueryTexture(sdlPointer, nil, nil, &size.width, &size.height)
    return size
  }

  public init(renderer: Renderer, surface: Surface) throws {
    let texturePointer = try withThrowingSDL {
      SDL_CreateTextureFromSurface(renderer._sdlRendererPointer, surface.sdlPointer)
    }
    self.sdlPointer = texturePointer
    // TODO: Format, Access
  }

  public func metadata() throws -> Metadata {
    var formatRawValue: UInt32 = 0
    var accessRawValue: Int32 = 0
    var width: Int32 = 0
    var height: Int32 = 0
    try withThrowingSDL {
      SDL_QueryTexture(
        sdlPointer,
        &formatRawValue,
        &accessRawValue,
        &width,
        &height
      )
    }
    return Metadata(
      size: ISize2(width: width, height: height),
      formatKind: PixelFormat.Kind(rawValue: formatRawValue),
      accessRawValue: accessRawValue
    )
  }

  deinit {
    SDL_DestroyTexture(sdlPointer)
  }
}
