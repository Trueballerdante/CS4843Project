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
    - test 
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
  - When creat
  - 
- ### Functions
  - Important: In order to use the functions service, you need to upgrade your projects payment plan to the Blaze Plan.

- ### Add Firebase to the app
