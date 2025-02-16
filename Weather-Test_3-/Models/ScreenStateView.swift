import UIKit

protocol ScreenStateViewProtocol: UIView {
    func setState(_ state: ScreenState)
}

final class ScreenStateView: UIView {
    private lazy var errorView: ErrorViewState = {
        let view = ErrorViewState()
        view.isHidden = true
        return view
    }()
    
    private lazy var emptyView: EmptyViewState = {
        let view = EmptyViewState()
        view.isHidden = true
        return view
    }()

    private lazy var notFoundView: NotFoundViewState = {
        let view = NotFoundViewState()
        view.isHidden = true
        return view
    }()
    
    private lazy var loadingView: LoadingViewState = {
        let view = LoadingViewState()
        view.isHidden = true
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ScreenStateViewModelsProtocol
extension ScreenStateView: ScreenStateViewProtocol {
    func setState(_ state: ScreenState) {
        hideAllStates()
        
        switch state {
        case .error:
            errorView.isHidden = false
            isUserInteractionEnabled = false
            bringSubviewToFront(errorView)
        case .empty:
            emptyView.isHidden = false
            isUserInteractionEnabled = false
            bringSubviewToFront(emptyView)
        case .notFound:
            notFoundView.isHidden = false
            isUserInteractionEnabled = false
            bringSubviewToFront(notFoundView)
        case .loading:
            loadingView.isHidden = false
            isUserInteractionEnabled = false
            bringSubviewToFront(loadingView)
        case .content:
            isUserInteractionEnabled = true
            isUserInteractionEnabled = false
        }
    }
    
    func hideAllStates() {
        errorView.isHidden = true
        emptyView.isHidden = true
        notFoundView.isHidden = true
        loadingView.isHidden = true
    }
}

// MARK: - Setup Subviews and Constraints
private extension ScreenStateView {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(errorView)
        addSubview(loadingView)
        addSubview(emptyView)
        addSubview(notFoundView)
    }
    
    func setupConstraints() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        notFoundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: topAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingView.topAnchor.constraint(equalTo: topAnchor, constant: 145),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyView.topAnchor.constraint(equalTo: topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            notFoundView.topAnchor.constraint(equalTo: topAnchor),
            notFoundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            notFoundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            notFoundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
