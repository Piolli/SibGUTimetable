//
//  TimetablePageView.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 03.02.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxRelay
import UIKit

class TimetablePageViewController : UIViewController {
    
    private lazy var pageViewController: CustomizablePageViewController<Date, TimetableLessonListController> = {
        let pageView = CustomizablePageViewController<Date, TimetableLessonListController>()
        return pageView
    }()
    
    var pageDidMoveDirection: PublishRelay<CustomizablePageViewMoveDirection> {
        return pageViewController.pageDidMoveDirection
    }
    
    public var timetableViewModel: TTViewModel? {
        didSet {
            guard let timetableViewModel = self.timetableViewModel else {
                pageViewController.dataSource = nil
                print("TimetablePageViewController: timetableViewModel set to nil")
                return
            }
            pageViewController.dataSource = CustomizablePageViewDataSource<Date, TimetableLessonListController>.init(startIterableValue: Date(), contentBuilder: { [weak self] (date) -> TimetableLessonListController in
                guard let self = self else {
                    ///Todo: LOG error
                    fatalError("TimetablePageViewController self is nil")
                }
                        let vc = TimetableLessonListController()
                        vc.date = date
                        vc.viewModel = timetableViewModel.getDayViewModel(at: date)
                        return vc
                    }, nextIterableValue: { (date) -> Date in
                        return date.followingDateByDay()
                    }, previousIterableValue: { (date) -> Date in
                        return date.previousDateByDay()
                    }, extractIterableValueFromController: { (viewController) -> Date in
                        return viewController.date
                    })
            
        }
    }
    
    func select(_ date: Date) {
        pageViewController.select(iterableValue: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        add(viewController: pageViewController, to: containerView)
        
    }
    
}
