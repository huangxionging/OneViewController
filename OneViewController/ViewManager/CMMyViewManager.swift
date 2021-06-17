//
//  CMMyViewManager.swift
//  OneViewController
//
//  Created by 黄雄 on 2021/6/16.
//

import UIKit

class CMMyViewManager: CMSwiftTableViewManager {
    override func drawingView() {
        self.viewController?.navigationItem.title = "我的"
        self.registerNibNameForCellReuseIdentifier(["MyRowCell":"CMMyRowTableViewCell"])
        self.getSectionData()
        self.tableView?.reloadData()
    }
    
    func getSectionData() {
        let sectionModel = CMSwiftSectionModel()
        for _ in 0...10 {
            let rowModel = CMSwiftRowModel.model(dictionary: ["viewManagerPath": self.viewManagerPath ?? "", "cellWithIdentifier": "MyRowCell"], isAllValueToString: false)
            rowModel.cellClass = "CMMyRowTableViewCell"
            rowModel.routerURL = "我的"
            rowModel.rowHeight = 44
            sectionModel.rowDataArray.append(rowModel)
        }
        self.sectionDataArray.append(sectionModel)
        
    }
}
