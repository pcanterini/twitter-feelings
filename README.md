# TwitterFeelings

[![Build Status](https://travis-ci.org/cblavier/twitter-feelings.svg?branch=master)](https://travis-ci.org/cblavier/twitter-feelings)[![Coverage Status](https://coveralls.io/repos/cblavier/twitter-feelings/badge.svg?branch=master)](https://coveralls.io/r/cblavier/twitter-feelings?branch=master)

TwitterFeelings is a Twitter sentiment analysis engine. It streams live statuses from Twitter and categorizes them according to their mood (positive or negative).
It is written in Elixir, runs on Erlang VM and uses Redis for storage.

It is partly based on _Twitter Sentiment Classification using Distant Supervision_ described in this [Stanford paper](http://cs.stanford.edu/people/alecmgo/papers/TwitterDistantSupervision09.pdf).

TwitterFeelings is composed of 3 parts :
- **corpus builder**: uses Twitter search API to build a very large set of tweets that will feed the sentiment analyzer, to make it learn.
- **learning**: based on a corpus of tweets, computes each word's probability to appear in a positive and in a negative tweet.
- **streaming machine** : uses Twitter streaming API to get live tweets on a specific topic, and updates Redis mood counters accordingly.

## Setup
- install Elixir / Erlang / Redis
- install dependencies `mix deps.get`
- build script with `mix escript.build` command
- have following environment variables declared:
   - TWITTER_CONSUMER_KEY
   - TWITTER_CONSUMER_SECRET
   - TWITTER_ACCESS_TOKEN
   - TWITTER_ACCESS_TOKEN_SECRET

## Corpus Builder
This application runs thousand of queries on Twitter Search API, to build a large corpus of Tweets that we will able to analyze later.
Since we need to know if each retrieved status is either positive or negative, we will use Stanford approach (see link in intro) to categorize Twitter statuses according to the smileys they contain.

Each tweet retrieved is:
  - filtered (we don't keep biased twitters containing both positive and negative smileys)
  - normalized (downcased, stripped of urls/usernames/accents/smileys/short words/...)
  - stored in a dedicated Redis set

To build a large corpus of french positive and negative tweets, run the following commands:
```
./twitter_feelings build-corpus --lang fr --mood positive
./twitter_feelings build-corpus --lang fr --mood negative
```
It will take hours since the application has to deal with Twitter rate limitations (450 queries per 15mn).
Each query fetches 100 tweets at once.

## Learning
Live Tweets will a be categorized using the _Naive Bayesian_ approach. The great benefit of this method is that a lot of stuff can be precomputed making the live computation very fast. The purpose of this module is to precompute (from existing tweets corpus) the probability for each monogram (ie word) to appear in either positive or negative messages.

Once two corpus have been built (both negative and positive moods on a single language), run the learning module with this command:
```
./twitter_feelings learn --lang fr
```
On my computer (4ghz i7), it takes about 10mn to learn from 2 x 500.000 tweets.

## Streaming Machine
TODO

