//
//  Authorization.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import Foundation
import SafariServices

public class AuthorizationService: AuthorizationServiceProtocol {
    
    var webAuthSession: SFAuthenticationSession?
    
    public func openAuthenticationServices() {
        
        let authEndpoint = getAuthEndpoint()
        let scheme = "localhost:8888/callback"

        webAuthSession = SFAuthenticationSession(url: authEndpoint, callbackURLScheme: scheme)
        { callbackURL, error in
            guard error == nil, let successURL = callbackURL else {
                return
            }

            let successUrlStr = successURL.absoluteString
            guard let accessToken = successUrlStr.slice(from: "access_token=", to: "&") else { return }
            print(accessToken)
        }
        
        guard let webAuthSession = self.webAuthSession else { return }
        webAuthSession.start()
    }
    
    private func getAuthEndpoint() -> URL {

        var authEndpoint = URLComponents(string: "https://accounts.spotify.com/authorize")

        authEndpoint?.queryItems = [

                URLQueryItem(name: "response_type", value: "token"),

                URLQueryItem(name: "scope", value: "user-read-private user-read-email"),

                URLQueryItem(name: "client_id", value: "c8e62832e84a4986aa740e581c867b10"),

                URLQueryItem(name: "redirect_uri", value: "localhost:8888/callback"),
        ]


        return (authEndpoint?.url)!

    }
    
}
