//
//  LocationView.swift
//  Scholar+
//
//  Created by Nate on 9/22/22.
//

import MapKit
import SwiftUI
import PhotosUI

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
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    var body: some View{
        ZStack{
            Map(coordinateRegion: $viewmodel.region, showsUserLocation: true, annotationItems: annotations) { ann in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: ann.latitude, longitude: ann.longitude)) {
                    PerLocation(annotation: ann)
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
                        newannotation.image = selectedImageData
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
                PhotosPicker("Choose Image", selection: $selectedItem)
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            // Retrieve selected asset in the form of Data
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }
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
