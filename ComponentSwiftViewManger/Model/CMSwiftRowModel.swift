//
//  CMSwiftRowModel.swift
//  32TeethProtector
//
//  Created by 黄雄 on 2020/9/19.
//  Copyright © 2020 huangxiong. All rights reserved.
//

import UIKit

class CMSwiftRowModel: NSObject, Codable {
    
    /// cell 标识
    @objc var cellWithIdentifier: String?
    
    /// 标识第几个 section
    @objc var section : Int = 0
    
    /// 标识第几 row
    @objc var row : Int = 0
    
    /// 行高
    @objc var rowHeight: CGFloat = 0
    
    /// 类名
    @objc var cellClass: String?
    
    /// 路由地址
    @objc var routerURL: String?
    
    /// pathId, 页面标识
    @objc var pathId: String?
    
    /// 视图控制器存储索引
    @objc var viewManagerPath: String?
    
    @objc override class func model(dictionary: [String: Any]?, isAllValueToString: Bool) -> CMSwiftRowModel {
        let rowModel = super.model(dictionary: dictionary, isAllValueToString: isAllValueToString) as! CMSwiftRowModel
        return rowModel
    }
    
  
    /// 生成参数
    /// - Returns: 从 model 获得需要的参数
    func fetchParameter() -> Any? {
        return nil
    }
}

/// 元素继承自 CMSwiftRowModel 才行
extension Array where Element:CMSwiftRowModel  {
    
    /// 将继承自 rowModel 协议的数组转换成 json 数组
    /// - Parameter needAll: 是否需要元素全部的属性
    /// - Returns:
    func toJsonArray(needAll:Bool = false) -> [[String: Any]] {
        needAll == true ? self.map {$0.getSwiftAllSuperPropertiesDictionary()} : self.map {$0.getSwiftPropertiesDictionary()}
    }
}
