//
//  HomeViewController+PostCollectionViewCell.swift
//  InstagramClone
//
//  Created by Gregory Molette on 20/01/2023.
//

import UIKit

extension HomeViewController {
    final class PostCollectionViewCell: UICollectionViewCell {
        private weak var placeholderAuthor: UIView!
        private weak var placeholderTitle: UIView!
        private weak var placeholderImage: UIView!

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
            let placeholderAuthor = UIView()
            placeholderAuthor.backgroundColor = .lightGray
            placeholderAuthor.layer.cornerRadius = 16
            self.placeholderAuthor = placeholderAuthor

            let placeholderTitle = UIView()
            placeholderTitle.backgroundColor = .lightGray
            placeholderTitle.layer.cornerRadius = 6
            self.placeholderTitle = placeholderTitle

            let placeholderImage = UIView()
            placeholderImage.backgroundColor = .lightGray
            self.placeholderImage = placeholderImage

            [placeholderAuthor, placeholderTitle, placeholderImage].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        }

        private func setupConstraints() {
            NSLayoutConstraint.activate([
                placeholderAuthor.heightAnchor.constraint(equalToConstant: 32),
                placeholderAuthor.widthAnchor.constraint(equalToConstant: 32),
                placeholderAuthor.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                placeholderAuthor.topAnchor.constraint(equalTo: topAnchor, constant: 8),

                placeholderTitle.heightAnchor.constraint(equalToConstant: 15),
                placeholderTitle.widthAnchor.constraint(equalToConstant: 68),
                placeholderTitle.leadingAnchor.constraint(equalTo: placeholderAuthor.trailingAnchor, constant: 8),
                placeholderTitle.centerYAnchor.constraint(equalTo: placeholderAuthor.centerYAnchor),

                placeholderImage.heightAnchor.constraint(equalToConstant: 390),
                placeholderImage.trailingAnchor.constraint(equalTo: trailingAnchor),
                placeholderImage.leadingAnchor.constraint(equalTo: leadingAnchor),
                placeholderImage.topAnchor.constraint(equalTo: placeholderAuthor.bottomAnchor, constant: 8)
            ])
        }
    }
}
