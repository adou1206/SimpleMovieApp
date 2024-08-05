//
//  DetailsViewController.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import UIKit
import Cosmos
import Combine

class DetailsViewController: UIViewController {
    private var scroll_view = UIScrollView()
    
    private var movie_details_stack_view = UIStackView()
    private var movie_title_stack_view = UIStackView()
    private var director_name_stack_view = UIStackView()
    private var caster_list_stack_view = UIStackView()
    private var rate_stack_view = UIStackView()
    private var overview_stack_view = UIStackView()
    
    private var movie_title_label = UILabel()
    private var movie_title_value_label = UILabel()
    private var director_name_label = UILabel()
    private var director_name_value_label = UILabel()
    private var caster_list_label = UILabel()
    private var caster_list_value_label = UILabel()
    private var rate_label = UILabel()
    private var overview_label = UILabel()
    private var overview_value_label = UILabel()
    
    private var rate_cosmos_view = CosmosView()
    
    private var poster_image_view = UIImageView()
    
    private var movie_detail: MovieDetail!
    
    private var vm: MovieCreditsViewModel
    
    private var isLoading: Bool = false {
        didSet {
            isLoading ? showSpinner() : removeSpinner()
        }
    }
    
    private var bindings = Set<AnyCancellable>()
    
    init() {
        self.vm = MovieCreditsViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(movie_detail: MovieDetail) {
        self.init()
        self.movie_detail = movie_detail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailsViewController {
    private func initView() {
        navigationItem.title = "Movie Details"
        
        view.backgroundColor = ColorSets.background.color()
        
        addSubView()
        scrollViewUI()
        imageViewUI()
        stackViewUI()
        labelUI()
        cosmosViewUI()
        fetchData()
        
        vm.$isLoading.assign(to: \.isLoading, on: self).store(in: &bindings)
    }
    
    private func addSubView() {
        view.addSubview(scroll_view)
        
        scroll_view.addSubview(poster_image_view)
        scroll_view.addSubview(movie_details_stack_view)
        
        movie_details_stack_view.addArrangedSubview(movie_title_stack_view)
        movie_details_stack_view.addArrangedSubview(director_name_stack_view)
        movie_details_stack_view.addArrangedSubview(caster_list_stack_view)
        movie_details_stack_view.addArrangedSubview(rate_stack_view)
        movie_details_stack_view.addArrangedSubview(overview_stack_view)
        
        movie_title_stack_view.addArrangedSubview(movie_title_label)
        movie_title_stack_view.addArrangedSubview(movie_title_value_label)
        
        director_name_stack_view.addArrangedSubview(director_name_label)
        director_name_stack_view.addArrangedSubview(director_name_value_label)
        
        caster_list_stack_view.addArrangedSubview(caster_list_label)
        caster_list_stack_view.addArrangedSubview(caster_list_value_label)
        
        rate_stack_view.addArrangedSubview(rate_label)
        rate_stack_view.addArrangedSubview(rate_cosmos_view)
        
        overview_stack_view.addArrangedSubview(overview_label)
        overview_stack_view.addArrangedSubview(overview_value_label)
    }
    
    private func scrollViewUI() {
        scroll_view.translatesAutoresizingMaskIntoConstraints = false
        scroll_view.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        scroll_view.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        scroll_view.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        scroll_view.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        scroll_view.showsHorizontalScrollIndicator = false
    }
    
    private func stackViewUI() {
        movie_details_stack_view.translatesAutoresizingMaskIntoConstraints = false
        movie_details_stack_view.topAnchor.constraint(equalTo: poster_image_view.bottomAnchor, constant: 12).isActive = true
        movie_details_stack_view.bottomAnchor.constraint(equalTo: scroll_view.bottomAnchor, constant: -20).isActive = true
        movie_details_stack_view.leadingAnchor.constraint(equalTo: poster_image_view.leadingAnchor).isActive = true
        movie_details_stack_view.trailingAnchor.constraint(equalTo: poster_image_view.trailingAnchor).isActive = true
        movie_details_stack_view.axis = .vertical
        movie_details_stack_view.distribution = .fill
        movie_details_stack_view.spacing = 15
        movie_details_stack_view.backgroundColor = .clear
        
        movie_title_stack_view.axis = .horizontal
        movie_title_stack_view.spacing = 12
        movie_title_stack_view.distribution = .fill
        movie_title_stack_view.backgroundColor = .clear
        
        director_name_stack_view.axis = .horizontal
        director_name_stack_view.spacing = 12
        director_name_stack_view.distribution = .fill
        director_name_stack_view.backgroundColor = .clear
        
        caster_list_stack_view.axis = .horizontal
        caster_list_stack_view.spacing = 12
        caster_list_stack_view.distribution = .fill
        caster_list_stack_view.backgroundColor = .clear
        
        rate_stack_view.axis = .horizontal
        rate_stack_view.spacing = 12
        rate_stack_view.distribution = .fill
        rate_stack_view.backgroundColor = .clear
        rate_stack_view.alignment = .center
        
        overview_stack_view.axis = .horizontal
        overview_stack_view.spacing = 12
        overview_stack_view.distribution = .fill
        overview_stack_view.backgroundColor = .clear
    }
    
    private func cosmosViewUI() {
        rate_cosmos_view.settings.fillMode = .precise
        rate_cosmos_view.isUserInteractionEnabled = false
    }
    
    private func labelUI() {
        movie_title_label.translatesAutoresizingMaskIntoConstraints = false
        movie_title_label.widthAnchor.constraint(equalTo: movie_title_stack_view.widthAnchor, multiplier: 0.3).isActive = true
        movie_title_label.font = .systemFont(ofSize: 16, weight: .semibold)
        movie_title_label.textColor = .darkText
        movie_title_label.lineBreakMode = .byWordWrapping
        movie_title_label.numberOfLines = 0
        movie_title_label.text = "Movie Name"
        
        movie_title_value_label.font = .systemFont(ofSize: 16, weight: .medium)
        movie_title_value_label.textColor = .darkText
        movie_title_value_label.lineBreakMode = .byWordWrapping
        movie_title_value_label.numberOfLines = 0
        
        director_name_label.translatesAutoresizingMaskIntoConstraints = false
        director_name_label.widthAnchor.constraint(equalTo: director_name_stack_view.widthAnchor, multiplier: 0.3).isActive = true
        director_name_label.font = .systemFont(ofSize: 16, weight: .semibold)
        director_name_label.textColor = .darkText
        director_name_label.lineBreakMode = .byWordWrapping
        director_name_label.numberOfLines = 0
        director_name_label.text = "Director Name"
        
        director_name_value_label.font = .systemFont(ofSize: 16, weight: .medium)
        director_name_value_label.textColor = .darkText
        director_name_value_label.lineBreakMode = .byWordWrapping
        director_name_value_label.numberOfLines = 0
        
        caster_list_label.translatesAutoresizingMaskIntoConstraints = false
        caster_list_label.widthAnchor.constraint(equalTo: caster_list_stack_view.widthAnchor, multiplier: 0.3).isActive = true
        caster_list_label.font = .systemFont(ofSize: 16, weight: .semibold)
        caster_list_label.textColor = .darkText
        caster_list_label.lineBreakMode = .byWordWrapping
        caster_list_label.numberOfLines = 0
        caster_list_label.text = "Casters"
        
        caster_list_value_label.font = .systemFont(ofSize: 16, weight: .medium)
        caster_list_value_label.textColor = .darkText
        caster_list_value_label.lineBreakMode = .byWordWrapping
        caster_list_value_label.numberOfLines = 0
        
        rate_label.translatesAutoresizingMaskIntoConstraints = false
        rate_label.widthAnchor.constraint(equalTo: rate_stack_view.widthAnchor, multiplier: 0.3).isActive = true
        rate_label.font = .systemFont(ofSize: 16, weight: .semibold)
        rate_label.textColor = .darkText
        rate_label.lineBreakMode = .byWordWrapping
        rate_label.numberOfLines = 0
        rate_label.text = "Rating"
        
        overview_label.translatesAutoresizingMaskIntoConstraints = false
        overview_label.widthAnchor.constraint(equalTo: overview_stack_view.widthAnchor, multiplier: 0.3).isActive = true
        overview_label.font = .systemFont(ofSize: 16, weight: .semibold)
        overview_label.textColor = .darkText
        overview_label.lineBreakMode = .byWordWrapping
        overview_label.numberOfLines = 0
        overview_label.text = "Plot"
        
        overview_value_label.font = .systemFont(ofSize: 16, weight: .medium)
        overview_value_label.textColor = .darkText
        overview_value_label.lineBreakMode = .byWordWrapping
        overview_value_label.numberOfLines = 0
    }
    
    private func imageViewUI() {
        poster_image_view.translatesAutoresizingMaskIntoConstraints = false
        poster_image_view.topAnchor.constraint(equalTo: scroll_view.topAnchor).isActive = true
        poster_image_view.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 20).isActive = true
        poster_image_view.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -20).isActive = true
        poster_image_view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        poster_image_view.backgroundColor = .clear
        poster_image_view.contentMode = .scaleAspectFit
    }
    
    private func updateDisplay() {
        if let poster_url = movie_detail.posterURL() {
            poster_image_view.loadFrom(URLAddress: poster_url)
        }
        
        movie_title_value_label.text = movie_detail.originalTitle
        overview_value_label.text = movie_detail.overview
        rate_cosmos_view.rating = movie_detail.ratingValue()
        
        guard let movie_credits = vm.movieCreditsModel else { return }
        
        let crew = movie_credits.crew
        let cast = movie_credits.cast
        
        if crew.count > 0, let director = crew.filter({ $0.job == jobType.director.rawValue }).first {
            director_name_value_label.text = director.originalName
        }
        
        if cast.count > 0 {
            caster_list_value_label.text = "\(cast.prefix(10).map { $0.originalName }.joined(separator: ", ")), etc..."
        }
    }
    
    private func fetchData() {
        Task {
            defer {
                if vm.hasError {
                    alertWithTitle("Notice", message: vm.error?.errorDescription ?? "")
                    
                }else {
                    updateDisplay()
                }
            }
            
            await vm.fetchMovieCredits(movie_id: movie_detail.id)
        }
    }
}
