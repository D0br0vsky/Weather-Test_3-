import AVKit

final class MainScreenView: UIView {
    typealias item = MainScreenViewCell.Model
    struct Model {
        let items: [item]
    }
    
    private let videoPlayerManager: VideoPlayerManagerProtocol
    
    private var dataCell: [MainScreenViewCell.Model] = []
    private var model: Model?
    private var playerLayer: AVPlayerLayer?
    private var player: AVQueuePlayer?
    
    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.text = "Weather"
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Start your search ..."
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.layer.shadowOpacity = 0
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .white
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 140)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainScreenViewCell.self, forCellWithReuseIdentifier: MainScreenViewCell.id)
        return collectionView
    }()

    let presenter: MainScreenPresenterProtocol
    
    init(presenter: MainScreenPresenterProtocol, videoPlayerManager: VideoPlayerManagerProtocol) {
        self.presenter = presenter
        self.videoPlayerManager = videoPlayerManager
        super.init(frame: .zero)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        self.model = model
        dataCell = model.items
        collectionView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension MainScreenView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.updateSearchQuery(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource
extension MainScreenView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScreenViewCell.id, for: indexPath) as? MainScreenViewCell else {
            fatalError("Error: it was not possible to bring the cell to MainScreenViewCell")
        }
        
        if let item = model?.items[indexPath.item] {
            cell.update(model: item)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainScreenView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard dataCell.indices.contains(indexPath.item) else { return }
        let selectedModel = dataCell[indexPath.item]
        presenter.didSelectWeather(with: selectedModel)
    }
}

// MARK: - Video Handling
private extension MainScreenView {
    func setupVideoLayer() {
        playerLayer = AVPlayerLayer()
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = bounds
        layer.insertSublayer(playerLayer!, at: 0)
    }

    func playVideo(named fileName: String) {
        player = videoPlayerManager.player(for: fileName)
        playerLayer?.player = player
        player?.play()
    }
}

// MARK: - Setup Subviews and Constraints
private extension MainScreenView {
    func commonInit() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(searchBar)
        addSubview(weatherLabel)
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            weatherLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            searchBar.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
