//
//  CMShopViewManager.swift
//  OneViewController
//
//  Created by 黄雄 on 2021/6/16.
//

import UIKit

class CMShopViewManager: CMSwiftViewManager {
    
    /// 直接在这个方法里添加代码布局
    override func render() {
        let label1 = UILabel()
        label1.tag = 1000
        label1.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        self.viewController?.view.addSubview(label1)
        label1.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(200)
        }
        
        ///...
        /// 继续添加别的 UI
    }
    
    override func drawingView() {
        self.viewController?.navigationItem.title = "商店"
        self.render()
        // 根据 tag 查询获得 Label 并设置文本信息
        self.fetchSubView(type: UILabel.self, withTag: 1000)?.text = "商店展示"
    }
}
