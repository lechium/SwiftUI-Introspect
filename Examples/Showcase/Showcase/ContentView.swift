import SwiftUI
import SwiftUIIntrospect

struct ContentView: View {
    @State var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            ListShowcase()
                .tabItem { Text("List") }
                .tag(0)
            ScrollViewShowcase()
                .tabItem { Text("ScrollView") }
                .tag(1)
            #if !os(macOS)
            NavigationShowcase()
                .tabItem { Text("Navigation") }
                .tag(2)
            ViewControllerShowcase()
                .tabItem { Text("ViewController") }
                .tag(3)
            #endif
            SimpleElementsShowcase()
                .tabItem { Text("Simple elements") }
                .tag(4)
        }
        #if os(iOS) || os(tvOS)
        .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) { tabBarController in
            tabBarController.tabBar.layer.backgroundColor = UIColor.green.cgColor
        }
        #elseif os(macOS)
        .introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { splitView in
            splitView.subviews.first?.layer?.backgroundColor = NSColor.green.cgColor
        }
        #endif
        .preferredColorScheme(.light)
    }
}

struct ListShowcase: View {
    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Default")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                List {
                    Text("Item 1")
                    Text("Item 2")
                }
            }

            VStack {
                Text(".introspect(.list, ...)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
                List {
                    Text("Item 1")
                    Text("Item 2")
                }
                #if os(iOS) || os(tvOS)
                .introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17)) { tableView in
                    tableView.backgroundView = UIView()
                    tableView.backgroundColor = .cyan
                }
                .introspect(.list, on: .iOS(.v16, .v17)) { collectionView in
                    collectionView.backgroundView = UIView()
                    collectionView.subviews.dropFirst(1).first?.backgroundColor = .cyan
                }
                #elseif os(macOS)
                .introspect(.list, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { tableView in
                    tableView.backgroundColor = .cyan
                }
                #endif
            }

            VStack {
                Text(".introspect(.list, ..., scope: .ancestor)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
                List {
                    Text("Item 1")
                    Text("Item 2")
                        #if os(iOS) || os(tvOS)
                        .introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17), scope: .ancestor) { tableView in
                            tableView.backgroundView = UIView()
                            tableView.backgroundColor = .cyan
                        }
                        .introspect(.list, on: .iOS(.v16, .v17), scope: .ancestor) { collectionView in
                            collectionView.backgroundView = UIView()
                            collectionView.subviews.dropFirst(1).first?.backgroundColor = .cyan
                        }
                        #elseif os(macOS)
                        .introspect(.list, on: .macOS(.v10_15, .v11, .v12, .v13, .v14), scope: .ancestor) { tableView in
                            tableView.backgroundColor = .cyan
                        }
                        #endif
                }
            }
        }

    }
}

struct ScrollViewShowcase: View {
    var body: some View {
        VStack(spacing: 40) {
            ScrollView {
                Text("Default")
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
            }

            ScrollView {
                Text(".introspect(.scrollView, ...)")
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
            }
            #if os(iOS) || os(tvOS)
            .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
                scrollView.layer.backgroundColor = UIColor.cyan.cgColor
            }
            #elseif os(macOS)
            .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { scrollView in
                scrollView.drawsBackground = true
                scrollView.backgroundColor = .cyan
            }
            #endif

            ScrollView {
                Text(".introspect(.scrollView, ..., scope: .ancestor)")
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
                    #if os(iOS) || os(tvOS)
                    .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17), scope: .ancestor) { scrollView in
                        scrollView.layer.backgroundColor = UIColor.cyan.cgColor
                    }
                    #elseif os(macOS)
                    .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14), scope: .ancestor) { scrollView in
                        scrollView.drawsBackground = true
                        scrollView.backgroundColor = .cyan
                    }
                    #endif
            }
        }
    }
}

struct NavigationShowcase: View {
    var body: some View {
        NavigationView {
            Text("Content")
                .modifier {
                    if #available(iOS 15, tvOS 15, macOS 12, *) {
                        $0.searchable(text: .constant(""))
                    } else {
                        $0
                    }
                }
                #if os(iOS)
                .navigationBarTitle(Text("Customized"), displayMode: .inline)
                #elseif os(macOS)
                .navigationTitle(Text("Navigation"))
                #endif
        }
        #if os(iOS) || os(tvOS)
        .introspect(.navigationView(style: .stack), on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) { navigationController in
            navigationController.navigationBar.backgroundColor = .cyan
        }
        .introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { splitViewController in
            splitViewController.preferredDisplayMode = .oneOverSecondary
        }
        .introspect(.navigationView(style: .columns), on: .tvOS(.v13, .v14, .v15, .v16, .v17)) { navigationController in
            navigationController.navigationBar.backgroundColor = .cyan
        }
        .introspect(.searchField, on: .iOS(.v15, .v16, .v17), .tvOS(.v15, .v16, .v17)) { searchBar in
            searchBar.backgroundColor = .red
            #if os(iOS)
            searchBar.searchTextField.backgroundColor = .purple
            #endif
        }
        #endif
    }
}

