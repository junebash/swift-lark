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

import IdentifiedCollections
import OrderedCollections

public protocol System: AnyObject {
  var componentSignature: ComponentSignature { get }
  var entityIDs: EntityIDStore { get set }

  init()

  func update(deltaTime: LarkDuration)
}

extension System {
  @inlinable
  internal static var typeID: ObjectIdentifier { ObjectIdentifier(Self.self) }

  @inlinable
  public func canOperate(on otherSignature: ComponentSignature) -> Bool {
    componentSignature.isSubset(of: otherSignature)
  }
}

public struct EntityIDStore {
  public private(set) var values: OrderedSet<EntityID> = []

  public init() {}

  public mutating func add(_ entity: EntityID) {
    values.append(entity)
  }

  public mutating func remove(_ entity: EntityID) {
    values.remove(entity)
  }
}

extension EntityIDStore: Sequence {
  public typealias Iterator = OrderedSet<EntityID>.Iterator

  public func makeIterator() -> OrderedSet<EntityID>.Iterator {
    values.makeIterator()
  }
}
