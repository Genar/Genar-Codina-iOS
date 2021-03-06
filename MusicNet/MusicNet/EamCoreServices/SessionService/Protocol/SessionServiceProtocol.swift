//
//  SessionServiceProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

public protocol SessionServiceProtocol {
    
    // MARK: - Methods
    
    func getToken() -> TokenEntity
    func setToken(token: TokenEntity)
}
