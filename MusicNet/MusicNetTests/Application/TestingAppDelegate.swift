//
//  AppDelegateTests.swift
//  MusicNetTests
//
//  Created by Genaro Codina Reverter on 6/3/21.
//

import UIKit
@testable import MusicNet

@objc(TestingAppDelegate)
class TestingAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navController = UINavigationController()
        
        let baseConfig: BaseConfigProtocol = BaseConfigPro()
        let endPoints: EndPointsProtocol = EndPoints()
        let requestService: RequestServiceProtocol = RequestService()
        let reachabilityService: ReachabilityServiceProtocol = ReachabilityService(urlStr: "dummy")
        
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
