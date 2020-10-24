import Foundation

public final class StreamDeckKit {
    private static var currentConnection: StreamDeckConnection!
    
    public static func launch(connectionCallback: (StreamDeckConnection) -> Void) throws {
        let connection = try StreamDeckConnection(configuration: PluginConfiguration())
        connectionCallback(connection)
        connection.connect()
        currentConnection = connection
        while RunLoop.current.run(mode: .default, before: .distantFuture) {}
    }
}
