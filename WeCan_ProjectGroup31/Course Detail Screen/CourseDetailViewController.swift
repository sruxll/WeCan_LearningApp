//
//  CourseDetailViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by FengAdela on 12/2/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CourseDetailViewController: UIViewController {
    private let courseDetailView = CourseDetailView()
    private var course: Course
    private var userProgress: [Int: Bool] = [:] // Maps section number to completion status
    private var isCourseAdded = false

    init(course: Course, isCourseAdded: Bool = false) {
        self.course = course
        self.isCourseAdded = isCourseAdded
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = courseDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = course.name

        // Set up UI
        courseDetailView.descriptionLabel.text = course.description
        courseDetailView.tableView.delegate = self
        courseDetailView.tableView.dataSource = self

        configureButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Check if the course is added and fetch progress whenever the screen appears
        checkIfCourseIsAdded()
    }

    private func configureButtons() {
        // Top-right navigation button
        let navButton = UIBarButtonItem(
            title: isCourseAdded ? "Invite" : "Add to My Course",
            style: .plain,
            target: self,
            action: isCourseAdded ? #selector(inviteTapped) : #selector(addToMyCourseTapped)
        )
        navigationItem.rightBarButtonItem = navButton

        // Bottom action button
        let bottomButtonTitle = isCourseAdded ? "View Friend's Progress" : "See who's also taking this course..."
        courseDetailView.actionButton.setTitle(bottomButtonTitle, for: .normal)
        courseDetailView.actionButton.removeTarget(nil, action: nil, for: .allEvents)
        courseDetailView.actionButton.addTarget(
            self,
            action: isCourseAdded ? #selector(viewFriendsProgressTapped) : #selector(seeParticipantsTapped),
            for: .touchUpInside
        )
    }

    private func checkIfCourseIsAdded() {
        guard let userEmail = Auth.auth().currentUser?.email?.lowercased() else {
            print("User not authenticated")
            return
        }

        let userRef = Firestore.firestore().collection("users").document(userEmail)

        userRef.getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching user document: \(error)")
                return
            }

            guard let data = document?.data(),
                  let subscribedCourses = data["subscribedCourses"] as? [String] else {
                print("No subscribedCourses field found")
                return
            }

            self?.isCourseAdded = subscribedCourses.contains(self?.course.id ?? "")
            self?.configureButtons()

            if self?.isCourseAdded == true {
                self?.fetchUserProgress(userEmail: userEmail) // Fetch progress after confirming the course is added
            } else {
                self?.courseDetailView.tableView.reloadData()
            }
        }
    }

    private func fetchUserProgress(userEmail: String) {
        let progressRef = Firestore.firestore()
            .collection("userProgress")
            .document("\(userEmail)_\(course.id)")

        progressRef.getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching progress: \(error)")
                return
            }

            guard let data = document?.data(),
                  let completedSections = data["completedSections"] as? [Int] else {
                print("No progress data found for this course")
                self?.userProgress = [:] // Reset progress if no data is found
                self?.courseDetailView.tableView.reloadData() // Reload the table view to reflect the absence of progress
                return
            }

            completedSections.forEach { self?.userProgress[$0] = true }
            self?.courseDetailView.tableView.reloadData()
        }
    }

    private func updateProgressInFirestore(sectionNumber: Int) {
        guard let userEmail = Auth.auth().currentUser?.email?.lowercased() else {
            print("User not authenticated")
            return
        }

        let progressRef = Firestore.firestore()
            .collection("userProgress")
            .document("\(userEmail)_\(course.id)")

        progressRef.setData([
            "userID": userEmail,
            "courseID": course.id,
            "completedSections": FieldValue.arrayUnion([sectionNumber])
        ], merge: true) { error in
            if let error = error {
                print("Error updating progress: \(error)")
            } else {
                print("Progress updated successfully for section \(sectionNumber)")
            }
        }
    }

    @objc private func inviteTapped() {
        print("Invite friends tapped")
    }

    @objc private func addToMyCourseTapped() {
        guard let userEmail = Auth.auth().currentUser?.email?.lowercased() else {
            print("User not authenticated")
            return
        }

        let userRef = Firestore.firestore().collection("users").document(userEmail)
        let courseRef = Firestore.firestore().collection("courses").document(course.id)

        // Batch write to update both user and course
        let batch = Firestore.firestore().batch()

        // Add course to user's subscribedCourses
        batch.updateData([
            "subscribedCourses": FieldValue.arrayUnion([course.id])
        ], forDocument: userRef)

        // Add user to course's subscribedUsers
        batch.updateData([
            "subscribedUsers": FieldValue.arrayUnion([userEmail])
        ], forDocument: courseRef)

        batch.commit { [weak self] error in
            if let error = error {
                print("Error updating user and course data: \(error)")
                return
            }

            print("User and course data updated successfully")
            self?.isCourseAdded = true
            self?.configureButtons()
            self?.courseDetailView.tableView.reloadData()
        }
    }

    @objc private func viewFriendsProgressTapped() {
        let friendsProgressVC = FriendsProgressViewController(course: course)
        navigationController?.pushViewController(friendsProgressVC, animated: true)
    }

    @objc private func seeParticipantsTapped() {
        let courseUserListVC = CourseUserListViewController(courseID: course.id)
        navigationController?.pushViewController(courseUserListVC, animated: true)
    }

}

// MARK: - Table View Delegate and Data Source
extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course.schedule.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as? SectionTableViewCell else {
            return UITableViewCell()
        }

        let section = course.schedule[indexPath.row]
        let isCompleted = userProgress[section.sectionNumber] ?? false

        // Pass the isCourseAdded flag to control the visibility of the complete button
        cell.configure(with: section.title, isCompleted: isCompleted, showCompleteButton: isCourseAdded)

        // Update button appearance if completed
        let softGreen = UIColor(red: 220/255, green: 255/255, blue: 220/255, alpha: 1.0) // Soft pale green
        cell.completeButton.isEnabled = !isCompleted
        cell.completeButton.backgroundColor = isCompleted ? .systemGray6 : .systemBlue
        cell.completeButton.setTitleColor(isCompleted ? .gray : .white, for: .normal)
        cell.completeButton.setTitle(isCompleted ? "Completed!" : "Complete", for: .normal)

        cell.completeButton.addTarget(self, action: #selector(completeSection(_:)), for: .touchUpInside)
        cell.completeButton.tag = section.sectionNumber

        return cell
    }

    @objc private func completeSection(_ sender: UIButton) {
        let sectionNumber = sender.tag

        // Check if this is the first non-completed section
        for i in 1..<sectionNumber {
            if userProgress[i] != true {
                showAlert(title: "Finish Previous Sections", message: "Please complete previous sections before completing this one.")
                return
            }
        }

        // Show confirmation alert
        let section = course.schedule.first { $0.sectionNumber == sectionNumber }
        showAlert(
            title: "Complete Section",
            message: "Are you sure you want to complete \(section?.title ?? "this section")?",
            confirmHandler: { [weak self] in
                guard let self = self else { return }
                self.userProgress[sectionNumber] = true // Mark this section as completed
                self.courseDetailView.tableView.reloadData()

                // Update Firestore
                self.updateProgressInFirestore(sectionNumber: sectionNumber)
            }
        )
    }

    private func showAlert(title: String, message: String, confirmHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let confirmHandler = confirmHandler {
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in confirmHandler() }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
