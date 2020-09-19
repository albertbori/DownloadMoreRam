//
//  LinkBuilder.swift
//  
//
//  Created by Albert Bori on 8/3/20.
//

import Foundation

struct LinkBuilder {
    private static let cacheQueue = DispatchQueue(label: "LinkBuilder.cacheQueue")
    private static var _cache: [String: String] = [:]
    static var localSavePathCache: [String: String] {
        get { cacheQueue.sync { _cache } }
        set { cacheQueue.sync { _cache = newValue } }
    }
    
    static func getLocalSavePath(from url: URL, mimeType: MimeType) -> String {
        let cacheKey = "\(url.absoluteString):\(mimeType)"
        if let cachedPath = localSavePathCache[cacheKey] {
            return cachedPath
        }
        
        var components: [String] = url.pathComponents.filter({ $0 != "/" })
        if url.pathExtension == "" {
            if components.isEmpty {
                components.append("index.\(mimeType)")
            } else {
                components.removeLast()
                components.append("\(url.lastPathComponent).\(mimeType)")
            }
        }
        
        // insert query hash folder to separate pages
        if let query = url.query {
            components.insert("d" + String(query.hashValue), at: components.count - 1)
        }
        
        let savePath = components.joined(separator: "/")
        localSavePathCache[cacheKey] = savePath
        return savePath
    }
    
    static func getRelativePath(from: (url: URL, mimeType: MimeType), to: (url: URL, mimeType: MimeType)) -> String {
        let fromUrl = URL(fileURLWithPath: "/" + getLocalSavePath(from: from.url, mimeType: from.mimeType))
        let fromDirectoryComponents = fromUrl.deletingLastPathComponent().pathComponents
        let toPath = getLocalSavePath(from: to.url, mimeType: to.mimeType)
        let toURL = URL(fileURLWithPath: "/" + toPath)
        let toDirectoryComponents = toURL.deletingLastPathComponent().pathComponents
        
        var backDirectoryCount = fromDirectoryComponents.count
        var matchedDirectoryCount = 0
        for i in 0..<fromDirectoryComponents.count {
            guard i < toDirectoryComponents.count else { break }
            if fromDirectoryComponents[i] == toDirectoryComponents[i] {
                backDirectoryCount -= 1
                matchedDirectoryCount += 1
            }
        }
        
        var components = Array<String>(repeating: "..", count: backDirectoryCount)
        components.append(contentsOf: toDirectoryComponents.suffix(toDirectoryComponents.count - matchedDirectoryCount))
        components.append(toURL.lastPathComponent)
        
        let relativePath = components.joined(separator: "/") + (to.url.query != nil ? "?\(to.url.query!)" : "") + (to.url.fragment != nil ? "#\(to.url.fragment!)" : "")
        return relativePath
    }
}
