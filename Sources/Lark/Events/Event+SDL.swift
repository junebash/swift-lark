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
