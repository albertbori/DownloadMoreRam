//
//  CssConverter.swift
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
        
        let outputCss = try Self.convert(css: css, baseUrl: resource.url, baseMimeType: resource.mimeType, externalResourceUrls: &externalResourceUrls)
        
        var updatedResource = resource
        guard let data = (outputCss as String).data(using: resource.encoding) else {
            throw CssConverterError.badCssOutput
        }
        updatedResource.data = data
        
        return Converter.ConvertedResult(externalResourceUrls: externalResourceUrls, updatedResource: updatedResource)
    }
        
    static func convert(css: String, baseUrl: URL, baseMimeType: MimeType, externalResourceUrls: inout Set<URL>) throws -> String {
        var outputCss = css as NSString
        let regex = try NSRegularExpression(pattern: "url\\([\"']?([^\\)\"']+)[\"']?\\)", options: [.caseInsensitive]) //pattern: url\(["']?([^\)"']+)["']?\)
        let totalRange = NSRange(location: 0, length: css.count)
        let matches = regex.matches(in: css, options: [], range: totalRange)
        let reversedMatches = matches.sorted(by: { l, r in l.range.location > r.range.location })
        for match in reversedMatches {
            let group1Range = match.range(at: 1)
            let rawUrl = outputCss.substring(with: group1Range)
            guard let assetUrl = URL(string: rawUrl, relativeTo: baseUrl) else { continue }
            guard let possibleMimeType = MimeType(url: assetUrl) else { continue }
            let relativePath = LinkBuilder.getRelativePath(from: (url: baseUrl, mimeType: baseMimeType), to: (url: assetUrl, mimeType: possibleMimeType))
            outputCss = outputCss.replacingCharacters(in: group1Range, with: relativePath) as NSString
        }
        return outputCss as String
    }
}

enum CssConverterError: Error {
    case invalidData,
    badCssOutput
}
