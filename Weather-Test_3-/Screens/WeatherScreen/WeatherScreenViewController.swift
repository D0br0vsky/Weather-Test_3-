import UIKit

protocol WeatherScreenViewControllerProtocol: AnyObject {
    func updateTable(model: WeatherScreenView.Model)
    func updateHeader(modelView: WeatherScreenView.HeaderModel)
    func setState(_ state: ScreenState)
}

final class WeatherScreenViewController: UIViewController {
    let presenter: WeatherScreenPresenter
    
    private let screenStateView: ScreenStateViewProtocol
    
    private lazy var customView = WeatherScreenView(presenter: presenter)
    
    init(presenter: WeatherScreenPresenter, screenStateView: ScreenStateViewProtocol) {
        self.presenter = presenter
        self.screenStateView = screenStateView
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
        commonInit()
        presenter.view = self
        presenter.viewDidLoad()
    }
}

extension WeatherScreenViewController: WeatherScreenViewControllerProtocol {
    func setState(_ state: ScreenState) {
        screenStateView.setState(state)
    }
    
    func updateTable(model: WeatherScreenView.Model) {
        customView.updateTable(model: model)
    }
    
    func updateHeader(modelView: WeatherScreenView.HeaderModel) {
        customView.updateHeader(modelView: modelView)
    }
}

// MARK: - Setup Subviews and Constraints
private extension WeatherScreenViewController {
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
            screenStateView.topAnchor.constraint(equalTo: view.topAnchor),
            screenStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
