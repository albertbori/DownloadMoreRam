//
//  HtmlConverter.swift
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
        try convert(doc: doc, elementName: "link[href]", attributeName: "href")
        try convert(doc: doc, elementName: "script[src]", attributeName: "src")
        try convert(doc: doc, elementName: "script[data-url]", attributeName: "data-url")
        try convert(doc: doc, elementName: "img", attributeName: "src")
        try convert(doc: doc, elementName: "image", attributeName: "xlink:href") //svg sub-tag
        
        try convertEmbeddedJavascript(doc: doc)
        try convertEmbeddedCss(doc: doc)
        try removeCanonicalElements(doc: doc)
        
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
            guard let possibleMimeType = try MimeType(element: element) ?? MimeType(url: url) else { continue }
            let relativePath = LinkBuilder.getRelativePath(from: (url: resource.url, mimeType: resource.mimeType), to: (url: url, mimeType: possibleMimeType))
            try element.attr(attributeName, relativePath)
            externalResourceUrls.insert(url.absoluteURL)
        }
    }
    
    private func convertEmbeddedJavascript(doc: Document) throws {
        let scripts = try doc.select("script:not([src])")
        for script in scripts {
            try script.text(JavascriptConverter.convert(javascript: try script.text(), baseUrl: resource.url, baseMimeType: resource.mimeType, externalResourceUrls: &externalResourceUrls))
        }
    }
    
    private func convertEmbeddedCss(doc: Document) throws {
        let styles = try doc.select("style")
        for style in styles {
            try style.text(CssConverter.convert(css: try style.text(), baseUrl: resource.url, baseMimeType: resource.mimeType, externalResourceUrls: &externalResourceUrls))
        }
    }
    
    private func removeCanonicalElements(doc: Document) throws {
        let bases = try doc.select("base[href]")
        try bases.forEach({ try $0.remove() })
        let canonicalLinks = try doc.select("link[rel=canonical]")
        try canonicalLinks.forEach({ try $0.remove() })
    }
}

enum HtmlConverterError: Error {
    case invalidData,
    badHtmlOutput
}
