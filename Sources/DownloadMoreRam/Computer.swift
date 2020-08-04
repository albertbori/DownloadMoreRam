//
//  File.swift
//  
//
//  Created by Albert Bori on 8/2/20.
//

import Foundation

struct Computer {
    func save(file: Data, at path: URL) throws {
        try file.write(to: path)
    }
}
