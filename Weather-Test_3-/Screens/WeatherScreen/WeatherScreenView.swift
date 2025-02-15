import AVKit

final class WeatherScreenView: UIView {
    typealias item = WeatherScreenViewCell.Model

    private var player: AVQueuePlayer?
    private var playerLayer = AVPlayerLayer()
    private var looper: AVPlayerLooper?

    struct ModelView {
        let name: String
        let country: String
        let temp: String
        let description: String
        let tempMin: String
        let tempMax: String
        let videoFileName: String
    }
    
    struct Model {
        let items: [item]
    }
    
    private var data: [WeatherScreenViewCell.Model] = []
    private var model: Model?
    private var modelView: ModelView?
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.6
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var cityName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var countryName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        return label
    }()
    
    private lazy var temperature: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 72, weight: .thin)
        label.textColor = .white
        return label
    }()
    
    private lazy var status: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.6)
        return label
    }()
    
    private lazy var tempMaxMin: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var tableView: UITableView  = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        tableView.prefetchDataSource = self
        tableView.register(WeatherScreenViewCell.self, forCellReuseIdentifier: WeatherScreenViewCell.id)
        return tableView
    }()
    
    var presenter: WeatherScreenPresenterProtocol
    
    init(presenter: WeatherScreenPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        backgroundColor = .black
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
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = bounds
            layer.insertSublayer(playerLayer, at: 0)

            player?.play()
        } catch {
            print("Video loading error: \(error.localizedDescription)")
        }
    }
    
    func updateHeader(modelView: ModelView) {
        cityName.text = modelView.name
        countryName.text = modelView.country
        temperature.text = modelView.temp
        status.text = modelView.description
        tempMaxMin.text = "Min: \(modelView.tempMin), Max: \(modelView.tempMax)"
        playVideo(named: modelView.videoFileName)
    }

    func updateTable(model: Model) {
        self.model = model
        self.data = model.items
        tableView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

// MARK: - UITableViewDataSource
extension WeatherScreenView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherScreenViewCell.id, for: indexPath) as? WeatherScreenViewCell else {
            fatalError("Failed to create AlphaModuleViewCell")
        }
        if let item = model?.items[indexPath.item] {
            cell.update(model: item)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension WeatherScreenView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.isOpaque = false
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension WeatherScreenView: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //<#code#>
    }
}

// MARK: - Setup Subviews and Constraints
private extension WeatherScreenView {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(cityName)
        addSubview(countryName)
        addSubview(temperature)
        addSubview(status)
        addSubview(tempMaxMin)
        addSubview(blurView)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        cityName.translatesAutoresizingMaskIntoConstraints = false
        countryName.translatesAutoresizingMaskIntoConstraints = false
        temperature.translatesAutoresizingMaskIntoConstraints = false
        status.translatesAutoresizingMaskIntoConstraints = false
        tempMaxMin.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityName.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            cityName.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            countryName.topAnchor.constraint(equalTo: cityName.bottomAnchor),
            countryName.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            temperature.topAnchor.constraint(equalTo: countryName.bottomAnchor, constant: 4),
            temperature.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            status.topAnchor.constraint(equalTo: temperature.bottomAnchor, constant: 4),
            status.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tempMaxMin.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 4),
            tempMaxMin.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            blurView.topAnchor.constraint(equalTo: tempMaxMin.bottomAnchor, constant: 40),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            
            tableView.topAnchor.constraint(equalTo: tempMaxMin.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ])
    }
}
