//
//  KeyChainService.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

struct KeychainConfiguration {
    static let serviceName = "LoginService"
    
    /*
     Specifying an access group to use with `KeychainPasswordItem` instances
     will create items shared accross both apps.
     
     For information on App ID prefixes, see:
     https://developer.apple.com/library/ios/documentation/General/Conceptual/DevPedia-CocoaCore/AppID.html
     and:
     https://developer.apple.com/library/ios/technotes/tn2311/_index.html
     */
    //static let accessGroup = "$(AppIdentifierPrefix)es.zurich.zuricharchitecture.Application"
    
    /*
     Not specifying an access group to use with `KeychainPasswordItem` instances
     will create items specific to each app.
     */
    static let accessGroup: String? = nil
}

public class KeychainService: KeychainServiceProtocol {
    
    enum KeychainError: Error {
        case itemNotFound
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }
    
    // MARK: Keychain access
    
    public func getValue(key: String) throws -> String {
        /*
         Build a query to find the item that matches the service, account and
         access group.
         */
        var query = KeychainService.keychainQuery(withService: KeychainConfiguration.serviceName, account: key, accessGroup: KeychainConfiguration.accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.itemNotFound }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Parse the value string from the query result.
        guard let existingItem = queryResult as? [String: AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedItemData
        }
        
        return password
    }
    
    public func setValue(key: String, value: String) throws {
        // Encode the password into an Data object.
        let encodedData = value.data(using: String.Encoding.utf8)
        
        do {
            // Check for an existing item in the keychain.
            try _ = getValue(key: key)
            
            // Update the existing item with the new value.
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedData as AnyObject?
            
            let query = KeychainService.keychainQuery(withService: KeychainConfiguration.serviceName, account: key, accessGroup: KeychainConfiguration.accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        } catch KeychainError.itemNotFound {
            /*
             No value was found in the keychain. Create a dictionary to save
             as a new keychain item.
             */
            var newItem = KeychainService.keychainQuery(withService: KeychainConfiguration.serviceName, account: key, accessGroup: KeychainConfiguration.accessGroup)
            newItem[kSecValueData as String] = encodedData as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    public func deleteItem(key: String) throws {
        // Delete the existing item from the keychain.
        let query = KeychainService.keychainQuery(withService: KeychainConfiguration.serviceName, account: key, accessGroup: KeychainConfiguration.accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    public func getAllValues() throws -> [String: AnyObject] {
        // Build a query for all items that match the service and access group.
        var query = KeychainService.keychainQuery(withService: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse
        
        // Fetch matching items from the keychain.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // If no items were found, return an empty array.
        guard status != errSecItemNotFound else { return [:] }
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Cast the query result to an array of dictionaries.
        guard let resultData = queryResult as? [[String: AnyObject]] else { throw KeychainError.unexpectedItemData }
        
        // Create a `KeychainPasswordItem` for each dictionary in the query result.
        var allValues: [String: AnyObject] = [:]
        for result in resultData {
            guard let account = result[kSecAttrAccount as String] as? String else { throw KeychainError.unexpectedItemData }
            
            let value = KeychainService.keychainQuery(withService: KeychainConfiguration.serviceName, account: account, accessGroup: KeychainConfiguration.accessGroup)
            allValues = value
        }
        
        return allValues
    }
    
    // MARK: Convenience
    
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
    
}
