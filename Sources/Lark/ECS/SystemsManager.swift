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

public struct SystemsManager {
    private var systems: [ObjectIdentifier: any System] = [:]

    internal init() {}

    public subscript<S: System>(type: S.Type) -> S? {
        _read { yield systems[S.typeID] as? S }
    }

    public subscript<S: System>(type: S.Type, default defaultValue: @autoclosure () -> S) -> S {
        mutating get {
            if let system = self.system(S.self) {
                return system
            } else {
                let system = defaultValue()
                setSystem(system)
                return system
            }
        }
        _modify {
            var system = self.system() ?? defaultValue()
            yield &system
            self.setSystem(system)
        }
        set {
            self.setSystem(newValue)
        }
    }

    public func system<S: System>(_: S.Type = S.self) -> S? {
        systems[S.typeID] as? S
    }

    public mutating func setSystem<S: System>(_ system: S) {
        systems[S.typeID] = system
    }

    public func hasSystem<S: System>(_: S.Type) -> Bool {
        systems.keys.contains(ObjectIdentifier(S.self))
    }

    public mutating func removeSystem<S: System>(_: S.Type) {
        systems.removeValue(forKey: ObjectIdentifier(S.self))
    }

    public mutating func addEntity(
        _ entity: Entity,
        toSystemsWithSignature signature: ComponentSignature
    ) {
        for system in systems.values where system.canOperate(on: signature) {
            system.entities.add(entity)
        }
    }
}
