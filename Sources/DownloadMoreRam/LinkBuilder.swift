//
//  LinkBuilder.swift
//  
//
//  Created by Albert Bori on 8/3/20.
//

import Foundation

struct LinkBuilder {
    static func getRelativePath(from url: URL, mimeType: MimeType) -> String {
        let folder: String
        switch mimeType {
        case .html:
            folder = "pages"
        case .css, .js:
            folder = "scripts"
        case .png, .gif, .tiff, .svg, .jpg:
            folder = "images"
        default:
            folder = "resources"
        }
        let pathExtension = url.pathExtension != "" ? url.pathExtension : "\(mimeType)"
        return "\(folder)/\(url.lastPathComponent)/\(pathExtension)"
    }
}
