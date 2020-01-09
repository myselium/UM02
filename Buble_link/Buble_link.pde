import java.util.*;
// Définie si les liens entre les bulles sont ou non affichés
boolean link = true;
// Opacité des bulles
float opacity = 200;
// Taille des bulles
int sizeBall = 50;
// Vitesse de déplacement des bulles
float speed = 0.5;
// Tableau csv de GoT
Table table;
// Le nombre de bulles/personnages de GoT affiché
int nbPerso = 100;
// Liste de toutes les bulles
ArrayList<Ball> tabBall = new ArrayList<Ball>();
// Liste de toutes les maison de GoT
ArrayList<House> tabHouse = new ArrayList<House>();

// Code pour que la couleur des bulles change
/*int redBallCoef = int(pow(-1,int(random(1,6))));
int greenBallCoef = int(pow(-1,int(random(1,6))));
int blueBallCoef = int(pow(-1,int(random(1,6))));
int back = int(pow(-1,int(random(1,6))));
int GlobalRed = int(random(60,185));
int GlobalGreen = int(random(60,185));
int GlobalBlue = int(random(60,185));*/

// Classe des maison de GoT
class House{
  // Identifiant unique
  int id;
  // Nom de la maison
  String name;
  // Couleur des bulles des membres
  int[] colorFill;
  // Couleur des contoures des membres
  int[] colorBorder;
  // Largeur du boutton dans le menu
  int largeur;
  // Position en X du boutton dans le menu
  int posX;
  // Position en Y du boutton dans le menu
  int posY;
  // Définie si la maison est ou non affichée
  boolean display = true;
  // Nombre de personnages appartenant à la maison
  int nbPerso = 0;
  
  // Constructeur de la classe "House"
  House(int id, String name, int[] colorF, int[] colorB, int larg, int X, int Y){
    this.id = id;
    this.name = name;
    this.colorFill = colorF;
    this.colorBorder = colorB;
    this.largeur = larg;
    this.posX = X;
    this. posY = Y;
  }
}

// Classe des bulles
class Ball {
  // Identifiant unique
  int id;
  // Position en X de la bulle
  float posX;
  // Position en X de la bulle
  float posY;
  // Taille de la bulle (diamètre)
  float size;
  // Direction de la bulle en X (positif : gauche à droite, négatif : droite à gauche)
  int directX;
  // Direction de la bulle en Y (positif : bas en haut, négatif : haut en bas)
  int directY;
  // Couleur du contour de la bulle
  int[] borderColor;
  // Couleur de la bulle
  int[] fillColor;
  // Nom et prénom du personnage de GoT tel que "Prénom Nom"
  String shortName;
  // Nom et prénom du personnage de GoT tel que "Prénom_Nom"
  String name;
  // Tableau contenant tout les personnages avec qui le personnage est lié
  ArrayList<String> tabLink;
  // Maison du personnage
  House house = null;
  
  // Constructeur de la classe "Ball"
  Ball(int id, float score, String shortName, String name, ArrayList<String> links){
    this.id = id;
    this.posX = int(random(sizeBall*score/2+2, width-sizeBall*score/2-202));
    this.posY = int(random(sizeBall*score/2+2, height-sizeBall*score/2-2));
    this.size = sizeBall*score;
    this.directX = int(int(random(1,6))*pow(-1,int(random(1,6))));
    this.directY = int(int(random(1,6))*pow(-1,int(random(1,6))));
    this.shortName = shortName;
    this.name = name;
    this.tabLink = links;
    

    
    // On associe le personnage à une maison en fonction de son nom de famille
    for(int i=0; i < 9; i++){
      if(this.name.toLowerCase().indexOf(tabHouse.get(i).name.toLowerCase()) != -1){
        this.house = tabHouse.get(i);
        tabHouse.get(i).nbPerso++;
        break;
      }
    }
    if (this.house == null){
      this.house = tabHouse.get(9);
      tabHouse.get(9).nbPerso++;
    }
    
    // La bulle prend les couleur de la maison qui lui est associée
    this.borderColor = this.house.colorBorder;
    this.fillColor = this.house.colorFill;
  }
  
  // Code pour que la couleur des bulles change
  /*this.red = GlobalRed - int(random(1,30) -50);
  this.green = GlobalGreen - int(random(1,30) -50);
  this.blue = GlobalBlue - int(random(1,30) -50);*/
}

