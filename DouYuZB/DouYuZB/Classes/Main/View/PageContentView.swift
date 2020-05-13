//
//  PageContentView.swift
//  DouYuZB
//
//  Created by YiWen25 on 2020/5/11.
//  Copyright © 2020 Yw. All rights reserved.
//

import UIKit

private let contentCell = "contentCell"

class PageContentView: UIView {
    private var childVcs : [UIViewController]
    private weak var parentVc : UIViewController?
    
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

extension PageContentView{
    func setCurrenIndex(currenIndex : Int)  {
        let offsetX = CGFloat(currenIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
}
