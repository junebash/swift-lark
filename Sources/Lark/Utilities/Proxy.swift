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
@dynamicMemberLookup
public struct Proxy<Value> {
  private let get: () -> Value
  private let set: (Value) -> Void

  public var wrappedValue: Value {
    get { get() }
    nonmutating set { set(newValue) }
  }

  public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
    self.get = get
    self.set = set
  }

  public init<Root: AnyObject>(
    _ strongRoot: Root,
    _ keyPath: ReferenceWritableKeyPath<Root, Value>
  ) {
    self.init(
      get: { strongRoot[keyPath: keyPath] },
      set: { strongRoot[keyPath: keyPath] = $0 }
    )
  }

  public init<Root: AnyObject>(
    weak root: Root,
    _ keyPath: ReferenceWritableKeyPath<Root, Value>
  ) {
    var fallback = root[keyPath: keyPath]
    self.init(
      get: { [weak root] in root?[keyPath: keyPath] ?? fallback },
      set: { [weak root] in
        root?[keyPath: keyPath] = $0
        fallback = $0
      }
    )
  }

  public subscript<NewValue>(
    dynamicMember keyPath: WritableKeyPath<Value, NewValue>
  ) -> Proxy<NewValue> {
    Proxy<NewValue>(
      get: { wrappedValue[keyPath: keyPath] },
      set: { wrappedValue[keyPath: keyPath] = $0 }
    )
  }
}
