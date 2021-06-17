//
//  CMMomentViewManager.swift
//  OneViewController
//
//  Created by 黄雄 on 2021/6/16.
//

import UIKit

class CMMomentRenderView: CMSwiftRenderView {
    lazy var label1 : UILabel? = {
        let view = UILabel()
        view.tag = 1000
        self.addSubview(view)
        view.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-150)
        }
        return view
    }()
    
    override func render() {
        self.label1?.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        self.label1?.text = "场景展示"
    }
}

class CMMomentViewManager: CMSwiftViewManager {
    override func drawingView() {
        self.viewController?.navigationItem.title = "场景"
        self.renderView = CMMomentRenderView()
        self.render()
    }
}
