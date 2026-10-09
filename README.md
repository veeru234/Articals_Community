# Articles Community: iOS App

An iOS app that shows a feed of articles in a **list** or **grid** layout, opens a full detail screen for each article, and handles loss of internet connection.

---

## 1. Features

| Feature | Description |
|---|---|
| Article feed | Articles are fetched from the backend API and shown with image, title and published date. |
| List / Grid toggle | A button in the header switches between a single-column list (default on launch) and a two-column grid. The button icon changes to show the layout you will switch to. |
| Dynamic row height | List rows grow with the length of the article title. No fixed heights. |
| Image loading | Images load asynchronously with caching. A loader is shown on each grid image until it arrives, and a placeholder is shown if there is no image or loading fails. |
| Article details | Tapping *Read More* (list) or a card (grid) opens the details screen with title, description, image and relative published time (e.g. "10h ago"). |
| Pull to refresh | Pull down on either the list or the grid to reload the articles. |
| Offline handling | When there is no internet, the list and grid are hidden and an offline screen with a **Retry** button is shown. |

---

## 2. Offline and refresh behaviour

| Situation | Result |
|---|---|
| App opens with no internet | Offline screen is shown. No API call is made. |
| Pull to refresh with no internet | Refresh spinner stops, list/grid are hidden, offline screen is shown. |
| Retry tapped while still offline | Offline screen stays. The API is not called. |
| Retry tapped, connected, API succeeds | Offline screen is removed and the articles are shown. |
| Retry tapped, connected but request fails for a network reason | Offline screen stays. |
| Server returns an error while online | An error alert is shown. If articles are already loaded they stay on screen. |
| Duplicate requests (e.g. pulling while a load is running) | Ignored. Only one request runs at a time. |

The offline screen is a reusable component and can be added to any screen with two lines of code.

---

## 3. Requirements

- iOS 15.0 or later
- Xcode with Swift
- Dependencies (Swift Package Manager or CocoaPods):
  - [Kingfisher](https://github.com/onevcat/Kingfisher): image loading and caching
  - [Reachability.swift](https://github.com/ashleymills/Reachability.swift): network status detection
- Roboto font family (Medium, Regular, Bold, Light) bundled and listed in `Info.plist`. If a font is missing, the system font is used.

---

## 4. Project structure

| File | Responsibility |
|---|---|
| `ArticalsListViewController` | Main screen. Owns the list, grid, header, data fetching, pull to refresh and offline handling. |
| `ArticalsListTableViewCell` (+ XIB) | List row: image, title, date and *Read More* button. |
| `ArticalsGridViewCollectionViewCell` (+ XIB) | Grid card: image with loader, two-line title. |
| `ArticalDetailsViewController` | Article details screen. |
| `ArticlesHeaderContainer` / `ArticlesHeaderView` | Header with title, layout-toggle button and search button (SwiftUI view hosted in UIKit). |
| `OfflineView` | Reusable offline screen with Retry button. |
| `UIViewController+Offline` | `showOfflineView` / `hideOfflineView` helpers for any screen. |
| `NetworkMonitor` | Wraps Reachability and exposes `isConnected`. |
| `ArticlesManager` | API layer that fetches the articles. |

---

## 5. Setup

1. Install the dependencies (Kingfisher and Reachability).
2. Start the network monitor once at launch, in `AppDelegate` or `SceneDelegate`:
   ```swift
   _ = NetworkMonitor.shared
   ```
3. In `Main.storyboard`:
   - Embed the articles list screen in a **UINavigationController**.
   - Set the details screen's **Storyboard ID** to `ArticalDetailsViewController`.
   - Give the table view and collection view identical constraints so they occupy the same area below the header. Only one is visible at a time.
   - Set the collection view flow layout's **Estimate Size** to **None**.
4. Add the layout-toggle icons to the asset catalog (`grid_icon`, `list_icon`) and use template rendering so they follow the header colour.

---

## 6. Reusing the offline screen on another screen

## 7. Known limitations and notes

- The article **body** shown on the details screen is limited to what the API returns in `description` or `content`. If the API truncates the content, a "Read full article" link to the source URL is recommended.
- Network detection reports *connectivity*, not *internet access*. On Wi-Fi with no internet, the app detects this when the API call fails and then shows the offline screen.
- Search is not part of this scope. The search button has a hook (`onSearchTap`) ready for it.
- Scroll position is not shared between the list and the grid. Each keeps its own.

---

## 8. Testing checklist

- [ ] First launch shows the list layout.
- [ ] Toggle switches list ↔ grid and the icon changes.
- [ ] Long titles expand the list row without clipping.
- [ ] Grid shows a loader on each image until it loads, and a placeholder on failure.
- [ ] *Read More* and grid card tap both open the correct article.
- [ ] Back button returns to the list.
- [ ] Pull to refresh works in list and grid.
- [ ] With mobile data and Wi-Fi off: launch, pull to refresh and Retry all show or keep the offline screen, and the list/grid stay hidden.
- [ ] Turning the connection back on and tapping Retry shows the articles and removes the offline screen.
- [ ] Rotating the device recalculates the grid columns.
