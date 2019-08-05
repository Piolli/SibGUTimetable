//
//  ViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 14/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.navigationItem.title = "Расписание группы БПИ16-01"
        self.navigationItem.largeTitleDisplayMode = .always
        
        navigationController!.navigationItem.title = "Расписание группы БПИ16-01"
        
        initAppearance()
        addTimetablePageViewController()
        print("TabBar height (viewDidLoad): \(self.tabBarController?.tabBar.frame.size.height)")
//        addCalendarContainerView()
//        addCalendarContainerView()
        
        //Test core data
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let fetch = NSFetchRequest<TESTENTITY>(entityName: "TESTENTITY")
//        do {
//            let result = try context.fetch(fetch)[0] as TESTENTITY
//            print(result.score)
//        } catch {
//            print(error.localizedDescription)
//        }
        
        //Save entity
//        let entity = TESTENTITY(context: context)
//        entity.id = UUID()
//        entity.name = "Sample test name"
//
//        do {
//            try context.save()
//        }
//        catch { print(error.localizedDescription) }
//
//        appDelegate.saveContext()
        
    }
    
    func addTimetablePageViewController() {
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.leftMargin.rightMargin.bottomMargin.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        
        containerView.backgroundColor = .red
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
        
//        getDayViewModel()
        
        let timetablePageViewController = TimetablePageViewController()
        timetablePageViewController.viewModel = TimetableScheduleViewModel.TESTScheduleViewModel()
        addViewControllerToContainerView(viewController: timetablePageViewController, containerView: containerView)
    }
    
//    func getDayViewModel() -> TimetableDayViewModel {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let day = Day(context: context)
//        
//        let lesson1 = Lesson(context: context)
//        
//        lesson1.name = "Programming languages"
//        lesson1.office = "L318"
//        lesson1.type = "Practice"
//        
//        day.header = "Sunday"
//        day.addToLessons(lesson1)
//
//        do {
//            try context.save()
//        }
//        catch { print(error.localizedDescription) }
//
//        appDelegate.saveContext()
//        
//        return TimetableDayViewModel(day: day)
//    }
    
    func loadCoreDataViewModel() -> TimetableDayViewModel? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<Day>(entityName: "Day")
        do {
            let result = try context.fetch(fetch)[0] as Day
            return TimetableDayViewModel(day: result)
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("TabBar height (viewDidAppear): \(self.tabBarController?.tabBar.frame.size.height)")
        addCalendarContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TabBar height (viewWillAppear): \(self.tabBarController?.tabBar.frame.size.height)")
//        addCalendarContainerView()
    }

    func addCalendarContainerView() {
        
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.bottom.equalTo((-1.0 ) * (self.tabBarController?.tabBar.frame.size.height ?? 600))
            make.leftMargin.equalToSuperview()
            make.rightMargin.equalToSuperview()
            make.height.equalTo(400)
        }
        
        containerView.backgroundColor = .red
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
        
        let scrollableCalendar = ScrollableCalendarView()
        addChild(scrollableCalendar)
        containerView.addSubview(scrollableCalendar.view)
        
        scrollableCalendar.view.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
        
        scrollableCalendar.didMove(toParent: self)
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

//TODO: create calendar model and view model (months in year)
//TODO: create calendar content view model (day in month)
