# THE REAL DEVOPS CHALLENGE - SOLUTIONS

## TABLE OF CONTENTS

## MOTIVATION

~~I feel highly motivated to~~... **Just  kidding!**

This PR proposal's is both to demonstrate IGZ Devops Team that **I'm the guy they're looking forward** and to address some improvement ideas to this old folk that @angelbarrera92 created 2 years ago.

I'm aware of IGZ's love for memes, so I will try to keep a *funny-formal* style while I explain what I'm doing and why I did it.

So... allé voy!

![Take my gil and shut up!](assets/ffvii.solutions.png)

## PREVIOUS CONSIDERATIONS

I would like to remark a few things before getting my hands dirty:

* My client IGZ deserves all of my time and attention, but in order to have healthy SLAs in both ends, please remember I'm currently working in a full-time position and making ~~the latest~~ a PRODUCTION deployment for my employer (do you guys enjoy complex automated Nokia + Openstack deployments?), so it would take some of my time to make my best with this challenge.
* With the previous consideration in mind, I will proceed in the following way:
  * I'm delivering the 1.0.0 release of this challenge **just completing it in the most basic way**, to deliver a valuable POC in the fastest way.
  * I'm taking some more time once the client is evaluating the previously mentioned POC to iterate and deliver a highly customized product.
  * Those following releases will be delivered taggged as X.X.X
  * Given the GitHub limitations, **you will be just noticing the latest changes I do**. To have a more accurate vision of what am I doing, please `git clone https://github.com/aacecandev/the-real-devops-challenge.git` and give a peek to the Git logs.
    * I recommend `git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches` or `sudo <pkg manager install command> tig`.
  * I have some *daddy issues* with privative software, so I'll try to keep myself as close as possible to open source tools and mindset. My apologies to those not having installed such tools/mindset.

Enough chattering, let's start!

![Can we start please?](https://media.giphy.com/media/S8ToH7Zt8gZ4u2iClh/giphy.gif)


## FIRST CHALLENGE

I am supposed to have a Mongo DB installation running on my localhost, shouldn't I? If so, please ask me to explain how to install it and configure the necessary stuff to have a working env var like this

``` bash
export MONGO_URI="mongodb://igz:<3@127.0.0.1:27017/?authSource=restaurant&authMechanism=SCRAM-SHA-256"
```

I evaluated to use a containerized Mongo DB, but I opted out to install and configure it manually, because, you know, I need you to know I know how it works.

I had to solve a **problem with DB authentication**, which I'm not sure if takes part on this challenge or is an outdated issue. I didn't opened an issue on GitHub just to not piss off the challenge, but you can find the logs [here](files/authentication_error)

@angelbarrera92 made me sweat so hard to find out **how extract a list element...**

![Sweating](https://media.giphy.com/media/l4FATJpd4LWgeruTK/giphy.gif)

### TO-DO

* [x] I **strongly recommend** changing the `app.run` host variable from 0.0.0.0 to 127.0.0.1. It's a big security issue having a development server listening externaly.
* [x] The README.md should be updated with `export MONGO_URI="mongodb://igz:<3@127.0.0.1:27017/?authSource=restaurant&authMechanism=SCRAM-SHA-256"` because the authentication method is broken
  * [x] [Github issue](https://github.com/dcrosta/flask-pymongo/issues/142)
  * [x] [Authentication docs](https://pymongo.readthedocs.io/en/stable/examples/authentication.html)
* [x] The code can be refactored by simply calling the package methods [here](https://github.com/dcrosta/flask-pymongo/blob/master/flask_pymongo/helpers.py#L86) and [here](https://github.com/dcrosta/flask-pymongo/blob/master/flask_pymongo/helpers.py#L53)
* [ ] Error handling for
  * [x] main

* [ ] Create an init_db.sh file with the following content
      * use restaurants
      * db.createUser({user: "igz", pwd: "<3", roles:[{role: "readWrite" , db:"restaurant"}]})
      * [enable authentication](https://medium.com/mongoaudit/how-to-enable-authentication-on-mongodb-b9e8a924efac)
      * mongoimport --user igz --password password --db restaurants --collection docs --drop --file data/restaurant.json
      * export MONGO_URI="mongodb://igz:<3@127.0.0.1:27017/restaurants"
* [ ] Add a init.sh file
  * https://stackoverflow.com/questions/27691434/python-virtualenv-check-environment
  * Check that venv has been activated
  * Check for mongod status
    * Install mongo from an ansible role (only for first challenge!!)

## FINAL CHALLENGE

mongo
  deployment
  service - clusterIP
python
  deployment
  service - clusterIP / NodePort (sin ingress) / LB (no)
  ingress /

## TO-DO, BUT I'M NOT DOING

* [ ] I just deleted some dupes from [.gitignore](.gitignore), but it can be further improved, e.g. all .png could be excluded but those kept into assets folder, to avoid having data/images/this-funny-cat-image.png
* [ ] Can be tox suite and configuration files be updated?

## REFERENCES

* [Mongo DB - Ansible installation + tunning](https://medium.com/@_oleksii_/how-to-install-tune-mongodb-using-ansible-693a40495ca1)

## AUTHORS

* Alejandro Aceituna Cano - ¿Intelygenz? - <3
