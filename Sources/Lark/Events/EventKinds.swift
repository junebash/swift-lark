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

import SDL2

public enum Orientation: Sendable, Hashable {
  case unknown, landscape, landscapeFlipped, portrait, portraitFlipped

  @inlinable
  internal init(sdlOrientation: SDL_DisplayOrientation) {
    switch sdlOrientation {
    case SDL_ORIENTATION_PORTRAIT:
      self = .portrait
    case SDL_ORIENTATION_PORTRAIT_FLIPPED:
      self = .portraitFlipped
    case SDL_ORIENTATION_LANDSCAPE:
      self = .landscape
    case SDL_ORIENTATION_LANDSCAPE_FLIPPED:
      self = .landscapeFlipped
    default:
      self = .unknown
    }
  }
}

public enum DisplayEvent: Sendable, Hashable {
  case none
  case orientationChanged(Orientation)
  case connected
  case disconnected

  @inlinable
  internal init(sdlDisplayEvent: SDL_DisplayEvent) {
    switch SDL_DisplayEventID(UInt32(sdlDisplayEvent.event)) {
    case SDL_DISPLAYEVENT_CONNECTED:
      self = .connected
    case SDL_DISPLAYEVENT_DISCONNECTED:
      self = .disconnected
    case SDL_DISPLAYEVENT_ORIENTATION:
      self = .orientationChanged(
        Orientation(sdlOrientation: .init(UInt32(bitPattern: sdlDisplayEvent.data1)))
      )
    default:
      self = .none
    }
  }
}

public enum WindowEvent: Sendable, Hashable {
  case none, shown, hidden, exposed
  case moved(IPoint2)
  case resized(ISize2)
  case sizeChanged(ISize2)
  case minimized, maximized, restored, enter, leave, focusGained, focusLost, takeFocus, close
  case hitTest, iccProfChanged
  case displayChanged(Int32)

  @inlinable
  internal init(sdlWindowEvent: SDL_WindowEvent) {
    switch SDL_WindowEventID(UInt32(sdlWindowEvent.event)) {
    case SDL_WINDOWEVENT_SHOWN:
      self = .shown
    case SDL_WINDOWEVENT_HIDDEN:
      self = .hidden
    case SDL_WINDOWEVENT_EXPOSED:
      self = .exposed
    case SDL_WINDOWEVENT_MOVED:
      self = .moved(IPoint2(x: sdlWindowEvent.data1, y: sdlWindowEvent.data2))
    case SDL_WINDOWEVENT_RESIZED:
      self = .resized(.init(width: sdlWindowEvent.data1, height: sdlWindowEvent.data2))
    case SDL_WINDOWEVENT_MINIMIZED:
      self = .minimized
    case SDL_WINDOWEVENT_MAXIMIZED:
      self = .maximized
    case SDL_WINDOWEVENT_RESTORED:
      self = .restored
    case SDL_WINDOWEVENT_ENTER:
      self = .enter
    case SDL_WINDOWEVENT_LEAVE:
      self = .leave
    case SDL_WINDOWEVENT_FOCUS_GAINED:
      self = .focusGained
    case SDL_WINDOWEVENT_FOCUS_LOST:
      self = .focusLost
    case SDL_WINDOWEVENT_TAKE_FOCUS:
      self = .takeFocus
    case SDL_WINDOWEVENT_CLOSE:
      self = .close
    case SDL_WINDOWEVENT_HIT_TEST:
      self = .hitTest
    case SDL_WINDOWEVENT_ICCPROF_CHANGED:
      self = .iccProfChanged
    case SDL_WINDOWEVENT_DISPLAY_CHANGED:
      self = .displayChanged(sdlWindowEvent.data1)
    default:
      self = .none
    }
  }
}

public struct KeyEventInfo: Sendable, Hashable {
  public let windowID: UInt32
  public let keyCode: KeyCode?
  public let scanCode: ScanCode?
  public let keyMod: KeyMod
  public let isRepeat: Bool

