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
        static let cellSize = CGSize(width: 45, height: 45)
        static let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        static let minimumLineSpacing: CGFloat = 10
        static let headerViewHeight: CGFloat = 38
        
        private init() { }
    }
    
    var viewModel: CalendarPageViewModel!

    let collectionLayout: UICollectionViewFlowLayout = {
        let collectionLayout = UICollectionViewFlowLayout()
        
        collectionLayout.itemSize = Constansts.cellSize
        collectionLayout.sectionInset = Constansts.sectionInsets
        collectionLayout.minimumLineSpacing = Constansts.minimumLineSpacing
        
        return collectionLayout
    }()
    
    var cellSize: CGFloat {
        return collectionLayout.itemSize.height
    }
    
    var minimumLineSpacing: CGFloat {
        return collectionLayout.minimumLineSpacing
    }
    

    init() {
        super.init(collectionViewLayout: collectionLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.setCollectionViewLayout(collectionLayout, animated: false)
        
        //TD: Add header view
        
        
        view.backgroundColor = .lightGray
        collectionView.backgroundColor = .lightGray
    }

}


// MARK: CollectionView DataSource
extension CalendarPageContentViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.month.countDays
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //TODO: create view cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        //        cell.backgroundColor = .blue
        cell.contentView.backgroundColor = UIColor(red: 0.319, green: 0.561, blue: 0.955, alpha: 1.000)
        cell.contentView.layer.cornerRadius = min(cell.contentView.frame.width, cell.contentView.frame.height) / 2
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
        label.textColor = .white
        label.text = "\(indexPath.row + 1)"
        
        // Configure the cell
        
        return cell
    }
    
    
}
