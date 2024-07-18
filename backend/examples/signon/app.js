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
// create application/json parser
var jsonParser = bodyParser.json()
// create application/x-www-form-urlencoded parser
var urlencodedParser = bodyParser.urlencoded({ extended: false })


const { PrismaClient } = require('@prisma/client');
const { response } = require("express");
const { json } = require("express");

const prisma = new PrismaClient()
const multer = require('multer');
let profileHelper = require('./profileHelper')
const auth  = require('./middleware/authMiddleware')
const ensureAuthenticated = auth.ensureAuthenticated

const storage = multer.memoryStorage({})

const upload = multer({ storage: storage })


const http = require('http').createServer(app);


var app = express();

// configure Express
app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');
app.use(cors())
app.use(session({
  secret: 'your secret',
  name: 'name of session id',
  resave: true,
  saveUninitialized: true
}));


app.get("/micCheck", async (req, res) => {
  console.log("mic-check hit")
  res.send("works");
});

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
        Gender: null, 
        Country: null, 
        Language: null, 
        Address: null,
        bio:null,
      },
    });
    
    const newUser = await prisma.User.create({
      data: {
        id: req.user.user_id,
        name: req.user.name,
        profilePicture: req.user.picture,
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
          theme:true
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

app.put('/updateUserInfo', ensureAuthenticated, async (req, res) => {
  //console.log("/getUserInfo called",req.body)
  try{
    let userData = await prisma.UserInfo.update({
      where: {
        id: req.user.user_id
      },
      data: {
        userInfo:true
      }
    })
    console.log(userData)
    res.send(JSON.stringify(userData));
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
  console.log(req.body.name);
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



app.post("/uploadProfile", ensureAuthenticated, upload.single('avatar'), (req, res) => {
  profileHelper.upProfilePic(req, res, prisma);
  res.sendStatus(200);
});

//#endpoint
app.post("/updateBio", ensureAuthenticated, async (req, res) => {
  const updateStatus = await prisma.UserInfo.update({
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
      Language: req.body.data.Language,
      Address: req.body.data.Address,
      Gender: req.body.data.Gender,
    },
  })
  res.sendStatus(200);
});


app.listen(3000);
http.listen(5000, () => console.log(`Listening on port ${3000}`));


