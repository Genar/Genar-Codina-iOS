//
//  BaseRemoteConfiguration.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

import Foundation

public class BaseProRemoteConfiguration: BaseRemoteConfigurationProtocol {
    
    // MARK: - Base URL
    
    public var baseUrl: String! = "https://api.spotify.com/v1/"
    
    public init() {}
}
