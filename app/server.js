const express = require("express");
const path = require("path");

const app = express();

const port = process.env.PORT || "8080";
const host = "0.0.0.0"

app.get("/", (req, res) => {
  res.render("index", { title: "Home" });
});

app.get("/user", (req, res) => {
  res.render("user", { title: "Profile", userProfile: { fullName: "Matthew Crook", name: "Matt Crook", skills: ["Javascript", "Python", "Go", "Kubernetes", "Terraform", "Helm", "Bash", "Docker"] } });
});

app.set("views", path.join(__dirname, "views"));

// The view engine setting tells Express what template engine to use, which in this case, is pug.
app.set("view engine", "pug");

// built-in middleware function that specifies the directory path from which to serve static assets
app.use(express.static(path.join(__dirname, "public")));

app.listen(port, host)
console.log(`Listening to requests on http://localhost:${port}`);
