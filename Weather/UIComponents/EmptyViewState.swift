import UIKit

final class EmptyViewState: UIView {
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .gray
        return imageView
    }()
    
    private lazy var titleMessage: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .gray
        label.text = "Empty request"
        return label
    }()
    
    private lazy var subtitleMessage: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .gray
        label.text = "Enter your search query in the search field"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Subviews and Constraints
private extension EmptyViewState {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(iconImageView)
        addSubview(titleMessage)
        addSubview(subtitleMessage)
    }
    
    func setupConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleMessage.translatesAutoresizingMaskIntoConstraints = false
        subtitleMessage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 75),
            
            titleMessage.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            titleMessage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            subtitleMessage.topAnchor.constraint(equalTo: titleMessage.bottomAnchor, constant: 10),
            subtitleMessage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
