//
//  ContentView.swift
//  Scholar+
//
//  Created by Nate on 9/22/22.
//

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Annotation.name, ascending: true)],
        animation: .default)
    private var annotations: FetchedResults<Annotation>
    @StateObject private var viewmodel = LocationViewModel()
    @State private var center = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 60), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    var body: some View {
        ZStack{
            Map(coordinateRegion: $center, showsUserLocation: true, annotationItems: annotations) { ann in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: ann.latitude, longitude: ann.longitude)) {
                Text(ann.name!)
            }
            }.onAppear(){
                viewmodel.CheckLocation()
            }
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32,height: 32)
                .onTapGesture {
                    let newannotation = Annotation(context: viewContext)
                    newannotation.latitude = center.center.latitude
                    newannotation.longitude = center.center.longitude
                    newannotation.name = "Trial"
                                do {
                                    try viewContext.save()
                                } catch {
                                    // Replace this implementation with code to handle the error appropriately.
                                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                    let nsError = error as NSError
                                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                }
    }
    }

//    private func addItem() {
//        withAnimation {
//            let newannotation = Annotation(context: viewContext)
//            newannotation.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
