// All external modules are loaded in:
const express = require('express')
const app = express()
const path = require('path')
const fs = require('fs')
const cors = require('cors')
const axios = require('axios')

const targetIP = '192.168.50.246'

let scriptINdata = {
    'booleans': [],
    'floats': []
}

let scriptOUTdata = {
    'booleans': [],
    'floats': []
}

for (let i=0; i< 32; i++) {
    scriptINdata['booleans'][i] = false
    scriptINdata['floats'][i] = 0
    scriptOUTdata['booleans'][i] = false
    scriptOUTdata['floats'][i] = 0
}

// Reading input from terminal start
const port = parseInt(process.argv[2]) || 3000
console.log(`${port} registered as server port`)
// Reading input from terminal end

app.use(cors()) // Making sure the browser can request more data after it is loaded on the client computer.

app.get('/', (req, res) => {
    console.log('Connection established!')
    res.send('Connected!')
})

app.get('/inData', (req, res) => {

    if (req.query.setValue == 'true' && req.query.type == 'booleans') {
        let indexVal = null
        if (req.query.value == 'true') {
            indexVal = true
        }else {
            indexVal = false
        }
        scriptINdata[req.query.type][parseInt(req.query.index) - 1] = indexVal
    }
    else if (req.query.setValue == 'true' && req.query.type == 'floats') {
        scriptINdata[req.query.type][parseInt(req.query.index) - 1] = parseFloat(req.query.value)
    }

    res.send(`${scriptINdata[req.query.type][parseInt(req.query.index) - 1]}`)
})

app.get('/outData', (req, res) => {
    console.log('Script output data retrieved')

    if (req.query.setValue == 'true' && req.query.type == 'booleans') {
        let indexVal = null
        if (req.query.value == 'true') {
            indexVal = true
        }else {
            indexVal = false
        }
        scriptOUTdata[req.query.type][parseInt(req.query.index) - 1] = indexVal
    }
    else if (req.query.setValue == 'true' && req.query.type == 'floats') {
        scriptOUTdata[req.query.type][parseInt(req.query.index) - 1] = parseFloat(indexVal)
    }

    res.send(scriptOUTdata[req.query.type][parseInt(req.query.index) - 1])
})

setInterval(() => {
    console.log("updating target server")
    axios.get(`http://${targetIP}:3000/outData?setValue=true&type=booleans&index=1&value=true`)
}, 16)

app.listen(port, () => console.log(`Listening on ${port}`))