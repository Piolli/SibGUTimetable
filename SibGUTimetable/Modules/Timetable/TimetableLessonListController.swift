//
//  TimetableLessonTableViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 07/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit


class TimetableLessonListController: UITableViewController {
    
    let viewModel: TimetableDayViewModel
    var date: Date!
    private var cellFrames: [IndexPath: CGSize] = [:]
    
    init(viewModel: TimetableDayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isDayOff: Bool {
        return viewModel.countOflessons == 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(LessonCell.self, forCellReuseIdentifier: "cell")
        tableView.register(LessonSubgroupCell.self, forCellReuseIdentifier: "subgroupCell")
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.backgroundColor = ThemeProvider.shared.calendarViewBackgroungColor
        
        if isDayOff {
            setupDayOffView()
        }
    }
    
    func setupDayOffView() {
        let dayOffView = DayOffView()
        dayOffView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(dayOffView)
        
        let day = Calendar.current.dateComponents([.day], from: date)
        //TODO: create enum with image identifiers
        dayOffView.loadImage(from: "day_off_\(((day.day ?? 1) % 3) + 1)") { [weak self] (imageSize) in
            guard let self = self else {
                logger.error("self = nil")
                return
            }
            let ratio = imageSize.height / imageSize.width
            logger.debug("dayOffView image ratio: \(ratio)")
            let dayOffHeightConstraint = dayOffView.heightAnchor.constraint(equalTo: self.tableView.widthAnchor, multiplier: ratio)
            //TODO: check out another constraints with .defaultLow priority
            dayOffHeightConstraint.priority = .defaultHigh
            dayOffHeightConstraint.isActive = true
        }
        
        NSLayoutConstraint.activate([
            dayOffView.topAnchor.constraint(equalTo: tableView.topAnchor),
            dayOffView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            dayOffView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            dayOffView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            dayOffView.heightAnchor.constraint(lessThanOrEqualTo: tableView.heightAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ///#It produces warnings about 'Ambiguous layout'. But after some researches it works well.
        ///Notes:
        ///0. in viewDidAppear DayOffView doesn't have frame (0 0, 0 0)
        ///1. adding setNeedsLayout() + layoutIfNeeded() after DayOffView's setup eliminates warnings
        ///2. a check of ambiguous layout after a couple of seconds doesn't show any warnings
        ///3. after directional swiping this warnings eliminates.
        ///4. If first added view controller to UIPageViewController contains DayOffView, it produces warnings.
        ///5. If first added view controller is just table view with lessons - there's no warnings.
        ///6. In `OnboardingItemViewController` this bug reproduces like in this case.
        ///# recap: bug might be in CustomizablePageViewController and related classes
        ///# uncomment code below for bug reproducing
//         checkAmbiguousLayout(view)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOflessons
    }
    
    /// Rounds corners for first and last cell
    /// - Parameters:
    ///   - cell: must be rounded
    ///   - indexPath: uses for check position of cell
    func roundCellCorners(_ cell: UITableViewCell, _ indexPath: IndexPath) {
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        let isFirstCell = indexPath.row == 0
        
        if !isLastCell && !isFirstCell {
            return
        }
        
        if isLastCell {
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            ///hide separator of table view cell
            cell.separatorInset = .init(top: 0, left: 10000, bottom: 0, right: 0)
        } else if isFirstCell {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let count = viewModel.lessonViewModels(at: indexPath)?.count, count > 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subgroupCell", for: indexPath) as! LessonSubgroupCell
            cell.lessonViewModels = viewModel.lessonViewModels(at: indexPath)!
            roundCellCorners(cell, indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LessonCell
            cell.viewModel = viewModel.lessonViewModels(at: indexPath)?[0]
            roundCellCorners(cell, indexPath)
            return cell
        }
    }
}

// MARK: - Calculate TableView's cells height
extension TimetableLessonListController {
    /// This method is called after heightForRow (returned from cellForRowAt).
    /// Method calculates height for manual layout cell (LessonSubgroupCell)
    /// Saves calculated cell's frame to `cellFrames`
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cellFrames[indexPath] == nil {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            cellFrames[indexPath] = cell.frame.size
        }
    }
    
    /// This method is called after dequeReusableCell and cellForRowAt methods
    ///#Note: this method also is called if tableView can't guess height for cell
    /// Call stack:
    /// -[UISectionRowData heightForRow:inSection:canGuess:] ()
    /// -[UITableViewRowData heightForRow:inSection:canGuess:adjustForReorderedRow:] ()
    /// -[UITableViewRowData rectForRow:inSection:heightCanBeGuessed:] ()
    /// -[UITableViewRowData rectForGlobalRow:heightCanBeGuessed:] ()
    /// - Returns: cell's height from `cellFrames` dict
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let frame = cellFrames[indexPath] else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        return frame.height
    }
}
