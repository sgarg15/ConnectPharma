const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
const dataBase = admin.firestore();

exports.testCollection = functions.firestore.document("TestCollection/{randomString}/Testv2/WhatUp").onWrite((change, context)=>{
    const afterData = change.after.data(); 
    functions.logger.log("Hello, here is the after data ", afterData);
    console.log("Hello, this is the company name" + afterData.company);
    console.log(context.params.randomString);
});

exports.aggregatePharmacists = functions.firestore.document("Users/{uid}/SignUp/Information").onWrite((change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();  

    
    if(afterData.userType == "Pharmacist"){
        //Send the following Pharmacist Information to the Aggregated Data:
            //Profile Photo
            //Name
            //Years of Experience
            //Known Software
            //Known Skills
            //known Languages
            //List of Availability
            //Resume link
        const aggregatedDataRef = dataBase.doc("aggregation/pharmacists");
        const profilePhoto = afterData.profilePhotoDownloadURL;
        const name = afterData.firstName + " " +  afterData.lastName;
        const yearsOfExperience = afterData.workingExperience;
        const knownSoftware = afterData.knownSoftware;
        const knownSkills = afterData.knownSkills;
        const knownLanguages = afterData.knownLanguages;
        const availability = afterData.availability ?? "";
        const resume = afterData.resumeDownloadURL;
        const email = afterData.email;
        const phoneNumber = afterData.phoneNumber
        const uid = context.params.uid;

        const next = {
            name: name,
            yearsOfExperience: yearsOfExperience,
            knownSoftware: knownSoftware,
            knownSkills: knownSkills,
            knownLanguages: knownLanguages,
            resume: resume,
            profilePhoto: profilePhoto,
            availability: availability,
            email:email,
            phoneNumber: phoneNumber,
            uid: uid
        }
        
        return aggregatedDataRef.set({[next.uid]: next}, { merge: true })

    }
    
    // functions.logger.log("Hello, here is the after data ON WRITE: ", afterData);
    // functions.logger.log("Hello, here is the after data address: ", afterData.firstName);
    // functions.logger.log("Hello, here is the uid: ", context.params.uid);
    
    
    return null;
});

exports.aggregateJobs = functions.firestore.document("Users/{uid}/Main/{jobID}").onWrite((change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();  

    const aggregatedDataRef = dataBase.doc("aggregation/jobs");
    const startDate = afterData.startDate;
    const endDate = afterData.endDate;
    const jobStatus = afterData.jobStatus;
    const skillsNeeded = afterData.skillsNeeded;
    const softwareNeeded = afterData.softwareNeeded;
    const techOnSite = afterData.techOnSite;
    const assistantOnSite = afterData.assistantOnSite;
    const hourlyRate = afterData.hourlyRate;
    const limaStatus = afterData.limaStatus;
    const comments = afterData.comments;
    const jobID = context.params.jobID;

    const next = {
        startDate: startDate,
        endDate: endDate,
        jobStatus: jobStatus,
        skillsNeeded: skillsNeeded,
        softwareNeeded: softwareNeeded,
        techOnSite: techOnSite,
        assistantOnSite: assistantOnSite,
        hourlyRate: hourlyRate,
        limaStatus: limaStatus,
        comments: comments,
        jobID: jobID,
    }
    
    return aggregatedDataRef.set({[next.jobID]: next}, { merge: true })

    
    // functions.logger.log("Hello, here is the after data ON WRITE: ", afterData);
    // functions.logger.log("Hello, here is the after data address: ", afterData.firstName);
    // functions.logger.log("Hello, here is the uid: ", context.params.uid);
    
    
    return null;
});