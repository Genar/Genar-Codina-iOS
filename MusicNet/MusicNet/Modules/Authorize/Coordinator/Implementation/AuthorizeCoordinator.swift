//
//  AuthorizeCoordinator.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import UIKit
import SafariServices

class AuthorizeCoordinator: BaseCoordinatorProtocol, AuthorizeProtocol {

    /// Parent coordinator
    weak var parentCoordinator: MainCoordinator?
    
    /// Coordinator can have child coordinators
    var childCoordinators: [BaseCoordinatorProtocol] = [BaseCoordinatorProtocol]()
    
    /// Navigation controller to push view controllers
    var navigationController: UINavigationController
    
    /// To get the authorization token from Spotify
    var webAuthSession: SFAuthenticationSession?
    
    private let scheme = "localhost:8888/callback"
    private let authorizeEndPoint = "https://accounts.spotify.com/authorize"
    private let responseTypeToken = "token"
    private let scopes = "user-read-private user-read-email"
    private let clientId = "c8e62832e84a4986aa740e581c867b10"
    
    /// Inits the coordinator
    /// - Parameter navigationController: navigation controller
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
    }
    
    /// Pushes the view controller
    func start() {
        
        openAuthenticationServices()
    }
    
    private func openAuthenticationServices() {
        
        let authEndpoint = getAuthEndpoint()

        webAuthSession = SFAuthenticationSession(url: authEndpoint, callbackURLScheme: scheme)
        { callbackURL, error in
            guard error == nil, let successURL = callbackURL else {
                return
            }

            let successUrlStr = successURL.absoluteString
            if let token = self.createToken(successUrl: successUrlStr) {
                //self.parentCoordinator?.tokenEntity = token
                self.parentCoordinator?.viewModel.tokenEntity = token
            }
        }
        
        guard let webAuthSession = self.webAuthSession else { return }
        
        webAuthSession.start()
    }
    
    private func getAuthEndpoint() -> URL {

        var authEndpoint = URLComponents(string: authorizeEndPoint)

        authEndpoint?.queryItems = [

                URLQueryItem(name: "response_type", value: responseTypeToken),
                URLQueryItem(name: "scope", value: scopes),
                URLQueryItem(name: "client_id", value: clientId),
                URLQueryItem(name: "redirect_uri", value: scheme),
        ]

        if let authUrl = authEndpoint?.url {
            return authUrl
        } else {
            fatalError("Could not get authorize url")
        }
    }
    
    private func createToken(successUrl: String) -> TokenEntity? {
        
        let modifiedUrl = successUrl + "&"
        guard let accessToken = modifiedUrl.slice(from: "access_token=", to: "&") else { return nil }
        guard let tokenType = modifiedUrl.slice(from: "token_type=", to: "&") else { return  nil}
        guard let expiresInStr = modifiedUrl.slice(from: "expires_in=", to: "&") else { return nil }
        let expiresIn = Int(expiresInStr) ?? 0
        
        return TokenEntity(accessToken: accessToken,
                           expiresIn: expiresIn,
                           tokenType: tokenType)
    }
}
