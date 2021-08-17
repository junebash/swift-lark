import SDL2

public protocol Drawable {
  func draw(renderer: Renderer)
}

public final class Renderer {
  public let window: Window
  var pointer: OpaquePointer
  
  // TODO: Index, flags
  public init(window: Window) {
    self.window = window
    guard let pointer = SDL_CreateRenderer(window.pointer, -1, 0) else {
      preconditionFailure("Failed to initialize SDL Renderer.")
    }
    self.pointer = pointer
  }

  deinit {
    SDL_DestroyRenderer(pointer)
  }

  @discardableResult
  public func setDrawColor(_ color: Color) -> Renderer {
    SDL_SetRenderDrawColor(
      pointer,
      color.red,
      color.green,
      color.blue,
      color.alpha
    )
    return self
  }

  @discardableResult
  public func clear() -> Renderer {
    SDL_RenderClear(pointer)
    return self
  }

  @discardableResult
  public func present() -> Renderer {
    SDL_RenderPresent(pointer)
    return self
  }

  @discardableResult
  public func fill(rect: Rectangle) -> Renderer {
    _ = withUnsafePointer(to: SDL_FRect(
      x: Float(rect.x),
      y: Float(rect.y),
      w: Float(rect.width),
      h: Float(rect.height)
    )) {
      SDL_RenderFillRectF(pointer, $0)
    }
    return self
  }

  @discardableResult
  public func draw(_ renderables: Drawable...) -> Renderer {
    for renderable in renderables {
      renderable.draw(renderer: self)
    }
    return self
  }

}
