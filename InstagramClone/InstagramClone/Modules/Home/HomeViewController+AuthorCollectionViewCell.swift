//
//  HomeViewController+AuthorCollectionViewCell.swift
//  InstagramClone
//
//  Created by Gregory Molette on 20/01/2023.
//

import UIKit

extension HomeViewController {
    final class AuthorCollectionViewCell: UICollectionViewCell {
        private weak var imageView: UIImageView!
        private weak var gradientView: UIImageView!
        private weak var nameLabel: UILabel!
        private var hasSetupConstraints = false

        lazy var gradient: CAGradientLayer = {
            let gradient = CAGradientLayer()
            gradient.type = .radial
            gradient.colors = [UIColor.red.cgColor, UIColor.purple.cgColor]
            gradient.locations = [0.0, 1.0]
            return gradient
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
            setupConstraints()
        }

        @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupView() {
            let imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 40
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.white.cgColor
            self.imageView = imageView
    
            let gradientView = UIImageView()
            gradientView.clipsToBounds = true
            gradientView.layer.cornerRadius = 44
            self.gradientView = gradientView
            
            let nameLabel = UILabel()
            self.nameLabel = nameLabel

            [gradientView, imageView, nameLabel].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        }

        override func updateConstraints() {
            if !hasSetupConstraints {
                setupConstraints()
                hasSetupConstraints = true
            }

            super.updateConstraints()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            addGradient()
        }

        private func setupConstraints() {
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 80),
                imageView.widthAnchor.constraint(equalToConstant: 80),
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),

                gradientView.heightAnchor.constraint(equalToConstant: 86),
                gradientView.widthAnchor.constraint(equalToConstant: 86),
                gradientView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                gradientView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
                
                nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
                nameLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
            ])
        }

        private func addGradient() {
            gradient.frame = gradientView.bounds
            gradientView.layer.insertSublayer(gradient, at: 0)
        }

        func configure(with author: Author) {
            if let authorIndex = Author.authors.firstIndex(of: author) {
                gradientView.isHidden = Author.authors[authorIndex].isSeen
            }
            imageView.image = UIImage(named: author.photoName)
            nameLabel.text = author.name
        }
    }
}
