import UIKit
import AVFoundation

protocol VideoCacheManagerProtocol: AnyObject {
    func prefetchVideos(videoFileNames: [String])
    func cachedURL(for videoFileName: String) -> URL?
}

final class VideoCacheManager: VideoCacheManagerProtocol {
    static let shared = VideoCacheManager()
    private var cachedTempURLs: [String: URL] = [:]
    
    private let syncQueue = DispatchQueue(label: "VideoCacheManager.syncQueue")
    
    private init() {}
    
    func prefetchVideos(videoFileNames: [String]) {
        DispatchQueue.global(qos: .utility).async {
            videoFileNames.forEach { fileName in
                self.syncQueue.sync {
                    if self.cachedTempURLs[fileName] != nil {
                        return
                    }
                }
                
                guard let asset = NSDataAsset(name: fileName) else { return }
                
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).mp4")
                do {
                    try asset.data.write(to: tempURL, options: .atomic)
                    self.syncQueue.sync {
                        self.cachedTempURLs[fileName] = tempURL
                    }
                } catch {
                }
            }
        }
    }
    
    func cachedURL(for videoFileName: String) -> URL? {
        syncQueue.sync {
            cachedTempURLs[videoFileName]
        }
    }
}
