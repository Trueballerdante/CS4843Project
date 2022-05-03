
### Functions
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
