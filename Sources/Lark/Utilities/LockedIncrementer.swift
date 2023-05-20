import Lock

@usableFromInline
internal struct LockedIncrementer<Value: Numeric> {
  @usableFromInline
  let value: Lock<Value>

  @usableFromInline
  init() {
    value = .init(unchecked: .zero)
  }

  @inlinable
  func next() -> Value {
    value.withLock { value in
      defer { value += 1 }
      return value
    }
  }
}

extension LockedIncrementer: Sendable where Value: Sendable {}
