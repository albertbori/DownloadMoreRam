//
//  File.swift
//  
//
//  Created by Albert Bori on 8/2/20.
//

import Foundation

struct Converter {
    func convert(resource: Resource) throws -> ConvertedResult {
        switch resource.mimeType {
        case .html:
            return convertHtml(resource: resource)
        case .css:
            return convertCss(resource: resource)
        case .js:
            return convertJavascript(resource: resource)
        default:
            return ConvertedResult(externalResourceUrls: [], updatedResource: resource)
        }
    }
    
    private func convertHtml(resource: Resource) -> ConvertedResult  {
        //TODO: extract urls, replacing them with relative urls
        return ConvertedResult(externalResourceUrls: [], updatedResource: try! Resource(url: URL(string: "")!, mimeType: "", data: Data()))
    }
    
    private func convertCss(resource: Resource) -> ConvertedResult {
        //TODO: extract urls, replacing them with relative urls
        return ConvertedResult(externalResourceUrls: [], updatedResource: try! Resource(url: URL(string: "")!, mimeType: "", data: Data()))
    }
    
    private func convertJavascript(resource: Resource) -> ConvertedResult {
        //TODO: extract urls, replacing them with relative urls
        return ConvertedResult(externalResourceUrls: [], updatedResource: try! Resource(url: URL(string: "")!, mimeType: "", data: Data()))
    }

    struct ConvertedResult {
        var externalResourceUrls: Set<URL>
        var updatedResource: Resource
    }
}
