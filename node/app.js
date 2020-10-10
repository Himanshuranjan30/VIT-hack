const express= require('express');
const app= express();
const bodyparser= require('body-parser');
app.use(bodyparser.json());
app.use(express.json());
app.post('/posts',(req,res)=>{
    res.json(req.body);
    console.log(req.body);
});
app.get('/',(req,res)=>{
    res.send('hey');
})

app.listen(5001);