//
//  TimetablePageViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

/* import UIKit

class TimetablePageViewController: UIPageViewController {

    enum PageViewMoveState: Int {
        case forward = 1
        case backward = -1
    }

    var viewModel: TimetableScheduleViewModel?

    var newSelectedDate: ((Date) -> ())?

    var pageViewDelegate: TimetablePageViewControllerDelegate?

    //This property sets by calendar
    fileprivate var selectedDate: Date = Date() {
        didSet {
            Logger.logMessageInfo(message: "selectedDate : \(self.selectedDate)")
        }
    }

    //Calendar call func for select day with lessons
    func select(at date: Date) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

//        select(at: Date())
    }
    
    func produceViewController(at date: Date) -> TimetableLessonPageContentViewController? {
        let pageContent = TimetableLessonPageContentViewController()
        
        pageContent.viewModel = viewModel?.getDayViewModel(at: date)
        pageContent.date = date

        Logger.logMessageInfo(message: "produce with date: \(date)")
        
        return pageContent
    }

}

extension TimetablePageViewController : UIPageViewControllerDelegate {

    //Calls after moving page content left/right
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let selectedPageContentView = pageViewController.viewControllers?.first as? TimetableLessonPageContentViewController {
                let newSelectedDate = selectedPageContentView.viewModel!.date

                //If forward move
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

extension TimetablePageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        var date = (viewController as! TimetableLessonPageContentViewController).date
        date = date!.previousDateByDay()

        return produceViewController(at: date!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        var date = (viewController as! TimetableLessonPageContentViewController).date
        date = date!.followingDateByDay()

        return produceViewController(at: date!)
    }
    
    
} */



//
//  TimetablePageViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import RxSwift

class TimetablePageViewController: UIPageViewController {

    enum PageViewMoveState: Int {
        case forward = 1
        case backward = -1
    }

    fileprivate var viewModelController: TimetableScheduleViewModelController!

    var newSelectedDate: ((Date) -> ())?

    var pageViewDelegate: TimetablePageViewControllerDelegate?
    
    var isUpdatingSchedule = false

    //This property sets by calendar
    fileprivate var selectedDate: Date = Date() {
        didSet {
            Logger.logMessageInfo(message: "selectedDate : \(self.selectedDate)")
        }
    }

    func initViewModelController() {
        self.viewModelController = TimetableScheduleViewModelController(
            repository: TimetableRepository()
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
        self.viewModelController.fetchData()
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

    func produceViewController(at date: Date) -> TimetableLessonPageContentViewController? {
        let pageContent = TimetableLessonPageContentViewController()

        pageContent.viewModel = viewModelController?.viewModel.value?.getDayViewModel(at: date)
        pageContent.date = date

        Logger.logMessageInfo(message: "produce with date: \(date)")

        return pageContent
    }

}

extension TimetablePageViewController : UIPageViewControllerDelegate {

    //Calls after moving page content left/right
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let selectedPageContentView = pageViewController.viewControllers?.first as? TimetableLessonPageContentViewController {
                let newSelectedDate = selectedPageContentView.viewModel!.date

                //If forward move
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

extension TimetablePageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewController = viewController as? TimetableLessonPageContentViewController else {
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

        guard let viewController = viewController as? TimetableLessonPageContentViewController else {
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


