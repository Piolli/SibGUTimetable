//
//  ViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 14/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import CoreData
import SnapKit
import FSCalendar

class ViewController: UIViewController {
    
    var tabBarHeight: CGFloat {
        return (self.tabBarController?.tabBar.frame.size.height ?? 0)
    }

    fileprivate weak var calendar: FSCalendar!
    let scrollableCalendar = ScrollableCalendarView()
    let timetablePageViewController = TimetablePageViewController()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "Расписание группы БПИ16-01"
        self.navigationItem.largeTitleDisplayMode = .always
        
        initAppearance()
        addCalendar()

        addTimetablePageViewController()
        //Test core data
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
    }

    private func addCalendar() {
        let calendar = FSCalendar()
        //Set monday for start week
        calendar.firstWeekday = 2

        view.addSubview(calendar)
        calendar.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(300)
        }
        calendar.dataSource = self
        calendar.delegate = self

        self.calendar = calendar
        self.calendar.select(Date())
        self.calendar.addGestureRecognizer(self.scopeGesture)
        self.calendar.setScope(.week, animated: false)
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
            // Do other updates
        }
        self.view.layoutIfNeeded()
    }

    func addTimetablePageViewController() {
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.leftMargin.rightMargin.bottomMargin.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.top.equalTo(calendar.snp_bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(tabBarHeight)
        }
        
        containerView.backgroundColor = .red
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8


        timetablePageViewController.viewModel = TimetableScheduleViewModel.TESTScheduleViewModel()
        addViewControllerToContainerView(viewController: timetablePageViewController, containerView: containerView)

        //Attach day in timetable and day in calendar
        timetablePageViewController.newSelectedDate = { nextDate in
            self.calendar.select(nextDate, scrollToDate: true)
        }
    }
    
    func addViewControllerToContainerView(viewController: UIViewController, containerView: UIView) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        
        viewController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
        
        viewController.didMove(toParent: self)
    }
    
    fileprivate func initAppearance() {
        //Init base appearance
        self.view.backgroundColor = .white
    }
    
}

extension ViewController : FSCalendarDataSource {
    
}

extension ViewController : FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        Logger.logMessageInfo(message: "Did select date: \(date)")
        timetablePageViewController.select(date: date)
    }
}

