//
//  File.swift
//  
//
//  Created by Albert Bori on 7/28/20.
//

import Foundation
import ArgumentParser
import SwiftSoup

struct DownloadWebsite: ParsableCommand {
    @Argument(help: "The url of the website to be downloaded.")
    var websiteUrl: String
    @Argument(help: "The ouput folder to be created. Note that a root \"web\" folder will always be created at this location.")
    var outputPath: String
    
    func validate() throws {
        guard let _ = URL(string: websiteUrl) else {
            throw ValidationError("Invalid website url.")
        }
        let pathUrl = URL(fileURLWithPath: outputPath)
        guard FileManager.default.fileExists(atPath: pathUrl.path, isDirectory: nil) else {
            throw ValidationError("Invalid output path: Does not exist.")
        }
    }
    
    func run() throws {
        guard let url = URL(string: websiteUrl) else {
            throw ValidationError("Invalid website url.")
        }
        let pathUrl = URL(fileURLWithPath: outputPath)
        guard FileManager.default.fileExists(atPath: pathUrl.path, isDirectory: nil) else {
            throw ValidationError("Invalid output path: Does not exist.")
        }
        
        print("-- Running Downloader --")
        print("Website Url: \(url.absoluteString)")
        print("Output Path: \(pathUrl.path)")
        let downloader = Downloader()
        downloader.download(website: url, saveTo: pathUrl)
    }
}