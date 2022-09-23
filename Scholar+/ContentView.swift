//
//  ContentView.swift
//  Scholar+
//
//  Created by Nate on 9/22/22.
//

import SwiftUI
import CoreData
import MapKit
import PhotosUI

struct ContentView: View {
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

struct PerLocation: View{
    @Environment(\.managedObjectContext) private var viewContext
    var annotation: FetchedResults<Annotation>.Element
    var body: some View{
        let uiImage = UIImage(data: annotation.image ?? .init())
        Image(uiImage: uiImage ?? .init())
            .resizable()
            .scaledToFill()
            .shadow(radius: 10)
            .aspectRatio(contentMode: .fit)
            .frame(width: 100,height: 100)
        let image  = Image(uiImage: uiImage ?? .init())
        ShareLink(item: image, preview: SharePreview(annotation.name!, image: image))
        Text(annotation.name!)
            .font(.callout)
            .onLongPressGesture {
                annotation.managedObjectContext?.delete(annotation)
                do{
                    try viewContext.save()
                }catch{
                    print(error.localizedDescription)
                }
            }

    }
    
}
