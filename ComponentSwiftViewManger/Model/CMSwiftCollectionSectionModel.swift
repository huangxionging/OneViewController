//
//  CMSwiftCollectionSectionModel.swift
//  32TeethProtector
//
//  Created by 黄雄 on 2020/9/22.
//  Copyright © 2020 huangxiong. All rights reserved.
//

import UIKit

class CMSwiftCollectionSectionModel: NSObject {
    
    /// section
    @objc var section:Int = 0
    
    /// 边角
    @objc var insets:UIEdgeInsets = UIEdgeInsets.zero
    
    /// 最小行间距
    @objc var minimumLineSpacing:CGFloat = 0
    
    /// 最小列间距
    @objc var minimumInteritemSpacing:CGFloat = 0
    
    /// 头部大小
    @objc var referenceSizeForHeader:CGSize = CGSize.zero
    
    /// 尾部大小
    @objc var referenceSizeForFooter:CGSize = CGSize.zero
    
    /// 数据源
    @objc var itemDataArray:[CMSwiftCollectionItemModel] = []
    
    /// pathId
    @objc var pathId:String?
    /// 视图控制器存储索引
    @objc var viewManagerPath: String?
    override class func model(dictionary: [String: Any]?, isAllValueToString: Bool) -> CMSwiftCollectionSectionModel {
        let rowModel: CMSwiftCollectionSectionModel = super.model(dictionary: dictionary, isAllValueToString: isAllValueToString) as! CMSwiftCollectionSectionModel
        return rowModel
    }
}
