//
//  CMLifeViewManager.swift
//  OneViewController
//
//  Created by 黄雄 on 2021/6/16.
//

import UIKit

class CMLifeViewManager: CMSwiftViewManager {
    
    override func drawingView() {
        self.viewController?.navigationItem.title = "生活"
        self.renderByXib()
        // 如果自己定义了 xib 的 RenderView/ CMLifeRenderView 即在 xib 中指定 View 的类型
        self.renderView = self.renderXibView as? CMSwiftRenderView
        self.renderView?.viewManagerPath = self.viewManagerPath
    }
    
    override func callActionExcute(dictionary: [String : Any]) {
        
        if let type = dictionary["type"] as? String {
            switch type {
            case "lifeClick":
                let lifeList = UIExtensionViewController(withParameter: ["viewManager": "CMLifeAddListViewManager"])
                self.viewController?.navigationController?.pushViewController(lifeList, animated: true)
                break
            default:
                break
            }
        }
    }
}
