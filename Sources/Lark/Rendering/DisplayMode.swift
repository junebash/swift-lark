import SDL2

public struct DisplayMode {
    public struct DriverData {
        internal let pointer: UnsafeMutableRawPointer
    }

    public var format: PixelFormat.Kind
    public var size: ISize2
    public var refreshRate: Int32?
    public let driverData: DriverData

    public static func getCurrent(displayIndex: Int32) throws -> DisplayMode {
        var displayMode: SDL_DisplayMode = .init()
        try withThrowingSDL {
            SDL_GetCurrentDisplayMode(displayIndex, &displayMode)
        }
        return .init(
            format: .unknown, // TODO: -
            size: ISize2(width: displayMode.w, height: displayMode.h),
            refreshRate: displayMode.refresh_rate.nonZero,
            driverData: DriverData(pointer: displayMode.driverdata)
        )
    }
}
