//
//  PageTitleView.swift
//  DouYuZB
//
//  Created by YiWen25 on 2020/5/9.
//  Copyright © 2020 Yw. All rights reserved.
//

import UIKit

// MARK - 定义协议
protocol pageTitleViewDelegate : class {
    func pageTitleView(titleView:PageTitleView ,selectIndex index:Int)
}

// MARK - 定义变量
private let kScrollViewLineH : CGFloat = 2
private let normalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let selectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

// MARK - 定义PageTitleView类
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
            label.textColor = UIColor(r: normalColor.0, g: normalColor.1, b: normalColor.2)
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
        let oldLabel = self.titlesLabel[currenIndex]
        oldLabel.textColor = UIColor(r: normalColor.0, g: normalColor.1, b: normalColor.2)
        currenIndex = currenLabel.tag
        currenLabel.textColor = UIColor(r: selectColor.0, g: selectColor.1, b: selectColor.2)

        let offsetX :CGFloat =  currenLabel.frame.origin.x
        UIView.animate(withDuration: 0.15) {
            self.scrollViewLine.frame.origin.x = offsetX
        }
        delegate?.pageTitleView(titleView: self, selectIndex: currenIndex)
    }
}

extension PageTitleView{
    func setTitleWthProgress(progress : CGFloat , sourceIndex : Int, tagrgetIndex : Int){
        //1.取出获取的titleLabel
        let sourceLabel = titlesLabel[sourceIndex]
        let targetLabel = titlesLabel[tagrgetIndex]
        
        //2.处理滑动模块的逻辑
        let moveTotalX = targetLabel.frame.origin.x  - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollViewLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3 颜色的渐变(复杂)
        // 颜色变化的范围
        let colorDelta = (selectColor.0 - normalColor.0, selectColor.1 - normalColor.1, selectColor.2 - normalColor.2)
        
        //变化sourceLabel
        sourceLabel.textColor = UIColor(r: selectColor.0 - colorDelta.0 * progress, g: selectColor.1 - colorDelta.1 * progress, b: selectColor.2 - colorDelta.2 * progress)
        
        //变化targetLabel
        targetLabel.textColor = UIColor(r: normalColor.0 + colorDelta.0 * progress, g: normalColor.1 + colorDelta.1 * progress, b: normalColor.2 + colorDelta.2 * progress)
        
        // 记录最新的index
        currenIndex = tagrgetIndex
    }
}
