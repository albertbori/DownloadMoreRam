//
//  File.swift
//  
//
//  Created by Albert Bori on 8/2/20.
//

import Foundation

struct Computer {
    func save(file: Data, at pathUrl: URL) throws {
        try file.write(to: pathUrl, options: .atomic)
    }
}

enum ComputerError: Error {
    case fileAlreadyExists(atPath: String)
    case failedToCreateFile
}
