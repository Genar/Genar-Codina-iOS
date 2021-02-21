//
//  WebservicesBaseConstants.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation

enum HTTPHeader: String {
    
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case contentSize = "Content-Length"
    case accept = "Accept"
}

// MARK: - HTTPHeaderValue

enum HTTPHeaderAuthorizationValue: String {
    
    case bearer = "Bearer <%@>"
}

enum HTTPHeaderContentTypeValue: String {
    
    case json = "application/json"
}
