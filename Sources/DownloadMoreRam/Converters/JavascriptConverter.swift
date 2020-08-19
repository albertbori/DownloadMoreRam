//
//  File.swift
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
        //TODO: Search javascript for other script references or url hyperlinks        
        return Converter.ConvertedResult(externalResourceUrls: externalResourceUrls, updatedResource: resource)
    }
}

enum JavascriptConverterError: Error {
    case invalidData,
    badjavascriptOutput
}

