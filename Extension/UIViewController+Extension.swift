//
//  UIViewController+Extension.swift
//  32TeethProtector
//
//  Created by 黄雄 on 2020/9/24.
//  Copyright © 2020 huangxiong. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 新增一个扩展视图控制器
/// page.extension.view.main
class UIExtensionViewController: UIViewController {
    /// 增加删除视图控制器功能, 默认就存在, 无需后期再写, 创建页面的时候,
    /// 继承或者之后修改为该扩展类就行了
    
    /// 参数, 如果存在, 则保存在参数中
    private var _parameters: [String: Any]?
    /// 参数访问方法
    var parameters: [String: Any]? {
        get {
            return _parameters
        }
        set {
            _parameters = newValue
        }
    }
    
    /// 覆写设置参数方法
    /// - Parameter parameters: 参数
    override func setParameters(_ parameters: Any!) {
        _parameters = parameters as? [String: Any]
    }
    
    /// 默认删除视图管理器
    deinit {
        self.removeSwiftViewManager()
    }
    
    
    init(withParameter parameters:[String: Any]) {
        super.init(nibName: nil, bundle: nil)
        self.setParameters(parameters)
        // 如果有必要, 提前加载 xib
        self.loadViewIfNeeded()
        if let viewManagerName = parameters["viewManager"] as? String  {
            if let _ = NSClassFromString(viewManagerName) as? CMSwiftViewManager.Type {
                self.drawSwiftViewUI(byViewManagerName: viewManagerName)
            } else {
                self.drawSwiftViewUI(byViewManagerName: "\(CMRouterManager.share.getProjectName()).\(viewManagerName)")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}

extension UIViewController {
    /// 视图管理器路径, 统一采用前缀 + pathId 的方式
    @objc var viewManagerPath:String {
        get {
            return "object.view.manager.\(self).\(self.swiftPathId)"
        }
    }
    
    /// 设置 Swift PathId 为了和 OC 中的 Category 不冲突, 都加了 Swift
    @objc var swiftPathId:String {
        get {
            return self.description.getMD5String()
        }
    }
    
    /// 设置返回按钮
    @objc func setSwiftBackButton() {
        let backImage = UIImage(named: "arrow_back")
        let item = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItems = [item]
    }
    
    /// 返回
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 注册视图控制器
    /// - Parameters:
    ///   - className: 类名
    ///   - forPath: 路径
    @objc func registerSwiftViewManager(_ viewManager:CMSwiftViewManager?) {
        // 注册视图控制器
        if viewManager == nil{
            return
        }
        viewManager?.viewManagerPath = self.viewManagerPath
        CMRouterManager.share.register(viewManager: viewManager, forPath: self.viewManagerPath)
    }
    
    /// 获得视图控制器
    /// - Parameter path: 路径
    /// - Returns: 视图控制器
    @objc func getSwiftViewManager(by viewManagerPath: String? = "") -> CMSwiftViewManager? {
        let queryViewManagerPath = (viewManagerPath == "" || viewManagerPath == nil) ? self.viewManagerPath : viewManagerPath
        return CMRouterManager.share.getViewManager(forPath: queryViewManagerPath)
    }
    
    
    /// 删除控制器
    /// - Parameter path: 路径
    @objc func removeSwiftViewManager() {
        var viewManager = self.getSwiftViewManager()
        if isValid(object: viewManager) == true {
            CMRouterManager.share.removeViewManager(withPath: self.viewManagerPath)
            viewManager = nil
        }
    }
    
    /// 注册 swiftManager
    /// - Parameter viewManagerName: viewManager 名字
    @objc func registerSwiftViewManager(byViewManagerName viewManagerName:String) {
        var className = NSClassFromString(anyToString(viewManagerName)) as? CMSwiftViewManager.Type
        
        if className == nil {
            className = NSClassFromString("\(CMRouterManager.share.getProjectName()).\(anyToString(viewManagerName))") as? CMSwiftViewManager.Type
        }
        
        if className == nil {
            return
        }
        self.registerSwiftViewManager(className?.init(withViewController: self))
    }
    
    /// 绘制 Swift 的 UI
    /// - Parameter viewManager: viewManager
    @objc func drawSwiftViewUI(_ viewManager:CMSwiftViewManager?) {
        self.registerSwiftViewManager(viewManager)
        self.getSwiftViewManager()?.drawingView()
    }
    
    /// 绘制 Swift 的 UI
    /// - Parameter viewManagerName: viewManager 名字
    @objc func drawSwiftViewUI(byViewManagerName viewManagerName:String) {
        self.registerSwiftViewManager(byViewManagerName: viewManagerName)
        self.getSwiftViewManager()?.drawingView()
    }
    
    
    /// 是否需要左滑返回手势
    /// - Returns: 默认需要
    @objc func needPopGesture() -> Bool {
        return true
    }
    
    /// 是否需要导航栏
    /// - Returns: 默认需要
    @objc func needNavigationBar() -> Bool {
        return true
    }
    
    /// push 页面的时候是否需要隐藏 TabBar
    /// - Returns: 默认需要
    @objc func needHideTabBarWhenPushed() -> Bool {
        return true
    }
    
    /// 视图即将出现
    @objc func viewWillAppear() {
        self.hideShowNavigationBar()
    }
    
    /// 隐藏是否导航栏
    @objc func hideShowNavigationBar() {
        self.navigationController?.setNavigationBarHidden(!self.needNavigationBar(), animated: true)
    }
    
    /// 是否隐藏下面的 Bar 条, 刘海屏手机才有
    /// - Returns:
    @objc func viewControllerPrefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    /// 设置参数
    /// - Parameter parameters: 参数
    @objc func setParameters(_ parameters: Any!) {
        
    }
    
    @objc func showXibView(withName name: String = "", tag: Int = 0, point:CGPoint = CGPoint.zero) {
        if isValidString(string: name) == false {
            return
        }
        self.hideView(withTag: tag)
        let nibArray = UINib.init(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)
        if nibArray.count == 0 {
            return
        }
        let xibView = nibArray[0] as! UIView
        xibView.frame.size.height = 120
        self.view.addSubview(xibView)
        self.view.bringSubviewToFront(xibView)
        xibView.tag = tag
    }
    
    
    @objc func hideView(withTag tag: Int) {
        var view = self.view.viewWithTag(tag)
        if view == nil {
            return
        }
        view?.removeFromSuperview()
        view = nil
    }
    
    
//    /// 网络错误提示框
//    /// - Parameters:
//    ///   - error: 错误描述
//    ///   - retryClosure: 闭包
//    /// - Returns: 空
//    @objc func showHUD(withError error: Error?, retryClosure: (()->())?) {
//        CMShowHUDManager.share()?.showAlert(with: error?.localizedDescription, message: "", actions: [["title": "知道了", "style": "\(UIAlertActionStyle.default)"], ["title": "重试", "style": "\(UIAlertActionStyle.default)"]], completed: {
//            (index: Int) in
//            if (index == 1) {
//                if retryClosure != nil {
//                    retryClosure!()
//                }
//            }
//            
//        })
//    }
}


//+ (void)pushWithNavigator:(UINavigationController *)navigationController parameters:(id)parameters {
//    UIViewController *viewController = [[[self class] alloc] init];
//    viewController.hidesBottomBarWhenPushed = YES;
//    // 如果有参数, 就配置参数
//    if (parameters) {
//        [viewController setParameters: parameters];
//    }
//    [navigationController pushViewController: viewController animated: YES];
//}
//
//- (void)setParameters:(id)parameters {
//
//}
//
//- (void) showWebErrorViewName:(NSString *)name tag:(NSInteger)tag {
//    [self hideWebErrorViewWithTag:tag];
//    UIView *webErrorView = [[UINib nibWithNibName: name bundle: nil] instantiateWithOwner: nil options: nil][0];
//    CGRect frame = self.view.frame;
//    frame.origin.y += 1.5;
//    frame.size.height -= 1.5;
//    webErrorView.frame = frame;
//    webErrorView.tag = tag;
//    [self.view addSubview: webErrorView];
//}
//
//- (void)hideWebErrorViewWithTag:(NSInteger)tag {
//    UIView *webErrorView = [self.view viewWithTag: tag];
//    if (webErrorView) {
//        [webErrorView removeFromSuperview];
//        webErrorView = nil;
//    }
//}
//
//- (BOOL)canConnectNetwork{
//    NSInteger status = [AFNetManager theNetworkStatus];
//    switch (status) {
//        case AFNetworkReachabilityStatusUnknown:
//        case AFNetworkReachabilityStatusNotReachable: {
//            return NO;
//            break;
//        }
//        default: {
//            return YES;
//            break;
//        }
//    }
//}


/// page.table.view.main, 默认 拥有 tableView 的
class UIExtensionTableViewController: UIExtensionViewController {
    
    @objc var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if let style = UITableView.Style(rawValue: Int(self.parameters?["style"] as? String ?? "0")!) {
            self.tableView = UITableView(frame: CGRect.zero, style: style)
            if let tableView = self.tableView {
                self.view.addSubview(tableView)
                tableView.snp.makeConstraints { maker in
                    maker.left.top.right.bottom.equalToSuperview()
                }
            }
        }
    }
}
