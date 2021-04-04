//
//  ChatViewController.swift
//  Flash Chat iOS13


import UIKit
import Firebase
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var messages:[Message]=[]
    let db = Firestore .firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        
        
        
        //add title for navigation bar
        title = K.appName
            //hide back btn
        navigationItem.hidesBackButton = true
        
        //register nib file
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
            
        loadMessages()
    }
    //retrive from fireStore
    func loadMessages(){
        //1-get the collection 2- order it by date 3-add the listener
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { [self] (querySnapshot, error) in
            messages = []
            if let e = error {
                print("there was an issue while retriving data from fireStore\(e)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc  in snapshotDocuments {
                        // print(doc.data())
                        let data = doc.data()
                        if let senderMessage = data [K.FStore.senderField] as? String ,let messageBody = data [K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: senderMessage, body: messageBody)
                            messages.append(newMessage)
                            DispatchQueue.main.async {
                                tableView.reloadData()
                                let indexPath = IndexPath(row: messages.count - 1, section: 0)
                                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        //save data to firestore
        //if messageTextfield.text not nil and their is a user loged in and not nil then take his email and save it in messageSender
        if let messageBody = messageTextfield.text , let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField : messageSender ,  K.FStore.bodyField : messageBody ,K.FStore.dateField :Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("thier is error in saving data to fireStore \(e)")
                }else {
                    print("successifly saving data to fireStore")
                    DispatchQueue.main.async {
                        //empty the textFiled after send the message
                        self.messageTextfield.text = ""
                    }
                }
            }
                                                                  
          
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
       //signOut() throw exception
    do {
      try  Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
          }
    
}
extension ChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageTableViewCell
        cell.label.text = message.body
        // this is message from current login user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor =  UIColor(named: K.BrandColors.purple)
        // this is message from another sender
        }else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor =  UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
    
    
}

