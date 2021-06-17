//
//  CMSwiftCollectionItemModel.swift
//  32TeethProtector
//
//  Created by 黄雄 on 2020/9/22.
//  Copyright © 2020 huangxiong. All rights reserved.
//

import UIKit


/// collectionView itemModel
@objc class CMSwiftCollectionItemModel: NSObject {
    
    /// section
    @objc var section:Int = 0
    
    /// item
    @objc var item:Int = 0
    
    /// 是否可以移动
    @objc var canMove:Bool = false
    
    /// 是否高亮
    @objc var canHighlight:Bool = false
    
    /// 尺寸 信息
    @objc var size:CGSize = CGSize.zero
    
    /// 复用标识
    @objc var cellWithIdentifier:String?
    
    /// 类名
    @objc var cellClass:String?
    
    /// 移动路由地址
    @objc var routerSelectURL:String?
    
    /// pathId
    @objc var pathId:String?
    
    /// 视图控制器存储索引
    @objc var viewManagerPath: String?
    //MARK: - 重写 model 产生方法
    override class func model(dictionary: [String: Any]?, isAllValueToString: Bool) -> CMSwiftCollectionItemModel {
        let rowModel: CMSwiftCollectionItemModel = super.model(dictionary: dictionary, isAllValueToString: isAllValueToString) as! CMSwiftCollectionItemModel
        return rowModel
    }
}

/// 元素继承自 CMSwiftCollectionItemModel 才行
extension Array where Element:CMSwiftCollectionItemModel  {
    
    /// 将继承自 rowModel 协议的数组转换成 json 数组
    /// - Parameter needAll: 是否需要元素全部的属性
    /// - Returns:
    func toJsonArray(needAll:Bool = false) -> [[String: Any]] {
        needAll == true ? self.map {$0.getSwiftAllSuperPropertiesDictionary()} : self.map {$0.getSwiftPropertiesDictionary()}
    }
}
