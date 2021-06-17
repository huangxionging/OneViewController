//
//  CMHomeViewManager.swift
//  OneViewController
//
//  Created by 黄雄 on 2021/6/16.
//

import Foundation
import UIKit
import SnapKit

class CMHomeViewManager: CMSwiftViewManager {
    
    lazy var button : UIButton? = {
        let view = fetchSubView(type: UIButton.self, withTag: 1000, containerView: renderXibView)
        return view
    }()
    
    override func drawingView() {
        self.viewController?.navigationItem.title = "首页"
        self.renderByXib()
        /// 使用 xib 之后自己添加点击事件
        self.button?.addTarget(self, action: #selector(self.homeClick), for: .touchUpInside)
    }
    
    @objc func homeClick() {
        let shop =  UIExtensionViewController(withParameter: ["viewManager": "CMShopViewManager"])
        self.viewController?.navigationController?.pushViewController(shop, animated: true)
    }
}
