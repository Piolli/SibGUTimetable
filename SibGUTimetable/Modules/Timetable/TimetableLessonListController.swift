//
//  TimetableLessonTableViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 07/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class TimetableLessonListController: UITableViewController {
    
    var viewModel: TTDayViewModel?
    
    var date: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(LessonCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
//        tableView.separatorInsetReference = .fromAutomaticInsets
//        tableView.separatorInset = .init(top: 18, left: 0, bottom: 18, right: 0)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        ///Maybe create init with viewModel?
        if viewModel?.countOflessons == 0 {
            let free = UILabel()
            free.text = "No Lessons Today"
            free.font = free.font.withSize(24)
            tableView.addSubview(free)
            free.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(30)
            }
//            tableView.backgroundView = free
        }
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.countOflessons ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LessonCell
        cell.viewModel = viewModel?.lessonViewModel(at: indexPath)
        return cell
    }

}
