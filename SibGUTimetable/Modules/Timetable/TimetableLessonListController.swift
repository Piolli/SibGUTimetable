//
//  TimetableLessonTableViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 07/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit


class TimetableLessonListController: UITableViewController {
    
    var viewModel: TimetableDayViewModel?
    var contentOffsetDidChange: ((CGPoint) -> ())?
    var date: Date!
    
    private var contentOffsetObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(LessonCell.self, forCellReuseIdentifier: "cell")
        tableView.register(LessonSubgroupCell.self, forCellReuseIdentifier: "subgroupCell")
        tableView.separatorStyle = .singleLine
//        tableView.separatorInsetReference = .fromAutomaticInsets
//        tableView.separatorInset = .init(top: 18, left: 0, bottom: 18, right: 0)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.backgroundColor = ThemeProvider.shared.tableViewBackgroundColor
        
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
        
        contentOffsetObserver = tableView.observe(\UITableView.contentOffset, options: .new) { [weak self](tableView, value) in
            guard let newValue = value.newValue else { return }
            self?.contentOffsetDidChange?(newValue)
        }
    }
    
    deinit {
        contentOffsetObserver?.invalidate()
    }
    
    private func checkAmbiguousLayout(_ view: UIView) { for subview in view.subviews {
        _ = subview.hasAmbiguousLayout
          checkAmbiguousLayout(subview)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        UIView.exerciseAmbiguity(view)
        checkAmbiguousLayout(view)
//        print(view.value(forKey: "_autolayoutTrace")!)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        logger.trace("velocity: \(velocity)")
        logger.trace("pointee: \(targetContentOffset.pointee)")
        self.contentOffsetDidChange?(velocity)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.countOflessons ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let count = viewModel?.lessonViewModels(at: indexPath)?.count, count > 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subgroupCell", for: indexPath) as! LessonSubgroupCell
            cell.lessonViewModels = viewModel!.lessonViewModels(at: indexPath)!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LessonCell
            cell.viewModel = viewModel?.lessonViewModels(at: indexPath)?[0]
            return cell
        }
    }
    
    var cells: [IndexPath: UITableViewCell] = [:]
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cells[indexPath] = cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = cells[indexPath] else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        return cell.frame.height
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = cells[indexPath] else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        return cell.frame.height
    }
    
}

extension UIView {
    class func exerciseAmbiguity(_ view: UIView) {
    #if DEBUG
        if view.hasAmbiguousLayout {
           Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                view.exerciseAmbiguityInLayout()
                logger.debug("Debug layout")
            }
          } else {
            for subview in view.subviews {
                UIView.exerciseAmbiguity(subview)
                logger.debug("Debug layout")
            }
          }
          #endif
        }
}
