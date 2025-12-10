//
//  GrandRevealViewController.swift
//  TwinTale
//
//  Created by Default User on 12/10/25.
//

import UIKit
import CoreData

class GrandRevealViewController: UIViewController {
    
    //MARK: PASSED DATA
    var gameData: GameData?
    var loggedInUser: NewUser?
    var currentStory: StoryList?
    
    //MARK: DISPLAY DATA
    var logoImageView = UIImageView()
    var pageTitle = UILabel()
    var logOutButton = UIButton()
    var moralLabel = UILabel()
    var moralText = UITextView()
    var storyTitleLabel = UILabel()
    var storyText = UITextView()
    var userStoryLabel = UILabel()
    var userStoryText = UITextView()
    var originalStoryLabel = UILabel()
    var originalStoryText = UITextView()
    var quitButton = UIButton()
    var viewScoreboard = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()

        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: -  CORE DATA CONTEXT

    func persistentContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    }
    
    //MARK: Retreive Moral from Stroy List
    
    func fetchStoryMoral(from storyList: StoryList)-> String{
        
        return storyList.storyMoral!
    }
    
    //MARK: Retrive title from story list
    
    func fetchStoryTitle(from storyList: StoryList) -> String{
        
        return storyList.storyTitle!
    }
    
    // MARK: Retrieve all lines from story parts
    func fetchUserParts(for game: GameData) -> String {
        
        // Fetch all parts
        let userStoryParts = fetchStoryParts(for: game)
        
        // Combine the text fields
        let combinedStory = userStoryParts
            .map { $0.text! }          // extract each line
            .joined(separator: "\n") // join with newline
        
        return combinedStory
    }

    
    //MARK: - Retreive story parts by GameData
    func fetchStoryParts(for game: GameData) -> [StoryPart]{
        
        let context = persistentContext()
        let req: NSFetchRequest<StoryPart> = StoryPart.fetchRequest()
        req.predicate = NSPredicate(format: "gameData == %@", game)
        req.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        do { return try context.fetch(req) } catch { print(error); return [] }
        
    }
    
    // MARK: - Retrieve Story from StoryList
    func retrieveStory(from storyList: StoryList) -> String {
        return storyList.storyContent!
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
    
    
    //MARK: Quit Button Function
    @objc func quitButtonFunction(){
        performSegue(withIdentifier: "GoToHomePage", sender: self)
        
    }
    
    //MARK: UI SETUP
    func setUpUI() {

        view.backgroundColor = UIColor(hex: "#90B6CC")

        // ------------------------
        // SCROLL VIEW + CONTENT
        // ------------------------
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // ------------------------
        // LOGO
        // ------------------------
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 110).isActive = true

        // ------------------------
        // TITLE + LOGOUT STACK
        // ------------------------
        pageTitle.text = "Grand Reveal"
        pageTitle.font = .boldSystemFont(ofSize: 20)
        pageTitle.textAlignment = .center

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

        let titleStack = UIStackView(arrangedSubviews: [pageTitle, logOutButton])
        titleStack.axis = .horizontal
        titleStack.alignment = .center
        titleStack.distribution = .equalSpacing
        titleStack.translatesAutoresizingMaskIntoConstraints = false

        // ------------------------
        // MORAL STACK
        // ------------------------
        moralLabel.text = "Category:"
        moralLabel.font = .boldSystemFont(ofSize: 16)

        moralText.text = fetchStoryMoral(from: currentStory!)
        moralText.font = .systemFont(ofSize: 16)
        moralText.isEditable = false
        moralText.isScrollEnabled = false
        moralText.backgroundColor = .clear
        moralText.translatesAutoresizingMaskIntoConstraints = true
        
        
        let moralStack = UIStackView(arrangedSubviews: [titleStack, moralLabel, moralText])
        moralStack.axis = .vertical
        moralStack.spacing = 4
        moralStack.translatesAutoresizingMaskIntoConstraints = false

        // combine logo + moral
        let topStack = UIStackView(arrangedSubviews: [logoImageView, moralStack])
        topStack.axis = .horizontal
        topStack.spacing = 12
        topStack.alignment = .center
        topStack.translatesAutoresizingMaskIntoConstraints = false

        // ------------------------
        // STORY STACK
        // ------------------------
        storyTitleLabel.text = "Story Title:"
        storyText.text = fetchStoryTitle(from: currentStory!)
        storyText.font = .systemFont(ofSize: 14)
        storyText.isEditable = false
        storyText.isScrollEnabled = false
        storyText.backgroundColor = .clear
        storyText.translatesAutoresizingMaskIntoConstraints = true
        
        let storyStack = UIStackView(arrangedSubviews: [storyTitleLabel, storyText])
        storyStack.axis = .vertical
        storyStack.spacing = 4
        storyStack.translatesAutoresizingMaskIntoConstraints = false

        // combine top + story
        let headerStack = UIStackView(arrangedSubviews: [topStack, storyStack])
        headerStack.axis = .vertical
        headerStack.spacing = 12
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        // ------------------------
        // LABELS + TEXTBOXES
        // ------------------------

        userStoryLabel.text = "Your Story"
        userStoryLabel.font = .boldSystemFont(ofSize: 16)

        userStoryText.backgroundColor = UIColor(hex: "#4E5968")
        userStoryText.text = fetchUserParts(for: gameData!)
        userStoryText.textColor = .white
        userStoryText.layer.cornerRadius = 16
        userStoryText.isEditable = false
        userStoryText.font = .systemFont(ofSize: 15)
        userStoryText.heightAnchor.constraint(equalToConstant: 300).isActive = true

        originalStoryLabel.text = "Original Story"
        originalStoryLabel.font = .boldSystemFont(ofSize: 16)
        
        originalStoryText.backgroundColor = UIColor(hex: "#4E5968")
        originalStoryText.text = retrieveStory(from: currentStory!)
        originalStoryText.textColor = .white
        originalStoryText.isEditable = false
        originalStoryText.layer.cornerRadius = 16
        originalStoryText.font = .systemFont(ofSize: 15)
        originalStoryText.heightAnchor.constraint(equalToConstant: 450).isActive = true

        // ------------------------
        // BOTTOM BUTTONS
        // ------------------------

        quitButton.setTitle("Quit", for: .normal)
        quitButton.backgroundColor = UIColor(hex: "#1877F2")
        quitButton.layer.cornerRadius = 12
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        quitButton.addTarget(self,
                             action: #selector(quitButtonFunction),
                               for: .touchUpInside)
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false

        let bottomButtonStack = UIStackView(arrangedSubviews: [spacer, quitButton])
        bottomButtonStack.axis = .horizontal
        bottomButtonStack.spacing = 16
        bottomButtonStack.translatesAutoresizingMaskIntoConstraints = false

        // ------------------------
        // MAIN STACK
        // ------------------------

        let mainStack = UIStackView(arrangedSubviews: [
            topStack,
            headerStack,
            userStoryLabel,
            userStoryText,
            originalStoryLabel,
            originalStoryText,
            bottomButtonStack
        ])

        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }


    
    
    

}
