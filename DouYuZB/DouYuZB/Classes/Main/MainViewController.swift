//
//  MainViewController.swift
//  DouYuZB
//
//  Created by YiWen25 on 2020/5/9.
//  Copyright © 2020 Yw. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        addChlidVC(storyName: "Home")
        addChlidVC(storyName: "Live")
        addChlidVC(storyName: "Follow")
        addChlidVC(storyName: "My")
        
     
        // Do any additional setup after loading the view.
    }
    private func addChlidVC(storyName: String){
             //1.通过stoyboard 获取控制器
             let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
                  // 将vc添加到tabbar
             addChild(childVC)
             
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
