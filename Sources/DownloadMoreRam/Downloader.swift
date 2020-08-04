//
//  WebsiteDownloader.swift
//  
//
//  Created by Albert Bori on 7/28/20.
//

import Foundation

struct Downloader {
    let internet = Internet()
    let computer = Computer()
    let resourceConverter = Converter()
    
    init() { }
    
    func download(website url: URL, saveTo outputUrl: URL) {
        download(url: url, saveTo: outputUrl, urlHistory: SafeSet<URL>())
    }
    
    private func download(url: URL, saveTo outputUrl: URL, urlHistory: SafeSet<URL>) {
        guard !urlHistory.safeSet.contains(url) else { return }
        urlHistory.safeSet.insert(url)
        print("Downloading \(url)")
        internet.getResource(for: url, completion: { result in
            switch result {
            case .failure(let error):
                print("Error downloading \(url): \(error)")
            case .success(let resource):
                print("Downloaded \(url)")
                self.convert(resource: resource, saveTo: outputUrl, urlHistory: urlHistory)
            }
        })
    }
    
    private func convert(resource: Resource, saveTo outputUrl: URL, urlHistory: SafeSet<URL>) {
        print("Converting \(resource.url)")
        do {
            let converterResult = try self.resourceConverter.convert(resource: resource)
            converterResult.externalResourceUrls.forEach({ download(url: $0, saveTo: outputUrl, urlHistory: urlHistory) })
            let filePathUrl = URL(fileURLWithPath: converterResult.updatedResource.relativeFilePath, isDirectory: false, relativeTo: outputUrl)
            do {
                print("Saving \(resource.url) to \(filePathUrl)")
                try computer.save(file: converterResult.updatedResource.data, at: filePathUrl)
            } catch {
                print("Error saving \(resource.url): \(error)")
            }
        } catch {
            print("Error converting \(resource.url): \(error)")
        }
    }
}