//
//  TestViewController.swift
//  GHFollowers
//
//  Created by Алексей Зубель on 27.02.26.
//

import UIKit

class TestViewController: UIViewController {
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 8
        return view
    }()
    
    let avatarImageView: UIImageView = {
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.image = UIImage(named: "avatar")
        avatar.layer.cornerRadius = 20
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        return avatar
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Name Surname"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    let descriptionTitleLabel: UILabel = {
        let descriptionTitleLabel = UILabel()
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitleLabel.text = "iOS Developer"
        descriptionTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionTitleLabel.textColor = .gray
        return descriptionTitleLabel
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "iOS Developers are best people in the world of informational technologies"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 2
        return descriptionLabel
    }()
    
    let titleStack: UIStackView = {
        let titleStack = UIStackView()
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        titleStack.axis = .horizontal
        titleStack.alignment = .center
        titleStack.spacing = 16
        return titleStack
    }()
    
    let titleVerticalStack: UIStackView = {
        let titleVerticalStack = UIStackView()
        titleVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        titleVerticalStack.axis = .vertical
        titleVerticalStack.alignment = .leading
        titleVerticalStack.spacing = 16
        return titleVerticalStack
    }()
    
    lazy var colorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change Color", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func buttonTap() {
        let colors: [UIColor] = [.red, .systemGreen, .orange, .purple, .black, .systemTeal]
        let randomColor = colors.randomElement() ?? .black
        
        // Анимация для красоты (не обязательно, но приятно)
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.textColor = randomColor
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) // Чуть увеличим
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.titleLabel.transform = .identity // Вернем размер
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup Methods
    private func setupViews() {
        view.backgroundColor = .systemGroupedBackground // Чуть серый фон, чтобы видеть белую карточку
        
        // Добавляем карточку на главный экран
        view.addSubview(cardView)
        
        // Собираем стэки
        titleVerticalStack.addArrangedSubview(titleLabel)
        titleVerticalStack.addArrangedSubview(descriptionTitleLabel)
        
        titleStack.addArrangedSubview(avatarImageView)
        titleStack.addArrangedSubview(titleVerticalStack)
        
        // Добавляем контент ВНУТРЬ карточки
        cardView.addSubview(titleStack)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(colorButton)

        // Не забываем про маску для descriptionLabel, так как он не в стэке в моем решении (можно и в стэк)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 1. Констрейнты для Карточки (cardView)
            // Прибиваем к верху (safeArea) и бокам
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            // Высота карточки определится её содержимым (Intrinsic Content Size),
            // но нам нужно привязать нижний край к контенту внутри + отступ
            cardView.bottomAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 16),

            // 2. Констрейнты для Аватара (размер)
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),

            // 3. Констрейнты Header Stack (Аватар + Тексты)
            titleStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // 4. Констрейнты Описания
            descriptionLabel.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            colorButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            colorButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            colorButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }
}
