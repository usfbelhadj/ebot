const express = require('express');
const nodemailer = require('nodemailer');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

const otpStore = {}; // Store OTPs temporarily in memory

// Configure nodemailer
const transporter = nodemailer.createTransport({
  service: 'gmail', // Use your email service
  auth: {
    user: 'joseph.belhadj@gmail.com', // Replace with your email
    pass: 'govd wuqj vxeg rprn', // Replace with your email password or app password
  },
});

// API to send OTP
app.post('/send-otp', (req, res) => {
  console.log('Received OTP request:', req.body);
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ message: 'Email is required' });
  }

  const otp = Math.floor(100000 + Math.random() * 900000); // Generate 6-digit OTP
  otpStore[email] = otp;

  const mailOptions = {
    from: 'joseph.belhadj@gmail.com', // Replace with your email
    to: email,
    subject: 'Your OTP Code',
    text: `Your OTP code is ${otp}. It is valid for 5 minutes.`,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error(error);
      return res.status(500).json({ message: 'Failed to send OTP' });
    }

    console.log(`OTP sent to ${email}: ${otp}`);
    res.status(200).json({ message: 'OTP sent successfully' });

    // Expire OTP after 5 minutes
    setTimeout(() => {
      delete otpStore[email];
    }, 5 * 60 * 1000);
  });
});

// API to verify OTP
app.post('/verify-otp', (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(400).json({ message: 'Email and OTP are required' });
  }

  if (otpStore[email]) {
    const storedOtp = otpStore[email];
    if (storedOtp === parseInt(otp, 10)) {
      delete otpStore[email]; // Remove OTP after successful verification
      console.log(`OTP verified for ${email}`);
      return res.status(200).json({ message: 'OTP verified successfully' });
    } else {
      console.warn(`Invalid OTP attempt for ${email}: Received ${otp}, Expected ${storedOtp}`);
    }
  } else {
    console.warn(`No OTP found or expired for ${email}`);
  }

  res.status(400).json({ message: 'Invalid or expired OTP' });
});

// Start the server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`OTP server running on http://localhost:${PORT}`);
});