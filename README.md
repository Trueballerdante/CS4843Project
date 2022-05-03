# CS4843Projec

## Firebase
Our flutter application utilizes firebase as its backend.

## Prerequisites
- Create a firebase account

## New Project Creation
The first thing you need to do is create a new project.
This can be done in four simple steps:
- 1) Click on Add Project
- 2) Name the project whatever you want
- 3) Disable Google Analytics
- 4) Click on Continue to create the project

## Services Used
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
- ### Functions
  - Important: In order to use the Function service, you need to upgrade your projects payment plan to the Blaze Plan.
  - Functions are used to execute code, a function, when a trigger occurs. In our case the cloud function handles events 
    triggered by the addition of new storage data. This new storage data, which should be an image, will be passed to the
    function and the function will create a thumbnail image based on the original image. The generated thumbnail will be 
    placed in the storage bucket and the image url, thumbnail url, file name, and mime type will be stored in the 
    "thumbnails" collection in firestore.
  - We utilized a premade function created by Firebase that generates a thumbnail based on an uploaded image. The function was
    modified to store the data into the Firestore Database instead of a Realtime Database.
  - Function deployment steps:
    - 1) Open the appFunctions folder and run the command ```firebase init functions```. When prompted, select JavaScript
    - 2) (Optional) Test the function with the emulators 
    - 3) Deploy the project by running the command ```firebase deploy```
    - 4) Go to your project's Cloud Console > IAM & admin > IAM, Find the App Engine default service account and add the Service 
         Account Token Creator role to that member. This will allow your app to create signed public URLs to the images.
         
## Data Flow
Our infrastructure incorporates a Flutter android application frontend that connects to a Firebase backend. When an image is
uploaded through the application, it is directly sent to the firebase storage which triggers the cloud function. The cloud 
function then takes the newly added image and creates a thumbnail. The thumbnail is added to the storage and the image url, 
thumbnail url, file name, and mime type are stored in the "thumbnails" collection in the firestore database. The Flutter 
application is then notified that data has been added to the collection and it retrieves the new thumbnail url and file name.
The application updates the list of thumbnails using the new thumbnail url and file name. Lastly, tapping on the thumbnail will view it.
