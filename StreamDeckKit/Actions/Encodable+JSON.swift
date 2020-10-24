//
//  Encodable+JSON.swift
//  StreamDeckKit
//
//  Created by Nicholas Cross on 24/10/20.
//

import Foundation

extension Encodable {
    var jsonData: Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            logError("Unable to encode object \(self)")
            return nil
        }
    }
}
