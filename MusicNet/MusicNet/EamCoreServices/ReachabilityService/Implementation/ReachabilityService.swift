//
//  ReachabilityService.swift
//  MusicNet
//
//  Created by Genar Codina Reverter on 25/2/21.
//

import Foundation
import SystemConfiguration

open class ReachabilityService: ReachabilityServiceProtocol {
    
    private let urlStr: String
    private var scNetworkReachability: SCNetworkReachability?
    
    public init(urlStr: String) {
        
        self.urlStr = urlStr
        if let scNetReachability = SCNetworkReachabilityCreateWithName(nil, urlStr) {
            self.scNetworkReachability = scNetReachability
        } else {
            self.scNetworkReachability = nil
        }
    }
    
    public init(sockAddressIn: sockaddr_in) {
        
        self.urlStr = ""
        var sockedAddressIn = sockAddressIn
        // Passes the reference of the struct
        self.scNetworkReachability = withUnsafePointer(to: &sockedAddressIn, { pointer in
            // Converts to a generic socket address
            return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {
                // $0 is the pointer to `sockaddr`
                return SCNetworkReachabilityCreateWithAddress(nil, $0)
            }!
        })
    }
    
    public func isReachable() -> Bool {
        
        var flags = SCNetworkReachabilityFlags()
        if let scNetReachability = self.scNetworkReachability {
            SCNetworkReachabilityGetFlags(scNetReachability, &flags)
        }
        let isReachable: Bool = flags.contains(.reachable)
        
        return isReachable
    }
    
    public func isNetworkReachable() -> Bool {
        
        var flags = SCNetworkReachabilityFlags()
        if let scNetReachability = self.scNetworkReachability {
            SCNetworkReachabilityGetFlags(scNetReachability, &flags)
        }
        
        return isNetworkReachable(with: flags)
    }
    
    public func isUsingWiFi() -> Bool {

        var flags = SCNetworkReachabilityFlags()
        if let scNetReachability = self.scNetworkReachability {
            SCNetworkReachabilityGetFlags(scNetReachability, &flags)
        }

        if !isNetworkReachable(with: flags) {
            // Device doesn't have internet connection
            return false
        }

        #if os(iOS)
            // It's available just for iOS because it's checking if the device is using mobile data
            if flags.contains(.isWWAN) {
                // Device is using mobile data
                return false
            }
        #endif
        
        // At this point we are sure that the device is using Wifi since it's online and without using mobile data
        return true
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)

        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
}
