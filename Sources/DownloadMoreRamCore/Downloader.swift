//
//  WebsiteDownloader.swift
//  
//
//  Created by Albert Bori on 7/28/20.
//

import Foundation

public class Downloader {
    let internet = Internet()
    let computer = Computer()
    let resourceConverter = Converter()
    public var logMessage: (String, LogLevel)->() = { _, _ in }
    private let dispatchGroup = DispatchGroup()
    private var resourceCounter: ThreadSafe<[MimeType: Int]> = .init(value: [:])
    
    public init() { }
    
    public func download(website url: URL, saveTo outputUrl: URL) {
        logMessage("Starting download...", .info)
        let urlHistory = ThreadSafe<Set<URL>>(value: [])
        download(url: url, saveTo: outputUrl, urlHistory: urlHistory)
        dispatchGroup.wait()
        logMessage("Download complete. Downloaded \(urlHistory.value.count) urls.", .info)
        let fileTypeCounts = resourceCounter.value.map({ "\t\($0.0): \($0.1)" })
        logMessage("Downloaded file types:\n" + fileTypeCounts.sorted().joined(separator: "\n"), .info)
    }
    
    private func download(url: URL, saveTo outputUrl: URL, urlHistory: ThreadSafe<Set<URL>>) {
        let uniqueUrl: URL
        if let fragment = url.fragment {
            uniqueUrl = URL(string: url.absoluteString.replacingOccurrences(of: "#" + fragment, with: ""))!
        } else {
            uniqueUrl = url
        }
        guard !urlHistory.value.contains(uniqueUrl) else { return }
        urlHistory.value.insert(uniqueUrl)
        logMessage("Downloading \(uniqueUrl)", .debug)
        dispatchGroup.enter()
        internet.getResource(for: uniqueUrl, completion: { result in
            switch result {
            case .failure(let error):
                self.logMessage("Error downloading \(uniqueUrl): \(error)", .error)
            case .success(let resource):
                self.resourceCounter.value[resource.mimeType] = 1 + (self.resourceCounter.value[resource.mimeType] ?? 0)
                self.logMessage("Downloaded \(uniqueUrl)", .debug)
                self.convert(resource: resource, saveTo: outputUrl, urlHistory: urlHistory)
            }
            self.dispatchGroup.leave()
        })
    }
    
    private func convert(resource: Resource, saveTo outputUrl: URL, urlHistory: ThreadSafe<Set<URL>>) {
        logMessage("Converting \(resource.url)", .debug)
        do {
            let converterResult = try self.resourceConverter.convert(resource: resource)
            converterResult.externalResourceUrls.forEach({ download(url: $0, saveTo: outputUrl, urlHistory: urlHistory) })
            let relativePath = LinkBuilder.getLocalSavePath(from: converterResult.updatedResource.url, mimeType: converterResult.updatedResource.mimeType)
            let filePathUrl = URL(fileURLWithPath: relativePath, isDirectory: false, relativeTo: outputUrl)
            do {
                logMessage("Saving \(resource.url) to \(filePathUrl)", .debug)
                try computer.save(file: converterResult.updatedResource.data, at: filePathUrl)
            } catch {
                logMessage("Error saving \(resource.url): \(error)", .error)
            }
        } catch {
            logMessage("Error converting \(resource.url): \(error)", .error)
        }
    }
}
