//
//  UIBarButtonItem-Extension.swift
//  DouYuZB
//
//  Created by YiWen25 on 2020/5/9.
//  Copyright © 2020 Yw. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    /*
    class func createBarButtonItem(imageName: String,highImageName: String,size: CGSize) -> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highImageName), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        return UIBarButtonItem(customView: btn)
    }
 */
    
    convenience init(imageName: String, highImageName: String = "", size: CGSize){
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        if (!highImageName.isEmpty){
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
              btn.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        
        self.init(customView: btn)
    }
    
}
