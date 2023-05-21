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
@MainActor
public final class ComponentProxy<C: Component> {
  @available(*, unavailable, message: "`Proxy` is only available from types conforming to `Entity`")
  public var wrappedValue: C {
    get { fatalError() }
    set { fatalError() }
  }

  public static subscript<E: Entity>(
    _enclosingInstance instance: E,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<E, C>,
    storage storageKeyPath: ReferenceWritableKeyPath<E, ComponentProxy<C>>
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
    storage storageKeyPath: ReferenceWritableKeyPath<E, ComponentProxy<C>>
  ) -> Storage {
    if let storage = instance[keyPath: storageKeyPath].storage {
      return storage
    } else {
      assertionFailure("Proxy wasn't initialized when expected")
      return instance[keyPath: storageKeyPath].initializeStorage(
        instance: instance,
        registry: instance.registry
      )
    }
  }

  private let fallbackValue: C
  private var storage: Storage?

  public init(wrappedValue: C) {
    self.fallbackValue = wrappedValue
  }
}

extension ComponentProxy {
  final class Storage: Sendable {
    let registry: Registry
    let id: EntityID

    @MainActor
    var wrappedValue: C {
      _read { yield registry[C.self, for: id] }
      _modify { yield &registry[C.self, for: id] }
      set { registry[C.self, for: id] = newValue }
    }

    @MainActor
    init(_ initialValue: C, registry: Registry, id: EntityID) {
      self.registry = registry
      self.id = id

      self.registry.addComponent(initialValue, for: id)
    }

    deinit {
      // TODO: Remove task when isolated deinits are stable
      Task { @MainActor [registry, id] in
        registry.removeComponent(C.self, for: id)
      }
    }
  }
}

@MainActor
internal protocol _Proxy: AnyObject {
  associatedtype Storage

  @discardableResult
  func initializeStorage(instance: some Entity, registry: Registry) -> Storage
}

extension ComponentProxy: _Proxy {
  @discardableResult
  internal func initializeStorage(instance: some Entity, registry: Registry) -> Storage {
    if let storage {
      assertionFailure("Attempting to initialize storage twice")
      return storage
    }
    let storage = Storage(
      fallbackValue,
      registry: instance.registry,
      id: instance.id
    )
    self.storage = storage
    return storage
  }
}
