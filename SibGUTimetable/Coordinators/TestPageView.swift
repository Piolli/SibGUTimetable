//
//  TestPageView.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 30.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation

import UIKit
import SnapKit
import SideMenuSwift

class TestPageView : Coordinator {
    
    weak var navigationController: UINavigationController!
    let viewController = TestPageViewController()
    
    var rootViewController: UIViewController {
        return viewController
    }
    
    init(navigationController: UINavigationController) {
//        let navigationController = AppCoordinator.putInNavigationController(viewController)
        self.navigationController = navigationController
        viewController.coordinator = self
    }
    
    func start() {
        navigationController.pushViewController(viewController, animated: true)
    }
    
}


class TestPageViewController : UIViewController {
    
    var pageViewController: CustomizablePageViewController<Date, TimetableLessonListController>!
    var coordinator: TestPageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        let timetable = FileLoader.shared.getLocalSchedule()!
        let viewModel = TTViewModel(schedule: timetable)
        
        pageViewController = .init()
        pageViewController.dataSource = CustomizablePageViewDataSource<Date, TimetableLessonListController>.init(startIterableValue: Date(), contentBuilder: { (date) -> TimetableLessonListController in
                    let vc = TimetableLessonListController()
                    vc.date = date
                    vc.viewModel = viewModel?.getDayViewModel(at: date)
                    return vc
                }, nextIterableValue: { (date) -> Date in
                    return date.followingDateByDay()
                }, previousIterableValue: { (date) -> Date in
                    return date.previousDateByDay()
                }, extractIterableValueFromController: { (viewController) -> Date in
                    return viewController.date
                })
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalTo(self.view)
        }
        label.text = "HEELLOO"
        label.font = UIFont.systemFont(ofSize: 32)
        
        let viewContrainer = UIView()
        viewContrainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContrainer)
        viewContrainer.snp.makeConstraints { (maker) in
            maker.edges.equalTo(view)
        }
        
        
        viewContrainer.addSubview(pageViewController.view)
        
        pageViewController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(viewContrainer)
        }
        
        pageViewController.didMove(toParent: self)
        
        //Work with side menu
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.snp.topMargin)
            maker.leading.equalTo(view.snp.leadingMargin)
        }
        button.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
        button.setTitle("Show", for: .normal)
        
    }
    
    @objc func showMenu(_ sender: UIButton) {
        sideMenuController?.revealMenu()
    }
    
}
