//
//  TimetablePageViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class TimetablePageViewController: UIPageViewController {

    var newSelectedDate: ((Date) -> ())?
//
//    var selectedDate: Date = Date() {
//        willSet {
//            let week = CalendarParser.shared.currentNumberOfWeek(date: newValue)
//            let day = CalendarParser.shared.currentDayOfWeek(date: newValue)
//
//            let newPosition = week * 7 + day
//            if let selectedViewController = produceViewController(at: newPosition) {
//                Logger.logMessageInfo(message: "newPosition is \(newPosition)")
//                self.currentIndex = newPosition
//                setViewControllers([selectedViewController], direction: .forward, animated: true, completion: nil)
//            }
//        }
//    }

//    func selectFollowingDate(_ isForward: Bool) {
//        let diffDay = isForward ? 1 : -1
//        self.selectedDate = Calendar.current.date(byAdding: .day, value: diffDay, to: self.selectedDate)!
//        newSelectedDate?(self.selectedDate)
//    }

    //This property sets by calendar
    fileprivate var selectedDate: Date = Date() {
        didSet {
            Logger.logMessageInfo(message: "selectedDate : \(self.selectedDate)")
        }
    }

    func moveContentPage(isForward: Bool) {
        let diffDay = isForward ? 1 : -1
        self.selectedDate = Calendar.current.date(byAdding: .day, value: diffDay, to: self.selectedDate)!
    }

    //Calendar call func for select day with lessons
    func select(date: Date) {
        let week = CalendarParser.shared.currentNumberOfWeek(date: date)
        let day = CalendarParser.shared.currentDayOfWeek(date: date)

        let newPosition = week * 7 + day
        if let selectedViewController = produceViewController(at: newPosition) {
            Logger.logMessageInfo(message: "newPosition is \(newPosition)")
//            self.currentIndex = newPosition
            self.selectedDate = date
            setViewControllers([selectedViewController], direction: .forward, animated: true, completion: nil)
        }
    }

//    private var currentIndex: Int = 0 {
//        willSet  {
//            guard abs(newValue - self.currentIndex) == 1 else {
//                Logger.logMessageInfo(message: "Select not following or previous day")
//                return
//            }
//            let isForwardDirectionPaged = (newValue - self.currentIndex) > 0
////            selectFollowingDate(isForwardDirectionPaged)
//            Logger.logMessageInfo(message: """
//                                           isForwardDirectionPaged: \(isForwardDirectionPaged)
//                                            newValue: \(newValue)
//                                             self.currentIndex: \(self.currentIndex)
//                                           """)
//        }
//    }
    
    var viewModel: TimetableScheduleViewModel?
    
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
        
        
        if let startDayPosition = viewModel?.startPageViewPosition, let selectedViewController = produceViewController(at: startDayPosition) {
            Logger.logMessageInfo(message: "startDayPosition is \(startDayPosition)")
//            self.currentIndex = startDayPosition
            self.selectedDate = selectedViewController.viewModel.date
            setViewControllers([selectedViewController], direction: .forward, animated: true, completion: nil)
        }

    }

    
    func produceViewController(at index: Int) -> TimetableLessonPageContentViewController? {
//        if index < 0 || index >= countOfPages() {
//            return nil
//        }

        #warning("DELETE")
        let index = abs(index)

        let pageContent = TimetableLessonPageContentViewController()
        
        pageContent.viewModel = viewModel?.dayViewModel(at: index)
        pageContent.index = index

        
        return pageContent
    }
    
    func countOfPages() -> Int {
        return 56 * 2 //14
    }

}

extension TimetablePageViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let selectedPageContentView = pageViewController.viewControllers?.first as? TimetableLessonPageContentViewController {
//                currentIndex = selectedPageContentView.index
                self.selectedDate = selectedPageContentView.viewModel!.date
                newSelectedDate?(self.selectedDate)
            }
        }
    }
}

extension TimetablePageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        var index = (viewController as! TimetableLessonPageContentViewController).index
        Logger.logMessageInfo(message: "index-1: \(index)")
//        moveContentPage(isForward: false)
        index -= 1

        return produceViewController(at: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        var index = (viewController as! TimetableLessonPageContentViewController).index
//        moveContentPage(isForward: true)
        Logger.logMessageInfo(message: "index+1: \(index)")
        index += 1

        return produceViewController(at: index)
    }
    
    
}
