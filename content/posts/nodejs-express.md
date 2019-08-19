---
title: Learn how to create an Express app in Node.js and deploy on Azure
date: 2019-08-19
categories: [web]
tags: [nodejs, web, containers, docker, appservice]
duration: 12:00
---

{{< step label="Overview" >}}
The intent of this project is to take you step-by-step through the process of building an Express app, documenting the changes as bite-sized chunks that you'll ideally be able to pick up and iterate upon rapidly.

Written by [Tierney Cyren](https://github.com/bnb)

### What you'll learn

- How to create a Node.js app and deploy to Azure

### What you'll need

- All steps:
  - [Node.js](https://nodejs.org/en/)
- Step Seven:
  - [Docker app](https://www.docker.com/get-started)
  - [Docker Hub account](https://hub.docker.com/)
- Optional:
  - [Azure account](https://aka.ms/step-by-step-express-azure) (free tier works just fine 💖)
- Source Code
  - [Github](https://github.com/bnb/step-by-step-express-workshop/)
Ready? Let's get started!

{{< /step >}}


{{< step label="Boilerplating This Project" >}}

Scaffolding out a Node.js project's boilerplate can be relatively straightforward. For this project, I ran the following commands to get started:

- `npm init`
  - Begins an npm initalization tool that builds a default `package.json` for you.
  - I've personally added some config settings in my root `.npmrc` config file that allows me to run `npm init -y` and have all my personal preferences scaffolded out.
- `git init`
  - Initialize the project as a git repository
  - I've grown up using GitHub so git is a natural source control tool for me, but you can really use whatever you're comfortable with/whatever works for your projects.
- `npx gitignore node`
  - This will pull the Node.js `.gitignore` that's maintained by GitHub. Also works for any other named `.gitignore`.
- `npx covgen tierney.cyren@microsoft.com`
  - This scaffolds out a Code of Conduct (sepcifically, the [Contributor Covenant](https://www.contributor-covenant.org/)) for my project, which I already know I'm comfortable actively enforcing.
- `npx license mit > LICENSE`
  - This will spit out the text of the MIT license into my terminal, and uses an output redirection operator that puts that text into the LICENSE file.
  - I've found that some companies, including major tech companies like Google, block their employees from contributing to projects that don't have an explicit license file defined in a project. Best to lower that barrier up front.

### As Commands

Here's the commands I've used to scaffold out this project without all the context that's included above:

```bash
npm init
git init
npx gitignore node
npx covgen <your email address here>
npx license mit > LICENSE
```

{{< /step >}}



{{< step label="Create a Basic Web Server" >}}

[Source Code for This Step](https://github.com/bnb/step-by-step-express-workshop/tree/master/step-one)

We'll install Express (`npm i express`), and set up an extremely simple web server using Express in `app.js`. This web server will listen to port `8080`, and are responding to a single route (`/`) with a simple message (`Hello from Express! 👋`). Finally, we let ourselves know the app is running by logging a tiny message out to the console.

Let's set up all the variables we'll use (put these at the very top of our `app.js` file):

```javascript
const express = require('express')
const app = express()
const port = 8080
```

Next, we're going to set up a route that will listen to the path browsers default to when they connect to a website. We'll achieve this with Express's `.get()` method, which takes two arguments – a path and a callback function:

```javascript
app.get(<path argument>, <callback function> {
  // this is where we are able to define what we want to do when someone navigates to this path
  response.send(<what we want to send back to the client>)
})
```

So, let's define the path and the arguemnts. In this case, I'm using the arrow function syntax (`(arguments) => {/* do work */}`) for defining a function – normal function syntax (`function (arguments) {/* do work */}`) works equally well here.

```javascript
app.get('/', (request, response) => {
  response.send(<what we want to send back to the client>)
})
```

Let's send a tiny, basic response to the connecting client:

```javascript
app.get('/', (request, response) => {
  response.send('Hello from XKCD-serv! 👋')
})
```

Finally, let's set Express up to actively listen to incoming requests using the `port` and log that when we start the app:

```javascript
app.listen(port, () => console.log(`Our app is now listening on port ${port}!`))
```

## Steps

- Require Express
- Instantiate Express and assign it to `app`
- Set up a variable for the port – we'll use `8080` as the value for that variable
- Set up a single route that listens to the browser's default route + send a very simple response
- Set our app to listen to the port we defined in the variable and log that we're listening
{{< /step >}}


{{< step label="Routing in Express" >}}

[Source Code for This Step](https://github.com/bnb/step-by-step-express-workshop/tree/master/step-two)

We're going to figuring out how Express routing works by exposing a bit of the internal guts. You're going to set up up a new route that we're listening to and are logging the request object in the response to the client.

You can achieve this by using the same syntax we used previously:

```javascript
app.get(<path argument>, <callback function> {
  response.send(<what we want to send back to the client>)
})
```

In this case, we're going to want to use `/comic` as the value for `<path argument>`, and pass in an arrow function that takes `request` and `response` as arguments:

```javascript
app.get('/comic', (request, response) => {
  response.send(<what we want to send back to the client>)
})
```

Finally, we're going to pass the querystring (everything after `?` in the URL) as the response via `request.query`, meaning we're just directly outputting whatever the user is inputting:

```javascript
app.get('/comic', (request, response) => {
  response.send(request.query)
})
```

# Steps

- Add another route, `/comic`
- When the user hits this route, render the querystring that they're passing as a part of the request as the response
{{< /step >}}


{{< step label="Call API for Content" >}}

[Source Code for This Step](https://github.com/bnb/step-by-step-express-workshop/tree/master/step-three)

Now that we understand that the express `request.query` object (where `request` is the name of the request object you've included in your `app.get()` callback), we can start using that to query the API we're hitting – the XKCD website, whcih provides a JSON object for every comic.

We need to start by introducing `request` to our application – this can go at the top of the file, with our other variables:

```javascript
const r = require('request')
```

Next, we'll add an if/else in the `/comic` route's callback to detect if there's an `id` property in the querystring:

```javascript
  if (request.query.id) {
    // do work if there's a querystring with a key of `id`
  } else {
    // if there's not, send a basic message instructing the user on what to do
    response.send('Find a comic by adding a querystring to the current page. For example: https://tierneyxkcd.azurewebsites.net/comic?id=112')
  }
```

Next we'll begin accessing the data we're going to be using to build our site by using the Request module (we've assigned it to `r` in this case to hopefully help avoid confusion with the request in request/response) to reach out to XKCD API.

The Request module takes two parameters: a URL to fetch and a callback with three propperties (a variable for the error, a variable for the respose from the APPI, and the body returned by the API).

Here's that change, adding the call to `r()` inside of the `if(request.query.id)` block:

```javascript
  if (request.query.id) {
    r(`https://xkcd.com/${request.query.id}/info.0.json`, (error, responseFromAPI, body) => {
      // do work with the response from the request
    })
  } else {
    response.send('Find a comic by adding a querystring to the current page. For example: https://tierneyxkcd.azurewebsites.net/comic?id=112')
  }
```

Next, let's do some work with what Request returns. Specifically:

- let's `throw` if an error occurs
- let's log the response + the status code we get back
- let's send what we got as a resposne from the API

```javascript
  if (request.query.id) {
    r(`https://xkcd.com/${request.query.id}/info.0.json`, (error, responseFromAPI, body) => {
      if (error) throw error // throw if there's an error

      console.log(`Response from XKCD website when calling https://xkcd.com/${request.query.id}/info.0.json: ${responseFromAPI} ${responseFromAPI.statusCode}`) // let's log the response + the status code we get back

      response.send(body) // let's send what we got as a resposne from the API
    })
  } else {
    response.send('Find a comic by adding a querystring to the current page. For example: https://tierneyxkcd.azurewebsites.net/comic?id=112')
  }
```

Interestingly, because we're directly sending the response from the XKCD website without any additional modification (via `response.send(body)`), we've actually created an extremely basic reverse proxy – a powerful tool that can be used to seamlessly transition back-ends from one tool, language, or platform to another.
{{< /step >}}



{{< step label="Templates" >}}

[Source Code for This Step](https://github.com/bnb/step-by-step-express-workshop/tree/master/step-four)


In this step, we start parsing the JSON response we're getting from the URI `request` is reaching out to. We are also introudce a very basic JS templating language – called `hanlebars` – into our application that allows us to seperate application logic from what we're serving to the user.

The first, we need to add `express-handlebars` to our application. Once again, this can go at the top:

```javascript
const handlebars = require('express-handlebars') // pull in the express-handlebars dependency
```

Next, we need to define express-handlebars as an engine and then set it as our default view engine:

```javascript
app.engine('handlebars', handlebars()) // set up handlebars as an engine
app.set('view engine', 'handlebars') // set handlebars as our default view engine
```

We've gone ahead and created a `views` directory with our first view – `comic.handlebars` – that we then render when someone hits the `/comic` path in our application. Since we're mainly focusing on Node.js and Express here, this is a bit outside of the scope of the workshop and we won't have you duplicate this work every time. If you'd like to look at what's in there, I highly encourage you to peek into `/views` to see the basic HTML we've written in the templates!

Next, we've added a few lines to the Request query to parse out the data we're getting back from the API. We pull a few properties on the JSON object into our own JSON object of data to render, and then responding to the client by rendering our `comic` template and passing in that data to the template:

```javascript
      const bodyToJson = JSON.parse(body) //parse the JSON we're getting from the API
      const dataToRender = { // assign a few specific bits of the parsed JSON to semantically named values
        'title': bodyToJson.safe_title, // title of the comic
        'img': bodyToJson.img, // comic image
        'desc': bodyToJson.alt // comic description
      }
      response.render('comic', dataToRender) // respond to the connecting client with the 'comic' handlebars template, and pass the dataToRender object
```

# Steps

- Add `express-handlebars to our aplication
- Define the `handlebars` engine with `app.engine()`
- Set the `view engine` to `handlebars` with `app.set`
- Created `/views` and added a single template, `comic.handlebars`
- Parse the JSON we're getting back from the API
- Build a new object that only contains the JSON we need to render our view correctly
- Send our response, rendering the `comic` handlebars template and passing in that new object with the data to render
{{< /step >}}



{{< step label="Add Some Style" >}}


[Source Code for This Step](https://github.com/bnb/step-by-step-express-workshop/tree/master/step-five)

This step is a relatively light one: we start to serve some baisc static CSS from our project, since our previous unstyled display was a bit... lacking.

Using Express's `static` method, we can serve from the `/static` directory. This will serve all static assets called from the `/static` directory – inhcluding assets like local images, stylesheets, and even the `favicon.ico` that browsers will automatically request.

```javascript
app.use(express.static('static')) // this will look at the `static` directory for our static assets
```

Since the following changes are in HTML and CSS, we won't need to change them in futher steps. That said, I wanted to be sure to be very explicit in what was actually happening to ensure you've got the full context of all the changes and there's no magic here 👍

We've also gone ahead and added a line to `views/comic.handlebars` which points to a CSS file accessible from the root path:

```HTML
<link rel="stylesheet" href="./comic.css">
```

Additionally, we've added a `/static` directory with a `comic.css` file:

```css
h1 {
  text-align: center;
}

.entry {
  display: block;
  width: fit-content;
  margin: 0 auto;
}
```
{{< /step >}}

{{< step label="Error Handling" >}}


[Source Code for This Step](https://github.com/bnb/step-by-step-express-workshop/tree/master/step-six)


In this step, we're adding Error handling. There are a few options for automatically scaffolding out Express applications (like [`express-generator`](http://npm.im/express-generator)) that will build out more effective error handling, but for this example I wanted to be sure to show you could build your own with minimal effort.

To do this, we need to add a function with four arguments (`(error, request, response, next)`), which will tell Express that this function is error handling middleware.

```
app.use((error, request, response, next) => {
  response.render('error', { error: error })
})
```

In this code example, we're calling Express's `.use()` method and passing the required four callbacks to let Express know we've encoutnered an error. Inside of the method's callback, we're telling Express to redner the `error` Handlebars template, and pass along the `error` argument from the callback as `problem`, which we use in the [`views/error.handlebars`](./views/error.handlebars) file.

Additionally, we need to start passing the `next` argument in the other Express method calls where we want to handle errors`

```javascript
app.get('/', (request, response, next) => {
```

and

```javascript
app.get('/comic', (request, response, next) => {
```

Finally, we want to replace anywhere we would have previously `throw`n errors with `next()`. In our case, as a way to handle errors thrown imediately in our callback to `r`, and wrap our JSON data builder in a `try`/`catch` where the `catch` can return an error if the `try` fails rather than crashing our application.

Here's the change we need to make at the beginning of our `r` callback:

```javascript
    r(`https://xkcd.com/${request.query.id}/info.0.json`, (error, responseFromAPI, body) => {
      if (error) return next(error)
```

And here's our try/catch addition, which just wraps our previous work to reender a `comic` view:

```javascript
      try {
        const bodyToJson = JSON.parse(body)
        const dataToRender = {
          'title': bodyToJson.safe_title,
          'img': bodyToJson.img,
          'desc': bodyToJson.alt
        }
        response.render('comic', dataToRender)
      } catch (error) {
        next(error)
      }
```

Now anytime we encounter an error _while requesting_ data from the XKCD API, an error will throw. This particular trigger is easy to encounter when we pass a comic ID that doesn't exist – for example, `7777777` or `beyonce`.

To wrap things up, we'll add the ability to use the `PORT` environment variable as the port we _should_ run the application on. If `PORT` isn't defined, we fall back to port `8080`. This is the only change required to deploy our app up to Azure AppService \o/

```javascript
const port = process.env.PORT ? process.env.PORT : 8080
```

Here's a general checklist of what you'll need to do to make sure your app will work with the least amount of effort when you deploy to AppService:

- Run your app on the port defined via the `PORT` environment variable
- The value of the `main` property in your `package.json` is the same as the main file of your app
- Your dependencies are all defined in `package.json`

If you have the [Azure App Service](https://aka.ms/app-service-extension) extension for VS Code, you can now right-click on the directory and select "Deploy to Web App" and ship it to prod!

{{< /step >}}


{{< step label="Containerize It" >}}


[Source Code for This Step](https://github.com/bnb/step-by-step-express-workshop/tree/master/step-seven)


In this step, we Dockerize!

The first step is adding a new npm script in our package.json, `start`, which can be run to start our app via npm:

```
  "scripts": {
    "lint": "standard",
    "diff": "npx prettydiff diff source:\"app.js\" diff:\"app.complete.js\"",
    "test": "echo \"Error: no test specified\" && exit 1",
    "start": "node app.js"
  }
```

Next, we went ahead and created `Dockerfile` and `.dockerignore`. In the Dockerfile we've scaffolded out a comparatively basic setup:

**Dockerfile:**

- Use the latest Node.js LTS with Alpine Linux
- Create an application directory
- Copy over the `package.json` and `package-lock.json` from the current directory
- Run `npm ci` to install dependencies rapidly
- Copy the dependencies into the app directory
- Run `npm start`

Here's the resulting Dockerfile:

```dockerfile
# Use LTS for stability and alpine for speed
FROM node:lts-alpine

# Create app directory
WORKDIR /usr/src/app

# A wildcard is used to ensure both package.json AND package-lock.json 
# are copied
COPY package*.json ./

# This command uses package-lock.json to install dependencies rapidly
RUN npm ci --only=production

# Copy the deps to the app – helps reduce build time in conjunction w/ previous
# COPY command
COPY . .

# Run `npm start`, which will execute `node app.js` as defined in the `start` 
# script in `package.json`
CMD [ "npm", "start" ]
```

**.dockerignore:**

- Ignore `node_modules`
- Ignore npm's debug file

Here's the resulting `.dockerignore`:

```
node_modules
npm-debug.log
```

Next, we'll _need_ to run a command to actually build the Docker image from the `Dockerfile`. To do this, run the following command after replacing `<YOUR_DOCKER_HUB_USERNAME>` with your [Docker Hub](https://hub.docker.com/) username:

```bash
docker build -t <YOUR_DOCKER_HUB_USERNAME>/step-by-step-express-workshop .
```

It's worth noting that `<YOUR_DOCKER_HUB_USERNAME>/step-by-step-express` can be any string – this is just the one I've decided to use personally, as it's more easily identifyable. You're not required to include your Docker Hub username nor the repo/project name, but this does seem to be the naming convention the Docker community has standardized on.

From there, we'll want to run the Docker image, publshing (`-p`) port 8080 and running it in detached mode (`-d`). You'll need to have Docker locally installed for this step!

```bash
docker run -p 8080:8080 -d <YOUR_DOCKER_HUB_USERNAME>/step-by-step-express-workshop
```

Next, you're going to want to publish this image to Docker Hub – this just requires a few steps:

```bash
docker login # log in with your Docker Hub credentials
```

```bash
docker push <YOUR_DOCKER_HUB_USERNAME>/step-by-step-express-workshop # push the image you built to hub.docker.com (the public registry)
```

Now, your app can be consumed on the public internet extremely easily! Anyone can pull it down from Docker Hub and get it up and running, including you. This is great, as any host that can deploy from Docker images, like [App Service](https://azure.microsoft.com/services/app-service/?WT.mc_id=stepbystepexpressworkshop-github-ticyren), can just automatically start running it from Docker Hub.

Additionally, since this step now has a Dockerfile you could even automatically build the Dockerfile on every commit and deploy it to production using something like App Service's [Deployment](https://docs.microsoft.com/azure/devops/pipelines/apps/cd/deploy-docker-webapp?view=azure-devops&WT.mc_id=stepbystepexpressworkshop-github-ticyren) functionality or [Azure Pipelines](https://docs.microsoft.com/azure/devops/pipelines/languages/docker?view=azure-devops&tabs=yaml&WT.mc_id=stepbystepexpressworkshop-github-ticyren) for ease of use \o/


{{< /step >}}



{{< step label="Deploy It" >}}

[Deploy it to Azure Web Apps using Docker](https://docs.microsoft.com/en-us/azure/devops/pipelines/apps/cd/deploy-docker-webapp?view=azure-devops&WT.mc_id=stepbystepexpressworkshop-github-ticyren)




### Further reading
For more details about deploying NodeJS applications on Azure see the following references:

- [Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/languages/docker?view=azure-devops&tabs=yaml&WT.mc_id=stepbystepexpressworkshop-github-ticyren)
- [Azure Web Apps](https://docs.microsoft.com/en-us/azure/app-service/)


{{< /step >}}