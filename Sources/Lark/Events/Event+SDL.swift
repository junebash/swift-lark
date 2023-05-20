import SDL2

extension Event {
    @inlinable
    init?(event: SDL_Event) {
        guard let kind = Event.Kind(event: event) else { return nil }
      self = .init(kind: kind, timestamp: EnvironmentValues.current.updateClock.now)
//        self = .init(kind: kind, timestamp: EnvironmentValues.current.updateClock.now)
    }
}

extension Event.Kind {
    @inlinable
    init?(event: SDL_Event) {
        switch SDL_EventType(event.type) {
        case SDL_QUIT:
            self = .quit
        case SDL_KEYUP:
            self = .keyUp(
                KeyEventInfo(
                    windowID: event.key.windowID,
                    keyCode: KeyCode(rawValue: .init(event.key.keysym.sym)),
                    scanCode: ScanCode(event.key.keysym.scancode),
                    keyMod: KeyMod(rawValue: UInt32(event.key.keysym.mod)),
                    isRepeat: event.key.repeat != 0
                )
            )
        case SDL_KEYDOWN:
            self = .keyDown(
                KeyEventInfo(
                    windowID: event.key.windowID,
                    keyCode: KeyCode(rawValue: .init(event.key.keysym.sym)),
                    scanCode: ScanCode(event.key.keysym.scancode),
                    keyMod: KeyMod(rawValue: UInt32(event.key.keysym.mod)),
                    isRepeat: event.key.repeat != 0
                )
            )
        case SDL_APP_TERMINATING:
            self = .appTerminating
        case SDL_APP_LOWMEMORY:
            self = .appLowMemory
        case SDL_APP_WILLENTERBACKGROUND:
            self = .appWillEnterBackground
        case SDL_APP_DIDENTERBACKGROUND:
            self = .appDidEnterBackground
        case SDL_APP_WILLENTERFOREGROUND:
            self = .appWillEnterForeground
        case SDL_APP_DIDENTERFOREGROUND:
            self = .appDidEnterForeground
        case SDL_LOCALECHANGED:
            self = .localeDidChange
        case SDL_DISPLAYEVENT:
            self = .display(
                index: Int32(bitPattern: event.display.display),
                event: DisplayEvent(sdlDisplayEvent: event.display)
            )
        case SDL_WINDOWEVENT:
            self = .window(
                id: event.window.windowID,
                event: WindowEvent(sdlWindowEvent: event.window)
            )

        default:
            // TODO: fill out more event types
            return nil
        }
    }
}

