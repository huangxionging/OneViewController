//
//  NSObject+Extension.swift
//  32TeethProtector
//
//  Created by 黄雄 on 2020/9/20.
//  Copyright © 2020 huangxiong. All rights reserved.
//

import Foundation
import CoreData

@objc extension NSObject {
    
    /// 转换成模型
    /// - Parameters:
    ///   - dictionary: 字典
    ///   - isAllValueToString: 是否全部转成字符串
    /// - Returns: model 方法
    @objc class func model(dictionary: Dictionary<String, Any>?, isAllValueToString: Bool) -> NSObject {
        let model = Self()
        if dictionary == nil {
            return model
        }
        // 设置 model
        model.setModelProperty(dictionary: dictionary, isAllValueToString: isAllValueToString)
        return model
    }
    
    /// 获得属性列表
    /// - Returns: 属性列表数组
    @objc class func getSwiftProperties() -> [String]? {
        var count:UInt32 = 0
        let properties:UnsafeMutablePointer<objc_property_t>! = class_copyPropertyList(self.classForCoder(), &count)
        var propetiesArray = [String]()
        for index in 0 ..< (Int(count)) {
            let propertyChars = property_getName(properties![index])
            let propertyName = String(validatingUTF8: propertyChars) ?? ""
            propetiesArray.append(propertyName)
        }
        free(properties)
//        print(propetiesArray)
        return propetiesArray
    }
    
    /// 获得所有自己以及父类组成的属性列表
    /// - Returns: 属性列表
    @objc class func getSwiftAllSuperProperties() -> [String]? {
        var cls: AnyClass? = self.classForCoder()
        var propetiesArray = [String]()
        while cls != nil {
            let properties = cls?.getSwiftProperties()
            propetiesArray.append(contentsOf: properties!)
            cls = class_getSuperclass(cls!)
            if (cls == NSObject.classForCoder() || cls == NSManagedObject.classForCoder()) {
                break
            }
        }
        return propetiesArray
    }
    
    /// 设置 Model
    /// - Parameter dictionary: 字典
    @objc func setModelProperty(dictionary:Dictionary<String, Any>?, isAllValueToString: Bool) {
        let propetiesArray = Self.getSwiftAllSuperProperties()
        if propetiesArray?.count ?? 0 > 0 {
            for key in propetiesArray! {
                var propertyName = key
                // 如果存在映射关系, 则使用映射关系获得 mapKey
                if let mapKey = Self.mapSettingClassDictionary()?[key] {
                    propertyName = mapKey
                }
                // 然后读取 value
                let value = dictionary?[propertyName]
                if value != nil {
                    if isAllValueToString == true {
                        let stringValue = anyToString(value)
                        self.setValue(stringValue, forKey: key)
                    } else {
                        if let objClassDict = Self.objectClassInArray(), let cls = objClassDict[key],
                           let arrayValue = value as? [Any] {
                            let modelValueArray = arrayValue.map {cls.model(dictionary: $0 as? Dictionary<String, Any>, isAllValueToString: false)}
                            self.setValue(modelValueArray, forKey: key)
                        } else if let objClassDict = Self.objectClassInDictionary(), let cls = objClassDict[key],
                                  let dictionaryValue = value as? [String: Any] {
                            let modelValue = cls.model(dictionary: dictionaryValue, isAllValueToString: false)
                            self.setValue(modelValue, forKey: key)
                        } else {
                            self.setValue(value!, forKey: key)
                        }
                    }
                }
            }
        }
    }
    
    /// 定义类的数组元素的类型使用
    /// - Returns: 属性名和数组元素的类型组成的字典
    @objc class func objectClassInArray() -> [String: AnyClass]? {
        return nil
    }
    
    /// 模型转换时, 属性和字典中不同的字段的映射关系
    /// - Returns: map 字典, key 为 propertyName, value 为映射的赋值字段名
    @objc class func mapSettingClassDictionary() -> [String: String]? {
        return nil
    }
    
    /// 模型转字典时的映射关系字典
    /// - Returns: 返回映射关系字典
    @objc class func mapGettingClassDictionary() -> [String: String]? {
        return nil
    }
    
