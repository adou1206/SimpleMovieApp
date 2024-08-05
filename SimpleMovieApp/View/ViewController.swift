//
//  ViewController.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import UIKit
import Combine
import CoreData

class ViewController: UIViewController {
    private var search_bar = UISearchBar()
    
    private var movie_collection_view = MovieCollectionView()
    
    private var vm: MovieViewModel
    
    private let movie_manager = MovieManager()
    
    private var isLoading: Bool = false {
        didSet {
            isLoading ? showSpinner() : removeSpinner()
        }
    }
    
    private var bindings = Set<AnyCancellable>()
    
    init() {
        self.vm = MovieViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    
    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController {
    private func initView() {
        navigationItem.title = "Movie List"

        view.backgroundColor = ColorSets.background.color()
        
        addSubView()
        searchBarUI()
        collectionViewUI()
        fetchData()
        
        vm.$isLoading.assign(to: \.isLoading, on: self).store(in: &bindings)
    }
    
    private func addSubView() {
        view.addSubview(search_bar)
        view.addSubview(movie_collection_view)
    }
    
    private func searchBarUI() {
        search_bar.translatesAutoresizingMaskIntoConstraints = false
        search_bar.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        search_bar.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 15).isActive = true
        search_bar.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -15).isActive = true
        search_bar.searchBarStyle = .minimal
        search_bar.returnKeyType = .search
        search_bar.backgroundColor = .clear
        search_bar.placeholder = "Search movies by title"
        search_bar.delegate = self
        
        let toolBar = UIToolbar(
            frame: CGRect(
                x: 0.0,
                y: 0.0,
                width: UIScreen.main.bounds.size.width,
                height: 44.0
            )
        )
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let DoneButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(tapDone))
        
        toolBar.setItems([flexibleSpace, DoneButton], animated: false)
        
        search_bar.searchTextField.inputAccessoryView = toolBar
    }
    
    private func collectionViewUI() {
        movie_collection_view.translatesAutoresizingMaskIntoConstraints = false
        movie_collection_view.topAnchor.constraint(equalTo: search_bar.bottomAnchor).isActive = true
        movie_collection_view.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        movie_collection_view.leadingAnchor.constraint(equalTo: search_bar.leadingAnchor, constant: 10).isActive = true
        movie_collection_view.trailingAnchor.constraint(equalTo: search_bar.trailingAnchor, constant: -10).isActive = true
        movie_collection_view.showsHorizontalScrollIndicator = false
        movie_collection_view.backgroundColor = .clear
        movie_collection_view.delegate = self
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Collection View", attributes: nil)
        
        movie_collection_view.refreshControl = refreshControl
    }
    
    private func updateDisplay(
        movie_detail: [MovieDetail]
    ) {
        movie_collection_view.movie_list = movie_detail
        
        if let refreshControl = movie_collection_view.refreshControl, refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    @objc private func fetchData() {
        if movie_manager.checkMovieListExists() {
            updateDisplay(movie_detail: movie_manager.convertToMovieDetail())
            
        }else {
            Task {
                defer {
                    if vm.hasError {
                        alertWithTitle("Notice", message: vm.error?.errorDescription ?? "")
                        
                    }else {
                        if let vm = vm.movieModel {
                            movie_manager.createMovies(data_for_saving: vm.results)
                            
                            updateDisplay(movie_detail: vm.results)
                            
                        }else {
                            alertWithTitle("Notice", message: "Movie data not found.")
                        }
                    }
                }
                
                await vm.fetchMovie()
            }
        }
    }
    
    @objc func tapDone() {
        view.endEditing(true)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let nvc = navigationController {
            let movie_details_vc = DetailsViewController(movie_detail: movie_collection_view.movie_list[indexPath.row])
            
            nvc.pushViewController(movie_details_vc, animated: true)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(
        _ searchBar: UISearchBar
    ) {
        tapDone()
        
        guard let search = searchBar.text else { return }
        
        updateDisplay(
            movie_detail: movie_manager.convertToMovieDetail(
                predicate: NSPredicate(
                    format: "original_title CONTAINS[cd] %@",
                    search.trimmingCharacters(in: .whitespacesAndNewlines)
                )
            )
        )
    }
}
