//
//  SessionService.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

public class SessionService: SessionServiceProtocol {
    
    // MARK: - Fields
    
    private var token: TokenEntity = TokenEntity(accessToken: "",
                                                 expiresIn: 0,
                                                 tokenType: "")
    
    // MARK: - Accessible methods
    
    public func getToken() -> TokenEntity {
        
        return self.token
    }
    
    public func setToken(token: TokenEntity) {
        
        self.token = token
    }
    
    // MARK: - Contructor
    
    init() {
    
    }
}
