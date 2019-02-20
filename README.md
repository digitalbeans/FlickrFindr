# Flickr Findr

Flickr Findr demonstrates using the Flickr REST API to retrieve and display photos using a search term specified in the search bar.
Flickr API content is returned in JSON format. 

It will initially display the first 25 photos, and when you 
scroll to the end of the list, it will download and display the next available 25 photos. 

Selecting a photo will show a second view that will display a large version of the photo.

Search history is maintained with the most recent at the top of the list. Search history is saved to User Defaults.
Tapping the clear button in the search history table header, will clear the search history.

Error messages received from the Flickr API are displayed using an AlertController.

Requires iOS 12.0.