  @inlinable
  public init(
    windowID: UInt32,
    keyCode: KeyCode?,
    scanCode: ScanCode?,
    keyMod: KeyMod,
    isRepeat: Bool
  ) {
    self.windowID = windowID
    self.keyCode = keyCode
    self.scanCode = scanCode
    self.keyMod = keyMod
    self.isRepeat = isRepeat
  }
}

public enum MouseState: Sendable, Hashable {
  case pressed, released
}

public enum MouseButton: Sendable, Hashable {
  // TODO: add MouseButton cases
}

public struct MouseEventInfo: Sendable, Hashable {
  public struct ButtonInfo: Sendable, Hashable {
    let mouseButton: MouseButton
    let clicks: UInt8
  }

  public enum WheelDirection: Sendable, Hashable {
    case normal, flipped
  }

  public enum Kind: Sendable, Hashable {
    case motion(state: MouseState, motion: IVector2)
    case buttonDown(ButtonInfo)
    case buttonUp(ButtonInfo)
    case wheel(direction: WheelDirection, precisePosition: FPoint2)
  }

  public let windowID: UInt32
  public let mouseID: UInt32
  public let position: IPoint2
  public let kind: Kind
}

public struct JoystickHatState: Sendable, Hashable {
  internal let rawValue: UInt8

  public static let centered: Self = .init(rawValue: 0)
  public static let up: Self = .init(rawValue: 0x01)
  public static let right: Self = .init(rawValue: 0x02)
  public static let down: Self = .init(rawValue: 0x04)
  public static let left: Self = .init(rawValue: 0x08)
  public static let upRight: Self = .init(rawValue: 0x02 | 0x01)
  public static let downRight: Self = .init(rawValue: 0x02 | 0x04)
  public static let upLeft: Self = .init(rawValue: 0x08 | 0x01)
  public static let downLeft: Self = .init(rawValue: 0x08 | 0x04)
}

public struct JoystickEventInfo: Sendable, Hashable {
  public enum Kind: Sendable, Hashable {
    case axisMotion(axisIndex: UInt8, value: Int16)
    case ballMotion(ballIndex: UInt8, relativeMotion: Vector2<Int16>)
    case hatMotion(hatIndex: UInt8, state: JoystickHatState)
    case joyButtonDown(buttonIndex: UInt8)
    case joyButtonUp(buttonIndex: UInt8)
    case deviceAdded
    case deviceRemoved
  }

  public let id: UInt32
  public let kind: Kind
}

public enum ControllerButton: Sendable, Hashable {
  case a, b, x, y
  case back, guide, start
  case leftStick, rightStick, leftShoulder, rightShoulder
  case dPadUp, dPadDown, dPadLeft, dPadRight
  case misc, touchpad
  case paddle1, paddle2, paddle3, paddle4

  init?(sdlControllerButton: SDL_GameControllerButton) {
    switch sdlControllerButton {
    case SDL_CONTROLLER_BUTTON_A: self = .a
    case SDL_CONTROLLER_BUTTON_B: self = .b
    case SDL_CONTROLLER_BUTTON_X: self = .x
    case SDL_CONTROLLER_BUTTON_Y: self = .y
    case SDL_CONTROLLER_BUTTON_BACK: self = .back
    case SDL_CONTROLLER_BUTTON_GUIDE: self = .guide
    case SDL_CONTROLLER_BUTTON_START: self = .start
    case SDL_CONTROLLER_BUTTON_LEFTSTICK: self = .leftStick
    case SDL_CONTROLLER_BUTTON_RIGHTSTICK: self = .rightStick
    case SDL_CONTROLLER_BUTTON_LEFTSHOULDER: self = .leftShoulder
    case SDL_CONTROLLER_BUTTON_RIGHTSHOULDER: self = .rightShoulder
    case SDL_CONTROLLER_BUTTON_DPAD_UP: self = .dPadUp
    case SDL_CONTROLLER_BUTTON_DPAD_DOWN: self = .dPadDown
    case SDL_CONTROLLER_BUTTON_DPAD_LEFT: self = .dPadLeft
    case SDL_CONTROLLER_BUTTON_DPAD_RIGHT: self = .dPadRight
    case SDL_CONTROLLER_BUTTON_MISC1: self = .misc
    case SDL_CONTROLLER_BUTTON_PADDLE1: self = .paddle1
    case SDL_CONTROLLER_BUTTON_PADDLE2: self = .paddle2
    case SDL_CONTROLLER_BUTTON_PADDLE3: self = .paddle3
    case SDL_CONTROLLER_BUTTON_PADDLE4: self = .paddle4
    case SDL_CONTROLLER_BUTTON_TOUCHPAD: self = .touchpad
    default: return nil
    }
  }
}

