public struct LarkError: Error {
  let code: Int32?
  let message: String?

  init(code: Int32?, message: String? = nil) {
    self.code = code
    self.message = message
  }
}

public extension Result {
  var error: Failure? {
    if case .failure(let error) = self { return error } else { return nil }
  }
}

public extension Result where Success == Void {
  static var success: Self { .success(()) }
}

public extension Result where Success == Void, Failure == LarkError {
  init(code: Int32) {
    if code == 0 {
      self = .success
    } else {
      self = .failure(LarkError(code: code))
    }
  }
}