// Fonction exécutée une fois lors du lancement
void setup() {
  
  // Chargement du excel dans la variable "table"
  table = loadTable("C:\\Users\\jeane\\Documents\\Travail\\UTSEUS\\UM02\\Buble_link\\data\\GOT.csv", "header");
  // La table est triée en fonction du score des personnages
  table.sortReverse("score");
  
  // Calcul de la largeur des bouttons des maison en fonction de la hauteur de l'écran
  int largeurRect = int(height/21);
  int X = int((width - 200 + largeurRect/2));
  
  // Instanciation des maison de GoT
  tabHouse.add(new House(0, "Stark", new int[]{255,255,255}, new int[]{169,169,169}, largeurRect ,X, largeurRect));
  tabHouse.add(new House(0, "Arryn", new int[]{255,255,255}, new int[]{135,206,250}, largeurRect ,X, largeurRect*3));
  tabHouse.add(new House(0, "Lannister", new int[]{255,255,51}, new int[]{220,20,60}, largeurRect ,X, largeurRect*5));
  tabHouse.add(new House(0, "Tyrell", new int[]{255,255,51}, new int[]{50,205,50}, largeurRect ,X, largeurRect*7));
  tabHouse.add(new House(0, "Greyjoy", new int[]{255,255,51}, new int[]{69,69,69}, largeurRect ,X, largeurRect*9));
  tabHouse.add(new House(0, "Martell", new int[]{220,20,60}, new int[]{255,255,51}, largeurRect ,X, largeurRect*11));
  tabHouse.add(new House(0, "Baratheon", new int[]{69,69,69}, new int[]{255,255,51}, largeurRect ,X, largeurRect*13));
  tabHouse.add(new House(0, "Targaryen", new int[]{220,20,60}, new int[]{69,69,69}, largeurRect ,X, largeurRect*15));
  tabHouse.add(new House(0, "Tully", new int[]{135,206,250}, new int[]{220,20,60}, largeurRect ,X, largeurRect*17));
  tabHouse.add(new House(0, "Other", new int[]{169,169,169}, new int[]{69,69,69}, largeurRect ,X, largeurRect*19));
  
  // Instanciation des bulles/personnages de Got
  for (int i=0; i < nbPerso; i++)  {
    float score = table.getRow(i).getFloat("score");
    String shortName = table.getRow(i).getString("short_name");
    String name = table.getRow(i).getString("url");
    
    // Récupération des personnages avec qui il est lié
    String link = table.getRow(i).getString("awoif_links");
    link = link.substring(2);
    link = link.substring(0, link.length()-2);
    ArrayList<String> links = new ArrayList(Arrays.asList(link.split("', '")));
    Set<String> set = new HashSet<String>(links);
    links.clear();
    links.addAll(set);
    
    tabBall.add(new Ball(i, score, shortName, name, links));
  }
  
  fullScreen();
  cursor(CROSS);
}