public enum ControllerAxis: Sendable, Hashable {
  case leftX
  case leftY
  case rightX
  case rightY
  case triggerLeft
  case triggerRight

  internal init?(sdlAxis: SDL_GameControllerAxis) {
    switch sdlAxis {
    case SDL_CONTROLLER_AXIS_LEFTX: self = .leftX
    case SDL_CONTROLLER_AXIS_LEFTY: self = .leftY
    case SDL_CONTROLLER_AXIS_RIGHTX: self = .rightX
    case SDL_CONTROLLER_AXIS_RIGHTY: self = .rightY
    case SDL_CONTROLLER_AXIS_TRIGGERLEFT: self = .triggerLeft
    case SDL_CONTROLLER_AXIS_TRIGGERRIGHT: self = .triggerRight
    default: return nil
    }
  }
}

public struct ControllerEventInfo: Sendable, Hashable {
  public struct TouchpadEventInfo: Sendable, Hashable {
    public let index: UInt32
    public let fingerIndex: UInt32
    /// Normalized 0...1, 0 at top-left
    public let position: FVector2
    /// Normalized 0...1
    public let pressure: Double
  }

  public enum Kind: Sendable, Hashable {
    case axisMotion(axis: ControllerAxis, value: Int16)
    case buttonDown(ControllerButton)
    case buttonUp(ControllerButton)
    case deviceAdded
    case deviceRemoved
    case deviceRemapped
    case touchpadDown(TouchpadEventInfo)
    case touchpadMotion(TouchpadEventInfo)
    case touchpadUp(TouchpadEventInfo)
    case sensorUpdated // TODO:
  }

  public let id: UInt32
  public let kind: Kind
}

public struct FingerEventInfo: Sendable, Hashable {
  public enum Kind: Sendable, Hashable {
    case fingerUp
    case fingerDown
    case motion
  }

  public let touchID: Int
  public let fingerID: Int
  public let position: FPoint2
  public let delta: FVector2
  public let pressure: Double
  public let kind: Kind
}

public struct DollarEventInfo: Sendable, Hashable {
  public let gestureID: Int
  public let error: Float
}

public struct TouchEventInfo: Sendable, Hashable {
  public enum Kind: Sendable, Hashable {
    case dollarGesture(DollarEventInfo)
    case dollarRecord(DollarEventInfo)
    case multiGesture(dTheta: Double, dDist: Double)
  }

  public let kind: Kind
  public let touchID: Int
  public let fingerCount: UInt32
  public let position: FPoint2
}

public struct DropEventInfo: Sendable, Hashable {
  public enum Kind: Sendable, Hashable {
    case dropFile(fileName: String)
    case dropText(fileName: String)
    case dropBegin
    case dropComplete
  }

  public let windowID: UInt32
  public let kind: Kind
}

public struct AudioDeviceEventInfo: Sendable, Hashable {
  public enum Kind: Sendable, Hashable {
    case added, removed
  }

  public let id: UInt32
  public let isCapture: Bool
  public let kind: Kind
}

public struct UserEventInfo: Sendable, Hashable {
  public struct Registration: Sendable, Hashable {
    internal let rawValue: UInt32

    internal init(rawValue: UInt32) {
      self.rawValue = rawValue
    }
  }

  public var registration: Registration
  public var code: Int32
  public var windowID: UInt32
  public var data1: [UInt8]
  public var data2: [UInt8]

  public init(
    registration: Registration,
    code: Int32,
    windowID: UInt32,
    data1: [UInt8] = [],
    data2: [UInt8] = []
  ) {
    self.registration = registration
    self.code = code
    self.windowID = windowID
    self.data1 = data1
    self.data2 = data2
  }
}
