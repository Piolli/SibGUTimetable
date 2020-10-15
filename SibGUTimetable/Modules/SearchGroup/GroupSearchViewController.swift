//
//  GroupSearchViewController.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 21.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit
import SPAlert
import NVActivityIndicatorView

class GroupSearchViewController: UIViewController, NVActivityIndicatorViewable {

    private static let cellId = "groupPair"
    private weak var timetableManager: TimetableDataManager?
    
    var coordinator: GroupSearchCoordinator!
    let viewModel: GroupSearchViewModel
    var apiServer: APIServer!
    var disposeBag = DisposeBag()
    var searchController: UISearchController!
    var activityIndicatorView: NVActivityIndicatorView!
    
    var input: GroupSearchViewModel.Input {
        return .init(groupName: searchController.searchBar.rx.text.orEmpty.asDriver().debug("input:", trimOutput: false))
    }
    
    init(timetableManager: TimetableDataManager) {
        self.timetableManager = timetableManager
        self.viewModel = .init(api: NativeAPIServer())
        super.init(nibName: nil, bundle: nil)
    }
    
    init(viewModel: GroupSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
//        tableView.dataSource = self
//        tableView.delegate = self
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let searchBar = searchController.searchBar
        
        searchBar.returnKeyType = .done
        searchBar.placeholder = LocalizedStrings.Enter_a_group_name
        
        navigationItem.searchController = searchController
        
        //setup activity indicator
        activityIndicatorView = .init(frame: CGRect(x: view.bounds.width/2, y: view.bounds.height/2, width: 75, height: 75), type: .lineScaleParty, color: .blue, padding: nil)
        view.addSubview(activityIndicatorView)
        
        navigationItem.title = LocalizedStrings.Group_search
        startAnimating()
        bindViewModel()
    }
    
    func bindViewModel() {
        let output = viewModel.transform(input: input)
        output.groupsPair.asObservable().bind(to: tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self), cellType: UITableViewCell.self)) {  (row,item,cell) in
            cell.textLabel?.text = "\(item.id) – \(item.name)"
        }.disposed(by: disposeBag)
        
        output.isLoading.drive(self.rx.isAnimating).disposed(by: disposeBag)
    
    }
    
}

//extension GroupSearchViewController : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel?.groupPairs.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellView = tableView.dequeueReusableCell(withIdentifier: GroupSearchViewController.cellId, for: indexPath)
//
//        cellView.textLabel?.text = "\(viewModel?.groupPairs[indexPath.row].id ?? -1) – \(viewModel?.groupPairs[indexPath.row].name ?? "")"
//
//        return cellView
//    }
//
//}
//
//extension GroupSearchViewController : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let pair = viewModel?.groupPairs[indexPath.row], let timetableManager = self.timetableManager {
//            startAnimating()
//            let timetableDetails = TimetableDetails(groupId: pair.id, groupName: pair.name)
//            timetableManager.loadTimetable(timetableDetails: timetableDetails)
//            timetableManager.loadTimetable(timetableDetails: timetableDetails)
//                .debug("GroupSearchViewController (timetableManager.timetableOutput)", trimOutput: false)
//                .observeOn(MainScheduler.instance)
//                .subscribe(onNext: { [weak self] timetable in
//                    //TODO: --------------------------------------CHECK ON ERRORS
//                    if timetable.timetable == nil {
//                        return
//                    }
//                    self?.stopAnimating()
//                    self?.viewModelController.save(timetableDetails: TimetableDetails(groupId: pair.id, groupName: pair.name, timestamp: timetable.timetable!.updateTimestamp))
//                    self?.navigationController?.popViewController(animated: true)
//                }).disposed(by: disposeBag)
//
////            timetableManager.errorOutput
////                .debug("GroupSearchViewController (timetableManager.errorOutput)", trimOutput: false)
////                .observeOn(MainScheduler.instance)
////                .subscribe(onNext: { [weak self] (error) in
////                    //Only network error
////                    if (error as NSError).code == 101 {
////                        logger.error("\(error.localizedDescription)")
////                        self?.stopAnimating()
////                        SPAlert.present(message: LocalizedStrings.Error_occured_while_loading_timetable)
////                    }
////            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
//        } else {
//            fatalError("viewModel is nil")
//        }
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}


