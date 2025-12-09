import { useState } from 'react'
import './App.css'
import User from './User'

function App() {
  const [user, setUser] = useState({})
  const [success, setSuccess] = useState(false)

  function getUser() {
    fetch('http://localhost:3000/api/v2/users/me', {
      headers: {
        "Authorization": "Bearer 123489"
      }
    })
    .then(response => {
      if (!response.ok) setSuccess(false)
      return response.json()
    })
    .then(data => {
      setUser(data)
      setSuccess(true)
    })
    .catch(error => console.error(error))
  }

  return (
    <>
      <h1>Neon Lab</h1>
      <div className="card">
        <button onClick={getUser}>
          Who am I?
        </button>
        <div className='result'>
          {success ? <User user={user}/> : 'Nobody'}
        </div>
      </div>
    </>
  )
}

export default App
