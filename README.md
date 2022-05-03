# CS4843Project

## Firebase
Our flutter application utilizes firebase as its backend.
Note: In order to use this Firebase setup

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
- ### Storage
  - Storage is used as a bucket to store the uploaded images along with thier created thumbnails.
  - Storage creation steps:
    - Click on Storage in the left side menu
    - Click Get Started 
    - Select the "Start in test mode" option for the "Security rules for Cloud Storage". Click next
    - Select "nam5 (us-central)" as the Cloud Storage Location. Click Done
  - After creating the storage bucket make sure to update the Rules to look like this:
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
  - Important: In order to use the Functions service, you need to upgrade your projects payment plan to the Blaze Plan.
  - Functions are used to execute code, a function, when a trigger occurs. In our case the cloud function handles events 
    triggered by the addition of new storage data.

- ### Add Firebase to the app
