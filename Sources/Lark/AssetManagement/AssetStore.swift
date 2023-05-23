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

@MainActor
public final class AssetStore {
  public enum Failure: Error {
    case noResourcePath
  }

  private var textures: [AssetID<Texture>: Texture] = [:]

  @Environment(\.resourcePath) private var resourcePath

  public nonisolated init() {}

  public func clear(keepingCapacity: Bool = false) {
    textures.removeAll(keepingCapacity: keepingCapacity)
  }

  public func addTexture(_ texture: Texture, for id: AssetID<Texture>) {
    textures[id] = texture
  }

  @discardableResult
  public func addTexture(
    at path: String,
    for id: AssetID<Texture>,
    with renderer: Renderer
  ) throws -> Texture {
    let texture = try Texture(
      renderer: renderer,
      surface: Surface(path: resolvedPath(for: path))
    )
    textures[id] = texture
    return texture
  }

  public func texture(for id: AssetID<Texture>) -> Texture? {
    textures[id]
  }

  private func resolvedPath(for path: String) throws -> String {
    guard let resourcePath else { throw Failure.noResourcePath }
    switch (resourcePath.last, path.first) {
    case ("/", "/"):
      return resourcePath.dropLast() + path
    case ("/", _), (_, "/"):
      return resourcePath + path
    default:
      return resourcePath + "/" + path
    }
  }
}

extension AssetStore: EnvironmentKey {
  public static let defaultValue: AssetStore = .init()
}

public extension EnvironmentValues {
  var assetStore: AssetStore {
    get { self[AssetStore.self] }
    set { self[AssetStore.self] = newValue }
  }
}
