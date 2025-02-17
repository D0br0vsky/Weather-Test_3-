import Dispatch

protocol SearchDebouncerProtocol {
    func debounce(query: String, action: @escaping (String) -> Void)
}

final class SearchDebouncer: SearchDebouncerProtocol {
    private let debouncer = CancellableExecutor(queue: .main)
    private let delay: DispatchTimeInterval
    
    init(delay: DispatchTimeInterval = .milliseconds(400)) {
        self.delay = delay
    }
    
    func debounce(query: String, action: @escaping (String) -> Void) {
        debouncer.execute(delay: delay) { isCancelled in
            guard !isCancelled.isCancelled else { return }
            action(query)
        }
    }
}
