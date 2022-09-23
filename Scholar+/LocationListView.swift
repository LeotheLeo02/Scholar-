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
            }
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}
