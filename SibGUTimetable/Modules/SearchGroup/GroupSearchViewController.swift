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

class GroupSearchViewController: UIViewController {

    private static let cellId = "groupPair"
    
    var coordinator: GroupSearchCoordinator!
    var viewModelController: GroupSearchViewModelController!
    var apiServer: APIServer!
    var disposeBag = DisposeBag()
    var searchController: UISearchController!
    
    var viewModel: GroupSearchViewModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: GroupSearchViewController.cellId)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        searchController = UISearchController()
        let searchBar = searchController.searchBar
        
        let searchResults = searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { (query) -> PublishRelay<GroupSearchViewModel> in
                if query.isEmpty {
                    return .init()
                }
                
                self.viewModelController.searchGroup(query: query)
                return self.viewModelController.viewModel
            }
            .observeOn(MainScheduler.instance)
        
        searchResults.subscribe(onNext: { (viewModel) in
            self.viewModel = viewModel
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        navigationItem.searchController = searchController
        initViewModel()
    }
    
    func initViewModel() {
        viewModelController = GroupSearchViewModelController(api: apiServer)
        viewModelController.viewModel.subscribe(onNext: { [weak self] (viewModel) in
            self?.viewModel = viewModel
        }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        viewModelController.searchGroup(query: "БПИ")
    }
    
}

extension GroupSearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.groupPairs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellView = tableView.dequeueReusableCell(withIdentifier: GroupSearchViewController.cellId, for: indexPath)
        
        cellView.textLabel?.text = "\(viewModel?.groupPairs[indexPath.row].id ?? -1) – \(viewModel?.groupPairs[indexPath.row].name ?? "")"
        
        return cellView
        
        
    }
    
}

extension GroupSearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pair = viewModel?.groupPairs[indexPath.row] {
            coordinator.openSearchedGroup(pair: pair)
        } else {
            fatalError("viewModel is nil")
        }
    }
}


