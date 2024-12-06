//
//  HomePageViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomePageViewController: UIViewController {

    let homePage = HomePageView()
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?
    private let database = Firestore.firestore()
    private var courses = [Course]() // Data model for courses
    
    let profileNotificationController = ProfileNotificationViewController()
    var landingPageController: LandingPageViewController?
    let notificationsController = NotificationsViewController()
    
    override func loadView() {
        view = homePage
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        // modify title font
        let titleAttributes: [NSAttributedString.Key: Any] = [.font:UIFont.boldSystemFont(ofSize: 22)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(onProfileBarButtonTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUserLogout(notofication:)), name: .userLogout, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationJumpToNotification(notification:)), name: .userJumpToNotification, object: nil)
        
        // Set up the table view
        homePage.tableView.delegate = self
        homePage.tableView.dataSource = self
        homePage.tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: "CourseCell")
        
        // Add target for the "Add Course" button
        homePage.addCourseButton.addTarget(self, action: #selector(addCourseButtonTapped), for: .touchUpInside)
        

        // Add the "My Course" button to the top-right corner
        let myCourseButton = UIBarButtonItem(
            title: "My Course",
            style: .plain,
            target: self,
            action: #selector(myCourseButtonTapped)
        )
        navigationItem.leftBarButtonItem = myCourseButton

        // Initial fetch of courses
        fetchCourses()
        
    }
    
//    func setupRightBarButton(){
//        let barIcon = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(onProfileBarButtonTapped))
//    }
    
    @objc func onProfileBarButtonTapped(){
        //display profile
        profileNotificationController.currentUser = currentUser
        profileNotificationController.displayUserProfile()
        navigationController?.pushViewController(profileNotificationController, animated: true)
    }
    
    @objc func notificationUserLogout(notofication: Notification){
        navigationController?.setViewControllers([self.landingPageController!], animated: true)
    }
    
    @objc func notificationJumpToNotification(notification: Notification) {
        notificationsController.currentUser = currentUser
        navigationController?.pushViewController(notificationsController, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch courses whenever the view appears
        fetchCourses()
    }

    @objc private func addCourseButtonTapped() {
        let addCourseController = AddCourseViewController()
        navigationController?.pushViewController(addCourseController, animated: true)
    }

    @objc private func myCourseButtonTapped() {
        let myCoursesController = MyCoursesViewController()
        navigationController?.pushViewController(myCoursesController, animated: true)
    }

    private func fetchCourses() {
        database.collection("courses").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching courses: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                self.courses = snapshot.documents.compactMap { document in
                    return Course(document: document.data()) // Assuming Course model initializer
                }
                DispatchQueue.main.async {
                    self.homePage.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Table View Delegate and Data Source
extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as? CourseTableViewCell else {
            return UITableViewCell()
        }
        let course = courses[indexPath.row]
        cell.configure(with: course)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Debug log for selected course
        let course = courses[indexPath.row]
        print("Selected course: \(course.name)")
        
        // Check if the course is already added by the user
        let isCourseAdded = checkIfCourseIsAdded(course: course)
        
        // Navigate to the Course Detail screen
        let courseDetailVC = CourseDetailViewController(course: course, isCourseAdded: isCourseAdded)
        navigationController?.pushViewController(courseDetailVC, animated: true)
    }
    
    private func checkIfCourseIsAdded(course: Course) -> Bool {
        // Replace with actual logic to check if the user has added the course
        // For now, return false for debugging
        print("Checking if course is added: \(course.name)")
        return false
    }
}

