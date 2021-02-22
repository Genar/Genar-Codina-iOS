//
//  RequestService.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

public enum APIError: Error {

    case missingData
}

public enum Result<T> {

    case success(T)
    case failure(Error)
}

public final class RequestService: RequestServiceProtocol {

    var defaultSession: URLSession

    typealias SerializationFunction<T> = (Data?, URLResponse?, Error?) -> Result<T>
    
    var tokenEntity: TokenEntity!
    
    public init() {
       
        let sessionConfig = URLSessionConfiguration.default
        defaultSession = URLSession(configuration: sessionConfig)
    }
    
    // MARK: - Public methods
    
    public func setAccessToken(accessToken: String) {
        
        let sessionConfig = URLSessionConfiguration.default
        let authValue: String? = "Bearer \(accessToken)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authValue ?? ""]
        defaultSession = URLSession(configuration: sessionConfig)
    }
    
    public func request<T: Decodable>(_ url: URL, completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask {
        
        return request(url, serializationFunction: serializeJSON, completion: completion)
    }
    
    // MARK: - Private methods

    private func request<T>(_ url: URL, serializationFunction: @escaping SerializationFunction<T>,
                            completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask {
        
        let dataTask = defaultSession.dataTask(with: url) { data, response, error in
            let result: Result<T> = serializationFunction(data, response, error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        dataTask.resume()
        
        return dataTask
    }

    private func serializeJSON<T: Decodable>(with data: Data?, response: URLResponse?, error: Error?) -> Result<T> {
        
        if let error = error { return .failure(error) }
        guard let data = data else { return .failure(APIError.missingData) }
        do {
            let serializedValue = try JSONDecoder().decode(T.self, from: data)
            return .success(serializedValue)
        } catch let error {
            return .failure(error)
        }
    }
}
