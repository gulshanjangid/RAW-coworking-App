const nodemailer = require('nodemailer');
require('dotenv').config();
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
    },
});

const sendMail = async (to, subject, html) => {
    return transporter.sendMail({
        from: `"Meeting App" <${process.env.EMAIL_USER}>`,
        to,
        subject:'Meeting Room Booking Confirmation',
        html,
    });
};

module.exports = sendMail;
