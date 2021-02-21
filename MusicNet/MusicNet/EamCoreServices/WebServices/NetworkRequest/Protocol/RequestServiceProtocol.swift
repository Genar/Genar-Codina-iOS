//
//  RequestServiceProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

public protocol RequestServiceProtocol {
    
    /// Performs a network request
    /// - Parameters:
    ///   - url: target URL
    ///   - completion: completion handler
    func request<T: Decodable>(_ url: URL, completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask
}
