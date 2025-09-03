// BarangaySubtitleFeedbackAPI.js
// Collects feedback from barangay viewers on subtitle clarity and emotional resonance

const express = require('express');
const app = express();
app.use(express.json());

let feedbackLog = [];

app.post('/feedback', (req, res) => {
  const { videoTitle, clarityScore, emotionalImpact, comments } = req.body;
  feedbackLog.push({ videoTitle, clarityScore, emotionalImpact, comments, timestamp: Date.now() });
  res.send({ status: "Feedback received", totalEntries: feedbackLog.length });
});

app.get('/summary', (req, res) => {
  const avgClarity = feedbackLog.reduce((sum, f) => sum + f.clarityScore, 0) / feedbackLog.length;
  const avgImpact = feedbackLog.reduce((sum, f) => sum + f.emotionalImpact, 0) / feedbackLog.length;
  res.send({ avgClarity, avgImpact, totalEntries: feedbackLog.length });
});

app.listen(4000, () => console.log("Barangay Subtitle Feedback API active on port 4000"));
