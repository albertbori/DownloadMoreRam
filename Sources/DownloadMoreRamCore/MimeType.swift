//
//  MimeType.swift
//  
//
//  Created by Albert Bori on 9/19/20.
//

import Foundation

enum MimeType: CaseIterable {
    case aac, abw, arc, avi, azw, bin, bmp, bz, bz2, csh, css, csv, doc, docx, eot, epub, gz, gif, html, ico, ics, jar, jpg, js, json, jsonld, midi, mp3, mpeg, mpkg, odp, ods, odt, oga, ogv, ogx, opus, otf, png, pdf, php, ppt, pptx, rar, rtf, sh, svg, swf, tar, tiff, ts, ttf, txt, vsd, wav, weba, webm, webp, woff, woff2, xhtml, xls, xlsx, xml, textXML, xul, zip, threegp, video3g2, video7z, unknown
    
    private static let rawMimeTypeMap: [String: MimeType] = [
        "application/epub+zip": .epub,
        "application/gzip": .gz,
        "application/java-archive": .jar,
        "application/json": .json,
        "application/ld+json": .jsonld,
        "application/msword": .doc,
        "application/octet-stream": .bin,
        "application/ogg": .ogx,
        "application/pdf": .pdf,
        "application/rtf": .rtf,
        "application/vnd.amazon.ebook": .azw,
        "application/vnd.apple.installer+xml": .mpkg,
        "application/vnd.mozilla.xul+xml": .xul,
        "application/vnd.ms-excel": .xls,
        "application/vnd.ms-fontobject": .eot,
        "application/vnd.ms-powerpoint": .ppt,
        "application/vnd.oasis.opendocument.presentation": .odp,
        "application/vnd.oasis.opendocument.spreadsheet": .ods,
        "application/vnd.oasis.opendocument.text": .odt,
        "application/vnd.openxmlformats-officedocument.presentationml.presentation": .pptx,
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": .xlsx,
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document": .docx,
        "application/vnd.rar": .rar,
        "application/vnd.visio": .vsd,
        "application/x-7z-compressed": .video7z,
        "application/x-abiword": .abw,
        "application/x-bzip": .bz,
        "application/x-bzip2": .bz2,
        "application/x-csh": .csh,
        "application/x-freearc": .arc,
        "application/x-httpd-php": .php,
        "application/x-sh": .sh,
        "application/x-shockwave-flash": .swf,
        "application/x-tar": .tar,
        "application/xhtml+xml": .xhtml,
        "application/xml": .xml,
        "application/zip": .zip,
        "audio/aac": .aac,
        "audio/midi audio/x-midi": .midi,
        "audio/mpeg": .mp3,
        "audio/ogg": .oga,
        "audio/opus": .opus,
        "audio/wav": .wav,
        "audio/webm": .weba,
        "font/otf": .otf,
        "font/ttf": .ttf,
        "font/woff": .woff,
        "font/woff2": .woff2,
        "image/bmp": .bmp,
        "image/gif": .gif,
        "image/jpeg": .jpg,
        "image/png": .png,
        "image/svg+xml": .svg,
        "image/tiff": .tiff,
        "image/vnd.microsoft.icon": .ico,
        "image/webp": .webp,
        "image/x-icon": .ico,
        "text/calendar": .ics,
        "text/css": .css,
        "text/csv": .csv,
        "text/html": .html,
        "text/javascript": .js,
        "text/plain": .txt,
        "text/xml": .textXML,
        "video/3gpp": .threegp,
        "video/3gpp2": .video3g2,
        "video/mp2t": .ts,
        "video/mpeg": .mpeg,
        "video/ogg": .ogv,
        "video/webm": .webm,
        "video/x-msvideo": .avi,
    ]
    
    init?(rawValue: String) {
        guard let mimeType = Self.rawMimeTypeMap[rawValue.lowercased()] else {
            return nil
        }
        self = mimeType
    }
    
    init?(url: URL) {
        var fileExtensionMap = Dictionary(grouping: MimeType.allCases, by: { "\($0)" })
        fileExtensionMap["jpeg"] = [.jpg]
        fileExtensionMap["tif"] = [.tiff]
        let lowerCasedFileExtension = url.pathExtension.lowercased()
        guard let value = fileExtensionMap[lowerCasedFileExtension]?.first else {
            return nil
        }
        self = value
    }
}
