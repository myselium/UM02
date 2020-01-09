Table table;
ArrayList<Planet> tabPlanets = new ArrayList<Planet>(); 

float xPlanets = 0.530;
float yPlanets = 0.535;
int nbPlanets = 10;
float angle = PI;
int currentPlanet;
int selectedPlanet = 0;
int hoverPlanet;
PImage bg;
PFont font1;
PFont font2;
int printLine = 0;
int titleLine = 0;
int printCharacter = 0;
int timePrint = 0;
PImage rimLeg;
PImage rimCenter;
PImage rimMid;
PImage rimOut;
PImage moonImg;
PImage planetImg;
ArrayList<PImage> skinPlanets = new ArrayList<PImage>();
ArrayList<String> infoOrder = new ArrayList<String>();



class Planet{
  int id;
  String name;
  String region;
  String sector;
  String rotation_period;
  String orbital_period;
  String diameter;
  String climate;
  String gravity;
  String terrain;
  String population;
  String native_species;
  String characters;
  String points_of_interest;
  String notable_info;
  boolean selected = false;
  float x;
  float y;
  float angle;
  int diam;  
  boolean isMoon;
  int rim;
  
  Planet(int id, String name, String region, String sector, String rotation_period, String orbital_period, String diameter, String climate, String gravity, String terrain, String population, String native_species, String characters, String points_of_interest, String notable_info, int diam, boolean isMoon, int rim){
    this.id = id;
    this.name = name;
    this.region = region;
    this.sector = sector;
    this.rotation_period = rotation_period;
    this.orbital_period = orbital_period;
    this.diameter = diameter;
    this.climate = climate;
    this.gravity = gravity;
    this.terrain = terrain;
    this. population = population;
    this.native_species = native_species;
    this.characters = characters;
    this.points_of_interest = points_of_interest;
    this.notable_info = notable_info;
    this.diam = diam;
    this.selected = false;
    this.isMoon = isMoon;
    this.rim = rim;
  }
}

void setup() {
  font1 = createFont("Source Code Pro Light", 50);
  font2 = createFont("OCR A Extended", 50);
  textFont(font2);
  
  bg = loadImage("C:\\Users\\jeane\\Documents\\Travail\\UTSEUS\\UM02\\Projet_StarWars\\data\\star-wars_readable\\nebula.jpg");
  frameRate(300);
  table = loadTable("C:\\Users\\jeane\\Documents\\Travail\\UTSEUS\\UM02\\Projet_StarWars\\Dynamic\\UM02_PlanetsStarWars\\data\\planets_clean.csv", "header");
  
rimLeg = loadImage("C:\\Users\\jeane\\Documents\\Travail\\UTSEUS\\UM02\\Projet_StarWars\\Dynamic\\UM02_PlanetsStarWars\\planets_skin\\RimLegend.png");
rimCenter = loadImage("C:\\Users\\jeane\\Documents\\Travail\\UTSEUS\\UM02\\Projet_StarWars\\Dynamic\\UM02_PlanetsStarWars\\planets_skin\\RimCenter.png");
rimMid = loadImage("C:\\Users\\jeane\\Documents\\Travail\\UTSEUS\\UM02\\Projet_StarWars\\Dynamic\\UM02_PlanetsStarWars\\planets_skin\\RimMiddle.png");
rimOut = loadImage("C:\\Users\\jeane\\Documents\\Travail\\UTSEUS\\UM02\\Projet_StarWars\\Dynamic\\UM02_PlanetsStarWars\\planets_skin\\RimOut.png");
moonImg = loadImage("C:\\Users\\jeane\\Documents\\Travail\\UTSEUS\\UM02\\Projet_StarWars\\Dynamic\\UM02_PlanetsStarWars\\planets_skin\\moon.png");
planetImg = loadImage("C:\\Users\\jeane\\Documents\\Travail\\UTSEUS\\UM02\\Projet_StarWars\\Dynamic\\UM02_PlanetsStarWars\\planets_skin\\planet.png");
  
  infoOrder.add("name");
  infoOrder.add("Astrophisical information: "); // 1
  infoOrder.add("region");
  infoOrder.add("sector");
  infoOrder.add("orbital_period");
  infoOrder.add("rotation_period");
  infoOrder.add("Physical information: "); // 6
  infoOrder.add("diameter");
  infoOrder.add("gravity");
  infoOrder.add("climate");
  infoOrder.add("terrain");
  infoOrder.add("points_of_interest");
  infoOrder.add("Societal information: "); // 12
  infoOrder.add("native_species");
  infoOrder.add("population");
  infoOrder.add("characters");
  
  for (int i=0; i < nbPlanets; i++)  {
    String name = table.getRow(i).getString("name");
    String region = "Region: " +  table.getRow(i).getString("region");
    String sector = "Sector: " + table.getRow(i).getString("sector");
    String rotation_period = "Rotation period: " + table.getRow(i).getInt("rotation_period") + " hours";
    String orbital_period = "Orbital period: " + table.getRow(i).getInt("orbital_period") + " days";
    int diam = int(table.getRow(i).getInt("diameter")*0.02);
    String diameter = "Diameter: " + table.getRow(i).getInt("diameter") + " km";
    String climate = "Climate: " + table.getRow(i).getString("climate");
    String gravity = "Gravity: " + table.getRow(i).getFloat("gravity");
    String terrain = "Primary terrain: " + table.getRow(i).getString("terrain");
    String population = "Population: " + table.getRow(i).getString("population") + " inhabitants";
    String native_species = "Native species: " + table.getRow(i).getString("native_species");
    String characters = "Characters: " + table.getRow(i).getString("characters");
    String points_of_interest = "Points of interest: " + table.getRow(i).getString("points_of_interest");
    String notable_info = table.getRow(i).getString("notable_info");
    int rim = table.getRow(i).getInt("rim");
    boolean isMoon = boolean(table.getRow(i).getString("moon"));
    tabPlanets.add(new Planet(i, name, region, sector, rotation_period, orbital_period, diameter, climate, gravity, terrain, population, native_species, characters, points_of_interest, notable_info, diam,isMoon,rim));
    skinPlanets.add(loadImage("C:\\Users\\jeane\\Documents\\Travail\\UTSEUS\\UM02\\Projet_StarWars\\Dynamic\\UM02_PlanetsStarWars\\planets_skin\\" + name + ".png"));
    
  }
  
  
  
  fullScreen();
  cursor(CROSS);
  xPlanets=width*xPlanets;
  yPlanets=height*yPlanets;
  FindXY();
}

