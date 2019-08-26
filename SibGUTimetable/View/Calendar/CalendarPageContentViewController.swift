//
//  CalendarPageContentViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 25/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import SnapKit

class CalendarPageContentViewController: UICollectionViewController {
    
    struct Constansts {
        static var cellWH: CGFloat = 10
        static var cellSize: CGSize {
            return CGSize(width: Constansts.cellWH, height: Constansts.cellWH)
        }
        
        static let cellsInRow = 7
        
        static let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        static let minimumLineSpacing: CGFloat = 8
        static let minimumInteritemSpacing: CGFloat = 8
        static let headerViewHeight: CGFloat = 58
        
        private init() { }
    }
    
    var viewModel: CalendarPageViewModel!
    
    weak var delegate: CalendarContentViewDelegate?

    let collectionLayout: UICollectionViewFlowLayout = {
        let collectionLayout = UICollectionViewFlowLayout()
        
        collectionLayout.itemSize = Constansts.cellSize
        collectionLayout.sectionInset = Constansts.sectionInsets
        collectionLayout.minimumInteritemSpacing = Constansts.minimumInteritemSpacing
        collectionLayout.minimumLineSpacing = Constansts.minimumLineSpacing
        
        return collectionLayout
    }()
    
    var cellSize: CGFloat {
        return collectionLayout.itemSize.height
    }
    
    var minimumLineSpacing: CGFloat {
        return collectionLayout.minimumLineSpacing
    }
    
    var selectedIndexPath: IndexPath?
    

    init() {
        super.init(collectionViewLayout: collectionLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        collectionLayout.itemSize = Constansts.cellSize®
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.isScrollEnabled = false
        
        collectionView.register(CalendarDayViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.setCollectionViewLayout(collectionLayout, animated: false)
        
        view.backgroundColor = .lightGray
        collectionView.backgroundColor = .lightGray
        
    }
    
    override func viewWillLayoutSubviews() {
        //Calculate itemSize in collectionView
        guard let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(Constansts.cellsInRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(Constansts.cellsInRow)).rounded(.down)
        flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth)
        //Update auto resizing cell size
        Constansts.cellWH = itemWidth
    }

}


// MARK: CollectionView DataSource
extension CalendarPageContentViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.countOfLeadingAndMonthDays
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarDayViewCell
        
        if viewModel.indexPathIsMonthDay(indexPath: indexPath) {
            cell.dayNumberLabel.text = viewModel.dayNumber(for: indexPath)
        } else {
            cell.isEmpty = true
        }
        
        return cell
    }
}


//MARK: - CollectionView Deleagate
extension CalendarPageContentViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellWasSelectedWith(month: viewModel.month, day: indexPath.row + 1)
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarDayViewCell {
            if !cell.isEmpty {
                cell.isSelected = false
            }
        }
    }
    
}
