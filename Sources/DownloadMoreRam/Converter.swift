//
//  File.swift
//  
//
//  Created by Albert Bori on 8/2/20.
//

import Foundation

struct Converter {
    func convert(resource: Resource) throws -> ConvertedResult {
        let convert: () throws -> ConvertedResult
        switch resource.mimeType {
        case .html:
            convert = HtmlConverter(resource: resource).convert
        case .css:
            convert = CssConverter(resource: resource).convert
        case .js:
            convert = JavascriptConverter(resource: resource).convert
        default:
            return ConvertedResult(externalResourceUrls: [], updatedResource: resource)
        }
        return try convert()
    }

    struct ConvertedResult {
        var externalResourceUrls: Set<URL>
        var updatedResource: Resource
    }
}

enum ConverterErrors: Error {
    case invalidData
}
