//
//  File.swift
//  
//
//  Created by Albert Bori on 8/2/20.
//

import Foundation

struct Resource {
    var url: URL
    var encoding: String.Encoding
    var mimeType: MimeType
    var data: Data
    
    init(url: URL, encoding rawEncoding: String, mimeType rawMimeType: String, data: Data) throws {
        guard let encoding = String.Encoding(rawValue: rawEncoding) else {
            throw ResourceError.unrecognized(mimeType: rawEncoding)
        }
        guard let mimeType = MimeType(rawValue: rawMimeType) else {
            throw ResourceError.unrecognized(mimeType: rawMimeType)
        }
        self.url = url
        self.encoding = encoding
        self.mimeType = mimeType
        self.data = data
    }
}

enum ResourceError: Error {
    case unrecognized(mimeType: String)
    case unrecognized(encoding: String)
}

extension String.Encoding {
    init?(rawValue: String) {
        switch rawValue {
        case "utf-8": self = .utf8
        case "utf-16": self = .utf16
        default: return nil
        }
    }
}

enum MimeType: CaseIterable {
    case aac, abw, arc, avi, azw, bin, bmp, bz, bz2, csh, css, csv, doc, docx, eot, epub, gz, gif, html, ico, ics, jar, jpg, js, json, jsonld, midi, mp3, mpeg, mpkg, odp, ods, odt, oga, ogv, ogx, opus, otf, png, pdf, php, ppt, pptx, rar, rtf, sh, svg, swf, tar, tiff, ts, ttf, txt, vsd, wav, weba, webm, webp, woff, woff2, xhtml, xls, xlsx, xml, textXML, xul, zip, threegp, video3g2, video7z, unknown
    
    init?(rawValue: String) {
        switch rawValue {
        case "audio/aac": self = .aac
        case "application/x-abiword": self = .abw
        case "application/x-freearc": self = .arc
        case "video/x-msvideo": self = .avi
        case "application/vnd.amazon.ebook": self = .azw
        case "application/octet-stream": self = .bin
        case "image/bmp": self = .bmp
        case "application/x-bzip": self = .bz
        case "application/x-bzip2": self = .bz2
        case "application/x-csh": self = .csh
        case "text/css": self = .css
        case "text/csv": self = .csv
        case "application/msword": self = .doc
        case "application/vnd.openxmlformats-officedocument.wordprocessingml.document": self = .docx
        case "application/vnd.ms-fontobject": self = .eot
        case "application/epub+zip": self = .epub
        case "application/gzip": self = .gz
        case "image/gif": self = .gif
        case "text/html": self = .html
        case "image/vnd.microsoft.icon": self = .ico
        case "text/calendar": self = .ics
        case "application/java-archive": self = .jar
        case "image/jpeg": self = .jpg
        case "text/javascript", "application/javascript": self = .js
        case "application/json": self = .json
        case "application/ld+json": self = .jsonld
        case "audio/midi audio/x-midi": self = .midi
        case "audio/mpeg": self = .mp3
        case "video/mpeg": self = .mpeg
        case "application/vnd.apple.installer+xml": self = .mpkg
        case "application/vnd.oasis.opendocument.presentation": self = .odp
        case "application/vnd.oasis.opendocument.spreadsheet": self = .ods
        case "application/vnd.oasis.opendocument.text": self = .odt
        case "audio/ogg": self = .oga
        case "video/ogg": self = .ogv
        case "application/ogg": self = .ogx
        case "audio/opus": self = .opus
        case "font/otf": self = .otf
        case "image/png": self = .png
        case "application/pdf": self = .pdf
        case "application/x-httpd-php": self = .php
        case "application/vnd.ms-powerpoint": self = .ppt
        case "application/vnd.openxmlformats-officedocument.presentationml.presentation": self = .pptx
        case "application/vnd.rar": self = .rar
        case "application/rtf": self = .rtf
        case "application/x-sh": self = .sh
        case "image/svg+xml": self = .svg
        case "application/x-shockwave-flash": self = .swf
        case "application/x-tar": self = .tar
        case "image/tiff": self = .tiff
        case "video/mp2t": self = .ts
        case "font/ttf": self = .ttf
        case "text/plain": self = .txt
        case "application/vnd.visio": self = .vsd
        case "audio/wav": self = .wav
        case "audio/webm": self = .weba
        case "video/webm": self = .webm
        case "image/webp": self = .webp
        case "font/woff": self = .woff
        case "font/woff2": self = .woff2
        case "application/xhtml+xml": self = .xhtml
        case "application/vnd.ms-excel": self = .xls
        case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": self = .xlsx
        case "application/xml": self = .xml
        case "text/xml": self = .textXML
        case "application/vnd.mozilla.xul+xml": self = .xul
        case "application/zip": self = .zip
        case "video/3gpp": self = .threegp
        case "video/3gpp2": self = .video3g2
        case "application/x-7z-compressed": self = .video7z
        default: self = .unknown
        }
    }
    
    init?(htmlElement elementName: String, orUrl url: URL) {
        switch elementName {
        case "a":
            self = .html
        case "link[rel=stylesheet]":
            self = .css
        case "script":
            self = .js
        case "img":
            self.init(from: url)
        default:
            self = .unknown
        }
    }
    
    init?(from url: URL) {
        var lookup = Dictionary(grouping: MimeType.allCases, by: { "\($0)" })
        lookup["jpeg"] = [.jpg]
        lookup["tif"] = [.tiff]
        guard let value = lookup[url.pathExtension]?.first else {
            self = .unknown
            return
        }
        self = value
    }
}
