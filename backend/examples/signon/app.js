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
 app.post('/saveuser', ensureAuthenticated, async function (req, res) {
   console.log("/saveuser called")
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
         name: req.user.name,
         profilePicture: req.user.picture,
         profileBanner: 'https://images.pexels.com/photos/325185/pexels-photo-325185.jpeg',
         gmailId: req.user.email,
         userInfoId: userInfo.id,
       },
     })
     
     const newUserAcc = await prisma.LinkedAccounts.create({
       data: {
         userId: req.user.user_id,
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
 //returns user info #endpoint
 app.post('/getUserInfo', ensureAuthenticated, async (req, res) => {
     //console.log("/getUserInfo called",req.body)
     try{
       let userData = await prisma.User.findMany({
         where: {
           id: req.body.id
         },
         include: {
           userInfo:true,
         }
       })
       //console.log(userData)
       res.send(userData);
     }
     catch(e){
       console.log(e)
       res.sendStatus(400)
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
 app.post('/userNameUpdate', ensureAuthenticated, urlencodedParser, async (req, res) => {
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
 app.post("/updateBio", ensureAuthenticated, async (req, res) => {
   const updateStatus = await prisma.user.update({
     where: {
       id: req.user.user_id,
     },
     data: {
       bio: req.body.bio,
     },
   })
   res.sendStatus(200);
 });
 //#endpoint

 app.post("/updateUserData", ensureAuthenticated, async (req, res) => {
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
 
 