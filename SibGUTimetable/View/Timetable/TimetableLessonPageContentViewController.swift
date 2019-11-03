//
//  TimetableLessonTableViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 07/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class TimetableLessonPageContentViewController: UITableViewController {
    
    var viewModel: TimetableDayViewModel?
    
    var date: Date!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TimetableLessonViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimetableLessonViewCell
        cell.viewModel = viewModel?.lessonViewModel(at: indexPath)
        return cell
    }

}
