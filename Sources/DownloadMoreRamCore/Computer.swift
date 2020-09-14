//
//  Computer.swift
//  
//
//  Created by Albert Bori on 8/2/20.
//

import Foundation

struct Computer {
    func save(file: Data, at pathUrl: URL) throws {
        let directoryUrl = pathUrl.deletingLastPathComponent()
        if directoryUrl.fileStatus == .nonExistent {
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
        }
        try file.write(to: pathUrl, options: .atomic)
    }
}

private extension URL {
    var fileStatus: FileStatus {
        get {
            let filestatus: FileStatus
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: self.path, isDirectory: &isDir) {
                if isDir.boolValue {
                    // file exists and is a directory
                    filestatus = .directoryExists
                }
                else {
                    // file exists and is not a directory
                    filestatus = .fileExists
                }
            }
            else {
                // file does not exist
                filestatus = .nonExistent
            }
            return filestatus
        }
    }
    enum FileStatus {
        case fileExists
        case directoryExists
        case nonExistent
    }
}

enum ComputerError: Error {
    case fileAlreadyExists(atPath: String)
    case failedToCreateFile
}
