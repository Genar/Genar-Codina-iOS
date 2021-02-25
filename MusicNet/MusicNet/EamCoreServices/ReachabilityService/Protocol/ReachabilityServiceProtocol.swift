//
//  ReachabilityServiceProtocol.swift
//  MusicNet
//
//  Created by Genar Codina Reverter on 25/2/21.
//

import Foundation

protocol ReachabilityServiceProtocol {
    
    func isReachable() -> Bool
    
    func isNetworkReachable() -> Bool
    
    func isUsingWiFi() -> Bool
}
