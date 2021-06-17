//
//  CMSwiftSectionModel.swift
//  32TeethProtector
//
//  Created by 黄雄 on 2020/9/19.
//  Copyright © 2020 huangxiong. All rights reserved.
//

import UIKit

class CMSwiftSectionModel: NSObject {
    
    /// row 数据源
    @objc var rowDataArray:[CMSwiftRowModel] = []
    
    /// section
    @objc var section:Int = 0
    
    /// section 背景颜色
    @objc var sectionBackgroundColor:Int = 0
    
    /// header 高度
    @objc var headerHeight:CGFloat = 0
    
    /// 头部标识
    @objc var headerWithIdentifier:String?
    
    /// 头部类
    @objc var headerClass:String?
    
    /// 头部标题
    @objc var headerTitle:String?
    
    /// 索引标题
    @objc var indexTitle:String?
    
    /// 标题
    @objc var title:String?
    
    /// 标题颜色
    @objc var titleColor:Int = 0
    
    /// 标题字体大小
    @objc var titleFontSize:CGFloat = 0
    
    /// 尾部高度
    @objc var footerHeight:CGFloat = 0
    
    /// 尾部标识
    @objc var footerWithIdentifier:String?
    
    /// 尾部标识的类
    @objc var footerClass:String?
    
    /// 尾部标题
    @objc var footerTitle:String?
    
    /// pathId
    @objc var pathId:String?
    
    /// 视图控制器存储索引
    @objc var viewManagerPath: String?
    
    
    /// 获得 section 的内容高度
    /// - Returns: 内容高度
    func getSectionContentHeight() -> CGFloat {
        self.headerHeight + self.footerHeight + self.rowDataArray.reduce(0) { rowHeight, rowModel in
            rowHeight + rowModel.rowHeight
        }
    }
}

/// 元素继承自 CMSwiftSectionModel 才行
extension Array where Element:CMSwiftSectionModel {
    
    /// 将继承自 rowModel 协议的数组转换成 json 数组
    /// - Parameter needAll: 是否需要元素全部的属性
    /// - Returns:
    func toJsonArray(needAll:Bool = false) -> [[String: Any]] {
        needAll == true ? self.map {$0.getSwiftAllSuperPropertiesDictionary()} : self.map {$0.getSwiftPropertiesDictionary()}
    }
}
