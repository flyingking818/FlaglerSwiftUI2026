
// ============================================================
// This ViewModel manages the course list.
// It reads from and writes to Firestore.
//
//  Same pattern as ConverterViewModel —
//   @Published + intent functions that talk to the Model layer

     //@Published (viewmodel) vs. @State (view specific)?

//  ========Why we put the database handling logic here?=======
//  In the converter app, the main job is calculation, so the Model does more.
//  In the course registration app, the main job is talking to Firebase and updating the UI, so the ViewModel does more.
//  In the Course Registration app

//  Most of the work is:

// reading from Firestore
// writing to Firestore
// deleting documents
// tracking loading state
// handling errors

// That is data access and app state management, not domain specific to Course.
// So it fits better in the ViewModel or a Service.

// ============================================================
//  Last Updated by Jeremy Wang on 4/1/26.

import Foundation
import Combine
import FirebaseFirestore   // Firestore database SDK
import SwiftUI

@MainActor
class CourseViewModel: ObservableObject {

  // --------------------------------------------------------
  // MARK: - @Published State
  // --------------------------------------------------------

  // The list of courses fetched from Firestore
  // When this changes, the List in CourseListView rebuilds
  @Published var courses: [Course] = []

  // true while loading courses from Firestore
  @Published var isLoading: Bool = false

  // Error message to show in the View if something fails
  @Published var errorMessage: String? = nil

  // --------------------------------------------------------
  // MARK: - Firestore Reference
  // --------------------------------------------------------
  // db is our connection to the Firestore database.
  // Firestore.firestore() returns the shared instance.
  // We point it at the "courses" collection — think of a
  // collection like a table in a regular database.
  // --------------------------------------------------------
  private let db         = Firestore.firestore()
  private let collection = "courses"   // Firestore collection name

  // --------------------------------------------------------
  // MARK: - Intent: Fetch Courses
  // --------------------------------------------------------
  // Reads all documents from the "courses" collection
  // and converts them into Course structs.
  // Called when CourseListView appears on screen.
  // --------------------------------------------------------
    
  //We are doing the CRUD (Create->Read->Update->Delete)
  //This is the R operation!
  func fetchCourses() {
      isLoading    = true
      errorMessage = nil

      // .getDocuments fetches all documents in the collection
      // The result comes back in a closure (it's async)
      db.collection(collection).getDocuments { snapshot, error in

          self.isLoading = false

          // If Firestore returned an error, show it
          if let error = error {
              self.errorMessage = error.localizedDescription
              return
          }

          // snapshot?.documents is an array of Firestore documents
          // We loop over them and convert each one to a Course
          self.courses = snapshot?.documents.compactMap { document in

              // try? means: attempt this, but return nil if it fails
              // data(as: Course.self) uses Codable to auto-convert
              // the Firestore dictionary into our Course struct
              try? document.data(as: Course.self)

          } ?? []   // ?? [] means: use empty array if nil
      }
  }

  // --------------------------------------------------------
  // MARK: - Intent: Add Course
  // --------------------------------------------------------
  // Creates a new Course and saves it to Firestore.
  // Called when the user taps "Save" in AddCourseView.
  //
  // Parameters:
  //   courseID    — e.g. "CIS330"
  //   courseTitle — e.g. "Mobile App Development"
  //   creditHours — e.g. 3
  // --------------------------------------------------------
    
  // This is the C operation!
  func addCourse(courseID: String, courseTitle: String, creditHours: Int) {
      errorMessage = nil

      // Validate — don't save empty data
      guard !courseID.isEmpty, !courseTitle.isEmpty else {
          errorMessage = "Please fill in all fields."
          return
      }

      // UUID().uuidString creates a unique ID string
      // e.g. "550E8400-E29B-41D4-A716-446655440000"
      let newID = UUID().uuidString

      // Build a new Course struct with the user's input
      let newCourse = Course(
          id:          newID,
          courseID:    courseID,
          courseTitle: courseTitle,
          creditHours: creditHours
      )

      // Save to Firestore
      // .document(newID) creates a document with that ID
      // try? setData(from:) uses Codable to convert our
      // Course struct into a Firestore dictionary automatically
      do {
          try db.collection(collection).document(newID).setData(from: newCourse)

          // Also add it to our local list so the UI updates instantly
          // without waiting for another fetchCourses() call
          self.courses.append(newCourse)

      } catch {
          self.errorMessage = error.localizedDescription
      }
  }

  // --------------------------------------------------------
  // MARK: - Intent: Delete Course
  // --------------------------------------------------------
  // Removes a course from Firestore and from our local list.
  // Called when the user swipes to delete in CourseListView.
  //
  // offsets — the IndexSet of rows the user wants to delete
  //           (SwiftUI passes this from .onDelete)
  // --------------------------------------------------------
    
  // This is the D operation
  func deleteCourse(at offsets: IndexSet) {
      errorMessage = nil

      // Loop over each index in the IndexSet
      for index in offsets {
          let course = courses[index]

          // Delete from Firestore using the course's id
          db.collection(collection).document(course.id).delete { error in
              if let error = error {
                  self.errorMessage = error.localizedDescription
              }
          }
      }

      // Remove from our local array so the UI updates immediately
      courses.remove(atOffsets: offsets)
  }
}

//Bonus idea - add the U operation to your app! 
