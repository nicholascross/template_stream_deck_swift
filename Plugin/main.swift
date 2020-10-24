import StreamDeckKit

logDebug("Plugin launched")

var plugin: Plugin!

do {
    try StreamDeckKit.launch { connection in
        plugin = Plugin(connection: connection)
        connection.delegate = plugin
        
        logDebug("StreamDeckKit connecting")
    }
} catch {
    logError("failed to start plugin \(error)")
}
