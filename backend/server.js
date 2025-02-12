const bcrypt = require('bcrypt');
const express = require('express');
const jwt = require('jsonwebtoken');
const cors = require("cors");
const asyncHandler = require('express-async-handler')
require('dotenv').config();
require('./dbconnection');

const User = require('./model');

const app = express();

app.use(express.json());
app.use(cors({
    origin: '*', 
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true
}));

const AuthenticateToken = asyncHandler(async (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) {
        return res.status(401).json({ message: 'No token provided' });
    }
    const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
        if (err) return res.sendStatus(403);

        if (user.id !== req.params.userId ) {
            return res.status(403).json({ message: 'Access denied' });
        }
        req.user = decoded;
        next();
    });
});

app.post('/api/register', async (req, res) => {
    try {
        const { email, password } = req.body;
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ message: 'User already exists' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const user = new User({
            email,
            password: hashedPassword,
        });
        
        await user.save();
        
        res.status(201).json({ message: 'User created successfully' });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ message: 'Error creating user' });
    }
});

app.post('/api/login', asyncHandler(async (req, res) => {
    try {
        const { email, password } = req.body;
        console.log("Login attempt:", email); // Debug

        const user = await User.findOne({ email });
        if (!user) {
            console.log("User not found:", email);
            return res.status(400).json({ message: 'User not found' });
        }

        console.log("User found:", user);

        const validPassword = await bcrypt.compare(password, user.password);
        if (!validPassword) {
            console.log("Invalid password for:", email);
            return res.status(400).json({ message: 'Invalid password' });
        }

        const token = jwt.sign(
            { userId: user._id }, 
            process.env.JWT_SECRET || 'your_jwt_secret',
            { expiresIn: '24h' }
        );

        res.json({ 
            token,
            user: {
                id: user._id.toString(),
                email: user.email,
                createdAt: user.createdAt
            }
        });

    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ message: 'Error logging in' });
    }
}));

app.get('/api/profile/:userId', AuthenticateToken, async (req, res) => {
    try {
        const userId = req.params.userId;
        const user = await User.findById(userId).select('-password');
        
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.json({
            success: true,
            profile: {
                id: user._id,
                email: user.email,
            }
        });
    }
    catch (error) {
        console.error("Error fetching profile:", error);
        res.status(500).json({ message: 'Error fetching profile' });
    }
});

app.put('/api/profile/:userId', AuthenticateToken, async (req, res) => {
    try {
        const userId = req.params.userId;
        const update = req.body;
        const user = await User.findByIdAndUpdate(userId, update, { new: true }).select('-password');
        
        if (!user) {
            return res.status(404).json({ message: 'User cannot be updated' });
        }

        if (update.password) {
            update.password = await bcrypt.hash(update.password, 10);
        }

        res.json({
            success: true,
            profile: {
                id: user._id,
                email: user.email,
            }
        });
    }
    catch (error) {
        console.error("Error updating user profile:", error);
        res.status(500).json({ message: 'Error updating user profile' });
    }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});