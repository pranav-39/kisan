/**
 * Project Kisan - Firebase Cloud Functions Backend
 * 
 * This file contains the server-side logic for:
 * - Gemini API proxy (secure API key handling)
 * - Weather data fetching
 * - Market price aggregation
 * - Data synchronization
 * 
 * TODO: Deploy to Firebase Cloud Functions
 * Command: firebase deploy --only functions
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// TODO: Store these securely in Firebase Functions config
// firebase functions:config:set gemini.api_key="YOUR_API_KEY"
// const GEMINI_API_KEY = functions.config().gemini?.api_key;

/**
 * Gemini Text Generation Proxy
 * Securely proxies requests to Gemini API without exposing API key to client
 */
exports.generateText = functions.https.onRequest(async (req, res) => {
  // Enable CORS
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'POST');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).send({ error: 'Method not allowed' });
    return;
  }

  try {
    const { prompt, systemInstruction, temperature, maxTokens } = req.body;

    // TODO: Implement actual Gemini API call
    // const { GoogleGenerativeAI } = require('@google/generative-ai');
    // const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
    // const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
    // const result = await model.generateContent(prompt);
    // const response = result.response.text();

    // Stub response for development
    const response = {
      text: `AI Response for: ${prompt.substring(0, 50)}...`,
      usage: { inputTokens: 100, outputTokens: 50 }
    };

    res.status(200).json(response);
  } catch (error) {
    console.error('Error generating text:', error);
    res.status(500).json({ error: 'Failed to generate text' });
  }
});

/**
 * Gemini Vision API Proxy
 * Handles crop disease diagnosis with image analysis
 */
exports.analyzeImage = functions.https.onRequest(async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'POST');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).send({ error: 'Method not allowed' });
    return;
  }

  try {
    const { image, mimeType, prompt, systemInstruction } = req.body;

    // TODO: Implement actual Gemini Vision API call
    // const { GoogleGenerativeAI } = require('@google/generative-ai');
    // const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
    // const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
    // 
    // const imagePart = {
    //   inlineData: { data: image, mimeType: mimeType }
    // };
    // const result = await model.generateContent([prompt, imagePart]);

    // Stub response
    const response = {
      isHealthy: Math.random() > 0.5,
      diseaseName: 'Late Blight',
      confidence: 0.87,
      severity: 'medium',
      symptoms: ['Water-soaked lesions', 'White fungal growth'],
      treatment: {
        chemical: { productName: 'Mancozeb 75% WP', dosage: '2.5g/L' },
        organic: { name: 'Copper Hydroxide', preparation: 'Mix 3g/L' }
      }
    };

    res.status(200).json(response);
  } catch (error) {
    console.error('Error analyzing image:', error);
    res.status(500).json({ error: 'Failed to analyze image' });
  }
});

/**
 * Gemini Chat Proxy
 * Handles multi-turn conversation with the AI assistant
 */
exports.chat = functions.https.onRequest(async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'POST');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).send({ error: 'Method not allowed' });
    return;
  }

  try {
    const { messages, systemInstruction, temperature } = req.body;

    // TODO: Implement actual Gemini chat
    // Use chat.sendMessage() for multi-turn conversations

    const lastMessage = messages[messages.length - 1]?.content || '';
    let response = 'I can help you with farming advice, weather, market prices, and crop diseases. What would you like to know?';

    if (lastMessage.toLowerCase().includes('price')) {
      response = 'Based on current market data, wheat is trading at Rs 2,450 per quintal. Prices have been stable this week.';
    } else if (lastMessage.toLowerCase().includes('weather')) {
      response = 'Current weather shows partly cloudy skies with temperature around 28°C. Good conditions for field work.';
    }

    res.status(200).json({ response });
  } catch (error) {
    console.error('Error in chat:', error);
    res.status(500).json({ error: 'Chat request failed' });
  }
});

/**
 * Get Weather Data
 * Fetches weather data and generates AI-based farming advice
 */
exports.getWeather = functions.https.onRequest(async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');

  try {
    const { lat, lon } = req.query;

    // TODO: Integrate with actual weather API
    // Consider: OpenWeatherMap, WeatherAPI, or Google Weather API

    const weather = {
      locationName: 'New Delhi, India',
      latitude: parseFloat(lat) || 28.6139,
      longitude: parseFloat(lon) || 77.2090,
      current: {
        temperature: 28.5,
        feelsLike: 31.2,
        humidity: 65,
        windSpeed: 12.5,
        windDirection: 'NW',
        rainfall: 0.0,
        uvIndex: 6,
        condition: 'Partly Cloudy',
        conditionIcon: 'partly_cloudy'
      },
      forecast: [],
      advice: {
        irrigation: {
          shouldIrrigate: true,
          recommendation: 'Soil moisture is low. Irrigate in early morning.',
          bestTime: '6:00 AM - 8:00 AM'
        },
        spray: {
          isSuitable: true,
          recommendation: 'Weather conditions favorable for spraying.',
          bestWindow: '7:00 AM - 10:00 AM'
        },
        generalTips: ['Good day for field activities'],
        alerts: []
      },
      updatedAt: new Date().toISOString()
    };

    res.status(200).json(weather);
  } catch (error) {
    console.error('Error fetching weather:', error);
    res.status(500).json({ error: 'Failed to fetch weather data' });
  }
});

/**
 * Get Market Prices
 * Fetches mandi prices from data sources
 */
exports.getMarketPrices = functions.https.onRequest(async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');

  try {
    const { crop, state } = req.query;

    // TODO: Integrate with Agmarknet API or other price sources
    // API: https://agmarknet.gov.in/

    const prices = [
      {
        id: '1',
        cropName: 'Wheat',
        cropNameLocal: 'गेहूं',
        mandiName: 'Azadpur Mandi',
        mandiLocation: 'Delhi',
        state: 'Delhi',
        pricePerQuintal: 2450,
        previousPrice: 2380,
        trend: 'up',
        percentChange: 2.94,
        recommendation: 'hold',
        aiInsight: 'Prices trending upward due to increased demand.',
        updatedAt: new Date().toISOString()
      }
    ];

    res.status(200).json({ prices });
  } catch (error) {
    console.error('Error fetching market prices:', error);
    res.status(500).json({ error: 'Failed to fetch market prices' });
  }
});

/**
 * Sync User Data
 * Handles offline data synchronization
 */
exports.syncData = functions.https.onRequest(async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'POST');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method !== 'POST') {
    res.status(405).send({ error: 'Method not allowed' });
    return;
  }

  try {
    const { userId, diagnoses, lastSyncTime } = req.body;

    // TODO: Implement data sync logic with Firestore
    // - Merge client data with server data
    // - Resolve conflicts based on timestamps
    // - Return updated data to client

    res.status(200).json({
      success: true,
      syncedAt: new Date().toISOString(),
      updatedItems: []
    });
  } catch (error) {
    console.error('Error syncing data:', error);
    res.status(500).json({ error: 'Sync failed' });
  }
});

// Scheduled function to update market prices daily
exports.scheduledPriceUpdate = functions.pubsub
  .schedule('0 6 * * *')  // Every day at 6 AM
  .timeZone('Asia/Kolkata')
  .onRun(async (context) => {
    console.log('Running scheduled market price update...');
    // TODO: Fetch and cache latest prices
    return null;
  });
