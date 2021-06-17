//
//  CMRouterManager.swift
//  OneViewController
//
//  Created by 黄雄 on 2021/6/16.
//

import Foundation

class CMRouterManager: NSObject {
    
    var routerStorage = [String: Any]()
    
    private override init() {
        
    }
    
    static let share = CMRouterManager()
    
    
    /// 注册 ViewManager
    /// - Parameters:
    ///   - viewManager: ViewManager
    ///   - path: 路径
    func register(viewManager:CMSwiftViewManager?, forPath path:String?) {
        if viewManager != nil, let viewManagerPath = path, self.routerStorage[viewManagerPath] == nil {
            self.routerStorage[viewManagerPath] = viewManager!
        }
    }
    
    func getViewManager(forPath path:String?) -> CMSwiftViewManager?{
        if let viewManagerPath = path {
            return self.routerStorage[viewManagerPath] as? CMSwiftViewManager
        }
        return nil
    }
    
    func removeViewManager(withPath path:String?) {
        if let viewManagerPath = path {
            self.routerStorage.removeValue(forKey: viewManagerPath)
        }
    }
    
    func getProjectName() -> String  {
        var projectName = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as! String
        let first = projectName.prefix(1)
        let other = projectName.suffix(projectName.count - 1)
        let firstInteger = Int(first)
        if firstInteger != nil && firstInteger! >= 0 && firstInteger! <= 9 {
            projectName = "_\(other)"
        }
        return projectName;
    }
}