// Fonction qui est appelée en boucle
void draw() {
  
  // Couleur du background
  background(240, 240, 240);
  // Taille du texte
  textSize(12);
  
  // Code pour que la couleur des bulles change
  /*background(GlobalRed + 70, GlobalGreen + 30, GlobalBlue + 50);
    
  if(GlobalRed +1 *redBallCoef-30 < 1 || GlobalRed +1 *redBallCoef > 184){
    redBallCoef = redBallCoef *-1;
  }else if(int(random(1,6)) > 5){
    redBallCoef = redBallCoef *-1;
  }
    
  if(GlobalGreen +1 *greenBallCoef-30 < 1 || GlobalGreen +1 *greenBallCoef > 184){
    greenBallCoef = greenBallCoef *-1;
  }else if(int(random(1,6)) > 5){
    greenBallCoef = greenBallCoef *-1;
  }
    
  if(GlobalBlue +1 *blueBallCoef-30 < 1 || GlobalBlue +1 *blueBallCoef > 184){
    blueBallCoef = blueBallCoef * -1;
  }else if(int(random(1,6)) > 5){
    blueBallCoef = blueBallCoef * -1;
  }
  
  GlobalRed = GlobalRed +1 *redBallCoef;
  GlobalGreen = GlobalGreen +1 *greenBallCoef;
  GlobalBlue = GlobalBlue +1 *blueBallCoef;*/

// On parcourt toute les bulles pour les afficher  
for (int i = 0; i < nbPerso; i++) {
  
  // Code pour que la couleur des bulles change
  /*tabBall.get(i).red = tabBall.get(i).red +1 *redBallCoef;
  tabBall.get(i).green = tabBall.get(i).green +1 *greenBallCoef;
  tabBall.get(i).blue = tabBall.get(i).blue +1 *blueBallCoef;*/
  
  // On parcourt les bulles restante pour voir si elles doivent être reliées
  for(int k=0; k<i; k++){
    float dist = sqrt(pow(tabBall.get(i).posX - tabBall.get(k).posX,2)+pow(tabBall.get(i).posY - tabBall.get(k).posY,2));
    boolean linked = false;
    for(int j=0; j < tabBall.get(i).tabLink.size(); j++){
      if (tabBall.get(i).tabLink.get(j).equals(tabBall.get(k).name)){
        linked = true;
        break;
      }
    }
    
    // Si les deux bulles sont proches, affichées et qu'elles possèdent un lien qui les relis, on affiche le lien
    if(dist < 2.5*sizeBall && link == true && linked == true && tabBall.get(i).house.display == true && tabBall.get(k).house.display == true){
      float sumOfRayon = (tabBall.get(i).size + tabBall.get(k).size)/2;
      // Respectivement, la couleur du lien, la couleur de son coutour et son épaisseur (calculé en fonction de la distance des deux boules et de leur taille)
      fill((tabBall.get(i).borderColor[0] + tabBall.get(k).borderColor[0])/2, (tabBall.get(i).borderColor[1] + tabBall.get(k).borderColor[1])/2, (tabBall.get(i).borderColor[2] + tabBall.get(k).borderColor[2])/2, opacity);
      stroke((tabBall.get(i).borderColor[0] + tabBall.get(k).borderColor[0])/2, (tabBall.get(i).borderColor[1] + tabBall.get(k).borderColor[1])/2, (tabBall.get(i).borderColor[2] + tabBall.get(k).borderColor[2])/2, opacity);
      strokeWeight(sizeBall*0.5 * (1 - (max((dist - sumOfRayon), 0)/ (2.5*sizeBall - sumOfRayon))));
      // Affichage du lien
      line(tabBall.get(i).posX, tabBall.get(i).posY, tabBall.get(k).posX, tabBall.get(k).posY);
    }
  }
}

// Epaisseur des liens
strokeWeight(3);

// Pour chaque boule, on vérifie qu'elle est affichée
for(int i=0; i<nbPerso; i++){
  if(tabBall.get(i).house.display == true){
    
    // On fait rebondir la bulle si besoin (elle ateint les bords)
    tabBall.get(i).posX = tabBall.get(i).posX + speed * tabBall.get(i).directX;
    tabBall.get(i).posY = tabBall.get(i).posY + speed * tabBall.get(i).directY;
    // On la déplace
    if(tabBall.get(i).posX >= width - tabBall.get(i).size/2-200 || tabBall.get(i).posX <= 0 + tabBall.get(i).size/2){
      tabBall.get(i).directX = tabBall.get(i).directX * -1;
    }
    if(tabBall.get(i).posY >= height-tabBall.get(i).size/2 || tabBall.get(i).posY<= 0+tabBall.get(i).size/2){
      tabBall.get(i).directY = tabBall.get(i).directY*-1;
    }
    
    // Affichage de la bulle
    fill(tabBall.get(i).fillColor[0], tabBall.get(i).fillColor[1], tabBall.get(i).fillColor[2], opacity);
    stroke(tabBall.get(i).borderColor[0], tabBall.get(i).borderColor[1], tabBall.get(i).borderColor[2], opacity);
    circle(tabBall.get(i).posX, tabBall.get(i).posY, tabBall.get(i).size);
    // Affichage du texte (Nom et prénom du personnage de GoT)
    textAlign(CENTER);
    fill(0, 0, 0);
    text(tabBall.get(i).shortName, tabBall.get(i).posX, tabBall.get(i).posY);
  }
  
}

// Affichage du cadre du menu
fill(190, 190, 190);
strokeWeight(3);
stroke(0, 0, 0);
rect(width-200, 0, 200, height);

// Pour chaque instance de "House"/maison de GoT
for(int i = 0; i < tabHouse.size(); i++){
  // On l'affiche, différament si elle est selectionnée ou pas
  if (tabHouse.get(i).display == false){
    textSize(15);
    fill(tabHouse.get(i).colorFill[0], tabHouse.get(i).colorFill[1], tabHouse.get(i).colorFill[2], 80);
    stroke(tabHouse.get(i).colorBorder[0], tabHouse.get(i).colorBorder[1], tabHouse.get(i).colorBorder[2], 80);
    rect(tabHouse.get(i).posX, tabHouse.get(i).posY, tabHouse.get(i).largeur, tabHouse.get(i).largeur, 3);
    textAlign(LEFT);
    text(tabHouse.get(i).name, tabHouse.get(i).posX + tabHouse.get(i).largeur*1.5, tabHouse.get(i).posY+tabHouse.get(i).largeur*0.5);
    
    textSize(35);
    fill(tabHouse.get(i).colorBorder[0], tabHouse.get(i).colorBorder[1], tabHouse.get(i).colorBorder[2], 80);
    textAlign(CENTER, CENTER);
    text(tabHouse.get(i).nbPerso, tabHouse.get(i).posX + tabHouse.get(i).largeur*0.5, tabHouse.get(i).posY+tabHouse.get(i).largeur*0.5);
  }else{
    textSize(15);
    fill(tabHouse.get(i).colorFill[0], tabHouse.get(i).colorFill[1], tabHouse.get(i).colorFill[2], 255);
    stroke(tabHouse.get(i).colorBorder[0], tabHouse.get(i).colorBorder[1], tabHouse.get(i).colorBorder[2], 255);
    rect(tabHouse.get(i).posX, tabHouse.get(i).posY, tabHouse.get(i).largeur, tabHouse.get(i).largeur, 3);
    textAlign(LEFT);
    text(tabHouse.get(i).name, tabHouse.get(i).posX + tabHouse.get(i).largeur*1.5, tabHouse.get(i).posY+tabHouse.get(i).largeur*0.5);
    
    textSize(35);
    fill(tabHouse.get(i).colorBorder[0], tabHouse.get(i).colorBorder[1], tabHouse.get(i).colorBorder[2], 255);
    textAlign(CENTER, CENTER);
    text(tabHouse.get(i).nbPerso, tabHouse.get(i).posX + tabHouse.get(i).largeur*0.5, tabHouse.get(i).posY+tabHouse.get(i).largeur*0.5);
  }
}
}

