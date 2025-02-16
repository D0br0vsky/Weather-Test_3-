import Foundation

protocol DataLoaderProtocol {
    func fetchData(url: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

final class DataLoader: DataLoaderProtocol {
    func fetchData(url: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        guard url.url != nil else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1001)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "No HTTP Response", code: -1)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid status code", code: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
