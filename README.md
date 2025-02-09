Swipe iOS Developer Assessment

Project Overview

This iOS app was developed as part of the Swipe iOS Developer Assessment. It consists of:
	1.	Product Listing Screen – Displays a list of products with search and favorite functionality.
	2.	Add Product Screen – Allows users to add new products.
	3.	(Pending) Offline Product Saving – Planned but not implemented due to technical limitations in testing.

Implemented Features

✅ Product Listing Screen
	•	Fetches and displays products from the API.
	•	Supports searching and scrolling through products.
	•	Displays product name, type, price, and tax.
	•	Loads product images from the URL or uses a default image if empty.
	•	Implements a heart icon to mark favorites, which persist locally.
	•	Shows a progress indicator while loading.

✅ Add Product Screen
	•	Allows users to enter product details (name, type, price, tax).
	•	Provides a dropdown for selecting product type.
	•	Supports optional image selection (JPEG/PNG, 1:1 ratio).
	•	Validates user inputs before submission.
	•	Sends data to the API using the POST method.
	•	Displays appropriate success or error messages.

Unimplemented Feature: Offline Product Saving & Syncing

The task required storing products locally when offline and uploading them once an internet connection is available. This feature was not implemented due to:
	•	NetworkMonitor Framework Issues: The NetworkMonitor framework does not behave reliably in the iOS simulator, making it difficult to detect connectivity changes.
	•	Lack of Physical Device: Since I do not have access to an actual iPhone, testing this feature accurately was not possible.

Future Implementation Plan

Once a physical device is available, the offline feature would be implemented using:
	1.	Network Status Detection – Using NetworkMonitor to observe connectivity status.
	2.	Local Storage – Storing offline products using CoreData or SwiftData.
	3.	Auto-Sync Mechanism – Uploading stored products once internet is available.

Tech Stack & Best Practices
	•	Language: Swift
	•	Framework: SwiftUI
	•	Architecture: MVVM
	•	API Handling: URLSession
	•	Local Data Storage: UserDefaults (for favorites
