//
//  AppDelegate.swift
//  OneViewController
//
//  Created by 黄雄 on 2021/6/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let vc1 = UIExtensionViewController(withParameter: ["viewManager": "CMHomeViewManager", "viewType": "1000"])
        let nav1 = UINavigationController(rootViewController: vc1)
        let vc2 = UIExtensionViewController(withParameter: ["viewManager": "CMLifeViewManager", "viewType": "1001"])
        let nav2 = UINavigationController(rootViewController: vc2)
        let vc3 = UIExtensionViewController(withParameter: ["viewManager": "CMMomentViewManager"])
        let nav3 = UINavigationController(rootViewController: vc3)
        let vc4 = UIExtensionTableViewController(withParameter: ["viewManager": "CMMyViewManager"])
        let nav4 = UINavigationController(rootViewController: vc4)
        
        nav1.title = "首页"
        nav2.title = "生活"
        nav3.title = "场景"
        nav4.title = "我的"
        
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = [nav1, nav2, nav3, nav4]
        
        self.window?.rootViewController = tabBarVC
        self.window?.makeKeyAndVisible()
        return true
    }

}

