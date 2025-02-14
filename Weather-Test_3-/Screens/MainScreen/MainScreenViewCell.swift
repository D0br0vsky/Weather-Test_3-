import AVKit

final class MainScreenViewCell: UICollectionViewCell {
    static let id = "MainScreenViewCell"
    private var model: Model?
    private var playerLayer: AVPlayerLayer?
    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?
    
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
    }
    
    private lazy var basicShape: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var cityName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var countryName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()

    private lazy var temperature: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 52, weight: .light)
        label.textColor = .white
        return label
    }()

    private lazy var status: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        return label
    }()

    private lazy var tempMin: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()

    private lazy var tempMax: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()

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
            return
        }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).mp4")

        do {
            try asset.data.write(to: tempURL)
            let asset = AVAsset(url: tempURL)
            let playerItem = AVPlayerItem(asset: asset)

            player = AVQueuePlayer(playerItem: playerItem)
            looper = AVPlayerLooper(player: player!, templateItem: playerItem)

            playerLayer?.player = player
            player?.play()
        } catch {
            print("Video download error")
        }
    }

    func update(model: Model) {
        self.model = model
        cityName.text = "\(model.name)"
        countryName.text = "\(model.country)"
        temperature.text = "\(model.temp)"
        status.text = "\(model.description)"
        tempMin.text = "Min.: \(model.tempMin)"
        tempMax.text = "Max.: \(model.tempMax),"
        playVideo(named: model.videoFileName)
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
        playerLayer?.player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
}

// MARK: - Setup Subviews and Constraints
private extension MainScreenViewCell {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        setupVideoLayer()
        contentView.addSubview(basicShape)
        basicShape.addSubview(cityName)
        basicShape.addSubview(countryName)
        basicShape.addSubview(temperature)
        basicShape.addSubview(status)
        basicShape.addSubview(tempMin)
        basicShape.addSubview(tempMax)
    }
    
    func setupConstraints() {
        basicShape.translatesAutoresizingMaskIntoConstraints = false
        cityName.translatesAutoresizingMaskIntoConstraints = false
        countryName.translatesAutoresizingMaskIntoConstraints = false
        temperature.translatesAutoresizingMaskIntoConstraints = false
        status.translatesAutoresizingMaskIntoConstraints = false
        tempMin.translatesAutoresizingMaskIntoConstraints = false
        tempMax.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            basicShape.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            basicShape.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            basicShape.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            basicShape.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
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
    
    func setupVideoLayer() {
        playerLayer = AVPlayerLayer()
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = contentView.bounds
        contentView.layer.insertSublayer(playerLayer!, at: 0)
    }
}
