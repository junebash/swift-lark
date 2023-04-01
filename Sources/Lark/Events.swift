import SDL2

public enum Orientation {
    case unknown, landscape, landscapeFlipped, portrait, portraitFlipped
}

public enum DisplayEvent {
    case none
    case orientationChanged(Orientation)
    case connected
    case disconnected
}

public enum WindowEvent {
    case none, shown, hidden, exposed
    case moved(IPoint)
    case resized(ISize)
    case sizeChanged(ISize)
    case minimized, maximized, restored, enter, leave, focusGained, focusLost, takeFocus, close
    case hitTest, iccProfChanged
    case displayChanged(Int32)
}

public struct KeyEventInfo {
    public let windowID: UInt32
    public let keyCode: KeyCode?
    public let scanCode: ScanCode?
    public let keyMod: KeyMod
    public let isRepeat: Bool
}

public enum MouseState {
    case pressed, released
}

public enum MouseButton {

}


public struct MouseEventInfo {
    public struct ButtonInfo {
        let mouseButton: MouseButton
        let clicks: UInt8
    }

    public enum WheelDirection {
        case normal, flipped
    }

    public enum Kind {
        case motion(state: MouseState, motion: IVector)
        case buttonDown(ButtonInfo)
        case buttonUp(ButtonInfo)
        case wheel(direction: WheelDirection, precisePosition: FPoint)
    }

    public let windowID: UInt32
    public let mouseID: UInt32
    public let position: IPoint
    public let kind: Kind
}

public struct JoystickHatState {
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

public struct JoystickEventInfo {
    public enum Kind {
        case axisMotion(axisIndex: UInt8, value: Int16)
        case ballMotion(ballIndex: UInt8, relativeMotion: Vector<Int16>)
        case hatMotion(hatIndex: UInt8, state: JoystickHatState)
        case joyButtonDown(buttonIndex: UInt8)
        case joyButtonUp(buttonIndex: UInt8)
        case deviceAdded
        case deviceRemoved
    }

    public let id: UInt32
    public let kind: Kind
}

public enum ControllerButton {
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

public enum ControllerAxis {
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

public struct ControllerEventInfo {
    public struct TouchpadEventInfo {
        public let index: UInt32
        public let fingerIndex: UInt32
        /// Normalized 0...1, 0 at top-left
        public let position: FVector
        /// Normalized 0...1
        public let pressure: Double
    }

    public enum Kind {
        case axisMotion(axis: ControllerAxis, value: Int16)
        case buttonDown(ControllerButton)
        case buttonUp(ControllerButton)
        case deviceAdded
        case deviceRemoved
        case deviceRemapped
        case touchpadDown(TouchpadEventInfo)
        case touchpadMotion(TouchpadEventInfo)
        case touchpadUp(TouchpadEventInfo)
        case sensorUpdated // TODO
        /*
         /// Triggered when the gyroscope or accelerometer is updated
         #[cfg(feature = "hidapi")]
         ControllerSensorUpdated {
             timestamp: u32,
             which: u32,
             sensor: crate::sensor::SensorType,
             /// Data from the sensor.
             ///
             /// See the `sensor` module for more information.
             data: [f32; 3],
         },
         */
    }

    public let id: UInt32
    public let kind: Kind
}

public struct FingerEventInfo {
    public enum Kind {
        case fingerUp
        case fingerDown
        case motion
    }

    public let touchID: Int
    public let fingerID: Int
    public let position: FPoint
    public let delta: FVector
    public let pressure: Double
    public let kind: Kind
}

public struct DollarEventInfo {
    public let gestureID: Int
    public let error: Float
}

public struct TouchEventInfo {
    public enum Kind {
        case dollarGesture(DollarEventInfo)
        case dollarRecord(DollarEventInfo)
        case multiGesture(dTheta: Double, dDist: Double)
    }

    public let kind: Kind
    public let touchID: Int
    public let fingerCount: UInt32
    public let position: FPoint
}

public struct DropEventInfo {
    public enum Kind {
        case dropFile(fileName: String)
        case dropText(fileName: String)
        case dropBegin
        case dropComplete
    }

    public let windowID: UInt32
    public let kind: Kind
}

public struct AudioDeviceEventInfo {
    public enum Kind {
        case added, removed
    }

    public let id: UInt32
    public let isCapture: Bool
    public let kind: Kind
}

public struct UserEventInfo {
    public struct Registration: Hashable {
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

public struct Event {
    public enum Kind {
        case quit
        case appTerminating
        case appLowMemory
        case appWillEnterBackground
        case appDidEnterBackground
        case appWillEnterForeground
        case appDidEnterForeground
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
    public var timestamp: Duration
}

extension Event {
    internal struct Poll: Sequence, IteratorProtocol {
        private var event: SDL_Event = .init()

        init() {}

        mutating func next() -> Event? {
            guard SDL_PollEvent(&event) == 1 else { return nil }
            // TODO
            return nil
        }
    }
}

public struct Events: Sendable {
    private var _makeEvents: @Sendable () -> [Event]

    public init(_ makeEvents: @escaping @Sendable () -> some Sequence<Event>) {
        self._makeEvents = { Array(makeEvents()) }
    }

    public func callAsFunction() -> [Event] {
        _makeEvents()
    }
}
