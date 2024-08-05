//
//  MovieCollectionView.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import UIKit

class MovieCollectionView: UICollectionView {
    var movie_list = [MovieDetail]() {
        didSet {
            reloadData()
        }
    }
    
    override init(
        frame: CGRect,
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        let customLayout = UICollectionViewCompositionalLayout { (sectionNumber, env) in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 2
            )
            group.interItemSpacing = .fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
//            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            
            return section
        }
        
        super.init(frame: frame, collectionViewLayout: customLayout)
        
        initView()
    }
    
    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieCollectionView {
    private func initView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        register(MovieCollectionCell.self, forCellWithReuseIdentifier: MovieCollectionCell.identifier)
        dataSource = self
    }
}

extension MovieCollectionView: UICollectionViewDataSource {
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return movie_list.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.identifier, for: indexPath) as! MovieCollectionCell
        cell.configure(view_model: movie_list[indexPath.row])
        
        return cell
    }
}
