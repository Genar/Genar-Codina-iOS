//
//  ReachabilityServiceProtocol.swift
//  MusicNet
//
//  Created by Genar Codina Reverter on 25/2/21.
//

import Foundation
import Network

protocol ReachabilityServiceProtocol {
    
    func isReachable() -> Bool
    
    func isNetworkReachable() -> Bool
    
    func isUsingWiFi() -> Bool
    
    func startNetworkMonitoring(pathUpdateHandler: ((NWPath) -> Void)?)
}
