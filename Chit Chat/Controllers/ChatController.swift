//
//  ChatController.swift
//  Chit Chat
//
//  Created by Harleen Singh on 24/12/20.
//

import UIKit

class ChatController: UICollectionViewController {
    
    //MARK: - Properties
    
    var offset = 1
    var firstTime = true
    var scrollViewMinContentY: CGFloat = 0
    private let user: User
    private var messages = [Message]()
    var fromCurrentUser = false
    let maxHeightForTextView: CGFloat = 100
    private lazy var customInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        iv.messageInputTextView.delegate = self
        return iv
    }()
    
    let spinner = UIActivityIndicatorView(style: .medium)
    
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
        print(collectionView.contentOffset)
        messages = Service.readJson(offset: offset)
        offset = offset + 1
        DispatchQueue.main.async {
            let lastIndexPath = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: lastIndexPath, at: .centeredVertically, animated: false)
        }
//        collectionView.scrollToLast()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // force layout before scrolling to most recent
        collectionView.layoutIfNeeded()
        // now you can scroll however you want
        // e.g. scroll to the right
       
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
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.bounces = false
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.name, prefersLargeTitles: false)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: K.chatCellIdentifier)
        
        
        spinner.color = UIColor.systemBlue
//        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: collectionView.bounds.width, height: CGFloat(44))
        collectionView.addSubview(spinner)
        
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
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        if (scrollView.contentOffset.y == scrollViewMinContentY && !firstTime && offset <= 10){
            spinner.startAnimating()
            let oldMessages = Service.readJson(offset: self.offset)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                
                self.offset = self.offset + 1
                self.messages.insert(contentsOf: oldMessages, at: 0)
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(row: 21, section: 0), at: UICollectionView.ScrollPosition.centeredVertically, animated: false)
                self.spinner.stopAnimating()
            }
            
        }

        if firstTime {
            scrollViewMinContentY = scrollView.contentOffset.y
            firstTime = false
        }
        
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
            adjustUITextViewHeight(arg: inputView.messageInputTextView)
        }

    }
    
}

extension ChatController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == customInputView.messageInputTextView {
            
            adjustUITextViewHeight(arg: textView)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        collectionView.scrollToLast()
    }
    
    func adjustUITextViewHeight(arg : UITextView){
        
        let numOfLines = Int(arg.contentSize.height / (arg.font?.lineHeight)!)
        
        if numOfLines < K.numberOfLinesForChatInputTextView {
            
            arg.translatesAutoresizingMaskIntoConstraints = true
            arg.sizeToFit()
            arg.frame.size.width = UIScreen.main.bounds.width - 66
            
        }
        else{
            
            arg.isScrollEnabled = true
            
        }
    }
}
