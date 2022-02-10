//
//  ProfileViewController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/21/22.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {
    
    private let profileLabel: UILabel = UILabel(font24: "PROFILE")
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderWidth = 5
        // Обязательно указывать такой формат  cGColor
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userPhotoView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "YOUR NAME"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = .robotoMedium24()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userHeightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height: _"
        label.font = .robotoBold16()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight: _"
        label.font = .robotoBold16()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var userInfoStackView: UIStackView = UIStackView()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Editing ", for: .normal)
        button.setImage(UIImage(named: "editProfileButton"), for: .normal)
        button.titleLabel?.font = .robotoBold16()
        button.tintColor = .specialGreen
        //Attribute for force text to right
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        return button
        
    }()
    
    private let collectionViewProfile: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionVIew = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVIew.translatesAutoresizingMaskIntoConstraints = false
        collectionVIew.bounces = false
        collectionVIew.showsHorizontalScrollIndicator = false
        collectionVIew.backgroundColor = .none
        return collectionVIew
    }()
    
    private let targetLabel: UILabel = {
       let label = UILabel()
        label.text = "TARGET: 0 workouts"
        label.font = .robotoBold16()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let localRealm = try! Realm()
    private var userArray: Results<UserModel>!
    
    private let idProfileCollectionViewCell = "MyCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserParameters()
    }
    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.height / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userArray = localRealm.objects(UserModel.self)
        setupViews()
        setConstrains()
        setDelegates()
        
        
    }
    
    private func setDelegates() {
        
        collectionViewProfile.dataSource = self
        collectionViewProfile.delegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(profileLabel)
        view.addSubview(userPhotoView)
        view.addSubview(userPhotoImageView)
        view.addSubview(userNameLabel)
        userInfoStackView = UIStackView(arrangedSubviews: [userHeightLabel,userWeightLabel],
                                        axis: .horizontal, spacing: 10)
        view.addSubview(userInfoStackView)
        view.addSubview(editProfileButton)
        view.addSubview(collectionViewProfile)
        collectionViewProfile.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: idProfileCollectionViewCell)
        view.addSubview(targetLabel)
        
    }
    //MARK: - EditProfile ActionButton
    @objc private func editProfileTapped() {
        let editVC = EditProfileViewController()
        //editVC.modalPresentationStyle = .fullScreen
        editVC.delegate = self
        present(editVC, animated: true, completion: nil)
    }
    
    private func setupUserParameters() {
        if userArray.count != 0 {
            userNameLabel.text = "\(userArray[0].userFirstName) \(userArray[0].userLastName)"
            userHeightLabel.text = "Height: \(userArray[0].userHeight)"
            userWeightLabel.text = "Weight: \(userArray[0].userWeight)"
            targetLabel.text = "TARGET: \(userArray[0].userTarget) workouts"
            
            // Проверяем есть ли в БД Фото и
            guard let data = userArray[0].userImage else { return }
            //потом дальше проверяет фото и далее присваиваем фото
            guard let image = UIImage(data: data) else { return }
            userPhotoImageView.image = image
        }
    }
}

extension ProfileViewController: EditProfileVCDelegate {
    func renewVC() {
        setupUserParameters()
    }
    
}


// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    
    //MARK: - quantity of cells in CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idProfileCollectionViewCell, for: indexPath) as! ProfileCollectionViewCell
        cell.backgroundColor = .red
        return cell
    }
    
}

// MARK: - Settings CELL, Size and Spacing
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: - Size The Cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionViewProfile.frame.width / 2.07, height: 120)
    }
    
    // MARK: - Spacing beetwin cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
}


//MARK: - setConstrains
extension ProfileViewController {
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 20),
            userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 90),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            userPhotoView.topAnchor.constraint(equalTo: userPhotoImageView.topAnchor, constant: 45),
            userPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userPhotoView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.centerXAnchor.constraint(equalTo: userPhotoView.centerXAnchor),
            userNameLabel.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: 19),
            userNameLabel.bottomAnchor.constraint(equalTo: userPhotoView.bottomAnchor, constant: -15),
            userNameLabel.trailingAnchor.constraint(equalTo: userPhotoView.trailingAnchor, constant: -1)
        ])
        
        NSLayoutConstraint.activate([
            userInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            userInfoStackView.topAnchor.constraint(equalTo: userPhotoView.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            editProfileButton.topAnchor.constraint(equalTo: userPhotoView.bottomAnchor,constant: 10),
            editProfileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editProfileButton.widthAnchor.constraint(equalToConstant: 75),
            editProfileButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            collectionViewProfile.topAnchor.constraint(equalTo: userInfoStackView.bottomAnchor, constant: 25),
            collectionViewProfile.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionViewProfile.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionViewProfile.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            targetLabel.topAnchor.constraint(equalTo: collectionViewProfile.bottomAnchor, constant: 23),
            targetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
}
