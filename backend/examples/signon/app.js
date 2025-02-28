/*
 * Basic example demonstrating passport-steam usage within Express framework
 adding space
 */
 const axios = require("axios")
 var https = require('https');
 var fs = require('fs');
 var cors = require('cors')
 const path = require('path')
 var express = require('express')
   , session = require('express-session')
 require("dotenv").config()
 let profileHelper = require('./profileHelper')
 var bodyParser = require('body-parser')
 // create application/x-www-form-urlencoded parser
 var urlencodedParser = bodyParser.urlencoded({ extended: false })
 
 
 const { PrismaClient } = require('@prisma/client');

 const prisma = new PrismaClient()
 const multer = require('multer');
 const auth  = require('./middleware/authMiddleware')
 const ensureAuthenticated = auth.ensureAuthenticated
 const storage = multer.memoryStorage({

 })
 const bannerStr = multer.memoryStorage({

 })
 
 const upload = multer({ storage: storage })
 const bnUpload = multer({ storage: bannerStr })
 

 const http = require('http').createServer(app);


 
 var app = express();
 
 // configure Express

 app.use(cors())
 app.use(session({
   secret: 'your secret',
   name: 'name of session id',
   resave: true,
   saveUninitialized: true
 }));
 
 app.use(bodyParser.json());
 
 //saves a new user #endpoint
 app.get('/saveuser', ensureAuthenticated, async function (req, res) {
   console.log("/saveuser called"+req.user)
   const fetchUser = await prisma.User.findUnique({
     where: {
       id: req.user.user_id
     },include: {
       userInfo:true,
     }
   })
   if (fetchUser == null) {
     // console.log("user not found ")
     const userInfo = await prisma.userInfo.create({
       data: {
         bio:null,
         Country: null, 
         Address: null,
         Phone:null
       },
     });
     
     const newUser = await prisma.User.create({
       data: {
         id: req.user.user_id,
         name: req.user.name?? req.user.email,
         profilePicture: req.user.picture?? 'https://firebasestorage.googleapis.com/v0/b/weather-app-graphe.appspot.com/o/ProfilePicture%2Fprofile.png?alt=media&token=761d6b73-d744-4476-99d8-022778158daf',
         profileBanner: 'https://images.pexels.com/photos/325185/pexels-photo-325185.jpeg',
         gmailId: req.user.email,
         userInfoId: userInfo.id,
       },
     })
     
     console.log("new user created db updated", newUser)
     // res.statusCode = 201
     res.send(JSON.stringify(newUser))
   } else {
     console.log("user exists")
     // res.statusCode(200)
     res.send(JSON.stringify(fetchUser))
   }
 
 });


 app.post("/saveUserInfo" , ensureAuthenticated , async (req , res)=>{
 
  let userData = await prisma.User.update({
   where:{
     id: req.user.user_id
   },
   data:{
     userInfo:{
       create:req.body
     }
   },
   include: { userInfo: true }
  })
   res.sendStatus(200)
 })
 //updates displayname of the user #endpoint
 app.put('/userNameUpdate', ensureAuthenticated, urlencodedParser, async (req, res) => {
   console.log("283"+req.body.name);
   const updateUserName = await prisma.User.update({
     where: {
       id: req.user.user_id
     },
     data: {
       name: req.body.name
     }
   })
   res.sendStatus(200);
 });
 

 //testing endpoint with no ensureauth
 app.get("/micCheck", async (req, res) => {
   console.log("mic-check hit")
   res.send("works");
 });
 

 //selfexplanatory #endpoint
 app.get('/logout', function (req, res) {
   req.logout();
   res.redirect('/');
 });
 
 app.post("/uploadProfile", ensureAuthenticated, upload.single('avatar'), (req, res) => {
   profileHelper.upProfilePic(req, res, prisma);
   res.sendStatus(200);
 });
 //#endpoint
 app.post("/uploadBanner", ensureAuthenticated, bnUpload.single('banner'), (req, res) => {
   profileHelper.upBanner(req, res, prisma);
   res.sendStatus(200);
 });

 //#endpoint
 app.put("/updateUserData", ensureAuthenticated, async (req, res) => {
  console.log("linw 158:"+req.body.data)
   const updateStatus = await prisma.userInfo.update({
     where: {
       id: req.body.data.id,
     },
     data: {
       Country: req.body.data.Country,
       bio: req.body.data.bio,
       Address: req.body.data.Address,
       Phone: req.body.data.Phone,
     },
   })
   res.sendStatus(200);
 });
 

 
 app.listen(3000);
 http.listen(5000, () => console.log(`Listening on port ${3000}`));
 
 