// Function appelée lorsque le boutton du click de la souris est laché
void mouseClicked() {
  // On (dé)selectionne la maison est on la (dé)grise
  for(int i = 0; i < tabHouse.size(); i++){
    if(mouseX >= tabHouse.get(i).posX && mouseX < tabHouse.get(i).posX + tabHouse.get(i).largeur && mouseY >= tabHouse.get(i).posY && mouseY < tabHouse.get(i).posY + tabHouse.get(i).largeur){
      if (tabHouse.get(i).display == true){
        textSize(15);
        tabHouse.get(i).display = false;
        fill(tabHouse.get(i).colorFill[0], tabHouse.get(i).colorFill[1], tabHouse.get(i).colorFill[2], 80);
        stroke(tabHouse.get(i).colorBorder[0], tabHouse.get(i).colorBorder[1], tabHouse.get(i).colorBorder[2], 80);
        rect(tabHouse.get(i).posX, tabHouse.get(i).posY, tabHouse.get(i).largeur, tabHouse.get(i).largeur, 3);
        textAlign(LEFT);
        text(tabHouse.get(i).name, tabHouse.get(i).posX + tabHouse.get(i).largeur*1.5, tabHouse.get(i).posY+tabHouse.get(i).largeur*0.5);
        
        textSize(35);
        fill(tabHouse.get(i).colorBorder[0], tabHouse.get(i).colorBorder[1], tabHouse.get(i).colorBorder[2], 80);
        textAlign(CENTER, CENTER);
        text(tabHouse.get(i).nbPerso, tabHouse.get(i).posX + tabHouse.get(i).largeur*0.5, tabHouse.get(i).posY+tabHouse.get(i).largeur*0.5);
      }else{
        tabHouse.get(i).display = true;
        textSize(15);
        fill(tabHouse.get(i).colorFill[0], tabHouse.get(i).colorFill[1], tabHouse.get(i).colorFill[2], 255);
        stroke(tabHouse.get(i).colorBorder[0], tabHouse.get(i).colorBorder[1], tabHouse.get(i).colorBorder[2], 255);
        rect(tabHouse.get(i).posX, tabHouse.get(i).posY, tabHouse.get(i).largeur, tabHouse.get(i).largeur, 3);
        textAlign(LEFT);
        text(tabHouse.get(i).name, tabHouse.get(i).posX + tabHouse.get(i).largeur*1.5, tabHouse.get(i).posY+tabHouse.get(i).largeur*0.5);
        
        textSize(35);
        fill(tabHouse.get(i).colorBorder[0], tabHouse.get(i).colorBorder[1], tabHouse.get(i).colorBorder[2], 255);
        textAlign(CENTER, CENTER);
        text(tabHouse.get(i).nbPerso, tabHouse.get(i).posX + tabHouse.get(i).largeur*0.5, tabHouse.get(i).posY+tabHouse.get(i).largeur*0.5);
      }
    }
  }
}