    /// 定义字典转换模型的字典
    /// - Returns: 属性名和类型组成的字典
    @objc class func objectClassInDictionary() -> [String: AnyClass]? {
        return nil
    }
    
    
    /// 获得属性字典, 包括父类
    /// - Returns: 属性字典
    @objc func getSwiftAllSuperPropertiesDictionary() -> Dictionary<String, Any>  {
        let propetiesArray = Self.getSwiftAllSuperProperties()
        var dictionary = [String: Any]()
        if propetiesArray?.count ?? 0 > 0 {
            for key in propetiesArray! {
                var propertyName = key
                // 如果存在映射关系, 则使用映射关系获得 mapKey
                if let mapKey = Self.mapGettingClassDictionary()?[key] {
                    propertyName = mapKey
                }
                let value = self.value(forKey: key)
                if value != nil {
                    if let objClassDict = Self.objectClassInArray(), let _ = objClassDict[key], let valueArray = value as? [AnyObject] {
                        let modelValueArray = valueArray.map{
                            (anyObject:AnyObject) -> [String: Any] in
                            let dict = anyObject.getSwiftPropertiesDictionary()
                            return dict
                        }
                        dictionary[propertyName] = modelValueArray
                    } else if let objClassDict = Self.objectClassInDictionary(), let _ = objClassDict[key]  {
                        let modelDictionary = (value as AnyObject).getSwiftPropertiesDictionary()
                        dictionary[propertyName] = modelDictionary
                    } else {
                        dictionary[propertyName] = value
                    }
                }
                
            }
        }
        return dictionary
    }
    
    /// 获得对象的 属性字典
    /// - Returns: 属性字典
    @objc func getSwiftPropertiesDictionary() -> [String: Any]  {
        let propetiesArray = Self.getSwiftProperties()
        var dictionary = [String: Any]()
        if propetiesArray?.count ?? 0 > 0 {
            for key in propetiesArray! {
                var propertyName = key
                // 如果存在映射关系, 则使用映射关系获得 mapKey
                if let mapKey = Self.mapGettingClassDictionary()?[key] {
                    propertyName = mapKey
                }
                let value = self.value(forKey: key)
                if value != nil {
                    if let objClassDict = Self.objectClassInArray(), let _ = objClassDict[key], let valueArray = value as? [AnyObject] {
                        let modelValueArray = valueArray.map{
                            (anyObject:AnyObject) -> [String: Any] in
                            let dict = anyObject.getSwiftPropertiesDictionary()
                            return dict
                        }
                        dictionary[propertyName] = modelValueArray
                    } else if let objClassDict = Self.objectClassInDictionary(), let _ = objClassDict[key]  {
                        let modelDictionary = (value as AnyObject).getSwiftPropertiesDictionary()
                        dictionary[propertyName] = modelDictionary
                    } else {
                        dictionary[propertyName] = value
                    }
                }
            }
        }
        return dictionary
    }
    
    func printDeinitInfo() {
        print("\(self)->挂了...挂了")
    }
}


/// 任何对象转换成字符串
/// - Parameter any: 任何对象
/// - Returns: 字符串
func anyToString(_ any: Any?) -> String {
    return (any != nil) ? String(format: "%@", any as! CVarArg) : ""
}


/// 是否合法
/// - Parameter object: 任何对象
/// - Returns: 是否为空
func isValid(object:Any?) -> Bool {
    return !(object == nil)
}

/// 判断是否合法字符串
/// - Parameter string: 字符串
/// - Returns: 是否合法的结果
func isValidString(string:String?) -> Bool {
    return !(string == nil || string == "<null>" || string == "(null)" || string == "")
}

/// 判断是否合法字符串
/// - Parameter string: 字符串 NSString
/// - Returns: 结果
func isValidString(string:NSString?) -> Bool{
    return !(string == nil || string == "<null>" || string == "(null)" || string == "")
}

/// 获得 Swift 视图控制器
/// - Parameter viewManagerPath: viewManager 索引路径
/// - Returns: 返回 viewManager
func getSwiftViewManager(by viewManagerPath: String?) -> CMSwiftViewManager? {
    return CMRouterManager.share.getViewManager(forPath: viewManagerPath)
}

///// 获得 OC 视图控制器
///// - Parameter viewManagerPath: viewManager 索引路径
///// - Returns: 返回 viewManager
//func getViewManager(by viewManagerPath: String?) -> CMViewManager? {
//    return CMRouterManager.share().object(forPath: viewManagerPath ?? "") as? CMViewManager
//}

extension NSObject {
    class func objectModel<T>(_ type:T.Type, dictionary: Dictionary<String, Any>?, isAllValueToString: Bool) -> T {
        
        let objectModel = Self()
        if dictionary == nil {
            return objectModel as! T
        }
        // 设置 model
        objectModel.setModelProperty(dictionary: dictionary, isAllValueToString: isAllValueToString)
        return objectModel as! T
    }
}



