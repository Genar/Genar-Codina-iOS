//
//  AppDelegate.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 19/2/21.
//

import UIKit

//@UIApplicationMain
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navController = UINavigationController()
        
        let requestService: RequestServiceProtocol = RequestService()
        let repository: RepositoryProtocol = Repository(requestService: requestService)
            
        coordinator = MainCoordinator(navigationController: navController,
                                      repository: repository)

        coordinator?.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }
}

