//
//  LocationListView.swift
//  Scholar+
//
//  Created by Nate on 9/22/22.
//

import SwiftUI

struct LocationListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Annotation.name, ascending: true)],
        animation: .default)

    private var annotations: FetchedResults<Annotation>
    var body: some View {
        List{
            ForEach(annotations){ann in
                HStack{
                    Text(ann.name!)
                    Spacer()
                    let uiImage = UIImage(data: ann.image ?? .init())
                    let image  = Image(uiImage: uiImage ?? .init())
                    image
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                }
            }.onDelete(perform: deleteAnnotation)
        }
    }
    private func deleteAnnotation(offsets: IndexSet) {
        withAnimation {
            offsets.map { annotations[$0] }
            .forEach(viewContext.delete)
        
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

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}

extension NSSet {
  func toArray<T>() -> [T] {
    let array = self.map({ $0 as! T})
    return array
  }
}
