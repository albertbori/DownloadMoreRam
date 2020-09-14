//
//  LinkBuilderTests.swift
//  
//
//  Created by Albert Bori on 9/13/20.
//

import Foundation
import XCTest
@testable import DownloadMoreRamCore

final class LinkBuilderTests: XCTestCase {
    static var allTests = [
        ("testRelativeLinkPath", testRelativeLinkPath),
    ]
    
    func testGetLocalSavePath() {
        struct Test {
            let url: URL
            let mimeType: MimeType
            let expected: String
        }
        let tests: [Test] = [
            Test(url: URL(string: "http://google.com")!, mimeType: .html, expected: "index.html"),
            Test(url: URL(string: "http://google.com/index.html")!, mimeType: .html, expected: "index.html"),
            Test(url: URL(string: "http://google.com/nice-page")!, mimeType: .html, expected: "nice-page.html"),
            Test(url: URL(string: "http://google.com/index?page=3")!, mimeType: .html, expected: "page/3/index.html"),
            Test(url: URL(string: "http://google.com/index?page=3&user=_cool")!, mimeType: .html, expected: "page/3/user/_cool/index.html")
        ]
        tests.forEach({ XCTAssertEqual(LinkBuilder.getLocalSavePath(from: $0.url, mimeType: $0.mimeType), $0.expected) })
    }
    
    func testRelativeLinkPath() {
        struct Test {
            let fromUrl: URL
            let fromMimeType: MimeType
            let toUrl: URL
            let toMimeType: MimeType
            let expected: String
        }
        let tests: [Test] = [
            Test(fromUrl: URL(string: "http://google.com")!, fromMimeType: .html, toUrl: URL(string: "http://google.com/main.js")!, toMimeType: .js, expected: "main.js"),
            Test(fromUrl: URL(string: "http://google.com")!, fromMimeType: .html, toUrl: URL(string: "http://google.com/scripts/main.js")!, toMimeType: .js, expected: "scripts/main.js"),
            Test(fromUrl: URL(string: "http://google.com/pages/cool")!, fromMimeType: .html, toUrl: URL(string: "http://google.com/scripts/api.js")!, toMimeType: .js, expected: "../scripts/api.js"),
            Test(fromUrl: URL(string: "http://google.com/scripts/cool.js")!, fromMimeType: .js, toUrl: URL(string: "http://google.com/scripts/context.js")!, toMimeType: .js, expected: "context.js"),
            Test(fromUrl: URL(string: "http://google.com/scripts/support/cool.js")!, fromMimeType: .js, toUrl: URL(string: "http://google.com/scripts/core/main.js")!, toMimeType: .js, expected: "../core/main.js")
        ]
        tests.forEach({ XCTAssertEqual(LinkBuilder.getRelativePath(from: (url: $0.fromUrl, mimeType: $0.fromMimeType), to: (url: $0.toUrl, mimeType: $0.toMimeType)), $0.expected) })
    }
}
