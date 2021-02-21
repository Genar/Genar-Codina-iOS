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

    static let shared = RequestService()

    let defaultSession: URLSession

    typealias SerializationFunction<T> = (Data?, URLResponse?, Error?) -> Result<T>
    
    private init() {
       
        let sessionConfig = URLSessionConfiguration.default
        let key = "BQCv9XFvNgBL_gCQyt-NLDkdqiPISNI4SWX3Px93m3-xUHkzQCkqoD32p1-fkX8SbYD75yI1DOa7tyFBCw--1NIY9E-kOFw4cERTyoaRp9js6rt9P4UKf3XnEYr08pslOOliowhX_bQ4WQ_z4gQdWelEsz-KhYURaNCEOEBqVZGgdUokUS8"
        let authValue: String? = "Bearer \(key)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authValue ?? ""]
        defaultSession = URLSession(configuration: sessionConfig)
    }

    @discardableResult
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
    
    @discardableResult
    public func request<T: Decodable>(_ url: URL, completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask {
        
        return request(url, serializationFunction: serializeJSON, completion: completion)
    }
}
