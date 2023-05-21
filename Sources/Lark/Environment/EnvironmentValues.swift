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

import Clocks

public struct EnvironmentValues: Sendable {
  @TaskLocal public static var current: EnvironmentValues = .init()

  @usableFromInline
  internal var values: [ObjectIdentifier: any Sendable] = [:]

  @usableFromInline
  internal init(values: [ObjectIdentifier: any Sendable]) {
    self.values = values
  }

  public init() {}

  @inlinable
  public subscript<Key: EnvironmentKey>(key: Key.Type) -> Key.Value {
    get { values[ObjectIdentifier(key)] as? Key.Value ?? key.defaultValue }
    set { values[ObjectIdentifier(key)] = newValue }
  }

  public static func withValues<R>(
    _ update: (inout EnvironmentValues) -> Void,
    perform operation: () throws -> R
  ) rethrows -> R {
    var values = Self.current
    update(&values)
    return try EnvironmentValues.$current.withValue(values, operation: operation)
  }

  public static func withValues<R>(
    _ update: (inout EnvironmentValues) -> Void,
    perform operation: () async throws -> R
  ) async rethrows -> R {
    var values = Self.current
    update(&values)
    return try await EnvironmentValues.$current.withValue(values, operation: operation)
  }

  public func merging(with other: EnvironmentValues) -> EnvironmentValues {
    Self(values: values.merging(other.values, uniquingKeysWith: { $1 }))
  }
}
