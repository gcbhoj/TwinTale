//
//  GamePageTableViewController.swift
//  TwinTale
//
//  Created by Default User on 11/28/25.
//

import UIKit
import CoreData

class GamePageTableViewController: UITableViewController {
    
    
    var categoryId: Int64 = 0
    var story: StoryList?
    var storyFirstLine: String?
    var categoryName: String?
    var loggedInUser: NewUser?
    var gameData: GameData?
    var currentStory: StoryList?

    
    var userStoryParts:[StoryPart] = []

   // MARK: - Timer
    var timerLabel: UITextField!
    var countdownTimer: Timer?
    var remainingSeconds = 60   // 1 minute for 24 hours use 24*60*60

    // MARK: - Footer References
    var inputField: UITextField!
    var sendButton: UIButton!
   

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex:"8CD4E6")
        tableView.backgroundColor = UIColor(hex:"8CD4E6")
        
        // fetching user Story Parts
        userStoryParts = fetchStoryParts(for: gameData!)
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GamePageTableViewCell")
        tableView.separatorStyle = .none
        startTimer()
        tableView.reloadData()
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToMoralPage" {
            let vc = segue.destination as! MoralEntryPageTableViewController
            
            vc.gameData = gameData
            vc.categoryName = categoryName
            vc.loggedInUser = loggedInUser
            vc.currentStory = currentStory

        }

    }
    //MARK: -  CORE DATA CONTEXT

    func persistentContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
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
    
    @objc func sendMessage() {

        guard let text = inputField.text, !text.isEmpty else { return }

        // Add new part
        addStoryPart(to: gameData!,
                     participantId: loggedInUser?.userId,
                     participantName: loggedInUser?.user_Name,
                     text: text,
                     order: Int64(userStoryParts.count + 1))

        // CLEAR FIELD
        inputField.text = ""

        // RELOAD DATA FROM CORE DATA
        userStoryParts = fetchStoryParts(for: gameData!)

        // REFRESH TABLE UI
        tableView.reloadData()

        // SCROLL TO BOTTOM
        DispatchQueue.main.async {
            
            guard self.userStoryParts.count > 0 else { return }
            
            let lastIndex = IndexPath(row: self.userStoryParts.count - 1,
                                      section: 0)

            self.tableView.scrollToRow(at: lastIndex,
                                       at: .bottom,
                                       animated: true)
        }
    }


    //MARK: -  Add data to story parts
    func addStoryPart(to game: GameData, participantId: String?,participantName: String?, text: String,order: Int64?) {
        let ctx = persistentContext()
        let part = StoryPart(context: ctx)
        part.participantId = participantId
        part.participantName = participantName
        part.text = text
        if let o = order { part.order = o }
        game.addToStoryParts(part) // generated helper from Codegen
        do { try ctx.save() } catch { print("Error adding story part:", error) }
    }
    
    //MARK: - Retreive story parts by GameData
    func fetchStoryParts(for game: GameData) -> [StoryPart]{
        
        let context = persistentContext()
        let req: NSFetchRequest<StoryPart> = StoryPart.fetchRequest()
        req.predicate = NSPredicate(format: "gameData == %@", game)
        req.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        do { return try context.fetch(req) } catch { print(error); return [] }
        
    }
    
    
    // MARK: - Timer Functions
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(updateTimer),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    //MARK: - Timer Update
    
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
           
            
            // Automatically navigate to next page
            performSegue(withIdentifier: "goToMoralPage", sender: self)
        }
    }
    //MARK: - Formatting Time
    
    func formatTime(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
    

    
    
    // MARK: - TableView Header
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "8CD4E6")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        
      
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
        
        
       
        //MARK: -  RIGHT STACK (top + category)
    
        let rightStack = UIStackView(arrangedSubviews: [
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
        
        
       
        // MARK: - STARTING LINE (OUTSIDE ABOVE STACK)
        
        let startingLineLabel = UILabel()
        startingLineLabel.text = "Starting Line:"
        startingLineLabel.font = .boldSystemFont(ofSize: 16)

        let startingLineDisplay = UITextView()
        startingLineDisplay.text = storyFirstLine
        startingLineDisplay.font = .systemFont(ofSize: 14)
        startingLineDisplay.isEditable = false
        startingLineDisplay.isScrollEnabled = false
        startingLineDisplay.backgroundColor = .clear
        startingLineDisplay.translatesAutoresizingMaskIntoConstraints = true

        // FIX: Remove internal padding
        startingLineDisplay.textContainerInset = .zero
        startingLineDisplay.textContainer.lineFragmentPadding = 0

        // FIX: Allow expansion in stack view
        startingLineDisplay.setContentHuggingPriority(.required, for: .vertical)
        startingLineDisplay.setContentCompressionResistancePriority(.required, for: .vertical)

        let startingLineStack = UIStackView(arrangedSubviews: [
            startingLineLabel,
            startingLineDisplay
        ])
        startingLineStack.axis = .vertical
        startingLineStack.spacing = 4
        startingLineStack.alignment = .leading
        startingLineStack.translatesAutoresizingMaskIntoConstraints = false

        
        
     
        //MARK: FINAL MAIN STACK
        
        let mainStack = UIStackView(arrangedSubviews: [
            topStack,
            startingLineStack
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 5
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        headerView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12)
        ])

        return headerView
    }


    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }

    // MARK: - TableView Footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor(hex:"8CD4E6")
        
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
        return userStoryParts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "GamePageTableViewCell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let msg = userStoryParts[indexPath.row]

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
extension CategoryList {
    var displayName: String {
        switch self {
        case .Friendship: return "Friendship"
        case .CourageAndBravery: return "Courage & Bravery"
        case .Responsibility: return "Responsibility"
        case .MagicAndFantasy: return "Magic & Fantasy"
        case .HonestyAndTruth: return "Honesty & Truth"
        case .Adventure: return "Adventure"
        case .FamilyAndHome: return "Family & Home"
        case .AnimalsAndNature: return "Animals & Nature"
        case .RespectAndGoodManners: return "Respect & Good Manners"
        }
    }
}

