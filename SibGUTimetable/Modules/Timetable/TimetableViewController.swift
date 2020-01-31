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

class TimetableViewController: UIViewController {
    
    var coordinator: TabTTPageViewCoordinator!

    fileprivate weak var calendarView: FSCalendar!

    lazy var timetablePageViewController: TTPageViewController = {
        let vc = TTPageViewController()
        vc.pageViewDelegate = self
        return vc
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()

    var tabBarHeight: CGFloat {
        return (self.tabBarController?.tabBar.frame.size.height ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationItem()
        initAppearance()

        addCalendar()
        addTimetablePageViewController()
    }

    private func initNavigationItem() {
        self.navigationItem.title = "БПИ16-01"

        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сегодня", style: .plain, target: self, action: #selector(todayButtonDidTapped(_:)))
    }
    
    @objc func todayButtonDidTapped(_ sender: Any) {
        self.calendarView.selectToday()
        updateTimetableFromSelectedDateCalendarView()
    }

    private func addCalendar() {
        let calendar = FSCalendar()
        view.addSubview(calendar)

        //Set monday for start week
        calendar.firstWeekday = 2

        makeCalendarConstraints(calendar: calendar)

//        calendar.dataSource = self
        calendar.delegate = self

        self.calendarView = calendar
        self.calendarView.select(Date())
        self.calendarView.addGestureRecognizer(self.scopeGesture)
        self.calendarView.setScope(.week, animated: false)
    }

    private func makeCalendarConstraints(calendar: FSCalendar) {
        calendar.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(300)
        }
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }

    private func makeTimetableConstraints(containerView: UIView) {
        containerView.snp.makeConstraints { (make) in
            make.leftMargin.rightMargin.bottomMargin.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.top.equalTo(calendarView.snp_bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(tabBarHeight)
        }
    }

    func addTimetablePageViewController() {
        let containerView = UIView()
        view.addSubview(containerView)

        makeTimetableConstraints(containerView: containerView)

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8

        updateTimetableFromSelectedDateCalendarView()

        addViewControllerToContainerView(viewController: timetablePageViewController, containerView: containerView)
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
        self.view.backgroundColor = .white
    }
    
}

extension TimetableViewController : FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        Logger.logMessageInfo(message: "Did select date: \(calendar.selectedDate)")
        updateTimetableFrom(date: calendar.selectedDate)
    }

    private func updateTimetableFrom(date: Date?) {
        guard let date = date else {
            return
        }

//        timetablePageViewController.select(at: date)
        updateTodayButtonVisibility()
    }

    private func updateTimetableFromSelectedDateCalendarView() {
        self.updateTimetableFrom(date: self.calendarView.selectedDate)
    }

    private func updateTodayButtonVisibility() {
        //if date is today then isVisible = false, that date == today is true
        navigationItem.rightBarButtonItem?.isEnabled = !calendarView.isSelectedDateEqualsToday
    }

}

extension TimetableViewController : CustomizablePageViewDelegate {
    func pageViewDidMoved(state: CustomizablePageViewMoveDirection) {
        Logger.logMessageInfo(message: "pageViewDidMoved state: \(state)")
        calendarView.moveTo(state: state)
        updateTodayButtonVisibility()
    }
}

