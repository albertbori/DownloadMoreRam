//
//  File.swift
//  
//
//  Created by Albert Bori on 8/3/20.
//

import Foundation

class CssConverter {
    let resource: Resource
    private var externalResourceUrls = Set<URL>()
    
    init(resource: Resource) {
        self.resource = resource
    }
    
    func convert() throws -> Converter.ConvertedResult {
        guard let css = String(bytes: resource.data, encoding: resource.encoding) else {
            throw CssConverterError.invalidData
        }
        
        var outputCss = css as NSString
        let regex = try NSRegularExpression(pattern: "url\\([\"']?([^\\)\"']+)[\"']?\\)", options: [.caseInsensitive]) //pattern: url\(["']?([^\)"']+)["']?\)
        let totalRange = NSRange(location: 0, length: css.count)
        let matches = regex.matches(in: css, options: [], range: totalRange)
        let reversedMatches = matches.sorted(by: { l, r in l.range.location > r.range.location })
        for match in reversedMatches {
            let group1Range = match.range(at: 1)
            let rawUrl = outputCss.substring(with: group1Range)
            guard let url = URL(string: rawUrl, relativeTo: resource.url) else { continue }
            let possibleMimeType = MimeType(from: url) ?? .png
            let relativePath = LinkBuilder.getRelativePath(from: url, mimeType: possibleMimeType)
            outputCss = outputCss.replacingCharacters(in: group1Range, with: relativePath) as NSString
        }
        
        var updatedResource = resource
        guard let data = (outputCss as String).data(using: resource.encoding) else {
            throw CssConverterError.badCssOutput
        }
        updatedResource.data = data
        
        return Converter.ConvertedResult(externalResourceUrls: externalResourceUrls, updatedResource: updatedResource)
    }
}

enum CssConverterError: Error {
    case invalidData,
    badCssOutput
}
