const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

// exports.testCollection = functions.firestore.document("TestCollection/{randomString}/Testv2/WhatUp").onWrite((change, context)=>{
//     const afterData = change.after.data(); 
//     functions.logger.log("Hello, here is the after data ", afterData);
//     console.log("Hello, this is the company name" + afterData.company);
//     console.log(context.params.randomString);
// });

exports.aggregatePharmacists = functions.firestore.document("Users/{uid}/SignUp/Information").onWrite((change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();    
    
    functions.logger.log("Hello, here is the after data ON WRITE: ", afterData);
    functions.logger.log("Hello, here is the after data address: ", afterData.firstName);
    functions.logger.log("Hello, here is the uid: ", context.params.uid);
    return null;
});