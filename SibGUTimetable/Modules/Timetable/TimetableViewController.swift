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
    
    var calendarHeightConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
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
        
        addCalendar()
        addTimetablePageViewController()
        
        setupRightBarButton()
        
        setupTimetablePageViewController()
        //setup autoupdate
        UserPreferences.sharedInstance.timetableDetailsDidChanged.subscribe(onNext: { (timetableDetails) in
            guard let timetableDetails = timetableDetails else { return }
            self.dataManager.loadTimetable(timetableDetails: timetableDetails)
        }).disposed(by: disposeBag)
        
        initAppearance()
        
        checkExistingTimetableDetails()
    }
    
    func checkExistingTimetableDetails() {
        if let timetableDetails = UserPreferences.sharedInstance.getTimetableDetails() {
            dataManager.loadTimetable(timetableDetails: timetableDetails)
        } else {
            showMessage(text: "Choose group from left side menu", title: "Error")
        }
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
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
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
        let safeAreaGuide = view.safeAreaLayoutGuide
        calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: 300)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            calendarHeightConstraint
        ])
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }

    private func makeTimetableConstraints(containerView: UIView) {
        let marginsGuide = view!
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
            .subscribe(onNext: { [weak self] (timetable) in
                guard let self = self else { return }
                //Because server-side saves timetable to db then we can compare if timetable is new
                if self.timetablePageViewController.timetableViewModel?.schedule.updateTimestampTime != timetable.updateTimestampTime {
                    self.timetablePageViewController.timetableViewModel = TTViewModel(schedule: timetable)
                    self.navigationItem.title = timetable.group_name
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        checkExistingTimetableDetails()
    }
    
    func setupTimetablePageViewController() {
        timetablePageViewController.pageDidMoveDirection
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (pageDidMoveTo) in
            DispatchQueue.main.async {
                Logger.logMessageInfo(message: "pageViewDidMoved state: \(pageDidMoveTo)")
                self?.calendarView.moveTo(state: pageDidMoveTo)
                self?.updateTodayButtonVisibility()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        timetablePageViewController.tableViewOffsetDidChange.subscribe(onNext: { (point) in
            if point.y > 0 {
                self.calendarView.setScope(.week, animated: true)
            }
        }).disposed(by: disposeBag)
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    fileprivate func initAppearance() {
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemBackground
            calendarView.appearance.titleDefaultColor = .systemGray4
        } else {
            self.view.backgroundColor = .white
            calendarView.appearance.titleDefaultColor = .lightGray
        }
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

