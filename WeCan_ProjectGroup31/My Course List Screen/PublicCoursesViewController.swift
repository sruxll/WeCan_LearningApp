//
//  PublicCoursesViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/4/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PublicCoursesViewController: UIViewController {
    private let publicCoursesView = MyCoursesView()
    private var subscribedCourses = [Course]() // List of public user's subscribed courses
    private var userProgress = [String: [Int: Bool]]() // Maps course ID to section progress for public user
    private let database = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    var publicUserId: String? // Public Profile User ID from Firebase
    var publicUserName: String? // Public Profile User Name
    var isFriend = false // Indicates if the public profile user is a friend

    override func loadView() {
        view = publicCoursesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = publicUserName != nil ? "\(publicUserName!)'s Courses" : "Public Courses"

        // Table view setup
        publicCoursesView.tableView.delegate = self
        publicCoursesView.tableView.dataSource = self
        publicCoursesView.tableView.register(MyCourseTableViewCell.self, forCellReuseIdentifier: "MyCourseCell")

        fetchPublicUserCourses()
    }

    private func fetchPublicUserCourses() {
        guard let publicUserId = publicUserId else {
            print("Public user ID is nil")
            return
        }

        // Check if the public user is a friend
        checkFriendStatus(for: publicUserId) { [weak self] isFriend in
            self?.isFriend = isFriend
            
            // Fetch subscribed courses and progress
            self?.database.collection("users").document(publicUserId).getDocument { document, error in
                if let error = error {
                    print("Error fetching public user: \(error)")
                    return
                }
                guard let data = document?.data(),
                      let user = User(documentData: data) else { return }

                self?.publicUserName = user.name
                self?.title = "\(user.name)'s Courses"

                let courseIDs = user.subscribedCourses
                self?.loadCourses(courseIDs: courseIDs)
            }
        }
    }

    private func checkFriendStatus(for publicUserId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserEmail = currentUser?.email else {
            completion(false)
            return
        }

        let followersRef = database.collection("users").document(publicUserId).collection("followers").document(currentUserEmail)
        let followingRef = database.collection("users").document(currentUserEmail).collection("following").document(publicUserId)

        let group = DispatchGroup()
        var isFollower = false
        var isFollowing = false

        group.enter()
        followersRef.getDocument { document, error in
            isFollower = document?.exists == true
            group.leave()
        }

        group.enter()
        followingRef.getDocument { document, error in
            isFollowing = document?.exists == true
            group.leave()
        }

        group.notify(queue: .main) {
            completion(isFollower || isFollowing)
        }
    }

    private func loadCourses(courseIDs: [String]) {
        let group = DispatchGroup()
        var loadedCourses = [Course]()
        var loadedProgress = [String: [Int: Bool]]()

        for courseID in courseIDs {
            group.enter()
            database.collection("courses").document(courseID).getDocument { document, error in
                if let document = document, let courseData = document.data(),
                   let course = Course(document: courseData) {
                    loadedCourses.append(course)
                }
                group.leave()
            }

            group.enter()
            database.collection("userProgress").document("\(publicUserId ?? "")_\(courseID)").getDocument { document, error in
                if let document = document, let progressData = document.data(),
                   let completedSections = progressData["completedSections"] as? [Int] {
                    var progress = [Int: Bool]()
                    completedSections.forEach { progress[$0] = true }
                    loadedProgress[courseID] = progress
                } else {
                    loadedProgress[courseID] = [:] // Initialize empty progress
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.subscribedCourses = loadedCourses
            self.userProgress = loadedProgress
            self.publicCoursesView.tableView.reloadData()
        }
    }
}

// MARK: - Table View Delegate and Data Source
extension PublicCoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribedCourses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCourseCell", for: indexPath) as? MyCourseTableViewCell else {
            return UITableViewCell()
        }
        let course = subscribedCourses[indexPath.row]
        let progress = userProgress[course.id] ?? [:]
        cell.configure(with: course, progress: progress)
        cell.setProgressBarVisibility(isHidden: !isFriend)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = subscribedCourses[indexPath.row]
        // Navigate to Course Detail
        let courseDetailVC = CourseDetailViewController(course: course, isCourseAdded: true)
        navigationController?.pushViewController(courseDetailVC, animated: true)
    }
}

