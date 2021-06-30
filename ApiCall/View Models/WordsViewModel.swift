//
//  NewsViewModel.swift
//  ApiCall
//
//  Created by Ankit on 16/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation

class NewsDataProvider: DataProvider {
    var pageNo: Int {
        return numberOfItems() % pagination.pageLimit
    }
    
    func getData<T>(index: Int) -> T? where T : Hashable {
        return arrNews[safe: index] as? T
    }
    
    func getData<T>(section: Int) -> T? where T : Hashable {
        return nil
    }
    
    var fetchingStatus: FetchingStatus = .idle
    var pagination: Paging
    var delegate: DataProviderDelegate
    
    var arrNews = [News]()
    init(delegate:DataProviderDelegate,pagination:Paging) {
        self.delegate = delegate
        self.pagination = pagination
    }
    
    func isFetchingFirstPage() -> Bool {
        return pagination.paginStatus == .noData && fetchingStatus == .idle && isNoDataPresent()
    }
    
    
    func fetchFirstPage() {
        fetchingStatus = .idle
        getData()
    }
    
    func fetchNextPage() {
        
    }
    
    private func getData(){
        if fetchingStatus == .idle {
            self.arrNews.removeAll()
            fetchingStatus = .fetching
            ModuleManager.manager.getNews() {[weak self] (response) in
                self?.fetchingStatus = .idle
                guard let self = self else {
                    return
                }
                switch response {
                case .failure(let error):
                    self.delegate.requestFailed(message: error.localizedDescription)
                    break
                case .success(let news):
                    self.arrNews.append(contentsOf: news.value)
                    self.delegate.requestUpdatedSuccessFully()
                }
            }
        }
    }
    
    func numberOfItems() -> Int {
        return arrNews.count
    }
    
    func numberOfHeaders() -> Int {
        return isNoDataPresent() ? 0 : 1
    }
    
    func isNoDataPresent() -> Bool {
        return arrNews.isEmpty
    }
}
