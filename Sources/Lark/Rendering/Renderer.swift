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

@MainActor
public final class Renderer {
  @usableFromInline
  internal let _sdlRendererPointer: OpaquePointer

  public init(window: Window, options: Options) throws {
    self._sdlRendererPointer = try withThrowingSDL {
      SDL_CreateRenderer(window._sdlWindowPtr, -1, options.rawValue)
    }
  }

  deinit {
    SDL_DestroyRenderer(_sdlRendererPointer)
  }
}

public extension Renderer {
  @inlinable
  func setColor(_ color: Color) {
    SDL_SetRenderDrawColor(
      _sdlRendererPointer,
      color.red,
      color.green,
      color.blue,
      color.alpha
    )
  }

  @inlinable
  func clear() throws {
    try withThrowingSDL {
      SDL_RenderClear(_sdlRendererPointer)
    }
  }

  @inlinable
  func present() {
    SDL_RenderPresent(_sdlRendererPointer)
  }

  func fillRect(_ rect: IRect) throws {
    try withThrowingSDL {
      withUnsafePointer(to: rect) { ptr in
        ptr.withMemoryRebound(to: SDL_Rect.self, capacity: 1) { sdlPtr in
          SDL_RenderFillRect(_sdlRendererPointer, sdlPtr)
        }
      }
    }
  }

  func fillRect(_ rect: FRect) throws {
    try withThrowingSDL {
      withUnsafePointer(to: rect) { ptr in
        ptr.withMemoryRebound(to: SDL_FRect.self, capacity: 1) { sdlPtr in
          SDL_RenderFillRectF(_sdlRendererPointer, sdlPtr)
        }
      }
    }
  }

  func renderCopy(_ texture: Texture, source: IRect? = nil, destination: IRect?) throws {
    try withThrowingSDL {
      withUnsafeOptionalSDLPointer(to: source, reboundTo: SDL_Rect.self) { srcPtr in
        withUnsafeOptionalSDLPointer(to: destination, reboundTo: SDL_Rect.self) { dstPtr in
          SDL_RenderCopy(_sdlRendererPointer, texture.sdlPointer, srcPtr, dstPtr)
        }
      }
    }
  }

  func renderCopy(
    _ texture: Texture,
    source: __shared IRect? = nil,
    destination: __shared FRect?
  ) throws {
    try withThrowingSDL {
      withUnsafeOptionalSDLPointer(to: source, reboundTo: SDL_Rect.self) { srcPtr in
        withUnsafeOptionalSDLPointer(to: destination, reboundTo: SDL_FRect.self) { dstPtr in
          SDL_RenderCopyF(_sdlRendererPointer, texture.sdlPointer, srcPtr, dstPtr)
        }
      }
    }
  }

  func renderCopy(
    _ texture: Texture,
    source: __shared IRect? = nil,
    destination: __shared FRect?,
    rotation: Angle,
    center: FVector2? = nil,
    flip: AxisSet = .none
  ) throws {
    try withThrowingSDL {
      withUnsafeOptionalSDLPointer(to: source, reboundTo: SDL_Rect.self) { srcPtr in
        withUnsafeOptionalSDLPointer(to: destination, reboundTo: SDL_FRect.self) { dstPtr in
          withUnsafeOptionalSDLPointer(to: center, reboundTo: SDL_FPoint.self) { centerPtr in
            SDL_RenderCopyExF(
              _sdlRendererPointer,
              texture.sdlPointer,
              srcPtr,
              dstPtr,
              rotation.degrees,
              centerPtr,
              flip.sdlRendererFlip
            )
          }
        }
      }
    }
  }
}

// TODO: Move

public struct AxisSet: OptionSet {
  public var rawValue: UInt8

  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }

  public static let none: Self = []
  public static let horizontal: Self = .init(rawValue: 1)
  public static let vertical: Self = .init(rawValue: 2)

  internal var sdlRendererFlip: SDL_RendererFlip {
    .init(UInt32(rawValue))
  }
}

// MARK: - Options

public extension Renderer {
  struct Options: OptionSet, Sendable {
    public var rawValue: UInt32

    public init(rawValue: UInt32) {
      self.rawValue = rawValue
    }

    init(_ flags: SDL_RendererFlags) {
      self.rawValue = flags.rawValue
    }

    /// The renderer is a software fallback.
    public static let software: Self = .init(SDL_RENDERER_SOFTWARE)

    /// The renderer uses hardware acceleration.
    public static let accelerated: Self = .init(SDL_RENDERER_ACCELERATED)

    /// Present is synchronized with the refresh rate.
    public static let presentVSync: Self = .init(SDL_RENDERER_PRESENTVSYNC)

    /// The renderer supports rendering to texture.
    public static let targetTexture: Self = .init(SDL_RENDERER_TARGETTEXTURE)
  }
}
