boolean link = false;
float opacity = 120;
int nbBall = 30;
int sizeBall = 365;
float sizeVariation = 0.2;
float[][] posBall = new float [nbBall][];
float speed = 0.7;
int redBallCoef = int(pow(-1,int(random(1,6))));
int greenBallCoef = int(pow(-1,int(random(1,6))));
int blueBallCoef = int(pow(-1,int(random(1,6))));
int back = int(pow(-1,int(random(1,6))));
int red = int(random(60,185));
int green = int(random(60,185));
int blue = int(random(60,185));

void setup() {
  //size(1750, 900);
  fullScreen();
  
  for(int i=0; i<nbBall; i++){
    float[] ball = new float [9];
    ball[0] = int(random(sizeBall/2+1, width-sizeBall/2-1));
    ball[1] = int(random(sizeBall/2+1, height-sizeBall/2-1));
    ball[2] = int(random(sizeBall*sizeVariation,sizeBall));
    ball[3] = int(int(random(1,6))*pow(-1,int(random(1,6))));
    ball[4] = int(int(random(1,6))*pow(-1,int(random(1,6))));
    ball[5] = red - int(random(1,30));
    ball[6] = green - int(random(1,30));
    ball[7] = blue - int(random(1,30));
    ball[8] = opacity;
    posBall[i] = ball;
  }
}

void draw() {
  
  background(red+70, green+30, blue+50);
  
  if(red +1 *redBallCoef-30 < 1 || red +1 *redBallCoef > 184){
    redBallCoef = redBallCoef *-1;
  }else if(int(random(1,6)) > 5){
    redBallCoef = redBallCoef *-1;
  }
  
  if(green +1 *greenBallCoef-30 < 1 || green +1 *greenBallCoef > 184){
    greenBallCoef = greenBallCoef *-1;
  }else if(int(random(1,6)) > 5){
    greenBallCoef = greenBallCoef *-1;
  }
  
  if(blue +1 *blueBallCoef-30 < 1 || blue +1 *blueBallCoef > 184){
    blueBallCoef = blueBallCoef *-1;
  }else if(int(random(1,6)) > 5){
    blueBallCoef = blueBallCoef *-1;
  }
  
  red = red +1 *redBallCoef;
  green = green +1 *greenBallCoef;
  blue = blue +1*blueBallCoef;
  
  for(int i=0; i<nbBall; i++){
    posBall[i][5] = posBall[i][5]+1*redBallCoef;
    posBall[i][6] = posBall[i][6]+1*greenBallCoef;
    posBall[i][7] = posBall[i][7]+1*blueBallCoef;
    
    for(int j=0; j<nbBall; j++){
      
      float dist = sqrt(pow(posBall[i][0]-posBall[j][0],2)+pow(posBall[i][1]-posBall[j][1],2));      
      
      if(dist < 2.5*sizeBall && link == true){
        
        float sumOfRayon = (posBall[i][2] + posBall[j][2])/2;
        strokeWeight(sizeBall*0.5 * (1 - ((dist - sumOfRayon)/ (2.5*sizeBall - sumOfRayon))));
        
        fill((posBall[i][5]+posBall[j][5])/2, (posBall[i][6]+posBall[j][6])/2, (posBall[i][7]+posBall[j][7])/2);
        stroke((posBall[i][5]+posBall[j][5])/2, (posBall[i][6]+posBall[j][6])/2, (posBall[i][7]+posBall[j][7])/2, opacity);
        line(posBall[i][0], posBall[i][1], posBall[j][0], posBall[j][1]);
      }
    }
  }
  
    for(int i=0; i<nbBall; i++){
     posBall[i][0] = posBall[i][0]+speed*posBall[i][3];
     if(posBall[i][0] >= width-posBall[i][2]/2 || posBall[i][0]<= 0+posBall[i][2]/2){
        posBall[i][3] = posBall[i][3]*-1;
     }
     
     posBall[i][1] = posBall[i][1]+speed*posBall[i][4];
     if(posBall[i][1] >= height-posBall[i][2]/2 || posBall[i][1]<= 0+posBall[i][2]/2){
        posBall[i][4] = posBall[i][4]*-1;
     }
     strokeWeight(0);
     fill(posBall[i][5], posBall[i][6], posBall[i][7], opacity);
     stroke(posBall[i][5], posBall[i][6], posBall[i][7], opacity);
     circle(posBall[i][0], posBall[i][1], posBall[i][2]);
  }
  
}
