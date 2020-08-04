//
//  File.swift
//  
//
//  Created by Albert Bori on 8/2/20.
//

import Foundation

struct Resource {
    var url: URL
    var mimeType: MimeType
    var data: Data
    
    init(url: URL, mimeType rawMimeType: String, data: Data) throws {
        guard let mimeType = MimeType(rawValue: rawMimeType) else {
            throw ResourceError.unrecognized(mimeType: rawMimeType)
        }
        self.url = url
        self.mimeType = mimeType
        self.data = data
    }
}

enum ResourceError: Error {
    case unrecognized(mimeType: String)
}

enum MimeType: String, CaseIterable {
    case
    aac = "audio/aac",
    abw = "application/x-abiword",
    arc = "application/x-freearc",
    avi = "video/x-msvideo",
    azw = "application/vnd.amazon.ebook",
    bin = "application/octet-stream",
    bmp = "image/bmp",
    bz = "application/x-bzip",
    bz2 = "application/x-bzip2",
    csh = "application/x-csh",
    css = "text/css",
    csv = "text/csv",
    doc = "application/msword",
    docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    eot = "application/vnd.ms-fontobject",
    epub = "application/epub+zip",
    gz = "application/gzip",
    gif = "image/gif",
    html = "text/html",
    ico = "image/vnd.microsoft.icon",
    ics = "text/calendar",
    jar = "application/java-archive",
    jpg = "image/jpeg",
    js = "text/javascript",
    json = "application/json",
    jsonld = "application/ld+json",
    midi = "audio/midi audio/x-midi",
    mp3 = "audio/mpeg",
    mpeg = "video/mpeg",
    mpkg = "application/vnd.apple.installer+xml",
    odp = "application/vnd.oasis.opendocument.presentation",
    ods = "application/vnd.oasis.opendocument.spreadsheet",
    odt = "application/vnd.oasis.opendocument.text",
    oga = "audio/ogg",
    ogv = "video/ogg",
    ogx = "application/ogg",
    opus = "audio/opus",
    otf = "font/otf",
    png = "image/png",
    pdf = "application/pdf",
    php = "application/x-httpd-php",
    ppt = "application/vnd.ms-powerpoint",
    pptx = "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    rar = "application/vnd.rar",
    rtf = "application/rtf",
    sh = "application/x-sh",
    svg = "image/svg+xml",
    swf = "application/x-shockwave-flash",
    tar = "application/x-tar",
    tiff = "image/tiff",
    ts = "video/mp2t",
    ttf = "font/ttf",
    txt = "text/plain",
    vsd = "application/vnd.visio",
    wav = "audio/wav",
    weba = "audio/webm",
    webm = "video/webm",
    webp = "image/webp",
    woff = "font/woff",
    woff2 = "font/woff2",
    xhtml = "application/xhtml+xml",
    xls = "application/vnd.ms-excel",
    xlsx = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    xml = "application/xml",
    textXML = "text/xml",
    xul = "application/vnd.mozilla.xul+xml",
    zip = "application/zip",
    threegp = "video/3gpp",
    video3g2 = "video/3gpp2",
    video7z = "application/x-7z-compressed",
    unknown = "unknown"
    
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
