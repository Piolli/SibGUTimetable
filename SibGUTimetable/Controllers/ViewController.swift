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

    fileprivate weak var calendarView: FSCalendar!

    lazy var timetablePageViewController: TimetablePageViewController = {
        let vc = TimetablePageViewController()
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
        self.navigationItem.title = "Расписание группы БПИ16-01"
        self.navigationItem.largeTitleDisplayMode = .always

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector())
    }

    private func addCalendar() {
        let calendar = FSCalendar()
        view.addSubview(calendar)

        //Set monday for start week
        calendar.firstWeekday = 2

        makeCalendarConstraints(calendar: calendar)

        calendar.dataSource = self
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
            // Do other updates
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

        containerView.backgroundColor = .red
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8

        timetablePageViewController.viewModel = TimetableScheduleViewModel.TESTScheduleViewModel()

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

extension ViewController : FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        Logger.logMessageInfo(message: "Did select date: \(date)")
        timetablePageViewController.select(at: calendar.selectedDate!)
    }
}

extension ViewController :  TimetablePageViewControllerDelegate {
    func pageViewDidMoved(state: TimetablePageViewController.PageViewMoveState) {
        Logger.logMessageInfo(message: "pageViewDidMoved state: \(state)")
        self.calendarView.moveTo(state: state)
    }
}

extension ViewController : FSCalendarDataSource {

}

