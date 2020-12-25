//
//  ChatController.swift
//  Chit Chat
//
//  Created by Harleen Singh on 24/12/20.
//

import UIKit

class ChatController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let user: User
    private var messages = [Message]()
    var fromCurrentUser = false
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        messages = Service.readJson()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        customInputView.isHidden = true
        inputAccessoryView?.resignFirstResponder()
        inputAccessoryView?.isHidden = true
    }
    
    override var inputAccessoryView: UIView? {
        get {return customInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.name, prefersLargeTitles: false)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: K.chatCellIdentifier)
        collectionView.alwaysBounceVertical = true
    }
}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.chatCellIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        return cell
    }
}

extension ChatController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}

extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        
        if inputView.messageInputTextView.text != "" {
            messages.append(Message(meID: "", m: inputView.messageInputTextView.text, i: [String](), v: [String](), u: K.user, isFromCurrent: true, d: 0))
            collectionView.reloadData()
            collectionView.scrollToLast()
            inputView.messageInputTextView.text = nil
        }
        

        
    }
}
