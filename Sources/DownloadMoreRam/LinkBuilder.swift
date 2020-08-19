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
        //TODO: to prevent accidental overriding resources from different paths and urls, the entire path needs to be included in each file name to guarantee uniqueness
        if url.pathExtension == "" {
            let fileName = url.lastPathComponent.trimmingCharacters(in: ["/"]) != "" ? url.lastPathComponent : "index"
            return "\(folder)/\(fileName).\(mimeType)"
        }
        return "\(folder)/\(url.lastPathComponent)"
    }
}
