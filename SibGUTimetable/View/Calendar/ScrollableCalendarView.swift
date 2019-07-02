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
    
    var estimatedStayedCalendarHeight: CGFloat!
    
    //Containts page view controller
    let containerView = UIView()
    
    
    // MARK: Variables
    var containerViewHeightConstraint: Constraint!
    
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
        
        //Attach superview to pan recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognizer(_:)))
        self.view.superview?.addGestureRecognizer(recognizer)
        
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
    
    func baseInit() {
        
//        addHeader()
        
//        view.addSubview(containerView)
//
//        containerView.snp.makeConstraints { (make) in
//            make.topMargin.leftMargin.rightMargin.equalToSuperview()
//            containerViewHeightConstraint = make.bottom.equalTo(0).constraint
//        }
        
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
        
    }
    
    let headerView = CalendarHeaderView()
    func addHeader() {
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(CalendarPageContentViewController.Constansts.headerViewHeight)
        }
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
        
        defer {
            pan.setTranslation(.zero, in: self.view)
        }
        
        let dy = pan.translation(in: self.view).y
    
        self.view.superview?.transform = self.view.superview?.transform.translatedBy(x: 0, y: dy) ?? .identity
        
        //Only 2th states: began, changed & ended
        
//                if previousState == nil {
//                    previousState = pan.state
//                } else if(previousState?.rawValue == pan.state.rawValue) {
//                    return
//                } else {
//                    previousState = pan.state
//                }
//
//
//                switch pan.state {
//                case .possible:
//                    print("possible")
//                case .began:
//                    print("began")
//                case .changed:
//                    print("changed")
//                case .ended:
//                    print("ended")
//                case .cancelled:
//                    print("cancelled")
//                case .failed:
//                    print("failed")
//                default:
//                    print("default")
//                }
    }
    
}


// MARK: - CalendarPageViewContentChanged
extension ScrollableCalendarView : CalendarPageViewContentChanged {
    
    func pageViewContentCollectionHeightChanged(collectionViewHeight: CGFloat) {
        print("pageViewContentCollectionHeightChanged(\(collectionViewHeight))")
//        self.view.superview?.frame.size.height = collectionViewHeight
        if let f = self.view.superview?.frame {
//            self.view.superview!.frame = CGRect(x: f.origin.x, y: f.origin.y, width: f.width, height: collectionViewHeight);
//            self.view.superview!.layoutIfNeeded()
        }
        
//        self.containerViewHeightConstraint.update(inset: collectionViewHeight)
        
    }
    
    
}
