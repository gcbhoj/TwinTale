//
//  MoralEntryPageTableViewController.swift
//  TwinTale
//
//  Created by Default User on 11/30/25.
//

import UIKit
import CoreData

class MoralEntryPageTableViewController: UITableViewController {
    
    //MARK: CurrentGameData
    var gameData: GameData?
    var categoryName: String?
    var loggedInUser: NewUser?
    var currentStory: StoryList?
    
    var userEnteredMorals:[MoralPart] = []
    
    
    // MARK: - Timer
    var timerLabel: UITextField!
    var countdownTimer: Timer?
    var remainingSeconds = 60   // 1 minute for one hout use 60*60

    // MARK: - Footer References
    var inputField: UITextField!
    var sendButton: UIButton!
    var completeStoryButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let game = gameData else {
            print("ERROR: gameData is nil when loading MoralEntryPage.")
            return
        }
        
        userEnteredMorals = fetchMoralParts(for: game)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MoralEntryPageTableViewCell")
        tableView.separatorStyle = .none
        startTimer()
        tableView.reloadData()
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToGrandReveal" {
            let vc = segue.destination as! GrandRevealViewController
            
            vc.gameData = gameData
            vc.loggedInUser = loggedInUser
            vc.currentStory = currentStory

        }

    }
    //MARK: -  CORE DATA CONTEXT

    func persistentContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    }
    
    
     //MARK: - Changing the User Story to be complete in Coredata
     func updateGameStatus() {
         guard let context = gameData?.managedObjectContext else { return }

         gameData?.isStoryComplete = true
         gameData?.isMoralComplete = true

         do {
             try context.save()
             print("Game status updated!")
         } catch {
             print("Failed to save game status: \(error)")
         }
     }
    
    //MARK: Add new User Moral
    func addMoralPart(to game: GameData, participantId: String?,participantName: String?, text: String, order: Int64?) {
        let ctx = persistentContext()
        let part = MoralPart(context: ctx)
        part.participantId = participantId
        part.participantName = participantName
        part.text = text
        if let o = order { part.order = o }
        game.addToMoralParts(part)
        do { try ctx.save() } catch { print("Error adding moral part:", error) }
    }
    
    //MARK: - log out Button Action
    @objc func loggingOutUser(){
        logOutUser()
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    //MARK: - Logging A user OUt
    func logOutUser (){
        loggedInUser = nil
    }
    //MARK: Get all morals from coredata
    
    func fetchMoralParts(for game: GameData) -> [MoralPart] {
        let ctx = persistentContext()
        let req: NSFetchRequest<MoralPart> = MoralPart.fetchRequest()
        req.predicate = NSPredicate(format: "gameData == %@", game)
        req.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        do { return try ctx.fetch(req) } catch { print(error); return [] }
    }
    
    
    // MARK: - Timer Functions
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(updateTimer),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    @objc func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            timerLabel.text = formatTime(remainingSeconds)
        } else {
            countdownTimer?.invalidate()
            timerLabel.text = "00:00:00"
            
            // Disable input when timer ends
            inputField.isEnabled = false
            sendButton.isEnabled = false
            
            updateGameStatus()
            
            // Automatically navigate to next page
            performSegue(withIdentifier: "goToGrandReveal", sender: self)
        }
    }
    
    func formatTime(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
    
    // MARK: - Button Actions
    @objc func sendMessage() {
        addMoralPart(to: gameData!, participantId: loggedInUser?.userId, participantName: loggedInUser?.user_Name, text: inputField.text!, order: Int64(userEnteredMorals.count + 1))
        
        // CLEAR FIELD
        inputField.text = ""

        // RELOAD DATA FROM CORE DATA
        userEnteredMorals = fetchMoralParts(for: gameData!)

        // REFRESH TABLE UI
        tableView.reloadData()

        // SCROLL TO BOTTOM
        let lastIndex = IndexPath(row: userEnteredMorals.count - 1, section: 0)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
    
    @objc func completeTask() {
        // Disable input/buttons
        inputField.isEnabled = false
        sendButton.isEnabled = false
        completeStoryButton.isEnabled = false
        
        // Navigate
        performSegue(withIdentifier: "goToScoreBoard", sender: self)
    }
    // MARK: - TableView Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray6

        // MARK: - LEFT: LOGO
   
        let logoImage = UIImageView(image: UIImage(named: "logo"))
        logoImage.contentMode = .scaleAspectFit
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImage.widthAnchor.constraint(equalToConstant: 140),
            logoImage.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        

        // MARK: - TIME STACK

        let timeLabel = UILabel()
        timeLabel.text = "Time Left:"
        timeLabel.font = .boldSystemFont(ofSize: 12)

        timerLabel = UITextField()
        timerLabel.text = formatTime(remainingSeconds)
        timerLabel.font = .systemFont(ofSize: 12)
        timerLabel.borderStyle = .roundedRect
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.isUserInteractionEnabled = false
        
        let timeStack = UIStackView(arrangedSubviews: [timeLabel, timerLabel])
        timeStack.axis = .horizontal
        timeStack.spacing = 3
        timeStack.alignment = .center
        timeStack.translatesAutoresizingMaskIntoConstraints = false
        
        

        //MARK: -  LOGOUT BUTTON

        let logOutButton = UIButton(type: .system)
        logOutButton.setTitle("Logout", for: .normal)
        logOutButton.titleLabel?.font = .systemFont(ofSize: 12)
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.backgroundColor = .systemGray
        logOutButton.layer.cornerRadius = 6
        logOutButton.clipsToBounds = true
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        logOutButton.addTarget(self,
                               action: #selector(loggingOutUser),
                               for: .touchUpInside)

        NSLayoutConstraint.activate([
            logOutButton.heightAnchor.constraint(equalToConstant: 30),
            logOutButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
        
        
       
        //MARK: - TOP RIGHT ROW: TIME LEFT + LOGOUT RIGHT
        
        let topRightStack = UIStackView(arrangedSubviews: [timeStack, logOutButton])
        topRightStack.axis = .horizontal
        topRightStack.spacing = 5
        topRightStack.distribution = .fill
        topRightStack.alignment = .center
        topRightStack.translatesAutoresizingMaskIntoConstraints = false
        
        
  
        // MARK: - CATEGORY STACK

        let categoryLabel = UILabel()
        categoryLabel.text = "Category:"
        categoryLabel.font = .boldSystemFont(ofSize: 16)

        let categoryTypeLabel = UILabel()
        categoryTypeLabel.text = categoryName
        categoryTypeLabel.font = .systemFont(ofSize: 16)

        let categoryStack = UIStackView(arrangedSubviews: [
            categoryLabel,
            categoryTypeLabel
        ])
        categoryStack.axis = .vertical
        categoryStack.spacing = 6
        categoryStack.alignment = .leading
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        
        let moralGuessLabel = UILabel()
        moralGuessLabel.text = "Moral Guess Reward 50,000"
        moralGuessLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
       
        //MARK: -  RIGHT STACK (top + category)
    
        let rightStack = UIStackView(arrangedSubviews: [
            moralGuessLabel,
            topRightStack,
            categoryStack
        ])
        rightStack.axis = .vertical
        rightStack.spacing = 10
        rightStack.alignment = .leading
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        
        
    
        //MARK: -  MAIN TOP ROW: LEFT + RIGHT
       
        let topStack = UIStackView(arrangedSubviews: [
            logoImage,
            rightStack
        ])
        topStack.axis = .horizontal
        topStack.spacing = 16
        topStack.alignment = .top
        topStack.translatesAutoresizingMaskIntoConstraints = false

       headerView.addSubview(topStack)

        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerView.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }

    // MARK: - TableView Footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor.systemGray6
        
        // Input Field
        inputField = UITextField()
        inputField.placeholder = "Enter Your Part..."
        inputField.borderStyle = .roundedRect
        inputField.translatesAutoresizingMaskIntoConstraints = false
        
        // Send Button
        sendButton = UIButton(type: .system)
        sendButton.setImage(UIImage(named: "Send"), for: .normal)
        sendButton.tintColor = .systemBlue      // optional (affects SF Symbols)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        let inputStack = UIStackView(arrangedSubviews: [inputField, sendButton])
        inputStack.axis = .horizontal
        inputStack.spacing = 8
        inputStack.alignment = .center
        inputStack.distribution = .fillProportionally
        
       
        let stack = UIStackView(arrangedSubviews: [inputStack])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8)
        ])

        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 120
    }

    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEnteredMorals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MoralEntryPageTableViewCell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let msg = userEnteredMorals[indexPath.row]

        // Sender Label
        let senderLabel = UILabel()
        
        senderLabel.text = msg.participantName
        senderLabel.font = UIFont.boldSystemFont(ofSize: 15)

        // Message Label
        let messageLabel = UILabel()
        messageLabel.text = msg.text
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.numberOfLines = 0

        // Stack
        let stack = UIStackView(arrangedSubviews: [senderLabel, messageLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12)
        ])

        return cell
    }


    

}
