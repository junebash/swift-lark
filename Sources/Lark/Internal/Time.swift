import SDL2

/// Returns `true` when `count` has surpassed `timeout`; otherwise, `false`.
func ticks<N: Numeric & Comparable>(_ count: N, havePassed timeout: N) -> Bool {
  count > timeout
}
