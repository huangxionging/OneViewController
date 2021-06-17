//
//  String+Extension.swift
//  32TeethProtector
//
//  Created by 黄雄 on 2020/9/19.
//  Copyright © 2020 huangxiong. All rights reserved.
//

import Foundation
import CommonCrypto.CommonDigest
import CoreImage
import UIKit

extension String {
    
    func getMD5String() -> String {
        // 获得 cString
        let cStr = cString(using: String.Encoding.utf8)
        // 创建 MD5 数组
        var result = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        // 转换
        CC_MD5(cStr, CC_LONG(cStr!.count - 1), &result)
        // 获得结果
        return result.reduce("") {
            $0 + String(format: "%02X", $1)
        }
    }
    
    func encodeToQRCodeImage(coverIcon: UIImage?, size: CGSize, cornerRadius: CGFloat = 0) -> UIImage? {
        
        var qrCodeImage: UIImage? = nil
        
        let data = self.data(using: String.Encoding.utf8)
        
        
        /// 二维码滤波器
        let qrFilter = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data!, "inputCorrectionLevel": "M"])
        
        /// 颜色过滤
        let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage": qrFilter!.outputImage!, "inputColor0": CIColor(color: UIColor.black), "inputColor1": CIColor(color: UIColor.white)])
        
        /// 生成二维码 Image CIImage CoreImage
        let qrImage = colorFilter?.outputImage
        
        
        /// 转换成 CGImage CoreGraphics
        let cgImage = CIContext().createCGImage(qrImage!, from: qrImage!.extent)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = CGInterpolationQuality.none
        context.scaleBy(x: 1.0, y: 1.0)
        context.draw(cgImage!, in: context.boundingBoxOfClipPath)
        if coverIcon != nil {
            coverIcon?.draw(at: CGPoint(x: (size.width - coverIcon!.size.width) / 2, y: (size.height - coverIcon!.size.height) / 2))
        }
        qrCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return qrCodeImage;
    }
    
    func toDictionay() -> [String: Any]? {
        guard !self.isEmpty else {
            return nil
        }
        
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        if let dict = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) {
            return dict
        }
        return nil
    }
}

