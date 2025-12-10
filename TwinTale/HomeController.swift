//
//  HomeController.swift
//  TwinTale
//
//  Created by Default User on 12/7/25.
//

import UIKit
import CoreData

//MARK:- Enums to define categories with their id
enum CategoryList:Int64{
    case Friendship = 101
    case CourageAndBravery = 102
    case Responsibility = 103
    case MagicAndFantasy = 104
    case HonestyAndTruth = 105
    case Adventure = 106
    case FamilyAndHome = 107
    case AnimalsAndNature = 108
    case RespectAndGoodManners = 109
}

class HomeController: UIViewController {
    
    // header view
    let logoImageView = UIImageView()
    let headerView = UILabel()
    let logOutButton = UIButton()
    
    //favorites
    let favoritesHeaderView = UILabel()
    let friendshipButton = UIButton()
    let courageAndBraveryButton = UIButton()
    let responsibilityButton = UIButton()
    
    //categories
    let categoriesHeaderView = UILabel()
    let magicAndFantacyButton = UIButton()
    let honestyAndTruthButton = UIButton()
    let adventureButton = UIButton()
    let familyAndHomeButton = UIButton()
    let animalsAndNatureButton = UIButton()
    let respectAndGoodMannersButton = UIButton()
    
    
    var loggedInUser: NewUser?
    var currentStory: StoryList?
    var currentGame:GameData?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex:"2B84E3")
        
        setUpUI()
        
        self.setUpInitialData()
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToGamePage" {
            let vc = segue.destination as! GamePageTableViewController
            
            if let story = currentStory {
                vc.categoryId = story.categoryId
                vc.story = story
                vc.gameData = currentGame
                vc.loggedInUser = loggedInUser
                vc.currentStory = currentStory
                
                // First line
                vc.storyFirstLine = firstLine(from: story.storyContent)
                
                // Convert category ID → enum → name
                if let categoryEnum = CategoryList(rawValue: story.categoryId) {
                    vc.categoryName = categoryEnum.displayName
                }
            }
        }
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
    
    //MARK: - Function to go to game page
    @objc func categoryButtonTapped(_ sender: UIButton) {
            let id = Int64(sender.tag)

            guard CategoryList(rawValue: id) != nil else {
                print("Invalid Category ID")
                return
            }

            guard let story = retrieveRandomStory(by: id) else {
                print("ERROR: No story found for category \(id)")
                return
            }

            currentStory = story
            
            // create game entry
            currentGame = createGameData(for: story)

            if let gameId = currentGame?.gameDataId {
                print("Created Game ID:", gameId)
            }

            performSegue(withIdentifier: "GoToGamePage", sender: self)
        }
    
    //MARK: -  CORE DATA CONTEXT
    func persistentContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    }
    
    //MARK: - Function to check Existing Game
    func fetchIncompleteGame(for story: StoryList) -> GameData? {
        let context = persistentContext()
        
        let request: NSFetchRequest<GameData> = GameData.fetchRequest()
        request.predicate = NSPredicate(format: "story == %@ AND isStoryComplete == NO AND isMoralComplete == NO" , story)
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            return result.first
        } catch {
            print("Error fetching incomplete game:", error)
            return nil
        }
    }
    
    
    //MARK:  FUNCTION TO CREATE A NEW GAME DATA
    func createGameData(for story: StoryList)-> GameData {
        
        if let existingGame = fetchIncompleteGame(for: story) {
            print("Returning existing incomplete game:", existingGame.gameDataId ?? "N/A")
            return existingGame
        }
        
        let context = persistentContext()
        let game = GameData(context: context)
        game.gameDataId = generateGameId()
        game.createdDate = Date()
        game.story = story
        game.isStoryComplete = false
        game.isMoralComplete = false
        
        do{
            try context.save()
        }catch{
            print("Game Data Createion error: ", error)
        }
        
        return game
        
    }
    
    //MARK: - GENERATE UNIQUE ID FOR GAMEID
    func generateGameId() -> String {
        return "GD\(Int.random(in: 1000...9999))"
    }

    
    //MARK: - Function to extract the first line from the story
    
    func firstLine(from text: String?) -> String {
        guard let text = text else { return "" }

        return text
            .components(separatedBy: .newlines)
            .first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty }) ?? ""
    }

    //MARK: - Retreive One Story from dB by categoryId
    
    func retrieveRandomStory(by categoryId: Int64) -> StoryList? {
        
        let context = persistentContext()
        
        let request: NSFetchRequest<StoryList> = StoryList.fetchRequest()
        request.predicate = NSPredicate(format: "categoryId == %d", categoryId)
        
        do {
            let results = try context.fetch(request)
            return results.randomElement()
        } catch {
            print("Error:", error)
            return nil
        }
    }
       
       //MARK: - Function to check if the story exists by story id
       
       func storyExists(id: String) -> Bool {
           
           let context = persistentContext()
           let request: NSFetchRequest<StoryList> = StoryList.fetchRequest()
           request.predicate = NSPredicate(format: "storyId == %@", id)
           
           do {
               return try context.count(for: request) > 0
           } catch {
               print("Error checking story existence:", error)
               return false
           }
       }
   
    //MARK: - UI Setup
    
    func setUpUI() {

        
        //MARK:  SCROLL VIEW SETUP
      
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


        //MARK:  LOGO
       
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true

 
        // MARK: HEADER TEXT

        headerView.text = "Select Category"
        headerView.font = .systemFont(ofSize: 22, weight: .bold)
        headerView.textAlignment = .center
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        headerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        headerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        
        //MARK: Logout Button
        logOutButton.setTitle("Logout", for: .normal)
        logOutButton.titleLabel?.font = .systemFont(ofSize: 14)
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.backgroundColor = .systemGray
        logOutButton.layer.cornerRadius = 6
        logOutButton.clipsToBounds = true
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        

        logOutButton.addTarget(self,
                               action: #selector(loggingOutUser),
                               for: .touchUpInside)
        logOutButton.setContentHuggingPriority(.required, for: .horizontal)
        logOutButton.setContentHuggingPriority(.required, for: .horizontal)
        logOutButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            logOutButton.heightAnchor.constraint(equalToConstant: 30),
            logOutButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
        
        let categoryHeaderStack = UIStackView(arrangedSubviews:[
            logOutButton,
            headerView]
        )
        categoryHeaderStack.axis = .vertical
        categoryHeaderStack.spacing = 12
        categoryHeaderStack.alignment = .center
        categoryHeaderStack.translatesAutoresizingMaskIntoConstraints = false
        
        let headerStack = UIStackView(arrangedSubviews: [
            logoImageView,
            categoryHeaderStack

        ])

        headerStack.axis = .horizontal
        headerStack.spacing = 12
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        headerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        logOutButton.setContentHuggingPriority(.required, for: .horizontal)

        contentView.addSubview(headerStack)

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            logOutButton.heightAnchor.constraint(equalToConstant: 30),
            logOutButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])

       
        //MARK:  FAVORITES SECTION
       
        favoritesHeaderView.text = "Favorites"
        favoritesHeaderView.font = .systemFont(ofSize: 22, weight: .bold)
        favoritesHeaderView.textAlignment = .left

        friendshipButton.setImage(UIImage(named: "Friendship (1)"), for: .normal)
        friendshipButton.widthAnchor.constraint(equalToConstant: 161).isActive = true
        friendshipButton.heightAnchor.constraint(equalToConstant: 108).isActive = true
        friendshipButton.tag = Int(CategoryList.Friendship.rawValue)

        courageAndBraveryButton.setImage(UIImage(named: "Courage_Bravery"), for: .normal)
        courageAndBraveryButton.widthAnchor.constraint(equalToConstant: 161).isActive = true
        courageAndBraveryButton.heightAnchor.constraint(equalToConstant: 108).isActive = true
        courageAndBraveryButton.tag = Int(CategoryList.CourageAndBravery.rawValue)

        responsibilityButton.setImage(UIImage(named: "Responsibility (1)"), for: .normal)
        responsibilityButton.widthAnchor.constraint(equalToConstant: 161).isActive = true
        responsibilityButton.heightAnchor.constraint(equalToConstant: 108).isActive = true
        responsibilityButton.tag = Int(CategoryList.Responsibility.rawValue)

        let favoritesRow = UIStackView(arrangedSubviews: [
            friendshipButton,
            courageAndBraveryButton
        ])
        favoritesRow.axis = .horizontal
        favoritesRow.spacing = 12
        favoritesRow.distribution = .fillEqually

        let favoritesContainer = UIStackView(arrangedSubviews: [
            favoritesHeaderView,
            favoritesRow,
            responsibilityButton
        ])
        favoritesContainer.axis = .vertical
        favoritesContainer.spacing = 16
        favoritesContainer.alignment = .leading
        favoritesContainer.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(favoritesContainer)

        NSLayoutConstraint.activate([
            favoritesContainer.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 24),
            favoritesContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            favoritesContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

   
        // MARK: CATEGORIES SECTION
     
        categoriesHeaderView.text = "Categories"
        categoriesHeaderView.font = .systemFont(ofSize: 22, weight: .bold)

        magicAndFantacyButton.setImage(UIImage(named: "Magic_fantasy"), for: .normal)
        magicAndFantacyButton.widthAnchor.constraint(equalToConstant: 161).isActive = true
        magicAndFantacyButton.heightAnchor.constraint(equalToConstant: 108).isActive = true
        magicAndFantacyButton.tag = Int(CategoryList.MagicAndFantasy.rawValue)

        honestyAndTruthButton.setImage(UIImage(named: "Honesty_Truth"), for: .normal)
        honestyAndTruthButton.widthAnchor.constraint(equalToConstant: 161).isActive = true
        honestyAndTruthButton.heightAnchor.constraint(equalToConstant: 108).isActive = true
        honestyAndTruthButton.tag = Int(CategoryList.HonestyAndTruth.rawValue)

        let categoriesTopStack = UIStackView(arrangedSubviews: [
            magicAndFantacyButton,
            honestyAndTruthButton
        ])
        categoriesTopStack.axis = .horizontal
        categoriesTopStack.spacing = 12
        categoriesTopStack.distribution = .fillEqually

        adventureButton.setImage(UIImage(named: "Adventurebut"), for: .normal)
        adventureButton.widthAnchor.constraint(equalToConstant: 161).isActive = true
        adventureButton.heightAnchor.constraint(equalToConstant: 108).isActive = true

        familyAndHomeButton.setImage(UIImage(named: "Family_Home"), for: .normal)
        familyAndHomeButton.widthAnchor.constraint(equalToConstant: 161).isActive = true
        familyAndHomeButton.heightAnchor.constraint(equalToConstant: 108).isActive = true

        let categoriesSecondStack = UIStackView(arrangedSubviews: [
            adventureButton,
            familyAndHomeButton
        ])
        categoriesSecondStack.axis = .horizontal
        categoriesSecondStack.spacing = 12
        categoriesSecondStack.distribution = .fillEqually

        animalsAndNatureButton.setImage(UIImage(named: "Animals_Nature"), for: .normal)
        animalsAndNatureButton.widthAnchor.constraint(equalToConstant: 161).isActive = true
        animalsAndNatureButton.heightAnchor.constraint(equalToConstant: 108).isActive = true

        respectAndGoodMannersButton.setImage(UIImage(named: "Respect_GoodMann"), for: .normal)
        respectAndGoodMannersButton.widthAnchor.constraint(equalToConstant: 161).isActive = true
        respectAndGoodMannersButton.heightAnchor.constraint(equalToConstant: 108).isActive = true

        let categoriesBottomStack = UIStackView(arrangedSubviews: [
            animalsAndNatureButton,
            respectAndGoodMannersButton
        ])
        categoriesBottomStack.axis = .horizontal
        categoriesBottomStack.spacing = 12
        categoriesBottomStack.distribution = .fillEqually

        let categoriesContainer = UIStackView(arrangedSubviews: [
            categoriesHeaderView,
            categoriesTopStack,
            categoriesSecondStack,
            categoriesBottomStack
        ])
        categoriesContainer.axis = .vertical
        categoriesContainer.spacing = 16
        categoriesContainer.alignment = .leading
        categoriesContainer.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(categoriesContainer)

        NSLayoutConstraint.activate([
            categoriesContainer.topAnchor.constraint(equalTo: favoritesContainer.bottomAnchor, constant: 32),
            categoriesContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoriesContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoriesContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        let allButtons = [
            friendshipButton,
            courageAndBraveryButton,
            responsibilityButton,
            magicAndFantacyButton,
            honestyAndTruthButton,
            adventureButton,
            familyAndHomeButton,
            animalsAndNatureButton,
            respectAndGoodMannersButton
        ]

        for button in allButtons {
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        }
    }

    // MARK: - Add Initial Data
    

    func setUpInitialData() {
        
        let context = persistentContext()
    
        //MARK: STORIES TO INSERT
    
        
        let stories: [(id: String,
                       category: CategoryList,
                       title: String,
                       content: String,
                       moral: String)] = [
            
            (
                "1S",
                .Friendship,
                "The Lion and the Mouse.",
                """
                One day, a mighty lion was sleeping in the forest when a tiny mouse accidentally ran across his nose.
                The lion woke up quickly and caught the mouse in his huge paw.

                "Please don’t eat me!" squeaked the mouse.
                "If you let me go, I promise I will help you someday."

                The lion laughed. "How could a little mouse ever help me?"
                But he felt kind and released the mouse.

                A few days later, the lion was caught in a hunter’s net.
                He roared and struggled, but the ropes were too strong.

                The little mouse heard the lion’s cries and hurried over.
                With quick bites, the mouse chewed through the ropes until the lion was free.

                "You helped me!" said the lion.

                "Even small friends can be great helpers."
                """,
                "A true friend is someone who shows kindness even when it is not expected."
            ),
            
            (
                "2S",
                .CourageAndBravery,
                "The Little Bird Who Learned to Fly.",
                """
                A little bird was afraid to fly.
                One windy morning she lost her balance…
                and something amazing happened — she flew!

                Courage is not the absence of fear,
                but the strength to rise even when afraid.
                """,
                "Bravery is doing what is right even when you feel afraid."
            ),
            
            (
                "3S",
                .Responsibility,
                "The Boy and His Garden.",
                """
                Sam was told to care for his seeds.
                At first he tried, then he became lazy.
                The plants suffered.

                When he became responsible again,
                the plants recovered and grew.

                Responsibility helps things grow.
                """,
                "Responsibility means doing what you should even when it is difficult."
            )
        ]
        
    
        //MARK: INSERT STORIES ONLY ONCE
    
        
        for story in stories {
            
            // skip if already inserted
            if storyExists(id: story.id) {
                continue
            }
            
            let newStory = StoryList(context: context)
            newStory.storyId = story.id
            newStory.categoryId = story.category.rawValue
            newStory.storyTitle = story.title
            newStory.storyContent = story.content
            newStory.storyMoral = story.moral
        }
        
        
        //MARK: SAVE
        
        
        do {
            try context.save()
            print("Initial stories saved (if not already present).")
        } catch {
            print("Error saving initial data:", error)
        }
    }
      


}
