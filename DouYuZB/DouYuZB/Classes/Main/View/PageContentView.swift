//
//  PageContentView.swift
//  DouYuZB
//
//  Created by YiWen25 on 2020/5/11.
//  Copyright © 2020 Yw. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contentView:PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

private var isForbidScrollViewDelegate : Bool = false
private let contentCell = "contentCell"

class PageContentView: UIView {
    private var childVcs : [UIViewController]
    private weak var parentVc : UIViewController?
    private var startOffsetX : CGFloat = 0
    weak var delegate : PageContentViewDelegate?
    private lazy var collectionView : UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCell)
        return collectionView
        }()
    
    init(frame: CGRect,childVcs: [UIViewController], parentsVc: UIViewController?) {
        self.childVcs = childVcs
        self.parentVc = parentsVc
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageContentView{
    private func setupUI(){
        for childVC in self.childVcs{
            self.parentVc?.addChild(childVC)
        }
        
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

extension PageContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCell, for: indexPath)
        
        for view in cell.subviews{
            view.removeFromSuperview()
        }
        
        let childVC = self.childVcs[indexPath.item]
        childVC.view.frame = cell.bounds
        cell.addSubview(childVC.view)
        return cell
    }
}

extension PageContentView : UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        isForbidScrollViewDelegate = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScrollViewDelegate { return }
        
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targeIndex : Int = 0
        
        //1.判断左滑还是右滑
        let scrollViewW = scrollView.frame.size.width
        let currentOffsetX = scrollView.contentOffset.x
        if(currentOffsetX > startOffsetX){ //左滑
            //1、计算滑动的progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            //2。 计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            //3.计算targetIndex
            targeIndex = sourceIndex + 1
            if(targeIndex >= childVcs.count){
                targeIndex = childVcs.count - 1
            }
            
            if(currentOffsetX  - startOffsetX == scrollViewW){
                progress = 1
                targeIndex = sourceIndex
            }
        }else{
            //1、计算滑动的progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            //2.计算targetIndex
            targeIndex = Int(currentOffsetX / scrollViewW)
            
            //3。 计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW) + 1
            if(sourceIndex >= childVcs.count){
                sourceIndex = childVcs.count - 1
            }
        }
        
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targeIndex)
    }
    
}

extension PageContentView{
    func setCurrenIndex(currenIndex : Int)  {
        isForbidScrollViewDelegate = true
        let offsetX = CGFloat(currenIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
}
