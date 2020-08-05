class Ftweet extends FBox {
  float dx, dy;
  String msg;


  Ftweet(String m) {
    super(size, size);
    msg = m;
    setStatic(false);
    setRestitution(1);
    setFriction(0.5);
    setGrabbable(false);
    //setName("tweet");
    dx = random(-100, 100);
    dy = random(-100, 100);
    //setVelocity(v,v);
    setDensity(0.8);
  }
  //void displaymsg(){
  //  if (dist(this.getX(), this.getY(), mouseX, mouseY)<this.getWidth()*0.6 ) {
  //    text(this.msg, mouseX, mouseY, 300, 300);
  //  }
  //}
  void move() {
    if ((this.getX()-this.getWidth()/2)<=3 ||(this.getX()+this.getWidth()/2)>=697) {
      dx = -dx;
    }
    if ((this.getY()-this.getHeight()/2)<=3 ||(this.getY()+this.getHeight()/2)>=697) {
      dy = -dy;
    }
    this.setVelocity(dx, dy);
  }

  void showmsg(String msg, int a) {
    if (dist(this.getX(), this.getY(), mouseX, mouseY)<this.getWidth()*0.6 ) {
      String t = content.get(a);
      fill(246, 183, 255, 60);
      noStroke();
      rect(mouseX-5, mouseY-5, width-mouseX+5, 200);
      fill(0);
      stroke(0);
      textSize(18);

      textAlign(LEFT, TOP);
      text(t, mouseX, mouseY, width-mouseX, 200);
    }
  }

  //boolean touching(String thing) {
  //  ArrayList<FContact> contacts = getContacts();
  //  for ( FContact c : contacts) {
  //    if (c.contains("tweet", thing)) {
  //      return true;
  //    }
  //  }
  //  return false;
  //}
}

void movetweets() {
  int count = 0;
  for (Ftweet b : tweetbox) {
    //b.setVelocity(random(25,75),random(25,75));
    b.move();
    String name = b.getName();
    String index = name.substring(5, name.length() );
    int c = int(index);
    if (abc == true && dist(b.getX(), b.getY(), mouseX, mouseY)<b.getWidth()*0.6) {
      b.showmsg(msg, c);
      //text(b.msg, mouseX, mouseY, 300, 300);
      count++;
    }
  }
  if (count == 0) abc = false;
}

void mouseReleased() {
  for (Ftweet a : tweetbox) {
    if (dist(a.getX(), a.getY(), mouseX, mouseY)<a.getWidth()*0.6) {
      if (abc == false) {
        abc = true;
      } else {
        abc = false;
      }
    }
  }
  
}