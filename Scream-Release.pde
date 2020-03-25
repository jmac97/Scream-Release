import twitter4j.conf.*;
import twitter4j.api.*; 
import twitter4j.*;
import twitter4j.auth.*;
import java.util.*; 
import processing.sound.*;

Amplitude amp;
AudioIn in;

Twitter twitter;

int count = 0;

PImage heart;

String[] tweets = {
  "Had such a wonderful day today!", 
  "Just letting everyone know that I'm doing great and am very stable!", 
  "I absolutely do not need to seek professional help, doing great!", 
  "Doing yoga rn! Love healthy coping mechanisms :)", 
  "Just used some essential oils to cleanse my soul, feeling so good rn!", 
  "Just prepared a healthy dinner that consisted of all the necessary nutrients an adult needs"
}; 

float x1;
float y1;

void setup() {
  //size(1100, 800);
  fullScreen();
  background(0);

  heart = loadImage("heart.jpg");

  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("");
  cb.setOAuthConsumerSecret("");
  cb.setOAuthAccessToken("");
  cb.setOAuthAccessTokenSecret("");

  TwitterFactory tf = new TwitterFactory(cb.build());

  twitter = tf.getInstance();

  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);

  textAlign(CENTER, CENTER);
  textSize(200);
}

void draw() {
  if (mousePressed == true) {
    float vol = amp.analyze();

    if (10+vol*200 >= 40) {
      count+=1;
      println(count);

      for (int i=0; i<=500; i++) {
        int x = int(random(heart.width));
        int y = int(random(heart.height));
        int loc = x + y*heart.width;

        // Look up the RGB color in the source image
        loadPixels();
        color c = heart.pixels[loc];

        x1 = ((width/2)-(1100/2))+x;
        y1 = ((height/2)-(800/2))+y;
        stroke(c);
        line(x1, y1, random(x1-20, x1+20), random(y1-20, y1+20));
      }
    }

    if (count>=50) {
      tweet();
      fill(255);
      text("it is done.", width/2, height/2);
      count = 0;
    }
  }
}

void tweet() { 
  float val = random(0, 6);
  
  try {
    Status status = twitter.updateStatus(tweets[int(val)] + " #ScreamTweet");
    System.out.println("Status updated to [" + status.getText() +"].");
  }
  catch (TwitterException te) {
    System.out.println("Error: "+ te.getMessage());
  }
}
