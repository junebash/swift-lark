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

@propertyWrapper
public struct Proxy<C: Component> {
  private final class Storage {
    let registry: Registry
    let id: EntityID

    var wrappedValue: C {
      get {
        registry.component(C.self, for: id)!
      }
      set {
        registry.withComponent(C.self, for: id) {
          $0 = newValue
        }
      }
    }

    init(_ initialValue: C, registry: Registry, id: EntityID) {
      self.registry = registry
      self.id = id

      self.registry.addComponent(initialValue, for: id)
    }

    deinit {
      registry.removeComponent(C.self, for: id)
    }
  }

  @available(*, unavailable, message: "`Proxy` is only available from types conforming to `Entity`")
  public var wrappedValue: C {
    get { fatalError() }
    set { fatalError() }
  }

  public static subscript<E: Entity>(
    _enclosingInstance instance: E,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<E, C>,
    storage storageKeyPath: ReferenceWritableKeyPath<E, Self>
  ) -> C {
    get {
      storage(instance, wrapped: wrappedKeyPath, storage: storageKeyPath).wrappedValue
    }
    set {
      storage(instance, wrapped: wrappedKeyPath, storage: storageKeyPath).wrappedValue = newValue
    }
  }

  private static func storage<E: Entity>(
    _ instance: E,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<E, C>,
    storage storageKeyPath: ReferenceWritableKeyPath<E, Self>
  ) -> Storage {
    if let storage = instance[keyPath: storageKeyPath].storage {
      return storage
    } else {
      let storage = Storage(
        instance[keyPath: storageKeyPath].fallbackValue,
        registry: instance.registry,
        id: instance.id
      )
      instance[keyPath: storageKeyPath].storage = storage
      return storage
    }
  }

  private let fallbackValue: C
  private var storage: Storage?

  public init(wrappedValue: C) {
    self.fallbackValue = wrappedValue
  }
}
