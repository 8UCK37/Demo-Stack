const {Storage} = require('@google-cloud/storage')
const bucketName = 'gs://weather-app-graphe.appspot.com';


async function upProfilePic(req, res, prisma){
  console.log(req.file);
  if(req.file){
  const destFileName = 'ProfilePicture/'+req.user.user_id+'.jpg';
  //console.log(myUUID);
      const storage = new Storage();
      async function uploadFromMemory() {
          await storage.bucket(bucketName).file(destFileName).save(req.file.buffer);
        
          console.log(
            `${destFileName}  uploaded to ${bucketName}.`
          );
        }
        uploadFromMemory().catch(console.error);      
        const updateUser = await prisma.User.update({
          where: {
            id: req.user.user_id,
          },
          data: {
            profilePicture: `https://firebasestorage.googleapis.com/v0/b/weather-app-graphe.appspot.com/o/ProfilePicture%2F${req.user.user_id}.jpg?alt=media&token=8b43dd17-5042-4452-b616-5355a80bafe4`,
          },
        }) 
  }

}

module.exports =  { upProfilePic}