//
//  CMSwiftTableViewManager.swift
//  32TeethProtector
//
//  Created by 黄雄 on 2020/9/16.
//  Copyright © 2020 huangxiong. All rights reserved.
//

import UIKit

class CMSwiftTableViewManager: CMSwiftViewManager, UITableViewDataSource, UITableViewDelegate {
    
    public var sectionDataArray: [CMSwiftSectionModel] = []
    
    /// 私有变量
    private var _tableView: UITableView?
    public var tableView: UITableView? {
        get {
            if _tableView == nil {
                _tableView = (self.viewController?.value(forKey: "tableView") as? UITableView)
                _tableView?.dataSource = self
                _tableView?.delegate = self
            }
            return _tableView
        }
    }
    
    /// 注册 tableView
    /// - Parameter tableView: tableView
    @objc public func registerTableView(_ tableView: UITableView) {
        _tableView = tableView
        _tableView?.dataSource = self
        _tableView?.delegate = self
    }
    
    /// 注册复用标识支持 xib 和纯代码 key: cellReuseIdentifier, value: Cell Xib 名字, 也可以是 cellClass
    /// - Parameter cellReuseIdentifierDictionary: 复用标识字典
    @objc public func registerNibNameForCellReuseIdentifier(_ cellReuseIdentifierDictionary: Dictionary<String, String>?) {
        if self.tableView == nil || cellReuseIdentifierDictionary == nil {
            return
        }
        let allKeys = cellReuseIdentifierDictionary!.keys
        for key in allKeys {
            
            if let value = cellReuseIdentifierDictionary?[key]  {
                let nib = UINib(nibName: value, bundle: nil)
                // 通过 path
                let path = Bundle.main.path(forResource: value, ofType: "nib")
                if path != nil {
                    self.tableView!.register(nib, forCellReuseIdentifier: key)
                } else {
                    var classType: AnyClass? = NSClassFromString(value)
                    if classType == nil {
                        classType = NSClassFromString("\(CMRouterManager.share.getProjectName()).\(value)")
                    }
                    self.tableView?.register(classType, forCellReuseIdentifier: key)
                }
                
            }
            
        }
    }
    
    /// 注册 header footer 复用表示
    /// - Parameter headerFooterViewReuseIdentifierDictionary: header footer 字典
    @objc public func registerNibNameForHeaderFooterViewReuseIdentifier(_ headerFooterViewReuseIdentifierDictionary: Dictionary<String, String>?) {
        if self.tableView == nil || headerFooterViewReuseIdentifierDictionary == nil {
            return
        }
        let allKeys = headerFooterViewReuseIdentifierDictionary!.keys
        for key in allKeys {
            if let value = headerFooterViewReuseIdentifierDictionary?[key] {
                let nib = UINib(nibName: value, bundle: nil)
                self.tableView!.register(nib, forHeaderFooterViewReuseIdentifier: key)
            }
            
        }
    }
    
    /// 默认选中的 IndexPath
    /// - Parameter indexPath: 索引路径
    func didSelectRow(at indexPath: IndexPath) {
        
    }
    
