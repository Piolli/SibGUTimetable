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
    let containerView = UIView()
    
    
    // MARK: Variables
    var containerViewHeightConstraint: Constraint!
    
    var estimatedStayedCalendarHeight: CGFloat!
    
    var viewIsExpanded = false
    
    #warning("DEBUG")
    var superviewOriginY: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
//        view.layer.masksToBounds = true
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 8
        
        baseInit()
    }
    
    var previousState: UIGestureRecognizer.State?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
//        print("Before animation\n", self.containerView.frame, self.view.superview?.frame)
//        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: {
//            //            self.containerView.frame = CGRect(x: self.containerView.frame.origin.x, y: 900, width: self.containerView.frame.width, height: self.containerView.frame.height)
//            self.view.superview?.transform = self.view.superview?.transform.translatedBy(x: 0, y: 400 + estimatedStayedCalendarHeight) ?? .identity
//
//            self.containerView.transform = self.containerView.transform.translatedBy(x: 0, y: 400 + estimatedStayedCalendarHeight)
//
//
//
//            print("After animation\n", self.containerView.frame, self.view.superview?.frame)
//        }) { (some) in
//            UIView.animate(withDuration: 2) {
//                self.containerView.transform = .identity
//                self.view.superview?.transform = .identity
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Attach superview to pan recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognizer(_:)))
        self.view.superview?.addGestureRecognizer(recognizer)
        
        #warning("DEBUG")
        superviewOriginY = self.view.superview!.frame.origin.y
    }
    
    func baseInit() {
        
//        addHeader()
        

        //        view.addSubview(containerView)
//
//        containerView.snp.makeConstraints { (make) in
//            make.topMargin.leftMargin.rightMargin.equalToSuperview()
//            containerViewHeightConstraint = make.bottom.equalTo(0).constraint
//        }
        
        headerView.snp.makeConstraints { (make) in
            make.height.equalTo(CalendarPageContentViewController.Constansts.headerViewHeight)
        }
        
        
        
        
        let vStack = UIStackView()
        self.view.addSubview(vStack)
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.spacing = 0.0
        
        vStack.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let pageViewController = CalendarPageViewController()
        addChild(pageViewController)
        containerView.addSubview(pageViewController.view)

        pageViewController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
        
        pageViewController.didMove(toParent: self)
        pageViewController.pageContentDelegate = self
        
        //calculate height
        calculateStayedCalendarHeight(cellSize: CalendarPageContentViewController.Constansts.cellSize.width, minimumLineSpacing: CalendarPageContentViewController.Constansts.minimumLineSpacing, headerViewHeight: CalendarPageContentViewController.Constansts.headerViewHeight)
        
        vStack.addArrangedSubview(headerView)
        vStack.addArrangedSubview(containerView)
        
        
        //Attach prev & next buttons to pageViewController
        headerView.nextMonthButton.addTarget(pageViewController, action: #selector(pageViewController.forwardPage), for: .touchUpInside)
        
        headerView.previousMonthButton.addTarget(pageViewController, action: #selector(pageViewController.backwardPage), for: .touchUpInside)
    }
    
    //Calculate not covered collection header view height
    func calculateStayedCalendarHeight(cellSize: CGFloat, minimumLineSpacing: CGFloat, headerViewHeight: CGFloat) {
        let containerHeight = self.containerView.frame.height
        estimatedStayedCalendarHeight = containerHeight - (headerViewHeight + cellSize + minimumLineSpacing)
    }

}

// MARK: Gesture Recognizer

extension ScrollableCalendarView {
    
    @objc func panRecognizer(_ pan: UIPanGestureRecognizer) {
        
        guard let superview = self.view.superview else { return }
        
        defer {
            pan.setTranslation(.zero, in: self.view)
        }
        
        let dy = pan.translation(in: self.view).y
        print("DY: \(dy)")
        
        calculateStayedCalendarHeight(cellSize: CalendarPageContentViewController.Constansts.cellWH, minimumLineSpacing: CalendarPageContentViewController.Constansts.minimumLineSpacing, headerViewHeight: CalendarPageContentViewController.Constansts.headerViewHeight)
        
//        if superview.frame.origin.y < superviewOriginY {
//            superview.transform = .identity
//        } else if superview.frame.origin.y >= (superview.frame.origin.y + estimatedStayedCalendarHeight) {
//            return
//        }
        
        switch pan.state {
        case .began:
            completeState()
        case .changed:
            superview.transform = superview.transform.translatedBy(x: 0, y: dy)
            print("superview.frame \(superview.frame)")
            completeState()
        case .ended:
            completeState()
        default:
            break
        }

        
        
//        let dy = pan.translation(in: self.view).y
//        superview.transform = superview.transform.translatedBy(x: 0, y: dy)
        
        //Only 3rd states: began, changed & ended
        
                if previousState == nil {
                    previousState = pan.state
                } else if(previousState?.rawValue == pan.state.rawValue) {
                    return
                } else {
                    previousState = pan.state
                }


                switch pan.state {
                case .possible:
                    print("possible")
                case .began:
                    print("began")
                case .changed:
                    print("changed")
                case .ended:
                    print("ended")
                case .cancelled:
                    print("cancelled")
                case .failed:
                    print("failed")
                default:
                    print("default")
                }
    }
    
    func completeState() {
        guard let superview = self.view.superview else { return }
        
//        if viewIsExpanded {
//            UIView.animate(withDuration: 0.6) {
//                superview.frame.origin.y = self.estimatedStayedCalendarHeight
//            }
//        } else {
//            UIView.animate(withDuration: 0.6) {
//                superview.frame.origin.y = 0
//            }
//        }
    }
    
}


// MARK: - CalendarPageViewContentChanged
extension ScrollableCalendarView : CalendarPageViewContentChanged {
    
    func pageViewContentChangedTo(newMonth: CalendarParser.CalendarMonth) {
        #warning("Change to viewModel")
        headerView.selectedMonthLabel.text = newMonth.name
    }
    
    func pageViewContentCollectionHeightChanged(collectionViewHeight: CGFloat) {
        print("pageViewContentCollectionHeightChanged(\(collectionViewHeight))")
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.superview?.frame.size.height = collectionViewHeight
        }, completion: nil)
        
//        if let f = self.view.superview?.frame {
//            self.view.superview!.frame = CGRect(x: f.origin.x, y: f.origin.y, width: f.width, height: collectionViewHeight);
//            self.view.superview!.layoutIfNeeded()
//        }
        
//        self.containerViewHeightConstraint.update(inset: collectionViewHeight)
        
    }
    
    
    
    
}
