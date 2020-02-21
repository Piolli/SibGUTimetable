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
import RxSwift


class TimetableViewController: UIViewController {
    
    var coordinator: TimetableCoordinator!
    weak var calendarView: FSCalendar!
    lazy var timetablePageViewController: TimetablePageViewController = .init()
    var dataManager: TimetableDataManager! {
        didSet {
            setupDataManager()
            print("TimetableViewController didSet dataManager")
        }
    }
    
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
        
        setupRightBarButton()
        
        setupTimetablePageViewController()
        
        //setup autoupdate
        UserPreferences.sharedInstance.timetableDetailsDidChanged.subscribe(onNext: { (timetableDetails) in
            guard let timetableDetails = timetableDetails else { return }
            self.dataManager.loadTimetable(timetableDetails: timetableDetails)
        })
        
    }
    
    func setupRightBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(revealMenu))
    }
    
    
    @objc func revealMenu() {
        if let sideMenuController = sideMenuController {
            sideMenuController.revealMenu()
        }
    }

    private func initNavigationItem() {
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
        let marginsGuide = view.layoutMarginsGuide
        let marginBetweenTimetableAndCalendar = CGFloat(16)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: marginBetweenTimetableAndCalendar),
            containerView.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor)
        ])
    }
    
    func setupDataManager() {
        dataManager.timetable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (timetable) in
            //Because server-side saves timetable to db then we can compare if timetable is new
//                DispatchQueue.main.async {
                    if self.timetablePageViewController.timetableViewModel?.schedule.updateTimestampTime != timetable.updateTimestampTime {
                        self.timetablePageViewController.timetableViewModel = TTViewModel(schedule: timetable)
                        self.navigationItem.title = timetable.group_name
                    }
//                }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        if let timetableDetails = UserPreferences.sharedInstance.getTimetableDetails() {
            dataManager.loadTimetable(timetableDetails: timetableDetails)
        } else {
            showMessage(text: "Choose group from left side menu", title: "Error")
        }
    }
    
    func setupTimetablePageViewController() {
        //TODO: bind datamanger to timetableViewModel
        addTimetablePageViewController()
//        dataManager.loadTimetable(groupId: 740, groupName: "БПИ16-01")
//        dataManager.timetable.subscribe(onNext: { (timetable) in
////            timetable.valida
//            DispatchQueue.main.async {
//                //Because server-side saves timetable to db then we can compare if timetable is new
//                if self.timetablePageViewController.timetableViewModel?.schedule.updateTimestampTime != timetable.updateTimestampTime {
//                    self.timetablePageViewController.timetableViewModel = TTViewModel(schedule: timetable)
//                }
//            }
//        }, onError: nil, onCompleted: nil, onDisposed: nil)
//        dataManager.updateTimetable(groupId: 740, groupName: "БПИ16-01")
//
//        timetablePageViewController.timetableViewModel = TTViewModel(schedule: FileLoader.shared.getLocalSchedule()!)!
        timetablePageViewController.pageDidMoveDirection
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (pageDidMoveTo) in
            DispatchQueue.main.async {
                Logger.logMessageInfo(message: "pageViewDidMoved state: \(pageDidMoveTo)")
                self?.calendarView.moveTo(state: pageDidMoveTo)
                self?.updateTodayButtonVisibility()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)

        
    }

    func addTimetablePageViewController() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        makeTimetableConstraints(containerView: containerView)

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8

        updateTimetableFromSelectedDateCalendarView()

        add(viewController: timetablePageViewController, to: containerView)
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

        timetablePageViewController.select(date)
        
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

