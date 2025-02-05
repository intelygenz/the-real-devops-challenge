const express = require('express');
const app = express();
const port = process.env.PORT || "8000"

app.get('/', (req, res) => {
  res.send('Hello, WORLD!!!');
});

app.listen(port, () => {
    console.log(`DevOps Challenge listening at http://localhost:${port}`);
});