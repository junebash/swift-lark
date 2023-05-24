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

public struct EngineInitOptions: OptionSet {
  public private(set) var rawValue: UInt32

  public init(rawValue: UInt32) {
    self.rawValue = rawValue
  }

  public static let timer: Self = .init(rawValue: SDL_INIT_TIMER)
  public static let audio: Self = .init(rawValue: SDL_INIT_AUDIO)
  public static let video: Self = .init(rawValue: SDL_INIT_VIDEO)
  public static let joystick: Self = .init(rawValue: SDL_INIT_JOYSTICK)
  public static let haptic: Self = .init(rawValue: SDL_INIT_HAPTIC)
  public static let gameController: Self = .init(rawValue: SDL_INIT_GAMECONTROLLER)
  public static let events: Self = .init(rawValue: SDL_INIT_EVENTS)
  public static let sensor: Self = .init(rawValue: SDL_INIT_SENSOR)
  public static let everything: Self = [
    .timer, .audio, .haptic, .gameController, .events, .sensor, .video,
  ]
}
