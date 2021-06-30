//
//  ViewController.swift
//  ApiCall
//
//  Created by Ankit on 09/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataProvider : NewsDataProvider!
    var refreshControl :UIRefreshControl! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        addRefreshControl()
        dataProvider = NewsDataProvider(delegate: self, pagination: Paging(isPagingAvailable: false, paginStatus: .noData, pageLimit: 20))
        
        dataProvider.fetchFirstPage()
    }
    
    func addRefreshControl()  {
        refreshControl = UIRefreshControl()
        refreshControl.endRefreshing()
        refreshControl.addTarget(self, action: #selector(manualRefresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.nibCell, forCellReuseIdentifier: NewsTableViewCell.identifierCell)
    }
    
    @objc func manualRefresh() {
        self.refreshControl.beginRefreshing()
        dataProvider.fetchFirstPage()
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return dataProvider.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifierCell, for: indexPath) as? NewsTableViewCell{
            cell.news = dataProvider.getData(index: indexPath.row)
            return cell
        }
       return UITableViewCell()
    }
    
}


extension ViewController:UITableViewDelegate {
    
}

extension ViewController: DataProviderDelegate{
    func requestUpdatedSuccessFully() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func requestFailed(message: String) {
        print("requestFailed \(message)")
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
        
    }
}
