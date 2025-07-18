module.exports = ({ username, name, phone, location, date, timeSlot, price }) => `
  <div style="max-width: 600px; margin: auto; padding: 20px; font-family: 'Segoe UI', sans-serif; background-color: #fffbe6; border-radius: 8px; border: 1px solid #f1c40f;">
    <h2 style="color: #f39c12; text-align: center;">📩 New Meeting Room Booking</h2>
    <p style="text-align: center; color: #444;">A user has booked a meeting room. Here are the details:</p>
    <table style="width: 100%; margin-top: 20px; border-collapse: collapse;">
      <tbody>
        <tr><td style="padding: 8px; font-weight: bold;">Username:</td><td style="padding: 8px;">${username}</td></tr>
        <tr style="background-color: #fdf5d4;"><td style="padding: 8px; font-weight: bold;">Name:</td><td style="padding: 8px;">${name}</td></tr>
        <tr><td style="padding: 8px; font-weight: bold;">Phone:</td><td style="padding: 8px;">${phone}</td></tr>
        <tr style="background-color: #fdf5d4;"><td style="padding: 8px; font-weight: bold;">Location:</td><td style="padding: 8px;">${location}</td></tr>
        <tr><td style="padding: 8px; font-weight: bold;">Date:</td><td style="padding: 8px;">${date}</td></tr>
        <tr style="background-color: #fdf5d4;"><td style="padding: 8px; font-weight: bold;">Time Slot:</td><td style="padding: 8px;">${timeSlot}</td></tr>
        <tr><td style="padding: 8px; font-weight: bold;">Price:</td><td style="padding: 8px; color: #e67e22;"><strong>₹${price}</strong></td></tr>
      </tbody>
    </table>
    <p style="margin-top: 30px; text-align: center; color: #888;">This is an automated notification for admin use.</p>
    <p style="text-align: center; color: #aaa; font-size: 12px;">&copy; ${new Date().getFullYear()} Meeting Room App</p>
  </div>
`;
