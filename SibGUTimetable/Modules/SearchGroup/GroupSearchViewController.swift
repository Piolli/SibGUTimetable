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

    let viewModel: GroupSearchViewModel
    var disposeBag = DisposeBag()
    var searchController: UISearchController!
    
    var input: GroupSearchViewModel.Input {
        return .init(
            groupName: searchController.searchBar.rx.text.orEmpty.asDriver(),
            selectedGroup: tableView.rx.modelSelected(GroupPairIDName.self).asDriver()
        )
    }
    
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return table
    }()
    
    init(viewModel: GroupSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(GroupPairIDName.self))
            .bind { [weak self] (indexPath, model) in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }.disposed(by: disposeBag)
        
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
        navigationItem.title = LocalizedStrings.Group_search
        
        bindViewModel()
    }
    
    func bindViewModel() {
        let output = viewModel.transform(input: input)
        disposeBag.insert([
            output.groupsPair.asObservable().bind(to: tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self), cellType: UITableViewCell.self)) {  (row, item, cell) in
                cell.textLabel?.text = item.description
            },
            output.isLoading.drive(self.rx.isAnimating),
            output.errors.drive(errorBinding),
            output.preloadCompleted.drive(successBinding)
        ])
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            SPAlert.present(message: error.localizedDescription)
        })
    }
    
    var successBinding: Binder<Void> {
        return Binder(self, binding: { (vc, error) in
            SPAlert.present(message: "Update timetable!")
        })
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
extension GroupSearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    }
}


