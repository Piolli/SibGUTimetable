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
    var timetablePageViewController: TimetablePageViewController!
    
    var calendarHeightConstraint: NSLayoutConstraint!
    let userPreferences: UserPreferences = Assembler.shared.resolve()
    
    let disposeBag = DisposeBag()
    var dataManager: TimetableDataManager! {
        didSet {
            setupDataManager()
            logger.debug("TimetableViewController didSet dataManager")
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
        
        setupLeftBarButton()
        
        setupTimetablePageViewController()
//        //setup autoupdate
//        userPreferences.timetableDetailsDidChanged.subscribe(onNext: { (timetableDetails) in
//            guard let timetableDetails = timetableDetails else { return }
//            self.dataManager.loadTimetable(timetableDetails: timetableDetails)
//        }).disposed(by: disposeBag)
        
        initAppearance()
        
        checkExistingTimetableDetails()
    }
    
    deinit {
        logger.debug("deinit TimetableViewController")
    }
    
    func checkExistingTimetableDetails() {
        if let timetableDetails = userPreferences.getTimetableDetails() {
            logger.debug("timetableDetails: \(timetableDetails)")
            dataManager.loadTimetable(timetableDetails: timetableDetails)
        } else {
            //TODO: add localization
            showMessage(text: "Choose group from left side menu", title: "Error")
        }
    }
    
    func setupLeftBarButton() {
        let iconImage = UIImage(named: "side_menu_icon")?.withRenderingMode(.alwaysTemplate)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(revealMenu))
    }
    
    @objc func revealMenu() {
        if let sideMenuController = sideMenuController {
            sideMenuController.revealMenu()
        }
    }

    private func initNavigationItem() {
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedStrings.Today, style: .plain, target: self, action: #selector(todayButtonDidTapped(_:)))
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
        self.calendarView.selectToday()
        timetablePageViewController = TimetablePageViewController(startDate: self.calendarView.today ?? Date())
//        #warning("Delete this")
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let someDateTime = formatter.date(from: "2020/06/08 22:31")
//        timetablePageViewController = TimetablePageViewController(startDate: someDateTime)
//        self.calendarView.select(someDateTime, scrollToDate: true)
//        #warning("Delete this")
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
        let marginsGuide = view.safeAreaLayoutGuide
        let marginBetweenTimetableAndCalendar = CGFloat(0)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor, constant: 8),
            marginsGuide.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
            containerView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: marginBetweenTimetableAndCalendar),
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func setupDataManager() {
        dataManager.timetableOutput
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (timetable) in
                guard let self = self else {
                    logger.error("self is nil")
                    return
                }
                logger.info("Got timetable: \(timetable.group_name):\(timetable.updateTimestampTime)")
                //Because server-side saves timetable to db then we can compare if timetable is new
                if self.timetablePageViewController.timetableViewModel?.schedule.updateTimestampTime != timetable.updateTimestampTime {
                    self.timetablePageViewController.timetableViewModel = TimetableViewModel(schedule: timetable)
                    self.navigationItem.title = timetable.group_name
                }
            }, onError: { [weak self] (error) in
                self?.showMessage(text: error.localizedDescription, title: "Error")
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        checkExistingTimetableDetails()
    }
    
    func setupTimetablePageViewController() {
        //TODO: check out code below
        timetablePageViewController.pageDidMoveDirection
            .subscribe(onNext: { [weak self] (pageDidMoveTo) in
            DispatchQueue.main.async {
                logger.trace("pageViewDidMoved state: \(pageDidMoveTo)")
                self?.calendarView.moveTo(state: pageDidMoveTo)
                self?.updateTodayButtonVisibility()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

//        timetablePageViewController.tableViewOffsetDidChange.subscribe(onNext: { (point) in
//            if point.y > 0 {
//                self.calendarView.setScope(.week, animated: true)
//            }
//        }).disposed(by: disposeBag)
    }

    func addTimetablePageViewController() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        makeTimetableConstraints(containerView: containerView)
        updateTimetableFromSelectedDateCalendarView()
        add(viewController: timetablePageViewController, to: containerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    fileprivate func initAppearance() {
        calendarView.appearance.titleDefaultColor = ThemeProvider.shared.calendarViewSelectedMonthDaysTextColor
        calendarView.appearance.headerTitleColor = ThemeProvider.shared.calendarViewMonthTitleTextColor
        calendarView.appearance.weekdayTextColor = ThemeProvider.shared.calendarViewWeekdayTextColor
        calendarView.appearance.headerDateFormat = "LLLL YYYY"
        calendarView.appearance.titlePlaceholderColor = ThemeProvider.shared.calendarPrevAndNextMonthDaysTextColor
        
        self.view.backgroundColor = ThemeProvider.shared.calendarViewBackgroungColor
        calendarView.calendarHeaderView.backgroundColor = ThemeProvider.shared.calendarViewBackgroungColor
        calendarView.calendarWeekdayView.backgroundColor = ThemeProvider.shared.calendarViewBackgroungColor
        calendarView.daysContainer.backgroundColor = ThemeProvider.shared.calendarViewBackgroungColor
    }
    
}

extension TimetableViewController : FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        logger.trace("Did select date: \(calendar.selectedDate)")
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
        logger.trace("pageViewDidMoved state: \(state)")
        calendarView.moveTo(state: state)
        updateTodayButtonVisibility()
    }
}

