//
//  Resource.swift
//  
//
//  Created by Albert Bori on 8/2/20.
//

import Foundation

struct Resource {
    var url: URL
    var encoding: String.Encoding
    var mimeType: MimeType
    var data: Data
    
    init(url: URL, encoding rawEncoding: String, mimeType rawMimeType: String, data: Data) throws {
        guard let encoding = String.Encoding(rawValue: rawEncoding) else {
            throw ResourceError.unrecognized(mimeType: rawEncoding)
        }
        guard var mimeType = MimeType(rawValue: rawMimeType) ?? MimeType(url: url) else {
            throw ResourceError.unrecognized(mimeType: rawMimeType)
        }
        
        //bin is derived from "application/octet-stream" which could really be anything. Try to find something more specific from the file extension
        if mimeType == .bin, let betterMimeType = MimeType(url: url) {
            mimeType = betterMimeType
        }
        
        self.url = url
        self.encoding = encoding
        self.mimeType = mimeType
        self.data = data
    }
}

enum ResourceError: Error {
    case unrecognized(mimeType: String)
    case unrecognized(encoding: String)
}

extension String.Encoding {
    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "utf-8": self = .utf8
        case "utf-16": self = .utf16
        default: return nil
        }
    }
}
