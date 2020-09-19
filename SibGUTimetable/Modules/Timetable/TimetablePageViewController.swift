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

//TODO: Inherite from CustomizablePageViewController
class TimetablePageViewController : UIViewController {
    
    let startDate: Date
    
    private var pageViewDataSource: CustomizablePageViewDataSource<Date, TimetableLessonListController>!
    
    private lazy var pageViewController: CustomizablePageViewController<Date, TimetableLessonListController> = {
        let pageView = CustomizablePageViewController<Date, TimetableLessonListController>()
        return pageView
    }()
    
    var tableViewOffsetDidChange: PublishRelay<CGPoint> {
        return pageViewController.tableViewOffsetDidChange
    }
    
    var pageDidMoveDirection: PublishRelay<CustomizablePageViewMoveDirection> {
        return pageViewController.pageDidMoveDirection
    }
    
    init(startDate: Date) {
        self.startDate = startDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var timetableViewModel: TimetableViewModel? {
        didSet {
            guard let timetableViewModel = self.timetableViewModel else {
                logger.error("timetableViewModel set to nil")
                return
            }
            pageViewDataSource = CustomizablePageViewDataSource<Date, TimetableLessonListController>.init(
                startIterableValue: startDate,
                contentBuilder: { (date) -> TimetableLessonListController in
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
                }
            )
            pageViewController.dataSource = pageViewDataSource
        }
    }
    
    func select(_ date: Date) {
        pageViewController.select(iterableValue: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
