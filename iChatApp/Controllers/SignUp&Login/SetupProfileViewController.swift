//
//  RegisterViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 14.10.2022.
//

import UIKit
import SnapKit
import FirebaseAuth

class SetupProfileViewController: UIViewController {
    
    private let welcomeLabel = UILabel(text: "Set up profile", font: .avenit26())
    private let photoUserView = AddPhotoView()
    private let fullNameLabel = UILabel(text: "Full name")
    private let fullNameTextField = UITextField(placeholderText: "Enter your full name")
    private let aboutLabel = UILabel(text: "About me")
    private let aboutTextField = UITextField(placeholderText: "Enter addition info about yourself")
    private let sexLabel  = UILabel(text: "Sex")
    private let sexControll = UISegmentedControl(first: "Male", second: "Female")
    private let goChattingButton = UIButton(title: "Go to charts!", titleColor: .white, backgroundColor: .black)
    private var mainStackView: UIStackView!
    private let currentUser: User!
    
    init(with currentUser: User){
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        
        goChattingButton.addTarget(self, action: #selector(goChattingBtnTapped), for: .touchUpInside)
        
        let fullNameView = TextFieldFormView(label: fullNameLabel, textField: fullNameTextField)
        let aboutView = TextFieldFormView(label: aboutLabel, textField: aboutTextField)
        let sexView = SegmentedFormView(label: sexLabel, segmentedControl: sexControll)
        mainStackView = UIStackView(arrangedView: [fullNameView, aboutView, sexView, goChattingButton], spacing: 40, axis: .vertical)
        
        view.addSubview(welcomeLabel)
        view.addSubview(photoUserView)
        view.addSubview(mainStackView)

        setupConstraits()
    }
    
    @objc private func goChattingBtnTapped(){
        FirestoreService.shared.saveProfile(with: currentUser.uid,
                                            username: fullNameTextField.text,
                                            email: currentUser.email,
                                            sex: sexControll.titleForSegment(at: sexControll.selectedSegmentIndex),
                                            avatarStringURL: nil,
                                            description: aboutTextField.text) { result in
            switch result{
            case .success(let mUser):
                self.showAlert(title: "Success", message: "Good chatting!") {
                    let mainVC = MainVC(with: mUser)
                    mainVC.modalPresentationStyle = .fullScreen
                    self.present(mainVC, animated: true, completion: nil)
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}


//MARK: --Constraits
extension SetupProfileViewController{
    
    private func setupConstraits(){
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(140)
        }
        
        photoUserView.translatesAutoresizingMaskIntoConstraints = false
        photoUserView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(welcomeLabel.snp.bottom).inset(-40)
        }
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(60)
            make.left.equalTo(view.snp.left).inset(40)
            make.right.equalTo(view.snp.right).inset(40)
        }
        
        goChattingButton.translatesAutoresizingMaskIntoConstraints = false
        goChattingButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
}
