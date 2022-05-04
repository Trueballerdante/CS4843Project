# CS4843Project
(Note: These Configurations are for Windows machines)

## Firebase
Our infrastructure incorporates a Flutter android application frontend that connects to a Firebase backend. When an image is
uploaded through the application, it is directly sent to the firebase storage which triggers the cloud function. The cloud 
function then takes the newly added image and creates a thumbnail. The thumbnail is added to the storage and the image url, 
thumbnail url, file name, and mime type are stored in the "thumbnails" collection in the firestore database. The Flutter 
application is then notified that data has been added to the collection and it retrieves the new thumbnail url and file name.
The application updates the list of thumbnails using the new thumbnail url and file name. Lastly, tapping on the thumbnail will view it.

## Prerequisites
- Create a firebase account
- Install [Node.js](https://nodejs.org/en/) onto your computer
- Install Firebase CLI using the following command:
  - ```npm install -g firebase-tools```


## New Project Creation
The first thing you need to do is create a new project.
This can be done in four simple steps:
- 1) Click on Add Project
- 2) Name the project whatever you want
- 3) Disable Google Analytics
- 4) Click on Continue to create the project

## Google services Used
Next, you need to setup all the firebase services.
- ### Storage
  - Storage is used as a bucket to store the uploaded images along with their created thumbnails.
  - Storage creation steps:
    - Click on Storage in the left side menu
    - Click Get Started 
    - Select the "Start in test mode" option for the "Security rules for Cloud Storage". Click next
    - Select "nam5 (us-central)" as the Cloud Storage Location. Click Done
  - After creating the storage bucket, make sure to update the Rules to look like this:
    ```rules_version = '2';
       service firebase.storage {
          match /b/{bucket}/o {
            match /{allPaths=**} {
              allow read, write: if true;
            }
          }
        }
    ```
- ### Firestore Database
  - Firestore is utilized to store the urls of the image and thumbnail along with metadata.
  - Firestore Database creation steps:
    - Click on "Firestore Database" in the left side menu
    - Click on "Create Database"
    - Select the "Start in test mode" option for the "Security rules for Cloud Firestore". Click next
    - Select "nam5 (us-central)" as the Cloud Firestoree Location. Click Enable 
  - After creating the Firestore Database, you now need to create a Collection in the database.
  - Collection creating steps:
    - Click Start Collection
    - Enter "thumbnails" for the Collection ID. Click next
    - Click "Auto-ID" for Document ID. Click Save
- ### Firebase Functions
  - Reference the README.md under appFunctions
