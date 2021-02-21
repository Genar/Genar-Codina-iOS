//
//  KeyChainProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

public protocol KeychainServiceProtocol {
    
    // MARK: - Methods
    
    func getValue(key: String) throws -> String
    func setValue(key: String, value: String) throws
    func deleteItem(key: String) throws
    func getAllValues() throws -> [String: AnyObject]
}
