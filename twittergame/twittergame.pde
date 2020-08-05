import twitter4j.util.*;
import twitter4j.*;
import twitter4j.management.*;
import twitter4j.api.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.auth.*;

ConfigurationBuilder cb;
Twitter twitterInstance;
Query queryForTwitter;

import fisica.*;
FWorld world;
FBox person;

float x = 50;
float y = 50;

String searchInput = "";
String search;
PImage sIcon;

boolean up, down, left, right;
int vx, vy;

FBox n, e, s, w;

float size;
float fat = 40;

ArrayList<Ftweet> tweetbox = new ArrayList<Ftweet>();
ArrayList<String> content = new ArrayList<String>();

String msg;
String twe;
boolean abc = false;
void setup() {
  size (700, 700);

  cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("83fM3NZI9hYRfmnY7DXpWesjG"); 
  cb.setOAuthConsumerSecret("BBX2ybx8J7ujEPwxIchYmDYhvfPJd1R3SPw7k5p8wAaSmtoqfW");
  cb.setOAuthAccessToken("983375196642918401-HoU1umPAplzSaW7KCkKFuUSWQmlepJV");
  cb.setOAuthAccessTokenSecret("1r5zQYF6WUgswoaX1oEQKGNpkhXxY7gp5Y0RgKxnYKYSl");

  twitterInstance = new TwitterFactory(cb.build()).getInstance();


  Fisica.init(this);
  makeWorld();
  //String statusMessage = "watch out!";
  //File file = new File("images/Done.jpg");
  //StatusUpdate status = new StatusUpdate(message);
  //status.setMedia(file);
  //twitterInstance.updateStatus(status);

  sIcon=loadImage("search.png");
}

void draw() {
  background(255);
  world.step();
  world.draw();

  //move player
  if (up == true ) {
    vy = -70;
  } else if (down == true) {
    vy = 70;
  } else {
    vy = 0;
  }
  if (left == true) {
    vx = -70;
  } else if (right == true) {
    vx = 70;
  } else {
    vx = 0;
  }
  person.setVelocity(vx, vy);
  person.setWidth(fat);
  person.setHeight(fat);
  movetweets();
  collision();

  //search bar
  fill(246, 183, 255);
  strokeWeight(0);
  rect(0, 620, 700, 70);
  fill(0);
  stroke(0);
  image(sIcon, 10, 640, 50, 50);
  strokeWeight(3);
  line(70, 680, 680, 680);
  textAlign(LEFT, BOTTOM);
  textSize(24);
  text("#", 70, 680);
  text(searchInput, 90, 680);
}

void makeWorld() {
  world = new FWorld();
  world.setGravity(0, 0);

  n = new FBox(width, 3);
  s = new FBox(width, 3);
  w = new FBox(3, height);
  e = new FBox(3, height);
  n.setPosition(width/2, 0);
  s.setPosition(width/2, height);
  w.setPosition(0, height/2);
  e.setPosition(width, height/2);
  n.setStatic(true);
  n.setRestitution(1);
  n.setStrokeWeight(0);
  n.setFill(0);
  s.setStatic(true);
  s.setRestitution(1);
  s.setStrokeWeight(0);
  s.setFill(0);
  w.setStatic(true);
  w.setRestitution(1);
  w.setStrokeWeight(0);
  w.setFill(0);
  e.setStatic(true);
  e.setRestitution(1);
  e.setStrokeWeight(0);
  e.setFill(0);
  n.setName("wall");
  e.setName("wall");
  s.setName("wall");
  w.setName("wall");
  world.add(n);
  world.add(s);
  world.add(e);
  world.add(w);


  // //platform
  //FBox platform = new FBox(200, 50);
  //platform.setPosition(0, 300);
  //platform.setStatic(true);
  //platform.setFill(246, 183, 255);
  //platform.setStroke(0);
  //platform.setGrabbable(false);
  //world.add(platform);

  person = new FBox(fat, fat);
  person.setPosition(50, 50);
  person.setGrabbable(false);
  person.setFill(0);
  person.setStroke(0);
  person.setName("player");
  world.add(person);
}
void fetchAndDrawTweets() {
  ArrayList tweets;

  queryForTwitter = new Query(searchInput);
  try {
    QueryResult result = twitterInstance.search(queryForTwitter);
    tweets = (ArrayList) result.getTweets();
    for (int i = 0; i < tweets.size(); i++) {
      Status t = (Status) tweets.get(i);
      User myUser= t.getUser();
      String user = myUser.getName();

      String picURL = t.getUser().getBiggerProfileImageURL();
      PImage profpic = loadImage(picURL);
      msg = t.getText();
      content.add(msg);

      int followers = t.getUser().getFollowersCount();
      size = map(followers, 0, 1000, 10, 120);
      size = min(125, size);
      profpic.resize(int(size), int(size));

      Ftweet c = new Ftweet(msg);
      c.attachImage(profpic);
      c.setPosition(random(100, 600), random(100, 500));
      //c.setForce(-100,100);
      c.setName("tweet" + i);
      c.move();
      c.setForce(50,50);
      tweetbox.add(c);
      world.add(c);


      println(user + ": " + msg);
      println("--------------------------------------------------------------------------------------------------------------------------------");
    }
  } 
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  }
}

void collision() {
  ArrayList<FContact> contacts = person.getContacts();
  for (FContact con : contacts) {
    if (!con.contains("wall")) {
      FBox b1 = (FBox) con.getBody1();
      FBox b2 = (FBox) con.getBody2();
      //println("BRIDGE!");

      if (b2 == person) {
        if ( b2.getWidth() > b1.getWidth()) {
          tweetbox.remove(b1);
          world.remove(b1);
          fat = fat + b1.getWidth()*0.2;
        } else {
          b2.setPosition(50, 50);
        }
      } else {
        if ( b1.getWidth() > b2.getWidth()) {
          tweetbox.remove(b2);
          world.remove(b2);
          fat = fat + b2.getWidth()*0.2;
        } else {
          b1.setPosition(50, 50);
        }
      }
    }
  }
}
void keyPressed() {
  if (keyCode == UP) {
    up = true;
  }  
  if (keyCode == DOWN) {
    down = true;
  }
  if (keyCode == LEFT) {
    left = true;
  }
  if (keyCode == RIGHT) {
    right = true;
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      up = false;
    }  
    if (keyCode == DOWN) {
      down = false;
    }
    if (keyCode == LEFT) {
      left = false;
    }
    if (keyCode == RIGHT) {
      right = false;
    }
  } else {
    if (key == BACKSPACE) {
      if (searchInput.length()>0 ) {
        searchInput = searchInput.substring(0, searchInput.length()-1);
        println(searchInput);
      }
    } else if(key == TAB) {
      person.setPosition(50,50);
      fat = 40;
    } else if (key == ENTER || key == RETURN) {
      //search = "#" + searchInput;
      fetchAndDrawTweets();

      //println(comment);
      searchInput = " ";
    } else {
      searchInput = searchInput + key;
    }
  }
}