//
//  AppDelegate.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 19/2/21.
//

import UIKit

@UIApplicationMain
//@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navController = UINavigationController()
        
        let baseConfig: BaseConfigProtocol = BaseConfigPro()
        let endPoints: EndPointsProtocol = EndPoints()
        let requestService: RequestServiceProtocol = RequestService()
        let reachabilityService: ReachabilityServiceProtocol = ReachabilityService(urlStr: "https://www.google.com")
        
        let repository: RepositoryProtocol = Repository(baseConfig: baseConfig,
                                                        endPoints: endPoints,
                                                        requestService: requestService,
                                                        reachabilityService: reachabilityService)
            
        coordinator = MainCoordinator(navigationController: navController,
                                      repository: repository)

        coordinator?.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }
}

