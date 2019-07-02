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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initAppearance()
        
        addCalendarContainerView()
        
        
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

    fileprivate func addCalendarContainerView() {
        let containerView = UIView()
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.bottomMargin.equalToSuperview()
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
    
    fileprivate func initAppearance() {
        //Init base appearance
        self.view.backgroundColor = .white
    }
    
}

//TODO: create calendar model and view model (months in year)
//TODO: create calendar content view model (day in month)
