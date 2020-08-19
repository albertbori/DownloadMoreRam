//
//  File.swift
//  
//
//  Created by Albert Bori on 8/3/20.
//

import Foundation
import SwiftSoup

class HtmlConverter {
    let resource: Resource
    private var externalResourceUrls = Set<URL>()
    
    init(resource: Resource) {
        self.resource = resource
    }
    
    func convert() throws -> Converter.ConvertedResult {
        guard let html = String(bytes: resource.data, encoding: resource.encoding) else {
            throw HtmlConverterError.invalidData
        }
        
        let doc = try SwiftSoup.parse(html)
        try convert(doc: doc, elementName: "a", attributeName: "href")
        try convert(doc: doc, elementName: "link[rel=stylesheet]", attributeName: "href")
        try convert(doc: doc, elementName: "script", attributeName: "src")
        try convert(doc: doc, elementName: "img", attributeName: "src")
        
        var updatedResource = resource
        guard let data = try doc.outerHtml().data(using: resource.encoding) else {
            throw HtmlConverterError.badHtmlOutput
        }
        updatedResource.data = data
        
        return Converter.ConvertedResult(externalResourceUrls: externalResourceUrls, updatedResource: updatedResource)
    }
    
    private func convert(doc: Document, elementName: String, attributeName: String) throws {
        let elements = try doc.select(elementName)
        for element in elements {
            guard let url = URL(string: try element.attr(attributeName), relativeTo: resource.url) else { continue }
            guard elementName != "a" || url.host == resource.url.host else { continue } //skip external url links
            guard let possibleMimeType = MimeType(htmlElement: elementName, orUrl: url) else { continue }
            let relativePath = LinkBuilder.getRelativePath(from: url, mimeType: possibleMimeType)
            try element.attr(attributeName, relativePath)
            externalResourceUrls.insert(url.absoluteURL)
        }
    }
}

enum HtmlConverterError: Error {
    case invalidData,
    badHtmlOutput
}
