# MentorSHIP
This is the Turing MentorSHIP project. It is written in Rails 5.

![MentorSHIP](http://i.imgur.com/aJ2znTv.jpg)

##Contributers
Add yourself to this list if you helped.

* Mark Miranda (1602)
* Josh Washke (1602)
* Christopher Soden (1603)
* Parker Phillips (1603)
* Megan Talbot (1608)
* John Kimble (1608)
* Vido Seaver (1608)
* Ben Pepper (1608)
* Ryan Spink (1611)
* Daniel Olson (1611)
* Valerie Trundell (1611)
* Ediline Cruz (1611)
* Ashley Schauer (1611)

## Installation

* `git clone git@github.com:turingschool-projects/MentorSHIP.git`
* `cd MentorSHIP`
* `bundle exec rake db:create db:migrate db:seed`

## Running / Development

So because of the Oauth Census had to use there are special instructions for running a local server. This walkthrough will get you set up to run a local HTTPS server so you can run dev server and test locally.

## 1) Create your private key (any password will do, we remove it below)

$ cd ~/.ssh
$ openssl genrsa -des3 -out server.orig.key 2048

## 2) Remove the password

$ openssl rsa -in server.orig.key -out server.key


## 3) Generate the csr (Certificate signing request) (Details are important!)

$ openssl req -new -key server.key -out server.csr

## IMPORTANT
## MUST have localhost.ssl as the common name to keep browsers happy
## (has to do with non internal domain names ... which sadly can be
## avoided with a domain name with a "." in the middle of it somewhere)

Country Name (2 letter code) [AU]:

#### Just press enter to get past prompts until you reach:
...
Common Name: localhost.ssl
...
#### Fill out the Common Name field and skip the rest.

## 4) Generate self signed ssl certificate

$ openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

## 5) Finally Add localhost.ssl to your hosts file

$ echo "127.0.0.1 localhost.ssl" | sudo tee -a /private/etc/hosts

## 6) Install Figaro and Census keys

$ bundle exec figaro install

This will add an application.yml file to your config folder

Add your census keys to the application.yml file. Use fuzzy finder(cmd + t) if you can't see the file in your file tree. Keys should be formatted as such.

CENSUS_ID: eba503f490a06e4065366baa96
CENSUS_SECRET: 78a08c6eafac10bd1adb2c05fd107
CENSUS_ACCESS_TOKEN: 3d8f68e0aa477176133655427eff29e7b77de72

# 7) To start the SSL web server open another terminal window and run

thin start -p 3001 --ssl --ssl-key-file ~/.ssh/server.key --ssl-cert-file ~/.ssh/server.crt

 ### Travis-CI

  Travis CI is a continuous integration tool that receives a webhook everytime you update a branch to a repo you've told it to
  follow. It deploys your application for each branch you pull request and runs your tests. If either of those things fail
  (deploying or tests) you will see a red X next to your pull request. Clicking the  In order to have it work you must have a
  travis.yml file.

  The following is in our .travis.yml which essentially acts as a travis config and lives in your root directory.
  For more info go [here](https://docs.travis-ci.com/user/languages/ruby/)

      ```
      language: ruby
      rvm:
        - 2.3.0
      script:
        - bundle exec rake db:setup
        - bundle exec rspec
      cache: bundler
      services:
        - postgresql
      addons:
        postgresql: "9.4"
      ```

   ### Heroku

  During development we mostly ran our our app from the development branch on our staging server on heroku. Its available
  [here](https://dashboard.heroku.com/apps/turing-mentorship-staging).

  Our production app is here: https://turing-mentorship.herokuapp.com/


  The main gotchya's on heroku are making sure to

  ```
  #in console

  $ rake assets:clobber
  $ rake asssets:precompile
  # then recommit and push
  ```

  The other one is make sure your config variables for heroku are set to the same as your as in your application.yml file. And
  set them the same in Travis.  Otherwise travis will fail, heroku requests to census will break and nothing will work and you
  will cry.

  Reach out to me (@vidoseaver) via email if you need anything. Peace.

### Where are the apps?

* Our deployable app: https://turing-mentorship-prod.herokuapp.com/
* Our staging app: https://turing-mentorship-staging.herokuapp.com/

To get access to both of the above reach out to your Project Manager / Project Owner and they will add you to the app.

### Testing

* To run the tests:
* `bundle exec rspec`

### Important notes for seed file
* to populate the seed file with mentors we hit the Census API with a unique access token. This token expires every 90 days. The current token was generated on 02/08/2017. If you are trying to run `rake db:seed` after 05/08/2017 you will need to OAuth in first and get a new access token. We have set up the seed to take an environment variable. We recommend using the figaro gem to help set up the `appication.yml` file.

To create a new token do the following.  The hacky/easy way is to place a `pry` in Session#create at the top. Then boot your `thin` server (See Running / Development for details) and log in with Census. Once you log in you will hit the `pry` and in params find your unique access token. Then update your `CENSUS_ACCESS_TOKEN` with this token and you will be all set.  

### Environment variables needed
* In the root of the project is an `application.yml.sample` file. This file contains all environment variables we are using in this project. We didn't push keys (for obvious reasons) but wanted to make sure any future teams knew which variables they needed to use.

###CensusService info
* We are currently taking in info from the mentor dashboard edit and using it to update both our database and Census' database. At this point our database updates correctly and passes the necessary info for Census to the CensusService.new.update_census method. It doesn't make a connection to the census api yet (too late in the mod to accomplish this). You will have to work with Census to make sure this end point `https://census-app-staging.herokuapp.com/api/v1/users/#{id}, params.to_json` is hooked up before you can submit. We have already posted a PR to Census that will tell them the type of data and structure to expect so building it out shouldn't be too much work.

## Endpoints

### Current Schema
![schema](http://i.imgur.com/1YoEdXA.png)

### Mentors

#### Get all mentors with completed profiles

Example Request:
```
  /api/v1/mentors
```

Example Response:
```
{
  "mentors": [
    {
      "id": 1,
      "avatar": "https://avatars2.githubusercontent.com/u/14855129?v=3&s=460",
      "name": "mentor 0",
      "email": "mentor0@turing.io",
      "phone_number": "555-555-5555",
      "slack_username": "mentor0",
      "location": "Denver",
      "timezone": "MT",
      "bio": "Former Student, current mentor!",
      "expertise": "Rails, Javascript, Postgres",
      "company": "Turing",
      "position": "Senior Developer",
      "last_active": "2 days ago"
    },
    {
      "id": 2,
      "github_avatar": "https://avatars2.githubusercontent.com/u/14855129?v=3&s=460",
      "name": "mentor 1",
      "email": "mentor1@turing.io",
      "phone_number": "555-555-5555",
      "slack_username": "mentor1",
      "location": "Denver",
      "timezone": "MT",
      "bio": "Former Student, current mentor!"
      "expertise": "Rails, Javascript, Postgres",
      "company": "Turing",
      "position": "Senior Developer",
      "last_active": "2 days ago"
    }
  ]
}
```

#### Get a single mentor by ID

Example Request:
```
  /api/v1/mentors/1
```

Example Response:
```
{
  "mentor": {
    "id": 1,
    "github_avatar": "https://avatars2.githubusercontent.com/u/14855129?v=3&s=460",
    "name": "mentor 0",
    "email": "mentor0@turing.io",
    "phone_number": "555-555-5555",
    "slack_username": "mentor0",
    "location": "Denver",
    "timezone": "MT",
    "bio": "Former Student, current mentor!",
    "expertise": "Rails, Javascript, Postgres",
    "Company": "Turing",
    "Position": "Senior Developer",
    "last_active": "2 days ago"
  }
}
```
