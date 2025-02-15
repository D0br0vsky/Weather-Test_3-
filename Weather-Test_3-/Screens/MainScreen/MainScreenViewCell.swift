import AVKit

final class MainScreenViewCell: UICollectionViewCell {
    static let id = "MainScreenViewCell"
    private var model: Model?
    private var player: AVQueuePlayer?
    private var playerItem: AVPlayerItem?
    private var looper: AVPlayerLooper?
    private var playerLayer = AVPlayerLayer()

    struct Model {
        let name: String
        let country: String
        let dateTime: String
        let temp: String
        let description: String
        let tempMin: String
        let tempMax: String
        let videoFileName: String
        let icon: WeatherIconModels
        let weatherList: [WeatherInfo]
    }
    
    private lazy var basicShape: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var cityName: UILabel = createLabel(fontSize: 24, weight: .bold)
    private lazy var countryName: UILabel = createLabel(fontSize: 14, weight: .medium)
    private lazy var temperature: UILabel = createLabel(fontSize: 52, weight: .light)
    private lazy var status: UILabel = createLabel(fontSize: 16, weight: .regular, alpha: 0.9)
    private lazy var tempMin: UILabel = createLabel(fontSize: 16, weight: .medium, alpha: 0.8)
    private lazy var tempMax: UILabel = createLabel(fontSize: 16, weight: .medium, alpha: 0.8)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func playVideo(named fileName: String) {
        guard let asset = NSDataAsset(name: fileName) else {
            print("Asset not found for \(fileName)")
            return
        }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).mp4")

        do {
            try asset.data.write(to: tempURL)
            let asset = AVAsset(url: tempURL)
            let playerItem = AVPlayerItem(asset: asset)

            player = AVQueuePlayer(playerItem: playerItem)
            looper = AVPlayerLooper(player: player!, templateItem: playerItem)
            
            playerLayer.player = player
            player?.play()
        } catch {
            print("Video loading error: \(error.localizedDescription)")
        }
    }

    func update(model: Model) {
        self.model = model
        cityName.text = model.name
        countryName.text = model.country
        temperature.text = model.temp
        status.text = model.description
        tempMin.text = "Min.: \(model.tempMin)"
        tempMax.text = "Max.: \(model.tempMax)"
        
        if playerLayer.player == nil || model.videoFileName != self.model?.videoFileName {
            playVideo(named: model.videoFileName)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cityName.text = nil
        countryName.text = nil
        temperature.text = nil
        status.text = nil
        tempMin.text = nil
        tempMax.text = nil
        player?.pause()
        playerLayer.player = nil
        looper = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer.frame = basicShape.bounds
        playerLayer.videoGravity = .resizeAspectFill
    }

}

// MARK: - Setup Subviews and Constraints
private extension MainScreenViewCell {
    func commonInit() {
        contentView.addSubview(basicShape)
        basicShape.layer.addSublayer(playerLayer)
        
        [cityName, countryName, temperature, status, tempMin, tempMax].forEach {
            basicShape.addSubview($0)
        }
        
        setupConstraints()
    }
    
    func setupConstraints() {
        basicShape.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            basicShape.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            basicShape.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            basicShape.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            basicShape.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        cityName.translatesAutoresizingMaskIntoConstraints = false
        countryName.translatesAutoresizingMaskIntoConstraints = false
        temperature.translatesAutoresizingMaskIntoConstraints = false
        status.translatesAutoresizingMaskIntoConstraints = false
        tempMin.translatesAutoresizingMaskIntoConstraints = false
        tempMax.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cityName.topAnchor.constraint(equalTo: basicShape.topAnchor, constant: 10),
            cityName.leadingAnchor.constraint(equalTo: basicShape.leadingAnchor, constant: 15),
            
            countryName.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 2),
            countryName.leadingAnchor.constraint(equalTo: basicShape.leadingAnchor, constant: 15),
            
            temperature.topAnchor.constraint(equalTo: basicShape.topAnchor, constant: 4),
            temperature.trailingAnchor.constraint(equalTo: basicShape.trailingAnchor, constant: -15),
            
            status.leadingAnchor.constraint(equalTo: basicShape.leadingAnchor, constant: 15),
            status.bottomAnchor.constraint(equalTo: basicShape.bottomAnchor, constant: -10),
            
            tempMin.trailingAnchor.constraint(equalTo: basicShape.trailingAnchor, constant: -15),
            tempMin.bottomAnchor.constraint(equalTo: basicShape.bottomAnchor, constant: -10),
            
            tempMax.trailingAnchor.constraint(equalTo: tempMin.leadingAnchor, constant: -5),
            tempMax.bottomAnchor.constraint(equalTo: basicShape.bottomAnchor, constant: -10)
        ])
    }
    
    func createLabel(fontSize: CGFloat, weight: UIFont.Weight, alpha: CGFloat = 1.0) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = .white.withAlphaComponent(alpha)
        return label
    }
}
