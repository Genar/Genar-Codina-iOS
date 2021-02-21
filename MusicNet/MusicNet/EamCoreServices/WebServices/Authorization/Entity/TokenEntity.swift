//
//  TokenEntity.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

public struct TokenEntity {
    
    private(set) var accessToken: String
    private(set) var expiresIn: Int
    private(set) var tokenType: String
    private var accessTokenExpirationTime: DispatchTime = DispatchTime.now()
        
    public init(accessToken: String,
                expiresIn: Int,
                tokenType: String) {
        
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
        self.accessTokenExpirationTime = DispatchTime.now() + .seconds(expiresIn)
    }
    
    public func hasTokenExpired() -> Bool {
        
        let hasExpired: Bool = (DispatchTime.now() > accessTokenExpirationTime)
        return hasExpired
    }
}

extension TokenEntity: Equatable {
    
    static public func == (lhs: TokenEntity, rhs: TokenEntity) -> Bool {
    
    return  lhs.accessToken == rhs.accessToken              &&
            lhs.expiresIn == rhs.expiresIn                  &&
            lhs.tokenType == rhs.tokenType
    }
}