#if os(iOS) || os(tvOS)
struct ViewControllerShowcase: View {
    var body: some View {
        NavigationView {
            VStack {
                Text(".introspect(.view, ...)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
            }
        }
        .navigationViewStyle(.stack)
        .introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) { viewController in
            viewController.children.first?.view.backgroundColor = .cyan
        }
    }
}
#endif

struct SimpleElementsShowcase: View {

    @State private var textFieldValue = ""
    @State private var toggleValue = false
    @State private var sliderValue = 0.0
    @State private var datePickerValue = Date()
    @State private var segmentedControlValue = 0

    var body: some View {
        VStack {
            HStack {
                TextField("Text Field Red", text: $textFieldValue)
                    #if os(iOS) || os(tvOS)
                    .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) { textField in
                        textField.backgroundColor = .red
                    }
                    #elseif os(macOS)
                    .introspect(.textField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { textField in
                        textField.backgroundColor = .red
                    }
                    #endif

                TextField("Text Field Green", text: $textFieldValue)
                    .cornerRadius(8)
                    #if os(iOS) || os(tvOS)
                    .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) { textField in
                        textField.backgroundColor = .green
                    }
                    #elseif os(macOS)
                    .introspect(.textField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { textField in
                        textField.backgroundColor = .green
                    }
                    #endif
            }

            HStack {
                Toggle("Toggle Red", isOn: $toggleValue)
                    #if os(iOS)
                    .introspect(.toggle, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { toggle in
                        toggle.backgroundColor = .red
                    }
                    #elseif os(macOS)
                    .introspect(.toggle, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { toggle in
                        toggle.layer?.backgroundColor = NSColor.red.cgColor
                    }
                    #endif

                Toggle("Toggle Green", isOn: $toggleValue)
                    #if os(iOS)
                    .introspect(.toggle, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { toggle in
                        toggle.backgroundColor = .green
                    }
                    #elseif os(macOS)
                    .introspect(.toggle, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { toggle in
                        toggle.layer?.backgroundColor = NSColor.green.cgColor
                    }
                    #endif
            }

            #if !os(tvOS)
            HStack {
                Slider(value: $sliderValue, in: 0...100)
                    #if os(iOS)
                    .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { slider in
                        slider.backgroundColor = .red
                    }
                    #elseif os(macOS)
                    .introspect(.slider, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { slider in
                        slider.layer?.backgroundColor = NSColor.red.cgColor
                    }
                    #endif

                Slider(value: $sliderValue, in: 0...100)
                    #if os(iOS)
                    .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { slider in
                        slider.backgroundColor = .green
                    }
                    #elseif os(macOS)
                    .introspect(.slider, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { slider in
                        slider.layer?.backgroundColor = NSColor.green.cgColor
                    }
                    #endif
            }

            HStack {
                Stepper(onIncrement: {}, onDecrement: {}) {
                    Text("Stepper Red")
                }
                #if os(iOS)
                .introspect(.stepper, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { stepper in
                    stepper.backgroundColor = .red
                }
                #elseif os(macOS)
                .introspect(.stepper, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { stepper in
                    stepper.layer?.backgroundColor = NSColor.red.cgColor
                }
                #endif

                Stepper(onIncrement: {}, onDecrement: {}) {
                    Text("Stepper Green")
                }
                #if os(iOS)
                .introspect(.stepper, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { stepper in
                    stepper.backgroundColor = .green
                }
                #elseif os(macOS)
                .introspect(.stepper, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { stepper in
                    stepper.layer?.backgroundColor = NSColor.green.cgColor
                }
                #endif
            }

            HStack {
                DatePicker(selection: $datePickerValue) {
                    Text("DatePicker Red")
                }
                #if os(iOS)
                .introspect(.datePicker, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { datePicker in
                    datePicker.backgroundColor = .red
                }
                #elseif os(macOS)
                .introspect(.datePicker, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { datePicker in
                    datePicker.layer?.backgroundColor = NSColor.red.cgColor
                }
                #endif
            }
            #endif

            HStack {
                Picker(selection: $segmentedControlValue, label: Text("Segmented control")) {
                    Text("Option 1").tag(0)
                    Text("Option 2").tag(1)
                    Text("Option 3").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                #if os(iOS) || os(tvOS)
                .introspect(.picker(style: .segmented), on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) { datePicker in
                    datePicker.backgroundColor = .red
                }
                #elseif os(macOS)
                .introspect(.picker(style: .segmented), on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { datePicker in
                    datePicker.layer?.backgroundColor = NSColor.red.cgColor
                }
                #endif
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
