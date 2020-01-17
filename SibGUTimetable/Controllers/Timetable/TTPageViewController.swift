//
//  TimetablePageViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import RxSwift

class TTPageViewController: UIPageViewController {

    enum PageViewMoveState: Int {
        case forward = 1
        case backward = -1
    }

    var viewModelController: TTViewModelController!
    var newSelectedDate: ((Date) -> ())?
    var pageViewDelegate: TTPageViewControllerDelegate?
    var isUpdatingSchedule = false

    //This property sets by calendar
    fileprivate var selectedDate: Date = Date() {
        didSet {
            Logger.logMessageInfo(message: "selectedDate : \(self.selectedDate)")
        }
    }

    func initViewModelController() {
        self.viewModelController = TTViewModelController(
            repository: FakeLocalTTRepository()
        )
        
        self.viewModelController.viewModel
            .observeOn(MainScheduler.instance)
            .subscribe (onNext: { _ in
                Logger.logMessageInfo(message: "did update viewmodel")
                self.isUpdatingSchedule = false
                self.select(at: self.selectedDate)
            })
    }
    
    func updateSchedule() {
        isUpdatingSchedule = true
        viewModelController.loadData()
    }

    //Calendar call func for select day with lessons
    func select(at date: Date) {
        if isUpdatingSchedule {
            return
        }
        
        if let selectedViewController = produceViewController(at: date) {
            Logger.logMessageInfo(message: "new selected Date is \(date)")
            if let date = selectedViewController.viewModel?.date {
                self.selectedDate = date
                setViewControllers([selectedViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initViewModelController()

        updateSchedule()
        
        dataSource = self
        delegate = self
    }

    func produceViewController(at date: Date) -> TTPageContentController? {
        let pageContent = TTPageContentController()

        pageContent.viewModel = viewModelController?.viewModel.value?.getDayViewModel(at: date)
        pageContent.date = date

        Logger.logMessageInfo(message: "produce with date: \(date)")

        return pageContent
    }

}

extension TTPageViewController : UIPageViewControllerDelegate {
    //Calls after moving page content left/right
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let selectedPageContentView = pageViewController.viewControllers?.first as? TTPageContentController {
                let newSelectedDate = selectedPageContentView.viewModel!.date

                //If it was forward move
                if newSelectedDate > self.selectedDate {
                    pageViewDelegate?.pageViewDidMoved(state: .forward)
                } else if newSelectedDate < self.self.selectedDate {
                    pageViewDelegate?.pageViewDidMoved(state: .backward)
                }

                self.selectedDate = newSelectedDate
            }
        }
    }
}

extension TTPageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewController = viewController as? TTPageContentController else {
            Logger.logMessageInfo(message: "viewControllerBefore is nil")
            return nil
        }
        
        guard let date = viewController.date else {
            Logger.logMessageInfo(message: "viewControllerBefore.date is nil")
            return nil
        }
        
        let previousDate = date.previousDateByDay()

        return produceViewController(at: previousDate)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewController = viewController as? TTPageContentController else {
            Logger.logMessageInfo(message: "viewControllerBefore is nil")
            return nil
        }
        
        guard let date = viewController.date else {
            Logger.logMessageInfo(message: "viewControllerBefore.date is nil")
            return nil
        }
        
        let followingDate = date.followingDateByDay()
        
        return produceViewController(at: followingDate)
    }


}

