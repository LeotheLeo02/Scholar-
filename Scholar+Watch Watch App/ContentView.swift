//
//  ContentView.swift
//  Scholar+Watch Watch App
//
//  Created by Nate on 9/22/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Annotation.name, ascending: true)],
        animation: .default)

    private var annotations: FetchedResults<Annotation>
    var body: some View {
        List{
            ForEach(annotations){ann in
                NavigationLink(destination: DetailView(annotation: ann)){
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
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
