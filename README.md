# SlackTrack - a slash command for Slack
This slack plugin does one thing, tracks time a user spends on slack. It can be used for developers that are tracking time for projects, too. The plugin leverages Slack's slash command feature in their API group of products. It is surprisingly easy to get going.

![screen shot 2018-06-30 at 12 31 02 pm](https://user-images.githubusercontent.com/24664863/42128482-83de13d6-7c61-11e8-828d-c2a478e2a7da.png)

![screen shot 2018-06-30 at 12 39 29 pm](https://user-images.githubusercontent.com/24664863/42128533-a97745f8-7c62-11e8-8021-75c41f49bd5a.png)

## Here is how it works!

There are several commands that are available. After the app has been installed and set up a user in the channel can perform the following commands:<br />
```/slacktrack help``` - returns a list of commands that are available to the user in the specific channel.<br />
```/slacktrack start``` - starts the clock! And the time is stamp and user is saved in database on a webserver.<br />
```/slacktrack stop``` - stops the timer and gives the total of time spent. This is extracted from the webserver and the status is updated.<br />
```/slacktrack restart``` - the user has the option of restarting the timer if neccessary. The status is updated at the web server.<br />
```/slacktrack clear``` - if the user wants to wipe all data from the database, this simple command will complete the process.<br />
<br />
Finally, simply using the ```/slacktrack``` command will let the user know if there is already a timer started, the log status or if there is a problem.

<p float="left" valgin="top">
  <img width="200" alt="screen shot 2018-05-01 at 2 03 50 pm" src="https://user-images.githubusercontent.com/24664863/42128673-e675913c-7c65-11e8-8936-2a84358a73ae.png">

  <img width="200" alt="screen shot 2018-05-01 at 1 56 35 pm" src="https://user-images.githubusercontent.com/24664863/42128679-f53e6342-7c65-11e8-870c-423e3f00acd8.png"> 
  
  <img width="200" alt="screen shot 2018-05-01 at 1 56 55 pm" src="https://user-images.githubusercontent.com/24664863/42128680-ff807142-7c65-11e8-86fe-49fef0ebb1b2.png">
  
  <img width="200" alt="screen shot 2018-05-01 at 1 56 55 pm" src="https://user-images.githubusercontent.com/24664863/42128683-1786fda6-7c66-11e8-8e86-d055f556bfda.png">
</p>

## What is underneath it all?
Before we go into details on setting it up, let's talk about how it works. The first thing you need is a server that can accept an incomming POST request. It's a lot like a form POST request in HTML. Regardless, you will need a server that is reachable from the internet. Then you need to create an App using the Slack's API wizard. You essentially are telling Slack whenever this keyword is followed by a '/' post to this URL. 

After that, it's all up to your webserver to figure out how to handle the rest and respond back with any messages. Not too complicated, is it?

## Setting up things in Slack.
There are plenty of tutorials on getting things set up in slack. Here are the highlights. First, you should go to https://api.slack.com/ to start creating your new app. You should see something like the following:
![](https://user-images.githubusercontent.com/24664863/42128444-b041f6c8-7c60-11e8-87d7-61cd3f28ac43.png)

User your own development environment to get this going. Mine, as you see here is "robotroundup"

Then you need to choose what type of App you want to create. You should choose ```slash commands ```.

![screen shot 2018-06-29 at 6 15 28 pm](https://user-images.githubusercontent.com/24664863/42128463-3cf58832-7c61-11e8-8993-86c1d316f6db.png)

The final step is telling where Slack should send its POST parameters after it detects the slash command. You do this here. You can see that I am using [ngrok](https://ngrok.com/) for my request URL becuase I working in development locally. Depending on the order you sent things up in, you may have to come back to this step and do this after you have set up your webserver.

![screen shot 2018-06-30 at 12 35 17 pm](https://user-images.githubusercontent.com/24664863/42128510-13d0b688-7c62-11e8-92cc-887580a0f08d.png)

## Let's get started

### First thing you will need to do is get Sintra set up
1. You will need to __clone__ this repository.
2. Run ```bundle install``` to bring all in all the gems.

If everything worked accoring to plan then in the command linke yo ushould be able to execute ```ruby app.rb``` and the webserver should spin up.

Finally if you navigate to ```http://localhost:4567``` you should see the message: __'Hello there, slack user!!'__

### Next let's create the database
1. run ```rake db:create``` to create the database
2. run ```rake db:migrate``` to start the migrations and create all the tables

__That's it!__

### How will Slack access your server?
Since you are probably working on your local machine to test and configure the application, you will need something like: ngrok

This lightweight application will generate a URL that, once your Sinatra application is up and running, [ngrok](https://ngrok.com) will create an external URL that will allow public access. You'll need that if you want to test your application. Of course, once you move into production and use a webserver like Heroku, all you'll need is the web address of the server.

Once you have downloaded ngrok at the command line, type: ```ngrok http 4567```

<img width="670" alt="screen shot 2018-05-01 at 11 52 15 am" src="https://user-images.githubusercontent.com/24664863/42128603-170bf446-7c64-11e8-95d9-c636072437af.png" text-align="center">


### New ngrok address
Ok, with this new ngrok web address for port 4567, you will need to go back in the slack app console to update the REQUEST URL as we previous metioned.

### Shout out for the TimeDifference Gem
In the app we use a time difference gem with is extremely easy to use and very easy to implement. That truly saved a lot of time. If you want more information about it, it is listed here: [TimeDifference](https://github.com/tmlee/time_difference).

## That's it
Just keep that server running and your channel team members will have access to that app!
