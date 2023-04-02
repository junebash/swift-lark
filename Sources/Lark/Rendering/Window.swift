import SDL2

@MainActor
public final class Window {
    internal let _sdlWindowPtr: OpaquePointer

    public init(
        title: String,
        x: Int32,
        y: Int32,
        w: Int32,
        h: Int32,
        options: Options = []
    ) throws {
        self._sdlWindowPtr = try withThrowingSDL {
            title.withCString { ptr in
                SDL_CreateWindow(
                    ptr,
                    x,
                    y,
                    w,
                    h,
                    options.rawValue
                )
            }
        }
    }

    public init(
        title: String,
        position: Position,
        size: Size2<Int32>,
        options: Options = []
    ) throws {
        let mask = position.windowMask
        self._sdlWindowPtr = try withThrowingSDL {
            title.withCString { ptr in
                SDL_CreateWindow(
                    ptr,
                    Int32(bitPattern: mask),
                    Int32(bitPattern: mask),
                    Int32(size.width),
                    Int32(size.height),
                    options.rawValue
                )
            }
        }
    }

    deinit {
        SDL_DestroyWindow(_sdlWindowPtr)
    }

    public func setFullScreen(options: Window.Options = [.fullscreen]) throws {
        try withThrowingSDL {
            SDL_SetWindowFullscreen(_sdlWindowPtr, options.rawValue)
        }
    }
}

extension Window {
    public enum Position {
        case centered
        case undefined

        var windowMask: UInt32 {
            switch self {
            case .centered: return SDL_WINDOWPOS_CENTERED_MASK
            case .undefined: return SDL_WINDOWPOS_UNDEFINED_MASK
            }
        }
    }

    public struct Options: OptionSet {
        public var rawValue: UInt32

        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public static let fullscreen: Self = .init(rawValue: SDL_WINDOW_FULLSCREEN.rawValue)
        public static let fullscreenDesktop: Self = .init(rawValue: SDL_WINDOW_FULLSCREEN_DESKTOP.rawValue)
        public static let openGL: Self = .init(rawValue: SDL_WINDOW_OPENGL.rawValue)
        public static let metal: Self = .init(rawValue: SDL_WINDOW_METAL.rawValue)
        public static let vulkan: Self = .init(rawValue: SDL_WINDOW_VULKAN.rawValue)
        public static let shown: Self = .init(rawValue: SDL_WINDOW_SHOWN.rawValue)
        public static let hidden: Self = .init(rawValue: SDL_WINDOW_HIDDEN.rawValue)
        public static let borderless: Self = .init(rawValue: SDL_WINDOW_BORDERLESS.rawValue)
        public static let resizable: Self = .init(rawValue: SDL_WINDOW_RESIZABLE.rawValue)
        public static let minimized: Self = .init(rawValue: SDL_WINDOW_MAXIMIZED.rawValue)
        public static let mouseGrabbed: Self = .init(rawValue: SDL_WINDOW_MOUSE_GRABBED.rawValue)
        public static let inputFocus: Self = .init(rawValue: SDL_WINDOW_INPUT_FOCUS.rawValue)
        public static let mouseFocus: Self = .init(rawValue: SDL_WINDOW_MOUSE_FOCUS.rawValue)
        public static let foreign: Self = .init(rawValue: SDL_WINDOW_FOREIGN.rawValue)
        public static let allowHighDPI: Self = .init(rawValue: SDL_WINDOW_ALLOW_HIGHDPI.rawValue)
        public static let mouseCapture: Self = .init(rawValue: SDL_WINDOW_MOUSE_CAPTURE.rawValue)
        public static let alwaysOnTop: Self = .init(rawValue: SDL_WINDOW_ALWAYS_ON_TOP.rawValue)
        public static let skipTaskBar: Self = .init(rawValue: SDL_WINDOW_SKIP_TASKBAR.rawValue)
        public static let utility: Self = .init(rawValue: SDL_WINDOW_UTILITY.rawValue)
        public static let tooltip: Self = .init(rawValue: SDL_WINDOW_TOOLTIP.rawValue)
        public static let popupMenu: Self = .init(rawValue: SDL_WINDOW_POPUP_MENU.rawValue)
        public static let keyboardGrabbed: Self = .init(rawValue: SDL_WINDOW_KEYBOARD_GRABBED.rawValue)
        public static let inputGrabbed: Self = .init(rawValue: SDL_WINDOW_INPUT_GRABBED.rawValue)

        /*
         /**< fullscreen window */
         public var SDL_WINDOW_FULLSCREEN: SDL_WindowFlags { get }
         /**< window usable with OpenGL context */
         public var SDL_WINDOW_OPENGL: SDL_WindowFlags { get }
         /**< window is visible */
         public var SDL_WINDOW_SHOWN: SDL_WindowFlags { get }
         /**< window is not visible */
         public var SDL_WINDOW_HIDDEN: SDL_WindowFlags { get }
         /**< no window decoration */
         public var SDL_WINDOW_BORDERLESS: SDL_WindowFlags { get }
         /**< window can be resized */
         public var SDL_WINDOW_RESIZABLE: SDL_WindowFlags { get }
         /**< window is minimized */
         public var SDL_WINDOW_MINIMIZED: SDL_WindowFlags { get }
         /**< window is maximized */
         public var SDL_WINDOW_MAXIMIZED: SDL_WindowFlags { get }
         /**< window has grabbed mouse input */
         public var SDL_WINDOW_MOUSE_GRABBED: SDL_WindowFlags { get }
         /**< window has input focus */
         public var SDL_WINDOW_INPUT_FOCUS: SDL_WindowFlags { get }
         /**< window has mouse focus */
         public var SDL_WINDOW_MOUSE_FOCUS: SDL_WindowFlags { get }
         public var SDL_WINDOW_FULLSCREEN_DESKTOP: SDL_WindowFlags { get }
         /**< window not created by SDL */
         public var SDL_WINDOW_FOREIGN: SDL_WindowFlags { get }
         /**< window should be created in high-DPI mode if supported.
          On macOS NSHighResolutionCapable must be set true in the
          application's Info.plist for this to have any effect. */
         public var SDL_WINDOW_ALLOW_HIGHDPI: SDL_WindowFlags { get }
         /**< window has mouse captured (unrelated to MOUSE_GRABBED) */
         public var SDL_WINDOW_MOUSE_CAPTURE: SDL_WindowFlags { get }
         /**< window should always be above others */
         public var SDL_WINDOW_ALWAYS_ON_TOP: SDL_WindowFlags { get }
         /**< window should not be added to the taskbar */
         public var SDL_WINDOW_SKIP_TASKBAR: SDL_WindowFlags { get }
         /**< window should be treated as a utility window */
         public var SDL_WINDOW_UTILITY: SDL_WindowFlags { get }
         /**< window should be treated as a tooltip */
         public var SDL_WINDOW_TOOLTIP: SDL_WindowFlags { get }
         /**< window should be treated as a popup menu */
         public var SDL_WINDOW_POPUP_MENU: SDL_WindowFlags { get }
         /**< window has grabbed keyboard input */
         public var SDL_WINDOW_KEYBOARD_GRABBED: SDL_WindowFlags { get }
         /**< window usable for Vulkan surface */
         public var SDL_WINDOW_VULKAN: SDL_WindowFlags { get }
         /**< window usable for Metal view */
         public var SDL_WINDOW_METAL: SDL_WindowFlags { get }
         /**< equivalent to SDL_WINDOW_MOUSE_GRABBED for compatibility */
         public var SDL_WINDOW_INPUT_GRABBED: SDL_WindowFlags { get }
         */
    }
}
