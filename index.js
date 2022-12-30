const express = require('express')
var cors = require('cors')
const app = express()
const port = 3000

app.use(cors())
app.use('/hls', express.static('hls'))
app.use('/dash', express.static('dash'))

app.use(function(req, res, next) {
    console.log(JSON.stringify(req.headers));

    res.setHeader('Cache-Control', 'no-cache;');
    res.setHeader('Access-Control-Max-Age', '86400');
    res.setHeader('Access-Control-Allow-Credentials', 'true');
    res.setHeader('Access-Control-Expose-Headers', 'Server,range,Date,hdntl,hdnts,Akamai-Mon-Iucid-Ing,Akamai-Mon-Iucid-Del,Akamai-Request-BC,Content-Length,Content-Range,Geo-Info,Quic-Version');
    res.setHeader('Access-Control-Allow-Headers', 'origin,range,hdntl,hdnts,accept-encoding,referer,CMCD-Request,CMCD-Object,CMCD-Status,CMCD-Session');
    res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
    next();
});

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})