    //MARK:- tableView DataSource/Delegate 数据源和代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionDataArray.count
    }
    //MARK: 一个 section 有多少个 row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sectionDataArray.count > section {
            self.sectionDataArray[section].section = section
            if isValidString(string: self.sectionDataArray[section].pathId) == false {
                self.sectionDataArray[section].pathId = self.pathId
            }
            return self.sectionDataArray[section].rowDataArray.count
        }
        return 0
    }
    
    //MARK: - 从数据源数组 sectionDataArray 获得 section 的索引标题数组
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    
    //MARK: - cell 配置
    //MARK: -cell 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.sectionDataArray.count > indexPath.section && self.sectionDataArray[indexPath.section].rowDataArray.count > indexPath.row {
            return self.sectionDataArray[indexPath.section].rowDataArray[indexPath.row].rowHeight;
        }
        return 0;
    }
    //MARK: -cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellWithIdentifier = "", cellClass = ""
        if self.sectionDataArray.count <= indexPath.section || self.sectionDataArray[indexPath.section].rowDataArray.count <= indexPath.row {
            return tableView.dequeueReusableCell(withIdentifier: cellWithIdentifier, for: indexPath)
        }
        // 标识符
        cellWithIdentifier = self.sectionDataArray[indexPath.section].rowDataArray[indexPath.row].cellWithIdentifier ?? ""
        // 类别
        cellClass = self.sectionDataArray[indexPath.section].rowDataArray[indexPath.row].cellClass ?? ""
        // 设置 section
        self.sectionDataArray[indexPath.section].rowDataArray[indexPath.row].section = indexPath.section
        // 设置 row
        self.sectionDataArray[indexPath.section].rowDataArray[indexPath.row].row = indexPath.row
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellWithIdentifier, for: indexPath)
        if cell == nil {
            let projectName = CMRouterManager.share.getProjectName()
            cellClass = projectName + "0" + cellClass
            cell = (NSClassFromString(cellClass) as! UITableViewCell.Type).init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellWithIdentifier)
        }
        // 设置 cell
        cell?.setCell(withRowModel: self.sectionDataArray[indexPath.section].rowDataArray[indexPath.row])
        return cell!
    }
    
   
    //MARK: - sectionHeader配置
    //MARK: -sectionHeader 高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.sectionDataArray.count > section {
            return self.sectionDataArray[section].headerHeight;
        }
        return 0;
    }
    
    //MARK: -sectionHeader
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.sectionDataArray.count <= section {
            return nil
        }
        // headerWithIdentifier 这个必须不为空才可以
        if let headerWithIdentifier = self.sectionDataArray[section].headerWithIdentifier {
            let headerClass = self.sectionDataArray[section].headerClass
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerWithIdentifier)
            // 如果 header = nil
            if header == nil {
                let classOC = NSClassFromString(anyToString(headerClass)) as? UITableViewHeaderFooterView.Type
                let classSwift = NSClassFromString("\(CMRouterManager.share.getProjectName()).\(anyToString(headerClass))") as? UITableViewHeaderFooterView.Type
                let classType = (classSwift != nil ? classSwift : classOC) ?? UITableViewHeaderFooterView.self
                header = classType.init(reuseIdentifier: headerWithIdentifier)
            }
            header?.setSection(widthSectionModel: self.sectionDataArray[section])
            return header
        }
        return nil
    }
    // footer 高度
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return self.sectionDataArray[section].footerTitle
//    }
    
    
    //MARK: - sectionFooter配置
    //MARK: -sectionFooter 高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.sectionDataArray.count > section {
            return self.sectionDataArray[section].footerHeight;
        }
        return 0;
    }
    
    //MARK: -sectionHeader
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.sectionDataArray.count <= section {
            return nil
        }
        if let footerWithIdentifier = self.sectionDataArray[section].footerWithIdentifier {
            let footerClass = self.sectionDataArray[section].footerClass
            var footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerWithIdentifier)
            // 如果 header = nil
            if footer == nil {
                let classOC = NSClassFromString(anyToString(footerClass)) as? UITableViewHeaderFooterView.Type
                let classSwift = NSClassFromString("\(CMRouterManager.share.getProjectName()).\(anyToString(footerClass))") as? UITableViewHeaderFooterView.Type
                let classType = (classSwift != nil ? classSwift : classOC) ?? UITableViewHeaderFooterView.self
                footer = classType.init(reuseIdentifier: footerWithIdentifier)
            }
            footer?.setSection(widthSectionModel: self.sectionDataArray[section])
            return footer
        }
        return nil
    }
    
    //MARK: - row 被选中了
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 为了避免崩溃
//        if self.sectionDataArray.count > indexPath.section && self.sectionDataArray[indexPath.section].rowDataArray.count > indexPath.row {
//            let routerURL = self.sectionDataArray[indexPath.section].rowDataArray[indexPath.row].routerURL ?? "";
//            // 将将路由地址提交给 CMRouterManager 处理, 有路由地址的优先级高
//            if CMRouterManager.share.itemExist(withRouter: routerURL) {
//                CMRouterManager.share().router(routerURL, parameters: indexPath, success: nil, failure: nil)
//            } else {
//                // 没有就调用选中 row 方法, 子类实现该方法即可
//                self.didSelectRow(at: indexPath)
//            }
//        }
    }
    
    /// 计算 tableView 内容高度, 不通过 tableView 的 contentSize 计算
    /// - Returns: 高度值
    func getTableViewContentHeight() -> CGFloat {
        // 计算 tableView 的 内容高度
        self.sectionDataArray.reduce(0) { result, sectionModel in
            result + sectionModel.getSectionContentHeight()
        }
    }
}
