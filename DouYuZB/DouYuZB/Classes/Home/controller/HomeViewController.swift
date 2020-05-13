//
//  HomeViewController.swift
//  DouYuZB
//
//  Created by YiWen25 on 2020/5/9.
//  Copyright © 2020 Yw. All rights reserved.
//

import UIKit

private let kTitleH : CGFloat = 40

class HomeViewController: UIViewController {
    
      private lazy var pageTitleView : PageTitleView = {[weak self] in
          let titleFrame = CGRect(x: 0, y: kStatusH + KNavigationH, width: kScreenW, height: kTitleH)
          let titles = ["推荐","游戏","娱乐","趣玩"]
          let titleView = PageTitleView(frame:titleFrame, titles: titles)
          titleView.delegate = self
          return titleView
      }()
    
    private lazy var pagaContentView : PageContentView = {[weak self] in
       let contentViewH = kScreenH - kStatusH - KNavigationH - kTitleH
       let pageViewFrame = CGRect(x: 0, y:  kStatusH + KNavigationH + kTitleH, width: kScreenW, height:contentViewH)
       var childVcs = [UIViewController]()
        for _ in 0...3{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)) , g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        let pageView = PageContentView(frame: pageViewFrame, childVcs: childVcs, parentsVc: self)
        return pageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1. 设置UI
        setUI()
        // Do any additional setup after loading the view.
    }
}
//MARK - 设置UI界面
extension HomeViewController{
      //1. 设置UI
    private func setUI(){
      automaticallyAdjustsScrollViewInsets = false
        //设置导航栏
        setupNavigationBar()
        
        setupPageTitleView()
        
        view.addSubview(pagaContentView)
    }
    private func setupPageTitleView(){
        view.addSubview(pageTitleView)
    }
        
    private func setupNavigationBar(){
        //1.设置左边的Item
        let btn = UIButton()
        btn.setImage(UIImage(named: "logo"), for: UIControl.State.normal)
        btn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        
        //1.设置右边的Items
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
}

extension HomeViewController : pageTitleViewDelegate{
    func pageTitleView(titleView: PageTitleView, selectIndex index: Int) {
        self.pagaContentView.setCurrenIndex(currenIndex: index)
    }
    
    
}
