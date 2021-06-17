//
//  CMSwiftRenderView.swift
//  32TeethProtector
//
//  Created by 黄雄 on 2021/6/8.
//  Copyright © 2021 huangxiong. All rights reserved.
//

import Foundation
import UIKit

class CMSwiftRenderView: UIView {
    /// 视图控制器存储在 Router 中的索引
    @objc var viewManagerPath: String?
    
    func render() {}
    
    /// 获得视图控制器
    /// - Parameter path: 路径
    /// - Returns: 视图控制器
    @objc func getSwiftViewManager(by viewManagerPath: String? = "") -> CMSwiftViewManager? {
        let queryViewManagerPath = (viewManagerPath == "" || viewManagerPath == nil) ? self.viewManagerPath : viewManagerPath
        return CMRouterManager.share.getViewManager(forPath: queryViewManagerPath)
    }
}
