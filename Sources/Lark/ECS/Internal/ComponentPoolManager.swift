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

private protocol _ComponentPool {
  func clear()
  func removeComponent(for entity: EntityID)
}

extension ComponentPool: _ComponentPool {}

internal final class ComponentPoolManager {
  private var componentPools: [ObjectIdentifier: Any] = [:]

  func pool<C: Component>(for: C.Type) -> ComponentPool<C> {
    if let pool = componentPools[C.objectID] as? ComponentPool<C> {
      return pool
    } else {
      let pool = ComponentPool<C>()
      componentPools[C.objectID] = pool
      return pool
    }
  }

  func clearAll() {
    for pool in componentPools.values.lazy.compactMap(_anyPool(from:)) {
      pool.clear()
    }
  }

  func removeAllComponents(for entityID: EntityID) {
    for pool in componentPools.values.lazy.compactMap(_anyPool(from:)) {
      pool.removeComponent(for: entityID)
    }
  }

  private func _anyPool(from value: Any) -> (any _ComponentPool)? {
    guard let pool = value as? any _ComponentPool else {
      assertionFailure("Expected non-ComponentPool in ComponentPoolManager: \(value)")
      return nil
    }
    return pool
  }
}
