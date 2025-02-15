import UIKit

final class WeatherScreenViewCell: UITableViewCell {
    static let id = "WeatherScreenViewCell"
    private var model: Model?
    
    struct Model {
        let dateTime: String
        let tempMin: String
        let tempMax: String
        let icon: WeatherIconModels
    }
    
    private lazy var date: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var iconStatus: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 14
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var tempMax: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()

    private lazy var tempMin: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [date, iconStatus, tempMin, tempMax])
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        self.model = model
        date.text = model.dateTime
        iconStatus.image = model.icon.imageWithColor()
        tempMax.text = "↑ \(model.tempMax)"
        tempMin.text = "↓ \(model.tempMin)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
        date.text = nil
        iconStatus.image = nil
        tempMax.text = nil
        tempMin.text = nil
    }
}

// MARK: - Setup Subviews and Constraints
private extension WeatherScreenViewCell {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        contentView.addSubview(stackView)
        contentView.addSubview(line)
    }
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -10),
            
            iconStatus.widthAnchor.constraint(equalToConstant: 20),
            iconStatus.heightAnchor.constraint(equalToConstant: 20),
            
            line.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            line.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale)
        ])
    }
}
