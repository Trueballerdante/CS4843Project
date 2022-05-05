
### Functions
  - Important: In order to use the Function service, you need to upgrade your projects payment plan to the Blaze Plan.
  - Functions are used to execute code, a function, when a trigger occurs. In our case the cloud function handles events 
    triggered by the addition of new storage data. This new storage data, which should be an image, will be passed to the
    function and the function will create a thumbnail image based on the original image. The generated thumbnail will be 
    placed in the storage bucket and the image url, thumbnail url, file name, and mime type will be stored in the 
    "thumbnails" collection in firestore.
  - We utilized a premade function created by Firebase that generates a thumbnail based on an uploaded image. The function was
    modified to store the data into the Firestore Database instead of a Realtime Database.
  - A document in the thumbnails collection will contain the following fields:
    - `fileName` - The name of the uploaded file
    - `fileUrl` - A public URL to the original image
    - `thumbnailPath` - A public URL to the generated thumbnail
    - `contentType` - The MIME type of the images
  - Function deployment steps:
    - 1) Login to Firebase CLI using the command ```firebase login``` and enter your login information
    - 2) Open the appFunctions folder and run the command ```firebase init functions```. When prompted, select JavaScript
    - 3) (Optional) Test the function with the emulators 
    - 4) Deploy the project by running the command ```firebase deploy```
    - 5) Go to your project's [Cloud Marketplace](https://console.cloud.google.com/marketplace/product/google/iamcredentials.googleapis.com?project=_) and enable the IAM Service Account Credentials API
    - 6) In your project's [Cloud Console > IAM & admin > IAM](https://console.cloud.google.com/iam-admin/iam?project=_), Find the App Engine default service account and add the Service
         Account Token Creator role to that member. This will allow your app to create signed public URLs to the images.
     
