public typealias Configure<Value> = (inout Value) -> Void

public protocol Configurable {}

extension Configurable {
  public __consuming func with(_ configuration: Configure<Self>) -> Self {
    configure(self, with: configuration)
  }
}

extension Configurable where Self: EmptyInitializable {
  public init(configure: Configure<Self>) {
    self.init()
    configure(&self)
  }
}

public func configure<Value>(
    _ value: __owned Value,
    with configure: Configure<Value>
) -> Value {
    var value = /*move*/ value
    configure(&value)
    return value
}
