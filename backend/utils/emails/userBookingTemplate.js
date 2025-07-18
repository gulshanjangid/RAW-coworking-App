module.exports = ({ username, name, phone, location, date, timeSlot, price }) => `
  <div style="max-width: 600px; margin: auto; padding: 20px; font-family: 'Segoe UI', sans-serif; background-color: #f9f9f9; border-radius: 8px; border: 1px solid #ddd;">
    <h2 style="color: #4CAF50; text-align: center;">✅ Your Meeting Room Booking is Confirmed!</h2>
    <p style="text-align: center; color: #555;">Hi ${name}, thanks for booking with us. Here are your meeting details:</p>
    <table style="width: 100%; margin-top: 20px; border-collapse: collapse;">
      <tbody>
        <tr><td style="padding: 8px; font-weight: bold;">Username:</td><td style="padding: 8px;">${username}</td></tr>
        <tr style="background-color: #f1f1f1;"><td style="padding: 8px; font-weight: bold;">Name:</td><td style="padding: 8px;">${name}</td></tr>
        <tr><td style="padding: 8px; font-weight: bold;">Phone:</td><td style="padding: 8px;">${phone}</td></tr>
        <tr style="background-color: #f1f1f1;"><td style="padding: 8px; font-weight: bold;">Location:</td><td style="padding: 8px;">${location}</td></tr>
        <tr><td style="padding: 8px; font-weight: bold;">Date:</td><td style="padding: 8px;">${date}</td></tr>
        <tr style="background-color: #f1f1f1;"><td style="padding: 8px; font-weight: bold;">Time Slot:</td><td style="padding: 8px;">${timeSlot}</td></tr>
        <tr><td style="padding: 8px; font-weight: bold;">Price:</td><td style="padding: 8px; color: #4CAF50;"><strong>₹${price}</strong></td></tr>
      </tbody>
    </table>
    <p style="margin-top: 30px; text-align: center; color: #888;">We look forward to seeing you!</p>
    <p style="text-align: center; color: #aaa; font-size: 12px;">&copy; ${new Date().getFullYear()} Meeting Room App</p>
  </div>
`;
