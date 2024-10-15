# Screen Journal

**Screen Journal** is an iOS app designed to help reduce screen time. By using Apple's automations, opening addictive apps redirects users to Screen Journal. To proceed to the addictive app, users must type out a brief reason (30+ characters) explaining why they want to use the app. Only after completing this step do they have the option to continue or exit.

By encouraging users to reflect on their intentions for using these apps, Screen Journal aims to help people, including myself, take better control of screen time and reduce unproductive phone use.
## Technologies Used in Screen Journal

**Quick Screen Journal** incorporates several technologies and SwiftUI features:

- **SwiftUI:** The app is built with SwiftUI, Apple's declarative framework for creating user interfaces across all Apple platforms. SwiftUI's intuitive syntax and powerful state management features allow for a responsive and dynamic user experience.
  
- **AppIntents Framework:** The app leverages Apple's **AppIntents** to handle deep integrations with Shortcuts, allowing users to automate the process of redirecting from addictive apps to Screen Journal. It captures user intent through custom intent handling (e.g., `QuickJournalIntentHandler`) and responds accordingly, whether by navigating within the app or opening specific apps.

- **NavigationStack:** The app uses SwiftUI's `NavigationStack` to manage the flow of views and handle navigation in a stack-like format. This ensures smooth transitions between different views within the app, such as navigating to the journal entry view.

- **SwiftData & Core Data:** Persistent data management is handled via **SwiftData** and Core Data, which are used to store journal entries reflecting users' reasons for opening certain apps. This data is managed through a `modelContext` that integrates seamlessly with SwiftUI's environment.

- **UIKit Integration:** While the app is primarily SwiftUI-based, it uses UIKit methods to open external apps and URLs. The function `openApp()` attempts to open apps using their custom URL schemes, and defaults to opening a web page if the app is not installed.

- **ScenePhase Management:** The app uses `@Environment(\.scenePhase)` to respond to changes in the app's lifecycle, such as when it becomes active or goes into the background. This ensures that the app properly updates state (e.g., resetting `lastOpenedApp`) based on how the user interacts with the app.

- **SharedData Management:** The app uses a shared data model (`SharedData`) to keep track of which app was last opened and whether it should be reopened after a journal entry is completed. This state management helps ensure smooth coordination between different parts of the app.

By leveraging these technologies, Screen Journal offers a streamlined, automated way to reflect on app usage and helps users reduce their screen time through intentional reflection.

