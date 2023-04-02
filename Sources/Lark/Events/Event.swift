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
    public var timestamp: Duration

    @inlinable
    public init(kind: Kind, timestamp: Duration) {
        self.kind = kind
        self.timestamp = timestamp
    }
}
