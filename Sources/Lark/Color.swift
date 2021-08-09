public struct Color {
  public var red, green, blue, alpha: UInt8

  public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
  }

  public static var white: Color {
    Color(red: 255, green: 255, blue: 255, alpha: 255)
  }

  public static var black: Color {
    Color(red: 0, green: 0, blue: 0, alpha: 255)
  }
}
