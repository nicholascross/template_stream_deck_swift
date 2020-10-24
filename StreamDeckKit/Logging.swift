import Foundation
import OSLog

public func logDebug(_ message: String) {
    os_log(.error, log: .default, "StreamDeckKit(DEBUG): %{public}s", message)
}

public func logError(_ message: String) {
    os_log(.error, log: .default, "StreamDeckKit(ERROR): %{public}s", message)
}
