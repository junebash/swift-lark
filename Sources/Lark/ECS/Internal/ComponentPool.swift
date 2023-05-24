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

internal final class ComponentPool<C: Component> {
  private var values: [EntityID: C] = [:]

  var count: Int { values.count }

  init() {}

  subscript(entityID entityID: EntityID) -> C {
    _read {
      yield values[
        entityID,
        default: {
          preconditionFailure("Expected component \(C.self) for entity \(entityID)")
        }()]
    }
    _modify {
      yield &values[
        entityID,
        default: {
          preconditionFailure("Expected component \(C.self) for entity \(entityID)")
        }()]
    }
    set {
      values[
        entityID,
        default: {
          preconditionFailure("Expected component \(C.self) for entity \(entityID)")
        }()] = newValue
    }
  }

  func set(_ component: C, for entity: EntityID) {
    values[entity] = component
  }

  func getComponent(for entity: EntityID) -> C? {
    values[entity]
  }

  func removeComponent(for entity: EntityID) {
    values.removeValue(forKey: entity)
  }

  func clear() {
    values.removeAll(keepingCapacity: true)
  }
}
