
const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.static(__dirname));
app.use(express.json());

// Serve main application
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({ 
        status: 'OK', 
        message: 'Railway Booking System is running',
        timestamp: new Date().toISOString()
    });
});

// API routes
app.get('/api/trains', (req, res) => {
    const trains = [
        { id: 1, name: 'Rajdhani Express', number: '12301', available: true },
        { id: 2, name: 'Shatabdi Express', number: '12001', available: true },
        { id: 3, name: 'Duronto Express', number: '12201', available: false }
    ];
    res.json(trains);
});

app.post('/api/bookings', (req, res) => {
    const booking = req.body;
    booking.id = Date.now();
    booking.status = 'Confirmed';
    booking.pnr = Math.random().toString(36).substr(2, 9).toUpperCase();
    res.json(booking);
});

// CRITICAL FIX: Bind to 0.0.0.0 instead of localhost
app.listen(port, '0.0.0.0', () => {
    console.log('✅ Railway Booking System running on port ' + port);
    console.log('🌐 Access the application at: http://0.0.0.0:' + port);
    console.log('🚀 Application is Kubernetes-ready!');
});
