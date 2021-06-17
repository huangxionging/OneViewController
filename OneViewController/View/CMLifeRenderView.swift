//
//  CMLifeRenderView.swift
//  OneViewController
//
//  Created by 黄雄 on 2021/6/16.
//

import UIKit

class CMLifeRenderView: CMSwiftRenderView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    /// xib 添加点击方法
    @IBAction func lifeClick(_ sender: Any) {
        self.getSwiftViewManager()?.callActionExcute(dictionary: ["type": "lifeClick"])
    }
    
}
