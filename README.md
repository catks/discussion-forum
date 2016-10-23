# Discussion Forum

Discussion Forum is a RESTful API project written using ruby on rails.

It provides several resources for a forum application
  - Post/thread creation
  - Comment on posts
  - Listing posts and comments
  - Pagination for root posts
  - Language censorchip
  - Inbox notifications
  - Daily mail notification

Also a running example can be found in heroku as
[discussion-forum-api](https://discussion-forum-api.herokuapp.com/v1/posts?page=1)
### Installation

To installl, first clone this git repository and enter the app directory

```sh
$ git clone https://github.com/catks/discussion-forum
$ cd discussion-forum
```

Now run bundler

```sh
$ bundle install
```

Run rails server

```sh
$ rails s
```
If you want to run rails in production environment first you need to configure 
`config/database.yml`, in the default configuration it uses `postgresql` for production and `sqlite` for test and development, so you need to configure a proper role in you postgres server if you want to run the project in production.

After that you need to configure the secret key for production.
You can generate and set a new secret key with the command:
```sh
$ export SECRET_KEY_BASE=(`rake secret`)
```
And finally you can run rails server in production environment

```sh
$ rails s -e production
```

#### Configuring email

Also if you want to receive mail notifications you need to cofigure a mail service in `config/environments/production.rb` for production environment or
`config/environments/development.rb` for development environment. In the default configuration production uses mail.com smtp service and development uses mailcatcher to view the messages.

##### Sendind email notifications

After configuring the email service correctly you can execute a rake task to send all emails to all users that have new notifications. The command can be executed with the folowing command:

```sh
$ rake notifications:send:unsent   
```

Notice that task send notifications in batches, so it join all new notifications for each user email in a single mail for sending, if the user
don't have any new notifications no email is sent. 
For more information please see the notification section.

##### Scheduling email notifications

You can configurate the mail notification task to run daily with whenever gem,
all you need to do is run:
```sh
$ whenever --update-crontab 
```
This wil update your crontab to run `rake notifications:send:unsent` every day
at 8:00 AM as configured in `config/schedule.rb`, notice that whenever configure the cronjob to run the rake task in production environment, if you want to change you can edit your crontab and change the environment with:

```sh
$ crontab -e
```
And change something like this:
```sh
0 8 * * * /bin/bash -l -c 'cd /home/carlos/dev/discussion-forum && RAILS_ENV=production bundle exec rake notifications:send:unsent --silent'
```
To this:
```sh
0 8 * * * /bin/bash -l -c 'cd /home/carlos/dev/discussion-forum && RAILS_ENV=development bundle exec rake notifications:send:unsent --silent'
```
### Post and Comments

A Post and comments are the same object the only differance is that a post can be a root post if the post don't have any parent and will be a comment for another post if have a parent, also a comment can have more comments.

### Censorship

The censorship is implemented in CensorConcern at `app/models/concerns/`, all the bad words must be listed in `config/bad_words`, to add a new word just place the new word in another line. If the title or the body of a post or comment contains bad words they are automatically censored with "*" (A "\*" for each character in the bad word).

### Pagination

The pagination are defined in ApplicationRecord model, basically it paginates any model with `::page` method. Notice that pagination starts in `1` not `0`, and if page method receives `nil` as paramater all the items are returned.

In the default configuration 10 items are returned in each page, and the order is the order of creation but you can easily change that with macros, like:
```ruby
#app/models/some_model_path.rb
class SomeModel < ApplicationRecord
    set_pagination_order "updated_at desc"
    set_max_items_for_page 15
end
```
### Notifications

When some post or comment is created a new notification is also created. Each notification belongs to a `NotificationMail`, a notification mail acts like a inbox for notifications for some specific email so when is time to send the notifications for the user email a `NotificationMail` instance is sent to `NotifyMailer` that sent all the new notifications for each user in one single email.
When sending, the notifications for that user are marked as sent so if 
`NotifyMailer` is called again with a `NotificationMail` instance without new notifications nothing will be sent.

### Using the API

The API has the folowing methods:

```ruby
#To view root posts
GET /v1/posts
#To create a new post or comment
POST /v1/posts
#To view a single post and comments
GET /v1/posts/:id
```


#### GET /v1/posts

If none parameter is sending all items are returned, but you can paginate items with `page=` query string.
```ruby
#Return all posts
GET /v1/posts
#Return first specific page of posts
GET /v1/posts?page=1
```

Examples with curl:
```sh
#To show first page of posts
$ curl -X GET http://localhost:3000/v1/posts?page=1
```

#### POST /v1/posts

To create a new post you need to pass the post parameters

  - `title`: the title of post or comment
  - `author`: the author email
  - `body`: the content of the post or comment
  - `parent_id`: the post that the comment is for, if nothing is passed a root post is created

Examples with curl:
```sh
#To Create a Root post
$ curl -d "post[title]=Test" -d "post[body]=My Awesome Text" -d "post[author]=some@emaail.com" http://localhost:3000/v1/posts

#To Create a comment post
$ curl -d "post[title]=Test" -d "post[body]=My Awesome Comment" -d "post[author]=some@emaail.com" -d "post[parent_id]=6" http://localhost:3000/v1/posts
```

#### GET /v1/posts/:id

You can use to show a specific post and it comments, the `:id` parameter must be the id of the post or comment.

Examples with curl:

```sh
#To show post 6 atributtes and comments
$ curl -X GET http://localhost:3000/v1/posts/6
```