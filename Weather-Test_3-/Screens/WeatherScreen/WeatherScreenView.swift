import UIKit

final class WeatherScreenView: UIView {
    typealias item = WeatherScreenViewCell.Model
    
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
    
    private lazy var cityName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
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
        label.font = UIFont.systemFont(ofSize: 62, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private lazy var status: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        return label
    }()
    
    private lazy var tempMaxMin: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    
    private lazy var tableView: UITableView  = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        tableView.prefetchDataSource = self
        tableView.separatorStyle = .singleLine
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
    
    func updateHeader(modelView: ModelView) {
        cityName.text = "\(modelView.name)"
        countryName.text = "\(modelView.country)"
        temperature.text = "\(modelView.temp)"
        status.text = modelView.description
        tempMaxMin.text = "Min: \(modelView.tempMin), Max: \(modelView.tempMax)"
    }

    func updateTable(model: Model) {
        self.model = model
        self.data = model.items
        tableView.reloadData()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //<#code#>
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
        addSubview(tableView)
    }
    
    func setupConstraints() {
        cityName.translatesAutoresizingMaskIntoConstraints = false
        countryName.translatesAutoresizingMaskIntoConstraints = false
        temperature.translatesAutoresizingMaskIntoConstraints = false
        status.translatesAutoresizingMaskIntoConstraints = false
        tempMaxMin.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityName.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            cityName.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            countryName.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 5),
            countryName.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            temperature.topAnchor.constraint(equalTo: countryName.bottomAnchor, constant: 4),
            temperature.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            status.topAnchor.constraint(equalTo: temperature.bottomAnchor, constant: 4),
            status.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tempMaxMin.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 4),
            tempMaxMin.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: tempMaxMin.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
}
