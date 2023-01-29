//
//  CustomFirebaseService.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//


import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import CoreLocation

//struct to keep the latitude and longitude together, they should not be in separate arrays
struct Annotation: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    let lat: String?
    let lng: String?
    var name: String
    var sport: String
    var headCoach: String
}

extension Annotation {
    //Safely unwrap the Strings into doubles and then create the coordinate
    var coordinate: CLLocationCoordinate2D? {
        guard let latStr = lat, let lngStr = lng, let latitude = Double(latStr), let longitude = Double(lngStr) else{
            print("Unable to get valid latitude and longitude")
            return nil
        }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return coordinate

    }
}

//MARK: Regular Get Annotations
struct CustomFirestoreService {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}

//MARK: Soccer Annotations
struct CustomFirestoreServiceSoccer {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).whereField("sport", isEqualTo: "soccer").getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}
 
//MARK: Table Tennis Annotations
struct CustomFirestoreServiceTableTennis {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).whereField("sport", isEqualTo: "table tennis").getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}

//MARK: Baseball Annotations
struct CustomFirestoreServiceBaseBall {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).whereField("sport", isEqualTo: "baseball").getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}

//MARK: Karate Annotations
struct CustomFirestoreServiceKarate {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).whereField("sport", isEqualTo: "karate").getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}

//MARK: Football Annotations
struct CustomFirestoreServiceFootball {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).whereField("sport", isEqualTo: "football").getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}

//MARK: Hockey Annotations
struct CustomFirestoreServiceHockey {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).whereField("sport", isEqualTo: "hockey").getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}

//MARK: Swimming Annotations
struct CustomFirestoreServiceSwimming {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).whereField("sport", isEqualTo: "swimming").getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}

//MARK: Cheer Annotations
struct CustomFirestoreServiceCheer {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).whereField("sport", isEqualTo: "cheer").getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}

//MARK: Tennis Annotations
struct CustomFirestoreServiceTennis {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).whereField("sport", isEqualTo: "tennis").getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}

//MARK: Lacrosse Annotations
struct CustomFirestoreServiceLacrosse {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).whereField("sport", isEqualTo: "lacrosse").getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}

//MARK: Fencing Annotations
struct CustomFirestoreServiceFencing {
    let store: Firestore = .firestore()
    init(){}
    func getAnnotations() async throws -> [Annotation]{
        let ANNOTATIONS_PATH = "annotations"
        return try await retrieve(path: ANNOTATIONS_PATH)
    }
    ///retrieves all the documents in the collection at the path
    private func retrieve<FC : Codable>(path: String) async throws -> [FC]{
        //Firebase provided async await.
        let querySnapshot = try await store.collection(path).whereField("sport", isEqualTo: "fencing").getDocuments()
        return querySnapshot.documents.compactMap { document in
            do{
                return try document.data(as: FC.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
}


