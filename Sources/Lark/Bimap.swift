public struct Bimap<Key: Hashable, Value: Hashable> {
    private var byKey: [Key: Value] = [:]
    private var byValue: [Value: Key] = [:]

    public init() {}

    public subscript(key key: Key) -> Value? {
        _read {
            yield byKey[key]
        }
    }

    public subscript(value value: Value) -> Key? {
        _read {
            yield byValue[value]
        }
    }

    @discardableResult
    public mutating func removeValue(forKey key: Key) -> Value? {
        guard let value = byKey.removeValue(forKey: key) else { return nil }
        byValue.removeValue(forKey: value)
        return value
    }

    @discardableResult
    public mutating func removeKey(forValue value: Value) -> Key? {
        guard let key = byValue.removeValue(forKey: value) else { return nil }
        byKey.removeValue(forKey: key)
        return key
    }

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

    public var startIndex: Dictionary<Key, Value>.Index {
        byKey.startIndex
    }

    public var endIndex: Dictionary<Key, Value>.Index {
        byKey.endIndex
    }

    public subscript(position: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Element {
        _read {
            yield byKey[position]
        }
    }

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
