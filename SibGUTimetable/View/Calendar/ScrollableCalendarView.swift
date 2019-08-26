//
//  ScrollableCalendarView.swift
//  SibGUTimetable
//
//  Created by Alexandr on 25/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import SnapKit


class ScrollableCalendarView: UIViewController {
    
    

    // MARK: Constants
    let headerView = CalendarHeaderView()
    let pageControllerContainerView = UIView()
    let pageViewController = CalendarPageViewController()
    
    
    // MARK: Variables
    var containerViewHeightConstraint: Constraint!
    
    var estimatedStayedCalendarHeight: CGFloat!
    
    #warning("DEBIG")
    //Replace to RxSwift
    var changeDayInTimetable: ((Int, Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        baseInit()
    }
    
    func baseInit() {
        let vStack = UIStackView()
        self.view.addSubview(vStack)
        vStack.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        vStack.axis = .vertical
//        vStack.setContentCompressionResistancePriority(.init(749), for: .vertical)
//        vStack.setContentHuggingPriority(.init(200), for: .vertical)
        vStack.distribution = .fill
        vStack.spacing = 0.0
        
        
        

        addChild(pageViewController)
        pageControllerContainerView.addSubview(pageViewController.view)

        pageViewController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(pageControllerContainerView)
        }
        
        pageViewController.didMove(toParent: self)
        pageViewController.pageContentDelegate = self
        
        headerView.snp.makeConstraints { (make) in
            make.height.equalTo(CalendarPageContentViewController.Constansts.headerViewHeight)
        }
        headerView.needsUpdateConstraints()
        

        vStack.addArrangedSubview(headerView)
        vStack.addArrangedSubview(pageControllerContainerView)
        
        vStack.layoutIfNeeded()


        calculateHeight()
//        //Attach prev & next buttons to pageViewController
//        headerView.nextMonthButton.addTarget(pageViewController, action: #selector(pageViewController.forwardPage), for: .touchUpInside)
//
//        headerView.previousMonthButton.addTarget(pageViewController, action: #selector(pageViewController.backwardPage), for: .touchUpInside)
    }
    
    func calculateHeight() -> CGFloat {
        calculateStayedCalendarHeight(
                cellSize: CalendarPageContentViewController.Constansts.cellSize.width,
                minimumLineSpacing: CalendarPageContentViewController.Constansts.minimumLineSpacing,
                headerViewHeight: CalendarPageContentViewController.Constansts.headerViewHeight
        )

        Logger.logMessageInfo(message: "estimatedStayedCalendarHeight: \(estimatedStayedCalendarHeight)")

        return estimatedStayedCalendarHeight
    }
    
    //Calculate not covered collection header view height
    fileprivate func calculateStayedCalendarHeight(cellSize: CGFloat, minimumLineSpacing: CGFloat, headerViewHeight: CGFloat) {
        self.estimatedStayedCalendarHeight = headerViewHeight + minimumLineSpacing + cellSize
    }

}


// MARK: - CalendarPageViewContentChanged
extension ScrollableCalendarView : CalendarPageViewContentChanged {
    
    func pageViewContentCellDidSelected(month: CalendarParser.CalendarMonth, day: Int) {
        Logger.logMessageInfo(message: "Month: \(month) day: \(day)")
        
        let newDate = month.toDate(withDay: day)
    
        changeDayInTimetable?(
            CalendarParser.shared.currentNumberOfWeek(date: newDate),
            CalendarParser.shared.currentDayOfWeek(date: newDate)
        )
        
    }
    
    func pageViewContentChangedTo(newMonth: CalendarParser.CalendarMonth) {
        #warning("Change to viewModel")
        headerView.selectedMonthLabel.text = newMonth.name
    }
    
    func pageViewContentCollectionHeightChanged(collectionViewHeight: CGFloat) {
        print("pageViewContentCollectionHeightChanged(\(collectionViewHeight))")
    }
    
}


//MARK: - CalendarContentViewDelegate
extension ScrollableCalendarView : CalendarContentViewDelegate {
    
    func cellWasSelectedWith(month: CalendarParser.CalendarMonth, day: Int) {
        print("Selected month \(month) with day \(day)")
    }
    
}
