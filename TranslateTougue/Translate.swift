//
//  Translate.swift
//  TranslateTougue
//
//  Created by Serx on 16/3/27.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import AFNetworking
import Foundation


class Translate {
    
    func startTranslate(rawString: String){
        
        var yiString:String = ""
        
        let manager = AFHTTPSessionManager()
        
        let url: String = "http://api.fanyi.baidu.com/api/trans/vip/translate"
        
        let q = rawString
        
        let from = "en"
        let to = "zh"
        let appid = "20160324000016535"
        let salt = String(Int.random())
        let miyao = "DD47u9TnDPL8ZCDG6PXC"
        
        let string1: String = appid + q + salt + miyao
        
        let sign = string1.md5()
        let parameters: Dictionary = ["q":q, "from": from, "to": to, "appid" :appid, "salt": salt, "sign": sign]
        
        manager.POST(url, parameters: parameters, success: { (AFHTTPRequestOperation operation,id responseObject) -> Void in
            
            
            if responseObject != nil{
                
//                print(responseObject)
                
                let aa = responseObject!["trans_result"]
                
                let aString = aa!![0]
                
                yiString = aString["dst"] as! String
                
                fanyiString = yiString
//                print(yiString)
//                let yuanString: String = aString["src"] as! String
                
            }
            
            }) { (AFHTTPRequestOperation operation,NSError error) -> Void in
                
                print(error)
        }
    }
}

extension String {
    
    func md5() -> String! {
        
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.destroy()
        
        return String(format: hash as String)
    }
}

extension Int {
    static func random() -> Int {
        return Int(arc4random())
    }
    
    static func random(range: Range<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
    }
}