
// ============================================================
// Form for adding a new course.
// Calls courseVM.addCourse() when the user taps Save.
// ============================================================
//  Last updated by Jeremy Wang on 4/1/26.

import SwiftUI

struct AddCourseView: View {

    // Receives the CourseViewModel from CourseListView
    // @ObservedObject — CourseListView owns it, we just observe
    @ObservedObject var courseVM: CourseViewModel

    // Local @State for each form field
    @State private var courseID    = ""
    @State private var courseTitle = ""
    @State private var creditHours = 3   // sensible default

    // Used to close this sheet when Save is tapped
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {

                // ── Course Info section ──────────────────────
                Section("Course Information") {

                    // Course ID field — e.g. "CIS330"
                    TextField("Course ID (e.g. CIS330)", text: $courseID)
                        .autocapitalization(.allCharacters)

                    // Course Title field
                    TextField("Course Title", text: $courseTitle)

                    // Picker for credit hours (1–6)
                    Picker("Credit Hours", selection: $creditHours) {
                        ForEach(1...6, id: \.self) { hours in
                            Text("\(hours) credit hour\(hours == 1 ? "" : "s")")
                                .tag(hours)
                        }
                    }
                }

                // ── Error section ────────────────────────────
                if let error = courseVM.errorMessage {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add Course")
            .navigationBarTitleDisplayMode(.inline)

            // ── Toolbar buttons ──────────────────────────────
            .toolbar {

                // Cancel — dismisses without saving
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                // Save — calls ViewModel, then dismisses
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // View calls the intent method
                        // ViewModel does the Firestore work
                        courseVM.addCourse(
                            courseID:    courseID,
                            courseTitle: courseTitle,
                            creditHours: creditHours
                        )

                        // Only dismiss if no error occurred
                        if courseVM.errorMessage == nil {
                            dismiss()
                        }
                    }
                    .fontWeight(.semibold)
                    // Disable Save if required fields are empty
                    .disabled(courseID.isEmpty || courseTitle.isEmpty)
                }
            }
        }
    }
}