public void FindXY(){
  int diamMoy = 0;
  float angleFonct = angle;
  
  for(int i=0; i<nbPlanets; i++){
    diamMoy += tabPlanets.get(i).diam;
  }
  
  for(int i=0; i<nbPlanets; i++){
    tabPlanets.get(i).x = (height*0.33*cos(angleFonct));
    tabPlanets.get(i).y = (height*0.33*sin(angleFonct));
    tabPlanets.get(i).angle = (angleFonct+2*PI)%(2*PI);
    float percent = (100*tabPlanets.get(i).diam/diamMoy);
    percent = percent/101;
    angleFonct = angleFonct + (2*PI)*percent;
  }
}

void draw() {  
  background(bg);  // Couleur du background
  
  hoverPlanet = -1;
  for(int i=0; i<nbPlanets; i++){
    
    if(sqrt(pow(mouseX - (xPlanets + tabPlanets.get(i).x), 2) + pow(mouseY - (yPlanets + tabPlanets.get(i).y), 2)) <= tabPlanets.get(i).diam/2){ // On regarde si la souris survolle une planete 
      hoverPlanet = i;
      
      text(tabPlanets.get(i).name, xPlanets-((float(tabPlanets.get(i).name.length())/2)*10)-47, yPlanets);
      if (tabPlanets.get(i).isMoon == true){
        image(moonImg, xPlanets+((float(tabPlanets.get(i).name.length())/2)*10) -17, yPlanets-20);
        image(rimOut, xPlanets+((float(tabPlanets.get(i).name.length())/2)*10) + 18, yPlanets-20);
      }else{
        image(planetImg, xPlanets+((float(tabPlanets.get(i).name.length())/2)*10) -17, yPlanets-20);
        if (tabPlanets.get(i).rim == 2){
          image(rimOut, xPlanets+((float(tabPlanets.get(i).name.length())/2)*10) + 33 , yPlanets-20);
        }else if(tabPlanets.get(i).rim == 1){
          image(rimMid, xPlanets+((float(tabPlanets.get(i).name.length())/2)*10) + 33, yPlanets-20);
        }else{
          image(rimCenter, xPlanets+((float(tabPlanets.get(i).name.length())/2)*10) + 33, yPlanets-20);
        }
      }
      
          
      
    }
    
    if((abs(tabPlanets.get(i).angle) < PI*1.005 && abs(tabPlanets.get(i).angle) > PI*0.995)){
      currentPlanet = i;
    }
    
    if(tabPlanets.get(i).selected == true && (abs(tabPlanets.get(i).angle) > PI*1.005 || abs(tabPlanets.get(i).angle) < PI*0.995)){
      if(abs(tabPlanets.get(i).angle) > PI){
        angle = angle - (2*PI)/400;
      }else{
        angle = angle + (2*PI)/400;
      }
      FindXY();
    }
  }
  
  for(int i=0; i<nbPlanets; i++){
    stroke(0, 0, 0);
    //fill(255, 255, 255);
    if((hoverPlanet > -1 && i == hoverPlanet) || (tabPlanets.get(i).selected == true)){
      stroke(255, 0, 0);
    }else{
      stroke(0, 0, 0);
    }
    image(skinPlanets.get(i), xPlanets + tabPlanets.get(i).x - tabPlanets.get(i).diam/2, yPlanets + tabPlanets.get(i).y - tabPlanets.get(i).diam/2);
    fill(255, 0, 0);
  }
  
  fill(0, 0, 0, 180);
  noStroke();
  rect(0, 0, width*0.25, height);
  triangle(width*0.25, height*0.535 -20, width*0.25, height*0.535 +20, width*0.25+30, height*0.535);
  
  /*timePrint = (timePrint +1)%2;
    if(timePrint == 1){
      printCharacter += 1;
    }
    
    if(titleLine == 0){
      text(planet.name.substring(0, printCharacter), 15, 100);
      if(printCharacter == planet.name.length()-1){
        printCharacter = 0;
        printLine +=1;
      }
    }else{
      text(planet.name, 15, 100);
    }
    
    
    if(titleLine == 1){
      text("Astrophisical information: ".substring(0, printCharacter), 15, 150);
      if(printCharacter == "Astrophisical information: ".length()-1){
        printCharacter = 0;
        titleLine +=1;
      }
    }else if(titleLine >= 1){
      text("Astrophisical information: ", 15, 150);
    }*/
    
  textSize(40); 
  fill(255, 255, 255);
  
  text("Do you really know the Star Wars planets?", width*0.34, 70);
  
  textSize(20);
  text("Main information about 10", width*0.80, height - 200);
  text("most important planets in", width*0.80, height - 170);
  text("Star Wars galaxy according to", width*0.80, height - 140);
  text("\"https://starwars.fandom.com\".", width*0.80, height - 110);
  text("Sorted by diameter's planet.", width*0.80, height - 80);
  
  image(rimLeg, width*0.80 + 300, height - 380);
  text("Center / Mid / Outher Rim", width*0.80 - 10, height - 360);
  image(planetImg, width*0.80 + 293, height - 330);
  text("Is a planet", width*0.80 + 150, height - 310);
  image(moonImg, width*0.80 + 300, height - 280);
  text("Is a moon", width*0.80 + 180, height - 260);
  
  if(currentPlanet == selectedPlanet){
    Planet planet = tabPlanets.get(selectedPlanet);
    fill(255, 255, 255);
    textSize(50);
    
    text(planet.name, 15, 80);
    textSize(20);
    text("Astrophisical information: ", 15, 130);
    if(planet.region.length() > 35){
      text(planet.region.substring(0, 34), 15, 160);
      printLine += 1;
      text(planet.region.substring(34, planet.region.length()), 15, 160+(printLine*30));
    }else{
      text(planet.region, 15, 160);
    }
    
    if(planet.sector.length() > 35){
      text(planet.sector.substring(0, 34), 15, 190+(printLine*30));
      printLine += 1;
      text(planet.sector.substring(34, planet.sector.length()), 15, 190+(printLine*30));
    }else{
      text(planet.sector, 15, 190+(printLine*30));
    }
    
    if(planet.orbital_period.length() > 35){
      text(planet.orbital_period.substring(0, 34), 15, 220+(printLine*30));
      printLine += 1;
      text(planet.orbital_period.substring(34, planet.orbital_period.length()), 15, 220+(printLine*30));
    }else{
      text(planet.orbital_period, 15, 220+(printLine*30));
    }
    
    if(planet.rotation_period.length() > 35){
      text(planet.rotation_period.substring(0, 34), 15, 250+(printLine*30));
      printLine += 1;
      text(planet.rotation_period.substring(34, planet.rotation_period.length()), 15, 250+(printLine*30));
    }else{
      text(planet.rotation_period, 15, 250+(printLine*30));
    }
    
    text("Physical information: ", 15, 310+(printLine*30));
    
    if(planet.diameter.length() > 35){
      text(planet.diameter.substring(0, 34), 15, 340+(printLine*30));
      printLine += 1;
      text(planet.diameter.substring(34, planet.diameter.length()), 15, 340+(printLine*30));
    }else{
      text(planet.diameter, 15, 340+(printLine*30));
    }
    
    if(planet.gravity.length() > 35){
      text(planet.gravity.substring(0, 34), 15, 370+(printLine*30));
      printLine += 1;
      text(planet.gravity.substring(34, planet.gravity.length()), 15, 370+(printLine*30));
    }else{
      text(planet.gravity, 15, 370+(printLine*30));
    }
    
    if(planet.terrain.length() > 35){
      String[] tabText = planet.terrain.split(" ");
      String Text1 = "";
      String Text2 = "";
      int i=0;
      while(Text1.length()+tabText[i].length() < 35){
        Text1 += tabText[i++] + " ";
      };
      while(i < tabText.length){
        Text2 += tabText[i++] + " ";
      }
      text(Text1, 15, 400+(printLine*30));
      printLine += 1;
      text(Text2, 15, 400+(printLine*30));
    }else{
      text(planet.terrain, 15, 400+(printLine*30));
    }
    
    if(planet.points_of_interest.length() > 35){
      String[] tabText = planet.points_of_interest.split(" ");
      String Text1 = "";
      String Text2 = "";
      int i=0;
      while(Text1.length()+tabText[i].length() < 35){
        Text1 += tabText[i++] + " ";
      };
      while(i < tabText.length){
        Text2 += tabText[i++] + " ";
      }
      text(Text1, 15, 430+(printLine*30));
      printLine += 1;
      text(Text2, 15, 430+(printLine*30));
    }else{
      text(planet.points_of_interest, 15, 430+(printLine*30));
    }
    
    text("Societal information: ", 15, 490+(printLine*30));
    
    if(planet.native_species.length() > 35){
      String[] tabText = planet.native_species.split(" ");
      String Text1 = "";
      String Text2 = "";
      int i=0;
      while(Text1.length()+tabText[i].length() < 35){
        Text1 += tabText[i++] + " ";
      };
      while(i < tabText.length){
        Text2 += tabText[i++] + " ";
      }
      text(Text1, 15, 520+(printLine*30));
      printLine += 1;
      text(Text2, 15, 520+(printLine*30));
    }else{
      text(planet.native_species, 15, 520+(printLine*30));
    }
    
    if(planet.population.length() > 35){
      String[] tabText = planet.population.split(" ");
      String Text1 = "";
      String Text2 = "";
      int i=0;
      while(Text1.length()+tabText[i].length() < 35){
        Text1 += tabText[i++] + " ";
      };
      while(i < tabText.length){
        Text2 += tabText[i++] + " ";
      }
      text(Text1, 15, 550+(printLine*30));
      printLine += 1;
      text(Text2, 15, 550+(printLine*30));
    }else{
      text(planet.population, 15, 550+(printLine*30));
    }
    
    if(planet.characters.length() > 35){
      String[] tabText = planet.characters.split(" ");
      String Text1 = "";
      String Text2 = "";
      int i=0;
      while(Text1.length()+tabText[i].length() < 35){
        Text1 += tabText[i++] + " ";
      };
      while(i < tabText.length){
        Text2 += tabText[i++] + " ";
      }
      text(Text1, 15, 580+(printLine*30));
      printLine += 1;
      text(Text2, 15, 580+(printLine*30));
    }else{
      text(planet.characters, 15, 580+(printLine*30));
    }
    
    text("Notable information:", 15, 640+(printLine*30));
    
    if(planet.notable_info.length() > 35){
      String[] tabText = planet.notable_info.split(" ");
      String[] Text = {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""};
      int i=0;
      
      for(int j=0; j<planet.notable_info.length()%36; j++){
        while(i < tabText.length && Text[j].length()+tabText[i].length() < 35){
          Text[j] += tabText[i++] + " ";
        };
        text(Text[j], 15, 670+(printLine*30));
        printLine += 1;
      }
    }else{
      text(planet.notable_info, 15, 670+(printLine*30));
    }
    printLine = 0;
  }
}

//OCRAExtended-48
//SourceCodePro-Light-48

void mousePressed() {
  for(int i=0; i<nbPlanets; i++){
    if(sqrt(pow(mouseX - (xPlanets + tabPlanets.get(i).x), 2) + pow(mouseY - (yPlanets + tabPlanets.get(i).y), 2)) <= tabPlanets.get(i).diam/2){ // On regarde si la souris survolle une planete 
      tabPlanets.get(i).selected = true;
      selectedPlanet = i;
    }else{
      tabPlanets.get(i).selected = false;
    } 
  }
}
