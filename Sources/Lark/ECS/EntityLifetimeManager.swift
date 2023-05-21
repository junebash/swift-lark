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

internal struct EntityLifetimeManager {
  @Environment(\.logger) var logger

  private var entityCount: UInt64 = 0
  private var entitiesToBeAdded: [EntityID] = []
  private var entitiesToBeRemoved: [EntityID] = []

  internal mutating func createEntityID() -> EntityID {
    defer { entityCount += 1 }

    let entityID = EntityID(rawValue: entityCount)
    entitiesToBeAdded.append(entityID)

    logger.log(level: .info, "Entity created with ID: \(entityID)")

    return entityID
  }

  internal mutating func withEntitiesToAdd(_ operation: (_ toAdd: [EntityID]) -> Void) {
    operation(entitiesToBeAdded)
    entitiesToBeAdded.removeAll(keepingCapacity: true)
  }

  internal mutating func withEntitiesToRemove(_ operation: (_ toRemove: [EntityID]) -> Void) {
    operation(entitiesToBeRemoved)
    entitiesToBeRemoved.removeAll(keepingCapacity: true)
  }

  internal mutating func removeEntity(_ entityID: EntityID) {
    entitiesToBeRemoved.append(entityID)
    logger.log(level: .info, "Removing entity with ID: \(entityID)")
  }
}
