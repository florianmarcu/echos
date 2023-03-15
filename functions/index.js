require('dotenv').config()
const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

const sgMail = require("@sendgrid/mail");
const SG_API_KEY = process.env.SG_API_KEY;
const SG_TEMPLATE_EMAIL_CONFIRMATION_USER = process.env.SG_TEMPLATE_EMAIL_CONFIRMATION_USER;
sgMail.setApiKey(SG_API_KEY);

const accountSid = process.env.TW_ACCOUNT_SID; 
const authToken = process.env.TW_AUTH_TOKEN; 
const twilio = require('twilio')(accountSid, authToken); 


exports.sendEmergencyAlertAsEmailAndSMS = functions.firestore
    .document("users/{user}/devices/{device}/alerts/{alert}")
    .onCreate(async (doc, context) => {
        const data = doc.data();
        const userDoc = await doc.ref.parent.parent.parent.parent.get();
        const userData = userDoc.data();
        console.log(userData);
        const msg = {
            to: data['email'],
            from: userData['email'],
            templateId: SG_TEMPLATE_EMAIL_CONFIRMATION_USER,
            dynamic_template_data: {
                text: data['email_message']
            }
        };
        console.log(msg);
        /// Send EMAIL
        Promise.all([sgMail.send(msg)]).then(value => {
            console.log(value);
        });
        /// Send SMS
        twilio.messages
        .create({
          body: data['sms_message'],
          messagingServiceSid: process.env.TW_MESSAGING_SERVICE,
          to: data['sms_phone_number_prefix'] + data['sms_phone_number']
        });
    });
