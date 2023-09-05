// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import DashboardTweetsController from "./dashboard_tweets_controller"
application.register("dashboard-tweets", DashboardTweetsController)

import HashtagController from "./hashtag_controller"
application.register("hashtag", HashtagController)

import MessagesController from "./messages_controller"
application.register("messages", MessagesController)

import TweetCardController from "./tweet_card_controller"
application.register("tweet-card", TweetCardController)

import TweetFormController from "./tweet_form_controller"
application.register("tweet-form", TweetFormController)

import TweetPollingController from "./tweet_polling_controller"
application.register("tweet-polling", TweetPollingController)
