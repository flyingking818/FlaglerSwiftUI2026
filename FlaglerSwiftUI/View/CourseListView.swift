// ============================================================
// Main screen after login.
// Shows the list of courses fetched from Firestore.
// Navigates to CourseDetailView and AddCourseView.
// ============================================================
//  Last updated by Jeremy Wang on 4/1/26.

import SwiftUI

struct CourseListView: View {

  // AuthViewModel — needed for the Log Out button
  @ObservedObject var authVM: AuthViewModel

  // CourseViewModel — owns and drives the course list
  // @StateObject because THIS view creates the CourseViewModel
  @StateObject private var courseVM = CourseViewModel()

  // Controls whether the AddCourse sheet is showing
  @State private var showAddCourse = false

  var body: some View {
      NavigationStack {
          Group {

              // Show spinner while loading
              if courseVM.isLoading {
                  ProgressView("Loading courses...")

              // Show message if no courses exist yet
              } else if courseVM.courses.isEmpty {
                  VStack(spacing: 12) {
                      Image(systemName: "book.closed")
                          .font(.system(size: 50))
                          .foregroundStyle(.secondary)
                      Text("No courses yet.")
                          .foregroundStyle(.secondary)
                      Text("Tap + to add your first course.")
                          .font(.subheadline)
                          .foregroundStyle(.secondary)
                  }

              // Show the list of courses
              } else {
                  List {
                      ForEach(courseVM.courses) { course in

                          // NavigationLink pushes CourseDetailView
                          // when the user taps a row
                          NavigationLink(destination: CourseDetailView(course: course)) {
                              CourseRowView(course: course)
                          }
                      }
                      // Swipe left to delete
                      .onDelete { offsets in
                          courseVM.deleteCourse(at: offsets)
                      }
                  }
              }
          }
          .navigationTitle("My Courses")

          // ── Toolbar buttons ──────────────────────────────
          .toolbar {

              // + button in top right — opens AddCourseView
              ToolbarItem(placement: .navigationBarTrailing) {
                  Button {
                      showAddCourse = true
                  } label: {
                      Image(systemName: "plus")
                  }
              }

              // Log Out button in top left
              ToolbarItem(placement: .navigationBarLeading) {
                  Button("Log Out") {
                      authVM.logout()
                  }
                  .foregroundStyle(.red)
              }
          }

          // Error banner
          .safeAreaInset(edge: .bottom) {
              if let error = courseVM.errorMessage {
                  Text(error)
                      .foregroundStyle(.white)
                      .padding()
                      .background(Color.red)
                      .cornerRadius(10)
                      .padding()
              }
          }

          // Fetch courses when this view appears on screen
          // .onAppear runs once when the view loads
          .onAppear {
              courseVM.fetchCourses()
          }

          // Show AddCourseView as a sheet
          .sheet(isPresented: $showAddCourse) {
              AddCourseView(courseVM: courseVM)
          }
      }
  }
}

// ============================================================
// CourseRowView — a single row in the list
// ============================================================
// Breaking this into its own View keeps CourseListView clean.
// It receives one Course and displays it.
// ============================================================
struct CourseRowView: View {

  let course: Course

  var body: some View {
      VStack(alignment: .leading, spacing: 4) {

          Text(course.courseTitle)
              .font(.headline)

          HStack {
              // Course ID badge
              Text(course.courseID)
                  .font(.caption)
                  .fontWeight(.semibold)
                  .padding(.horizontal, 8)
                  .padding(.vertical, 3)
                  .background(Color.blue.opacity(0.15))
                  .foregroundStyle(.blue)
                  .cornerRadius(6)

              Spacer()

              // Credit hours
              Text("\(course.creditHours) cr hrs")
                  .font(.caption)
                  .foregroundStyle(.secondary)
          }
      }
      .padding(.vertical, 4)
  }
}

