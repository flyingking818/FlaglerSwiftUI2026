// ============================================================
// This is the Model — it defines the shape of our data.
// It has no SwiftUI, no Firebase logic, just plain Swift.
// ============================================================
//  Last updated by Jeremy Wang on 4/1/26.

import Foundation

// Identifiable — lets SwiftUI use this in a List or ForEach
// Codable    — lets Firebase automatically convert this
//              struct to/from a dictionary (no manual mapping)
struct Course: Identifiable, Codable {

  // 'var id' is required by Identifiable
  // Firestore uses this as the document ID
  var id: String

  // The three fields required by the project spec
  var courseID:    String   // e.g. "CIS331"
  var courseTitle: String   // e.g. "Mobile App Development"
  var creditHours: Int      // e.g. 3

  // This tells Codable to map our 'id' property
  // to the Firestore field called 'id'
  enum CodingKeys: String, CodingKey {
      case id
      case courseID
      case courseTitle
      case creditHours
  }
  
  //Extra notes:
  /* Firestore stores data like this in Json (JavaScript Object Notation) format, which you'll learn more about in our CIS 325 course.
   
   {
     "courseID": "CIS331",
     "courseTitle": "Mobile App Development",
     "creditHours": 3
   }

   With Codable, Swift can automatically:

   convert Firestore data → Course
   convert Course → Firestore data

   No manual parsing needed.
   */
}
