import UIKit

protocol MainScreenViewControllerProtocol: AnyObject {
    func update(model: MainScreenView.Model)
}

final class MainScreenViewController: UIViewController {
    let presenter: MainScreenPresenter
    
    private let videoPlayerManager: VideoPlayerManagerProtocol
    
    private lazy var customView = MainScreenView(presenter: presenter, videoPlayerManager: videoPlayerManager)
    
    init(presenter: MainScreenPresenter, videoPlayerManager: VideoPlayerManagerProtocol) {
        self.presenter = presenter
        self.videoPlayerManager = videoPlayerManager
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
    }
}

// MARK: - MainScreenViewControllerProtocol
extension MainScreenViewController: MainScreenViewControllerProtocol {
    func update(model: MainScreenView.Model) {
        customView.update(model: model)
    }
}
