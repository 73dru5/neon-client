import React from 'react'
import { createRoot } from 'react-dom/client'


// Your root React component (e.g., App.jsx in the same dir)
import App from './App.jsx'

const container = document.getElementById('app')  // Add <div id="app"></div> to your index.html later
const root = createRoot(container)
root.render(<App />)