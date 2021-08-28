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

exports.aggregateCreatePharmacists = functions.firestore.document("Users/{uid}/SignUp/Information").onCreate((snapshot, context) => {
    const afterData = snapshot.data();  

    
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
        
        return aggregatedDataRef.set({[next.uid]: next}, {merge: true})

    }
    
    // functions.logger.log("Hello, here is the after data ON WRITE: ", afterData);
    // functions.logger.log("Hello, here is the after data address: ", afterData.firstName);
    // functions.logger.log("Hello, here is the uid: ", context.params.uid);
    
    
    return null;
});

exports.aggregateUpdatePharmacists = functions.firestore.document("Users/{uid}/SignUp/Information").onUpdate((change, context) => {
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
        
        return aggregatedDataRef.update({[next.uid]: next})

    }
    
    // functions.logger.log("Hello, here is the after data ON WRITE: ", afterData);
    // functions.logger.log("Hello, here is the after data address: ", afterData.firstName);
    // functions.logger.log("Hello, here is the uid: ", context.params.uid);
    
    
    return null;
});

exports.aggregateCreateJobs = functions.firestore.document("Users/{uid}/Main/{jobID}").onCreate((snapshot, context) => {
    //const beforeData = change.before.data();
    const afterData = snapshot.data();

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
    const pharmacyName = afterData.pharmacyName;
    const pharmacyAddress = afterData.pharmacyAddress;
    const pharmacyUID = afterData.pharmacyUID;
    const jobID = context.params.jobID;
    const email = afterData.email;
    const phoneNumber = afterData.pharmacyNumber;

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
        pharmacyAddress: pharmacyAddress,
        pharmacyName:pharmacyName,
        pharmacyUID:pharmacyUID,
        email: email,
        jobID: jobID,
        phoneNumber: phoneNumber,
    }
    // //functions.logger.log("Hello, here is the after data: ");

    
    return aggregatedDataRef.set({[next.jobID]: next}, {merge: true})

    
    // functions.logger.log("Hello, here is the after data address: ", afterData.firstName);
    // functions.logger.log("Hello, here is the uid: ", context.params.uid);
    
    
    return null;
});

exports.aggregateUpdateJobs = functions.firestore.document("Users/{uid}/Main/{jobID}").onUpdate((change, context) => {
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
    const pharmacyName = afterData.pharmacyName;
    const pharmacyAddress = afterData.pharmacyAddress;
    const pharmacyUID = afterData.pharmacyUID;
    const jobID = context.params.jobID;
    const email = afterData.email;
    const phoneNumber = afterData.pharmacyNumber;

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
        pharmacyAddress: pharmacyAddress,
        pharmacyName:pharmacyName,
        pharmacyUID:pharmacyUID,
        email: email,
        jobID: jobID,
        phoneNumber: phoneNumber,
    }
    //functions.logger.log("Hello, here is the after data: ");

    
    return aggregatedDataRef.update({[next.jobID]: next})

    
    // functions.logger.log("Hello, here is the after data address: ", afterData.firstName);
    // functions.logger.log("Hello, here is the uid: ", context.params.uid);
});

exports.deleteJobs = functions.firestore.document("Users/{uid}/Main/{jobID}").onDelete((snapShot, context) => {
    const afterData = snapShot.data();  
    const FieldValue = admin.firestore.FieldValue;

    const aggregatedDataRef = dataBase.doc(`aggregation/jobs`);
    //functions.logger.log("Hello, here is the after data: ", afterData);
    
    return aggregatedDataRef.update({[context.params.jobID] : FieldValue.delete()});

    
    // functions.logger.log("Hello, here is the after data address: ", afterData.firstName);
    // functions.logger.log("Hello, here is the uid: ", context.params.uid);
});

exports.updateJobStatus = functions.runWith({memory: '2GB'}).pubsub.schedule(`0 0 * * *`).onRun(async context => {
    dataBase.doc(`aggregation/jobs`).get().then(snapshot => {
        const aggregateJobsData = snapshot.data();
        //functions.logger.log("Jobs Data: ", aggregateJobsData);
        for (const jobID in aggregateJobsData) {
            console.log(`${jobID}: `);
            const userUID = aggregateJobsData[jobID]["pharmacyUID"];
            console.log(`UserUID: ${userUID}`);
            // console.log(aggregateJobsData[jobID]["endDate"]);
            // console.log("Job Date: " + aggregateJobsData[jobID]["endDate"].toDate());
            // console.log("Current Date: " + Date.now());
            // console.log("Check: ");
            // console.log(aggregateJobsData[jobID]["endDate"].toDate() < Date.now());
            if(aggregateJobsData[jobID]["endDate"].toDate() < Date.now()){
                console.log("Job Date: " + Date(aggregateJobsData[jobID]["endDate"]));
                console.log("Current Date: " + Date());
                const jobPosterRef = dataBase.doc(`Users/${userUID}/Main/${jobID}`);
                //console.log(jobPosterRef)
                jobPosterRef.update({"jobStatus":"past"});
            }
        }
     });
     return null;
});


//TEST
exports.updateJobStatus = functions.firestore.document("aggregation2/jobs").onUpdate((change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();
    dataBase.doc(`aggregation/jobs`).get().then(snapshot => {
       const aggregateJobsData = snapshot.data();
       //functions.logger.log("Jobs Data: ", aggregateJobsData);
       for (const jobID in aggregateJobsData) {
           console.log(`${jobID}: `);
           const userUID = aggregateJobsData[jobID]["pharmacyUID"];
           console.log(`UserUID: ${userUID}`);
           // console.log(aggregateJobsData[jobID]["endDate"]);
           // console.log("Job Date: " + aggregateJobsData[jobID]["endDate"].toDate());
           // console.log("Current Date: " + Date.now());
           // console.log("Check: ");
           // console.log(aggregateJobsData[jobID]["endDate"].toDate() < Date.now());
           if(aggregateJobsData[jobID]["endDate"].toDate() < Date.now()){
               console.log("Job Date: " + Date(aggregateJobsData[jobID]["endDate"]));
               console.log("Current Date: " + Date());
               const jobPosterRef = dataBase.doc(`Users/${userUID}/Main/${jobID}`);
               //console.log(jobPosterRef)
               jobPosterRef.update({"jobStatus":"past"});
           }
       }
    });
    return null;
});