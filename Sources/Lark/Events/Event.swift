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

public struct Event: Sendable, Hashable {
  public enum Kind: Sendable, Hashable {
    case quit
    case appTerminating
    case appLowMemory
    case appWillEnterBackground
    case appDidEnterBackground
    case appWillEnterForeground
    case appDidEnterForeground
    case localeDidChange
    case display(index: Int32, event: DisplayEvent)
    case window(id: UInt32, event: WindowEvent)
    case keyDown(KeyEventInfo)
    case keyUp(KeyEventInfo)
    case textEditing(windowID: UInt32, text: String, start: Int, length: Int)
    case textInput(windowID: UInt32, text: String)
    case mouse(MouseEventInfo)
    case joystick(JoystickEventInfo)
    case controller(ControllerEventInfo)
    case finger(FingerEventInfo)
    case clipboardUpdate
    case touch(TouchEventInfo)
    case drop(DropEventInfo)
    case audioDevice(AudioDeviceEventInfo)
    case renderTargetsReset
    case renderDeviceReset
    case user(UserEventInfo)
  }

  public var kind: Kind
  public var timestamp: LarkClock.Instant

  @inlinable
  public init(kind: Kind, timestamp: LarkClock.Instant) {
    self.kind = kind
    self.timestamp = timestamp
  }
}
