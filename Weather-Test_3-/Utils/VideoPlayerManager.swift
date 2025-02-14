import AVKit

final class VideoPlayerManager {
    static let shared = VideoPlayerManager()
    
    private var players: [String: AVQueuePlayer] = [:]
    private var loopers: [String: AVPlayerLooper] = [:]
    
    private init(){}

    func player(for videoFileName: String) -> AVQueuePlayer {
        if let existingPlayer = players[videoFileName] {
            return existingPlayer
        }
        
        guard let path = Bundle.main.path(forResource: videoFileName, ofType: "mp4") else {
            fatalError("Error: video \(videoFileName) not found")
        }
        
        let url = URL(fileURLWithPath: path)
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)

        let audioMix = AVMutableAudioMix()
        audioMix.inputParameters = []
        playerItem.audioMix = audioMix

        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        queuePlayer.volume = 0
        let looper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        
        players[videoFileName] = queuePlayer
        loopers[videoFileName] = looper
        return queuePlayer
    }
}
