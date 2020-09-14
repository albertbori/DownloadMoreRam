//
//  JavascriptConverter.swift
//  
//
//  Created by Albert Bori on 8/18/20.
//

import Foundation

class JavascriptConverter {
    let resource: Resource
    private var externalResourceUrls = Set<URL>()
    
    init(resource: Resource) {
        self.resource = resource
    }
    
    func convert() throws -> Converter.ConvertedResult {
        guard let javascript = String(bytes: resource.data, encoding: resource.encoding) else {
            throw HtmlConverterError.invalidData
        }
        
        let convertedJavascript = Self.convert(javascript: javascript, baseUrl: resource.url, baseMimeType: resource.mimeType, externalResourceUrls: &externalResourceUrls)
        var updatedResource = resource
        guard let data = convertedJavascript.data(using: resource.encoding) else {
            throw JavascriptConverterError.badjavascriptOutput
        }
        updatedResource.data = data
        return Converter.ConvertedResult(externalResourceUrls: externalResourceUrls, updatedResource: updatedResource)
    }
    
    static func convert(javascript: String, baseUrl: URL, baseMimeType: MimeType, externalResourceUrls: inout Set<URL>) -> String {
        let regex = try! NSRegularExpression(pattern: "\"https?:\\/\\/[^\"]+?\"", options: .caseInsensitive)
        let entireStringRange = NSRange(location: 0, length: javascript.count)
        let urlMatches = regex.matches(in: javascript, options: .init(), range: entireStringRange)
        
        var convertedJavascript: NSString = javascript as NSString
        for match in urlMatches.reversed() {
            let matchedUrlString = convertedJavascript.substring(with: match.range).trimmingCharacters(in: ["\""])
            guard let dataUrl = URL(string: matchedUrlString) else { continue }
            guard dataUrl.host == baseUrl.host else { continue } //don't replace all kinds of links to prevent surfing the entire internet by accident
            guard let possibleMimeType = MimeType(url: dataUrl) else { continue }  // skip unrecognizable types. best to let those remain external, since they may be of any kind
            let relativePath = LinkBuilder.getRelativePath(from: (url: baseUrl, mimeType: baseMimeType), to: (url: dataUrl, mimeType: possibleMimeType))
            convertedJavascript = convertedJavascript.replacingCharacters(in: match.range, with: "\"\(relativePath)\"") as NSString
            externalResourceUrls.insert(dataUrl)
        }
        return convertedJavascript as String
    }
}

enum JavascriptConverterError: Error {
    case invalidData,
    badjavascriptOutput
}

