//
//  CMSwiftViewManager.swift
//  32TeethProtector
//
//  Created by 黄雄 on 2020/9/16.
//  Copyright © 2020 huangxiong. All rights reserved.
//

import UIKit

/// 刷新页面
let PathAllPageRefresh = "message.page.refresh"


class CMSwiftViewManager: NSObject {
    
    /// 渲染视图
    var renderView:CMSwiftRenderView?
    
    var renderXibView:UIView?
    
    /// 视图控制器存储在 Router 中的索引
    @objc var viewManagerPath: String?
    
    /// 私有变量
    
    /// 只有 get 方法
    @objc weak var viewController: UIViewController?
    
    /// 主队列, 刷新 UI
    var mainDispatchQueue = DispatchQueue.main
    
    /// 默认队列
    var defaultDispatchQueue = DispatchQueue.global()
    
    /// 数据队列
    var dataDispatchQueue = DispatchQueue.global(qos: .utility)
    
    var backgroundDispatchQueue = DispatchQueue.global(qos: .background)
    
    lazy var parameters: [String: Any]? = {
        var parameters:[String: Any]? = nil
        if let viewController = self.viewController as? UIExtensionViewController {
            parameters = viewController.parameters
        } else {
            parameters = self.controller(forKey: "parameters") as? [String : Any]
        }
        return parameters
    }()
    
    /// 是否重复刷新
    @objc var reapeatRefresh = true
    
    /// Path id
    @objc lazy var pathId: String = {
        [weak self] in
        if let strongSelf = self {
            assert(self != nil || (strongSelf.viewController != nil), "self.viewController 不能为空")
            return strongSelf.viewController!.description.getMD5String()
        }
        return ""
    }()
    
//    @objc lazy var pathId: String! = {
//        get {
//            if _pathId == nil {
//                assert((self.viewController != nil), "self.viewController 不能为空")
//                _pathId = self.viewController?.description.getMD5String()
//            }
//            return _pathId
//        }
//        set {
//            _pathId = newValue
//        }
//    }
    
    /// 便利构造函数
    /// - Parameter viewController: 视图控制器
    @objc required init(withViewController viewController: UIViewController?) {
        super.init()
        self.viewController = viewController
        self.reapeatRefresh = true
    }
    
    
    /// 渲染函数, 此处编写布局代码/或者加载渲染视图
    /// 重绘则把 self.renderView = nil, 之后重建就行
    @objc func render() {
        if let renderView = self.renderView {
            self.viewController?.view.addSubview(renderView)
            self.renderView?.viewManagerPath = self.viewManagerPath
            renderView.snp.makeConstraints { maker in
                maker.left.right.top.bottom.equalToSuperview()
            }
            renderView.render()
        }
    }
    
    func renderByXib() {
        let type = self.parameters?["viewType"] as? String ?? "999"
        let typeInt = Int(type)! - 1000
        if typeInt < 0 {
            return
        }
        let viewArray = UINib(nibName: "AppView", bundle: nil).instantiate(withOwner: self, options: nil).filter {$0 is UIView}
        self.renderXibView = viewArray[typeInt] as? UIView
        self.viewController?.view.addSubview(self.renderXibView!)
        self.renderXibView!.snp.makeConstraints { maker in
            maker.left.right.bottom.top.equalToSuperview()
        }
    }
    
    /// 绘制主界面
    @objc func drawingView() {
        
    }
    
    /// 获取数据
    @objc func getRemoteData() {
        
    }
    
    /// 注册 block
    @objc func registerBlock() {
        
    }
    
    /// 删除 block
    @objc func removeBlock() {
        
    }
    
    /// 注册类
    @objc func registerClass() {
        
    }
    
    /// 删除类
    @objc func removeClass() {
        
    }
    
    /// 刷新操作
    @objc func refreshAction() {
        
    }
    
    /// 移除视图消失时的 block
    @objc func removeViewDisappearBlock() {
        
    }
    
    /// 注册视图出现时的 block
    @objc func registerViewAppearBlock() {
        
    }
    
    /// 注册刷新消息回调
//    @objc func registerRefreshMessageBlock() {
//        CMRouterManager.share().registerTarget(self.pathId, messageBlock: {
//            [weak self] in
//            if let strongSelf = self {
//                strongSelf.reapeatRefresh = true
//                strongSelf.refreshAction()
//            }
//        }, forPath: PathAllPageRefresh)
//    }
    
    /// 读取控制器属性
    /// - Parameter forKey: 属性名
    /// - Returns: 返回结果
    @objc func controller(forKey: String) -> Any? {
        return self.viewController?.value(forKey: forKey)
    }
    
    /// 执行操作, 用于 viewController 向 viewManager 执行操作
    /// viewController 和 viewManager 之间无需使用 block 来通信,
    /// viewController 和别的 viewController之间,
    /// viewManager 和别的 viewManager 之间, 这几种情况使用 block 来通信
    /// - Parameter dictionary: 参数为字典, 通过参数执行不同的操作
    @objc func callActionExcute(dictionary:[String: Any]) {
        
    }
    
//    /// 执行刷新页面命令
//    /// 2020.12.03
//    func callActionAllPageRefresh() {
//        CMRouterManager.share().router("messageTo://\(PathAllPageRefresh)", parameters: nil, success: nil, failure: nil)
//    }
    
    /// 加载子元素
    /// time: 2021.05.19 22:36
    /// - Parameters:
    ///   - type: 是子视图类型, 必须继承自 UIView
    ///   - tag: 是子视图的 tag
    ///   - containerView: 是 superView, 默认为 self.viewController?.view
    /// - Returns: 返回子视图的对象
    func fetchSubView<T>(type: T.Type?, withTag tag: Int, containerView: UIView? = nil) -> T? where T: UIView {
        let superView = containerView != nil ? containerView : renderView != nil ? renderView : self.viewController?.view
        return superView?.viewWithTag(tag) as? T
    }
    
   
    
    @objc deinit{
        debugPrint(self, " 挂了....挂了")
        self.removeBlock()
    }
}

