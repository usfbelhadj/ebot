import express from 'express';
import nodemailer from 'nodemailer';

const app = express();
app.use(express.json());

const otpStore = {};

// Configure nodemailer
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'joseph.belhadj@gmail.com',
    pass: 'govd wuqj vxeg rprn',
  },
});

// API to send OTP
app.post('/send-otp', (req, res) => {
  console.log('Received OTP request:', req.body);
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ message: 'Email is required' });
  }

  const otp = Math.floor(100000 + Math.random() * 900000);
  otpStore[email] = otp;

  const mailOptions = {
    from: 'joseph.belhadj@gmail.com',
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

  const storedOtp = otpStore[email];
  if (storedOtp && storedOtp === parseInt(otp, 10)) {
    delete otpStore[email];
    console.log(`OTP verified for ${email}`);
    return res.status(200).json({ message: 'OTP verified successfully' });
  }

  console.warn(`Invalid or expired OTP for ${email}`);
  res.status(400).json({ message: 'Invalid or expired OTP' });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`OTP server running on http://localhost:${PORT}`);
});
