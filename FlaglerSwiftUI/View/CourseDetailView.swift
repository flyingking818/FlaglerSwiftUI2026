// ============================================================
// Shows full details for a single course.
// Receives a Course struct — no ViewModel needed here
// because we're only displaying data, not fetching it.
// ============================================================
//  Last updated by Jeremy Wang on 4/1/26.

import SwiftUI

struct CourseDetailView: View {

  // The course to display — passed in from CourseListView
  // 'let' because we're not editing it here
  let course: Course

  var body: some View {
      List {

          // ── Course Identity ──────────────────────────────
          Section("Course Identity") {

              // LabeledContent shows a label on the left
              // and the value on the right — clean and simple
              LabeledContent("Course ID") {
                  Text(course.courseID)
                      .fontWeight(.semibold)
                      .foregroundStyle(.blue)
              }

              LabeledContent("Title") {
                  Text(course.courseTitle)
                      .multilineTextAlignment(.trailing)
              }
          }

          // ── Credit Hours ─────────────────────────────────
          Section("Schedule") {
              LabeledContent("Credit Hours") {
                  Text("\(course.creditHours)")
                      .fontWeight(.semibold)
              }

              LabeledContent("Hours per Week") {
                  // Typically credit hours = hours in class per week
                  Text("\(course.creditHours) hrs")
                      .foregroundStyle(.secondary)
              }
          }

          // ── Summary card ─────────────────────────────────
          Section {
              VStack(alignment: .leading, spacing: 8) {
                  Text(course.courseTitle)
                      .font(.headline)

                  HStack {
                      Label(course.courseID, systemImage: "number")
                          .font(.subheadline)
                          .foregroundStyle(.blue)

                      Spacer()

                      Label("\(course.creditHours) credit hours", systemImage: "clock")
                          .font(.subheadline)
                          .foregroundStyle(.secondary)
                  }
              }
              .padding(.vertical, 6)
          } header: {
              Text("Summary")
          }
      }
      .navigationTitle(course.courseID)
      .navigationBarTitleDisplayMode(.large)
  }
}

