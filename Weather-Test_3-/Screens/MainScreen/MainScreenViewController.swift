import UIKit

protocol MainScreenViewControllerProtocol: AnyObject {
    func update(model: MainScreenView.Model)
    func setState(_ state: ScreenState)
}

final class MainScreenViewController: UIViewController {
    let presenter: MainScreenPresenter
    
    private let videoPlayerManager: VideoPlayerManagerProtocol
    private let screenStateView: ScreenStateViewProtocol
    
    private lazy var customView = MainScreenView(presenter: presenter, videoPlayerManager: videoPlayerManager)
    
    init(presenter: MainScreenPresenter, videoPlayerManager: VideoPlayerManagerProtocol, screenStateView: ScreenStateViewProtocol) {
        self.presenter = presenter
        self.videoPlayerManager = videoPlayerManager
        self.screenStateView = screenStateView
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        presenter.view = self
        presenter.viewDidLoad()
    }
}

// MARK: - MainScreenViewControllerProtocol
extension MainScreenViewController: MainScreenViewControllerProtocol {
    func setState(_ state: ScreenState) {
        screenStateView.setState(state)
    }
    
    func update(model: MainScreenView.Model) {
        customView.update(model: model)
    }
}

// MARK: - Setup Subviews and Constraints
private extension MainScreenViewController {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        view.addSubview(screenStateView)
    }
    
    func setupConstraints() {
        screenStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            screenStateView.topAnchor.constraint(equalTo: view.topAnchor, constant: 190),
            screenStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
