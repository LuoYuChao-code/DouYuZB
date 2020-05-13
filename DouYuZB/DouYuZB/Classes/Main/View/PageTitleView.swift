//
//  PageTitleView.swift
//  DouYuZB
//
//  Created by YiWen25 on 2020/5/9.
//  Copyright © 2020 Yw. All rights reserved.
//

import UIKit

protocol pageTitleViewDelegate : class {
    func pageTitleView(titleView:PageTitleView ,selectIndex index:Int)
}

private let kScrollViewLineH : CGFloat = 2

class PageTitleView: UIView {
    private var titles : [String]
    private var currenIndex : Int = 0
    weak var delegate : pageTitleViewDelegate?
    
    private lazy var scrollView : UIScrollView = {
        let scrollView  = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var titlesLabel : [UILabel] = [UILabel]()
    
    private lazy var scrollViewLine : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    init(frame: CGRect , titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        // MARK - 设置UI界面
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageTitleView{
    
    private func setupUI(){
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //1.添加标题文字
        setupTitleLabels()
        
        //2.添加底部line
        setupBottomLine()
        
        //3.添加滚动底部直线
        setupScrollViewLine()
    }
    
    private func setupTitleLabels(){
        
        let labelW : CGFloat =  frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollViewLineH
        let labelY : CGFloat = 0
        
        for(index, title) in titles.enumerated(){
            let label = UILabel()
            label.textColor = UIColor.darkGray
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = NSTextAlignment.center
            label.tag = index
            label.text = title
            
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            scrollView.addSubview(label)
            titlesLabel.append(label)
            
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
            label .addGestureRecognizer(tap)
        }
    }
    
    private func setupBottomLine(){
        let scrollViewLine = UIView()
        scrollViewLine.backgroundColor = UIColor.darkGray
        let scrollViewLineH : CGFloat = 0.5
        scrollViewLine.frame = CGRect(x: 0, y: frame.height - scrollViewLineH, width: frame.width, height: scrollViewLineH)
        addSubview(scrollViewLine)
    }
    
    private func setupScrollViewLine(){
        scrollView.addSubview(scrollViewLine)
        guard let fistLabel = titlesLabel.first else{return}
        scrollViewLine.frame = CGRect(x: fistLabel.frame.origin.x, y: frame.height - kScrollViewLineH, width: fistLabel.frame.width, height: kScrollViewLineH)
        fistLabel.textColor = UIColor.orange
    }
    
}

extension PageTitleView{
    
    @objc func tapLabel(tap:UITapGestureRecognizer){
        guard  let currenLabel = tap.view as? UILabel else {return}
        currenLabel.textColor = UIColor.orange
        let oldLabel = self.titlesLabel[currenIndex]
        oldLabel.textColor = UIColor.darkGray
        currenIndex = currenLabel.tag
        
        let offsetX :CGFloat =  currenLabel.frame.origin.x
        UIView.animate(withDuration: 0.15) {
            self.scrollViewLine.frame.origin.x = offsetX
        }
        
        delegate?.pageTitleView(titleView: self, selectIndex: currenIndex)
    }
}

