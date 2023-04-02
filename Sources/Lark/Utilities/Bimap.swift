public struct Bimap<Key: Hashable, Value: Hashable> {

    @usableFromInline
    internal var byKey: [Key: Value] = [:]

    @usableFromInline
    internal var byValue: [Value: Key] = [:]

    public init() {}

    @inlinable
    public subscript(key key: Key) -> Value? {
        _read {
            yield byKey[key]
        }
        set(newValue) {
            if let newValue {
                setValue(newValue, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }

    @inlinable
    public subscript(value value: Value) -> Key? {
        _read {
            yield byValue[value]
        }
        set(newKey) {
            if let newKey {
                setValue(value, forKey: newKey)
            } else {
                removeKey(forValue: value)
            }
        }
    }

    @inlinable
    @discardableResult
    public mutating func removeValue(forKey key: Key) -> Value? {
        guard let value = byKey.removeValue(forKey: key) else { return nil }
        byValue.removeValue(forKey: value)
        return value
    }

    @inlinable
    @discardableResult
    public mutating func removeKey(forValue value: Value) -> Key? {
        guard let key = byValue.removeValue(forKey: value) else { return nil }
        byKey.removeValue(forKey: key)
        return key
    }

    @inlinable
    public mutating func setValue(_ value: Value, forKey key: Key) {
        byKey[key] = value
        byValue[value] = key
    }
}

extension Bimap: Equatable, Hashable {}

extension Bimap: Sendable where Key: Sendable, Value: Sendable {}

extension Bimap: Sequence, Collection {
    public typealias Index = Dictionary<Key, Value>.Index
    public typealias Element = Dictionary<Key, Value>.Element

    @inlinable
    public var count: Int {
        byKey.count
    }

    @inlinable
    public var startIndex: Dictionary<Key, Value>.Index {
        byKey.startIndex
    }

    @inlinable
    public var endIndex: Dictionary<Key, Value>.Index {
        byKey.endIndex
    }

    @inlinable
    public subscript(position: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Element {
        _read {
            yield byKey[position]
        }
    }

    @inlinable
    public func index(after i: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Index {
        byKey.index(after: i)
    }
}

extension Bimap: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.byKey = .init(minimumCapacity: elements.count)
        self.byValue = .init(minimumCapacity: elements.count)
        
        for (key, value) in elements {
            self.setValue(value, forKey: key)
        }
    }
}
