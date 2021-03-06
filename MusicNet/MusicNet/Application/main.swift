//
//  main.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 6/3/21.
//

import UIKit

let appDelegateClass: AnyClass = NSClassFromString("TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
