# CS4843Project

## Firebase
Our flutter application utilizes firebase as its backend.

## Services Used
- ### Storage
  - Storage is used as a bucket to store the uploaded images along with thier created thumbnails.
  - When creating the storage bucket make sure to update the Rules to look like this:
    ```rules_version = '2';
       service firebase.storage {
          match /b/{bucket}/o {
            match /{allPaths=**} {
              allow read, write: if true;
            }
          }
      }
    ```

