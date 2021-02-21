//
//  BaseRemoteConfigurationProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

/// A protocol to define the base URL of the request
/// so that the app can point to different environments
/// like DEV, PRE or PRO
public protocol BaseRemoteConfigurationProtocol {
    
    // MARK: - Base URL's
    
    /// The base URL string
    var baseUrl: String! { get set }
}
