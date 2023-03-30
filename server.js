#!/usr/bin/env node
//WebChat interaction API &&
let app = require("express")();
let bodyparser = require("body-parser");
app.use(bodyparser.urlencoded({extended: false}));
let msgs = new Object({});
let titles = "";

app.get("/api/get/*", (req,res) => {
    let pubkey = req.path.split("/").at(-1);
    out = "";
    if (pubkey == "all")
    {
        let i=0;
        titles.split(",").forEach(title => {
            out += i + ": " + title + ", ";
            i++;
        });
        res.send(out.slice(0,-7)); //? Take the extra off the end
    }
    if (pubkey.startsWith("@"))
    {
        let no = pubkey.slice(1,7);
        console.log(no);
        res.send(msgs[titles.split(",")[no]])
    }
    res.send(msgs[pubkey]);
});

app.post("/api/post/*", (req,res) => {
    try
    {
        Object.defineProperty(msgs, req.body.usrKey, {value: req.body.msg});
        titles += req.body.usrKey + ",";
    }
    catch(err)
    {
        res.send(err.message);
    }
    res.send("Sent.");
});

app.listen(8181);
