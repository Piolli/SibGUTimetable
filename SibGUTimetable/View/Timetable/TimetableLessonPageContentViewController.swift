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
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TimetableLessonViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.countOflessons ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimetableLessonViewCell
        
        cell.viewModel = viewModel?.lessonViewModel(at: indexPath)
    
//        cell.backgroundColor = .blue

        return cell
    }

}
