//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Алексей Зубель on 20.02.26.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let placeholderImage = UIImage(named: "avatar-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
    }
    
    func downloadImage(from stringURL: String) {
        let imageKey = NSString(string: stringURL)
        if let image = NetworkManager.shared.cache.object(forKey: imageKey) {
            self.image = image
            return
        }
        
        guard let url = URL(string: stringURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard error == nil else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            
            NetworkManager.shared.cache.setObject(image, forKey: imageKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
