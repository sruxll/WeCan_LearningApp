//
//  ViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit
import FirebaseFirestore

class AllCoursesViewController: UIViewController {
    private let allCoursesView = AllCoursesView()
    private let database = Firestore.firestore()
    private var courses = [Course]() // Data model for courses

    override func loadView() {
        view = allCoursesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Courses"
        
        // Set up the table view
        allCoursesView.tableView.delegate = self
        allCoursesView.tableView.dataSource = self
        allCoursesView.tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: "CourseCell")
        
        // Add target for the "Add Course" button
        allCoursesView.addCourseButton.addTarget(self, action: #selector(addCourseButtonTapped), for: .touchUpInside)

        // Add the "My Course" button to the top-right corner
        let myCourseButton = UIBarButtonItem(
            title: "My Course",
            style: .plain,
            target: self,
            action: #selector(myCourseButtonTapped)
        )
        navigationItem.rightBarButtonItem = myCourseButton

        // Initial fetch of courses
        fetchCourses()
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
                    self.allCoursesView.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Table View Delegate and Data Source
extension AllCoursesViewController: UITableViewDelegate, UITableViewDataSource {
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
