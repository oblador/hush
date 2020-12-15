//
//  ContentView.swift
//  ConsentMeNot
//
//  Created by Joel Arvidsson on 2020-12-11.
//

import SwiftUI
import CoreData

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var appState: AppState

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        ZStack {
            Color.appBackgroundColor.ignoresSafeArea()
            VStack {
                Image(self.appState.contentBlockerEnabledState == .disabled ? "Disabled" : "Enabled")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.invertedBackgroundColor)
                    .frame(width: 200, height: 155)
                VStack {
                    (self.appState.contentBlockerEnabledState == .disabled
                        ? AnyView(InstructionsView())
                        : nil
                    )
                }.padding(.top, 40)
            }
//            VStack {
//                Spacer()
//                ContributeFooterView()
//                .frame(alignment: .bottom)
//                .padding(.bottom, 10)
//            }
//            VStack() {
//                Spacer()
//                HStack() {
//                    Spacer()
//                    Text("v\(Bundle.main.releaseVersionNumber!)")
//                        .font(.footnote)
//                        .offset(CGSize(width: -15.0, height: -15.0))
//                }
//            }
//            .ignoresSafeArea()
        }

//        List {
//            ForEach(items) { item in
//                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//            }
//            .onDelete(perform: deleteItems)
//        }
//        .toolbar {
//            #if os(iOS)
//            EditButton()
//            #endif
//
//            Button(action: addItem) {
//                Label("Add Item", systemImage: "plus")
//            }
//        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AppState())
    }
}
