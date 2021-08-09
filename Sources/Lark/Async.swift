@available(macOS, deprecated: 12.0, message: "Use Swift.AsyncStream")
public struct AsyncStream<Output> {
  public typealias Completion = (Output) -> Void
  public typealias Runner = (@escaping Completion) -> Void
  
  private let _run: Runner

  public init(_ run: @escaping Runner) {
    self._run = run
  }

  public func run(_ completion: @escaping Completion) {
    self._run(completion)
  }
}
