//
//  MovieCollectionViewCell.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    static let identifier = "MovieCollectionCell"
    
    private var background_view = UIView()
    
    private var movie_title_label = UILabel()
    
    private var poster_image_view = UIImageView()
    
    override init(
        frame: CGRect
    ) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        view_model: MovieDetail
    ) {
        movie_title_label.text = view_model.originalTitle
        
        if let poster_url = view_model.posterURL() {
            poster_image_view.loadFrom(URLAddress: poster_url)
        }
    }
}

extension MovieCollectionCell {
    private func initView() {
        backgroundColor = .clear
        
        addSubView()
        viewUI()
        labelUI()
        imageViewUI()
    }
    
    private func addSubView() {
        contentView.addSubview(background_view)
        
        background_view.addSubview(poster_image_view)
        background_view.addSubview(movie_title_label)
    }
    
    private func viewUI() {
        background_view.translatesAutoresizingMaskIntoConstraints = false
        background_view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        background_view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        background_view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        background_view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        background_view.layer.cornerRadius = 12
        background_view.backgroundColor = .white
    }
    
    private func labelUI() {
        movie_title_label.translatesAutoresizingMaskIntoConstraints = false
        movie_title_label.topAnchor.constraint(equalTo: poster_image_view.bottomAnchor, constant: 15).isActive = true
        movie_title_label.bottomAnchor.constraint(equalTo: background_view.bottomAnchor, constant: -15).isActive = true
        movie_title_label.leadingAnchor.constraint(equalTo: poster_image_view.leadingAnchor, constant: 10).isActive = true
        movie_title_label.trailingAnchor.constraint(equalTo: poster_image_view.trailingAnchor, constant: -10).isActive = true
        movie_title_label.font = .systemFont(ofSize: 18, weight: .semibold)
        movie_title_label.textColor = .darkText
        movie_title_label.lineBreakMode = .byWordWrapping
        movie_title_label.numberOfLines = 0
    }
    
    private func imageViewUI() {
        poster_image_view.translatesAutoresizingMaskIntoConstraints = false
        poster_image_view.topAnchor.constraint(equalTo: background_view.topAnchor).isActive = true
        poster_image_view.leadingAnchor.constraint(equalTo: background_view.leadingAnchor).isActive = true
        poster_image_view.trailingAnchor.constraint(equalTo: background_view.trailingAnchor).isActive = true
        poster_image_view.heightAnchor.constraint(equalTo: background_view.heightAnchor, multiplier: 0.7).isActive = true
        poster_image_view.backgroundColor = .clear
        poster_image_view.contentMode = .scaleToFill
    }
}
