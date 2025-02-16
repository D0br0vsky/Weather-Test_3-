import UIKit

protocol WeatherScreenViewControllerProtocol: AnyObject {
    func updateTable(model: WeatherScreenView.Model)
    func updateHeader(modelView: WeatherScreenView.HeaderModel)
}

final class WeatherScreenViewController: UIViewController {
    let presenter: WeatherScreenPresenter
    private lazy var customView = WeatherScreenView(presenter: presenter)
    
    init(presenter: WeatherScreenPresenter) {
        self.presenter = presenter
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

extension WeatherScreenViewController: WeatherScreenViewControllerProtocol {
    func updateTable(model: WeatherScreenView.Model) {
        customView.updateTable(model: model)
    }
    
    func updateHeader(modelView: WeatherScreenView.HeaderModel) {
        customView.updateHeader(modelView: modelView)
    }
}
