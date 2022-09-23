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
    @State private var add = false
    @State private var name = ""
    @FocusState var focus
    var body: some View {
        LocationView()
            .ignoresSafeArea()
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct LocationView: View{
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Annotation.name, ascending: true)],
        animation: .default)
    private var annotations: FetchedResults<Annotation>
    @StateObject private var viewmodel = LocationViewModel()
    @State private var add = false
    @State private var name = ""
    @FocusState var focus
    var body: some View{
        ZStack{
            Map(coordinateRegion: $viewmodel.region, showsUserLocation: true, annotationItems: annotations) { ann in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: ann.latitude, longitude: ann.longitude)) {
                    Text(ann.name!)
                        .onLongPressGesture {
                            ann.managedObjectContext?.delete(ann)
                            do{
                                try viewContext.save()
                            }catch{
                                print(error.localizedDescription)
                            }
                        }
                }
            }.onAppear(){
                viewmodel.CheckLocation()
            }
            VStack{
            if add{
                HStack{
                    TextField("Name of Location", text: $name, axis: .vertical)
                        .focused($focus)
                    Button {
                        let newannotation = Annotation(context: viewContext)
                        newannotation.latitude = viewmodel.region.center.latitude
                        newannotation.longitude = viewmodel.region.center.longitude
                        newannotation.name = name
                        do {
                            try viewContext.save()
                        } catch {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                        name = ""
                        add.toggle()
                    } label: {
                        Text("Add")
                    }

                }.padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding()
            }
                if !add{
                    Circle()
                        .fill(.blue)
                        .opacity(0.3)
                        .frame(width: 32,height: 32)
                        .onTapGesture {
                            withAnimation{
                                add.toggle()
                                focus.toggle()
                            }
                        }
                }
        }
    }
    }
}
