import java.util.*;
// Variables globales
Table table;  // Tableau csv de GoT
int nbPerso = 100;  // Le nombre de bulles/personnages de GoT affiché
ArrayList<Perso> tabPerso = new ArrayList<Perso>();  // Liste de toutes les bulles
ArrayList<House> tabHouse = new ArrayList<House>();  // Liste de toutes les maison de GoT


Boolean sortedParameter1 = false;  // Graphe1, False : score décroissant, True : par maison
Boolean sorted1 = false;  // Graphe1 trié
Boolean sortedParameter2 = true;  // Graphe2, False : Score décroissant, True : nb personnages
Boolean sorted2 = false;  // Graphe2 trié

// Position XY des graphes 1&2
float graph1X = 0.075;
float graph1Y = 0.77;
float graph2X = 0.82;
float graph2Y = 0.1;

// Nombre de personnages max et min dans les maisons
int max = 0;
int min = 0;

// Classe des maison de GoT
class House{
  int id;  // Ordre de la maison dans le classement
  String name;  // Nom de la maison
  float[] colorFill;  // Couleur de la maison (en fonction de son nombre de membre)
  float[] colorText;  // Couleur du nom de la maison
  int nbPerso = 0;  // Nombre de personnages appartenant à la maison
  float sumScore = 0; // Total des scores cumulés des membres de la maison
  
  // Constructeur de la classe "House"
  House(int id, String name){
    this.id = id;
    this.name = name;
  }
}

// Classe des personnages
class Perso {
  String shortName;  // Nom et prénom du personnage de GoT tel que "Prénom Nom"
  String name;  // Nom et prénom du personnage de GoT tel que "Prénom_Nom"
  House house = null;  // Maison du personnage
  float score;
  
  // Constructeur de la classe "Ball"
  Perso(float score, String shortName, String name){
    this.shortName = shortName;
    this.name = name;
    this.score = score;
    
    // On associe le personnage à une maison en fonction de son nom de famille
    for(int i=0; i < 9; i++){
      if(this.name.toLowerCase().indexOf(tabHouse.get(i).name.toLowerCase()) != -1){
        this.house = tabHouse.get(i);
        tabHouse.get(i).nbPerso++; // On ajoute +1 aux membres de la maison
        tabHouse.get(i).sumScore += this.score; 
        break;
      }
    }
    // Alors c'est que le personnage n'appartient pas aux maisons principales
    if (this.house == null){
      this.house = tabHouse.get(9);
      tabHouse.get(9).nbPerso++;
      tabHouse.get(9).sumScore += this.score;
    }
  }
}

// Fonction exécutée une fois lors du lancement
void setup() {
  table = loadTable("C:\\Users\\jeane\\Documents\\Travail\\UTSEUS\\UM02\\GOT_Interactif_House\\data\\GOT.csv", "header");  // Chargement du excel dans la variable "table"
  table.sortReverse("score");  // La table est triée en fonction du score des personnages
  
  // Instanciation des maisons de GoT
  tabHouse.add(new House(0, "Arryn"));
  tabHouse.add(new House(1, "Baratheon"));
  tabHouse.add(new House(2, "Greyjoy"));
  tabHouse.add(new House(3, "Stark"));
  tabHouse.add(new House(4, "Martell"));
  tabHouse.add(new House(5, "Lannister"));
  tabHouse.add(new House(6, "Targaryen"));
  tabHouse.add(new House(7, "Tully"));
  tabHouse.add(new House(8, "Tyrell"));
  tabHouse.add(new House(9, "Other"));
  
  // Instanciation des personnages de Got
  for (int i=0; i < nbPerso; i++)  {
    float score = table.getRow(i).getFloat("score");
    String shortName = table.getRow(i).getString("short_name");
    String name = table.getRow(i).getString("url");
    tabPerso.add(new Perso(score, shortName, name));
  }
  
  // Definition des couleurs des maison selon le nb de personnages dedans
  // Calcule du min et du max parmis toutes les maisons
  for(int i=0; i < tabHouse.size(); i++){
    if((tabHouse.get(i).nbPerso < min && tabHouse.get(i).nbPerso != 0) || min == 0){
      min = tabHouse.get(i).nbPerso;
    }
    if(tabHouse.get(i).nbPerso > max && tabHouse.get(i).nbPerso != 0){
      max = tabHouse.get(i).nbPerso;
    }
  }
  
  // Calcule de la couleur des maisons en fonction de leur effectif et du max et min des maisons
  for(int i=0; i < tabHouse.size(); i++){
    float colorF = 22000000/max * (max - tabHouse.get(i).nbPerso);
    colorF = colorF/100000;
    float colorT;
    if(colorF < 125){
      colorT = 255;
    }else{
      colorT = 0;
    }
    
    tabHouse.get(i).colorFill = new float[] {colorF, colorF, colorF};
    tabHouse.get(i).colorText = new float[] {colorT, colorT, colorT};
  }
  
  fullScreen();
  cursor(CROSS);
}

// Fonction qui affiche le texte penché
void leaningText(float x, float y, float angle, String Text){
  pushMatrix();
  translate(x,y);
  rotate(angle);
  translate(-x,-y);
  text(Text, x,y);
  popMatrix();
}

// Fonction qui est appelée en boucle
void draw() {
  
  // Tri des maisons
  if(sorted2 == false){
    if(sortedParameter2 == false){  // Tri en fonction du nombre de membres
      for(int i=1; i<tabHouse.size(); i++){
        House x = tabHouse.get(i);
        int j = i;
        while(j>0 && tabHouse.get(j-1).nbPerso < x.nbPerso){
          tabHouse.set(j, tabHouse.get(j-1)) ;
          j--;
        }
        tabHouse.set(j, x);
      }
      sorted2 = true;
    }else{  // Tri en fonction du score moyen des membres
      for(int i=1; i<tabHouse.size(); i++){
        House x = tabHouse.get(i);
        int j = i;
        while(j>0 && ((tabHouse.get(j-1).sumScore/tabHouse.get(j-1).nbPerso) < (x.sumScore/x.nbPerso) || tabHouse.get(j-1).nbPerso == 0)){
          tabHouse.set(j, tabHouse.get(j-1)) ;
          j--;
        }
        tabHouse.set(j, x);
      }
      sorted2 = true;
    }
    // On met à jour les ordres des maisons
    for(int i=0; i<tabHouse.size(); i++){
      tabHouse.get(i).id = i;
    }
  }
  
  // Tri des personnages
  if(sorted1 == false){
    if(sortedParameter1 == false ){  // Tri en fonction du score
      for(int i=1; i<tabPerso.size(); i++){
        Perso x = tabPerso.get(i);
        int j = i;
        while(j>0 && tabPerso.get(j-1).score < x.score){
          tabPerso.set(j, tabPerso.get(j-1)) ;
          j--;
        }
        tabPerso.set(j, x);
      }
      sorted1 = true;
    }else{  // Tri en fonction de la maison
      for(int i=1; i<tabPerso.size(); i++){
        Perso x = tabPerso.get(i);
        int j = i;
        while(j>0 && tabPerso.get(j-1).house.id > x.house.id){
          tabPerso.set(j, tabPerso.get(j-1)) ;
          j--;
        }
        tabPerso.set(j, x);
      }
      sorted1 = true;
    }
  }
  
  background(240, 240, 240);  // Couleur du background
  // Titre des diagrammes
  textAlign(LEFT, CENTER);
  fill(255, 0, 0);
  textSize(30);
  text("Who are the main characters and Houses of GoT?", 0.2 * width, 0.1 * height);
  fill(0, 0, 0);
  textSize(15);
  text("Score charts based on Game of Thrones main characters and Houses based on the number of their members,\naccording to Wiki of Ice and Fire for the firsts 10 volumes.", 0.2 * width, 0.15 * height);
  textSize(12);
  
  // GRAPHE 1 : Personnages
  textAlign(LEFT, CENTER);
  int hover = -1; // si -1, aucun personnage n'est survollé par la souris, sinon égal à sa position dans tabPerso
  for(int i=0; i < tabPerso.size(); i++){
    
    // On vérifie si le bloc du personnage est survollé par la souris
    if(mouseX > i * (0.62 * width/(nbPerso)) + graph1X * width && mouseX < i * (0.62 * width/(nbPerso)) + graph1X * width + 0.62 * width/(nbPerso) && mouseY > graph1Y * height - (0.30 * height * tabPerso.get(i).score) && mouseY < graph1Y * height - (0.30 * height * tabPerso.get(i).score) + 0.30 * height * tabPerso.get(i).score){
      hover = i;
      stroke(255, 0, 0);
    }else{
      stroke(240, 240, 240);
    }
    
    fill(255, 255, 255);
    strokeWeight(3);
    rect(i * (0.62 * width/(nbPerso)) + graph1X * width, graph1Y * height - (0.30 * height * tabPerso.get(i).score), 0.62 * width/(nbPerso), 0.30 * height * tabPerso.get(i).score);  // Bloc du personnage
    
    // On affiche les noms des personnages dans le bloc seulement s'ils sont 80 ou moins
    if(nbPerso < 81){
      fill(0, 0, 0);
      leaningText((i+0.75) * 0.62 * width/(nbPerso) + (graph1X - 0.005) * width +3, (graph1Y-0.01) * height, -HALF_PI, tabPerso.get(i).shortName);
    }
    
    // Si le Graph1 est trié par maison, on vérifie et affiche au besoin la délimitation entre les familles et le nom de la famille
    if(sortedParameter1 == true && ((i > 0 && tabPerso.get(i).house.name != tabPerso.get(i-1).house.name) || i == 0)){
      line(i * (0.62 * width/(nbPerso)) + graph1X * width, (graph1Y + 0.02) * height -3, i * (0.62 * width/(nbPerso)) + graph1X * width, (graph1Y + 0.02) * height +3);
      fill(0, 0, 0);
      leaningText(i * (0.62 * width/(nbPerso)) + graph1X * width + 0.62 * width/(nbPerso) * 0.5, (graph1Y + 0.02) * height +5, 0.5 *HALF_PI, tabPerso.get(i).house.name);
    }
  }
  
  // Si le Graph1 est trié par maison, on affiche l'axe
  if(sortedParameter1 == true){
    line(graph1X * width, (graph1Y + 0.02) * height, (graph1X + 0.62) * width, (graph1Y + 0.02) * height); // Horizontale Maison
    line(graph1X * width, (graph1Y + 0.02) * height -3, graph1X * width, (graph1Y + 0.02) * height +3); // Premier separateur Maison
    line((graph1X + 0.62) * width, (graph1Y + 0.02) * height -3, (graph1X + 0.62) * width, (graph1Y + 0.02) * height +3); // Dernier separateur Maison
  }
  
  // Si un personnage est survollé
  if(hover > -1){
    // Ligne pointillée avec le score du personnage hover
    stroke(255, 0, 0);
    for(float i = graph1X * width - 4; i< (graph1X + 0.65) * width; i+=10){
      line(i, graph1Y * height - (0.30 * height * tabPerso.get(hover).score), i+2 ,graph1Y * height - (0.30 * height * tabPerso.get(hover).score));
    }
    fill(255, 255, 255);
    rect(hover * (0.62 * width/(nbPerso)) + graph1X * width, graph1Y * height - (0.30 * height * tabPerso.get(hover).score), 0.62 * width/(nbPerso), 0.30 * height * tabPerso.get(hover).score);  // Bloc du personnage
    fill(255, 0, 0);
    textAlign(RIGHT, CENTER);
    // On affiche les noms des personnages dans le bloc seulement s'ils sont 80 ou moins
    if(nbPerso < 81){
      fill(255, 0, 0);
      textAlign(LEFT, CENTER);
      leaningText((hover+0.75) * 0.62 * width/(nbPerso) + (graph1X - 0.005) * width +3, (graph1Y-0.01) * height, -HALF_PI, tabPerso.get(hover).shortName);
    }
    textAlign(RIGHT, CENTER);
    text(tabPerso.get(hover).score*10, (graph1X - 0.005) * width, graph1Y * height - (0.30 * height * tabPerso.get(hover).score));
    textAlign(LEFT, CENTER);
    text("Score", (graph1X + 0.65) * width +4, graph1Y * height - (0.30 * height * tabPerso.get(hover).score) -2);
    
    if(nbPerso > 80){
      textAlign(LEFT, CENTER);
      fill(255, 0, 0);
      leaningText((hover+0.75) * 0.62 * width/(nbPerso) + (graph1X - 0.005) * width +3, graph1Y * height - (0.30 * height * tabPerso.get(hover).score)-7, -0.5 * HALF_PI, tabPerso.get(hover).shortName);
    }
    
    // Si le graphe 1 est trié par Maison
    if(sortedParameter1 == true){
      for(int i=0; i < tabPerso.size(); i++){
        if(tabPerso.get(hover).house.name == tabPerso.get(i).house.name){
          if(i == 0 || tabPerso.get(i).house.name != tabPerso.get(i-1).house.name){
            stroke(255, 0, 0);
            fill(255, 0, 0);
            line(i * (0.62 * width/(nbPerso)) + graph1X * width, (graph1Y + 0.02) * height -3, i * (0.62 * width/(nbPerso)) + graph1X * width, (graph1Y + 0.02) * height +3);
            leaningText(i * (0.62 * width/(nbPerso)) + graph1X * width + 0.62 * width/(nbPerso) * 0.5, (graph1Y + 0.02) * height +5, 0.5 *HALF_PI, tabPerso.get(i).house.name);
          }
          if(i == tabPerso.size()-1 || tabPerso.get(i).house.name != tabPerso.get(i+1).house.name){
            stroke(255, 0, 0);
            fill(255, 0, 0);
            line(i * (0.62 * width/(nbPerso)) + graph1X * width + 0.62 * width/(nbPerso), (graph1Y + 0.02) * height -3, i * (0.62 * width/(nbPerso)) + graph1X * width + 0.62 * width/(nbPerso), (graph1Y + 0.02) * height +3);
          }
          line(i * (0.62 * width/(nbPerso)) + graph1X * width + 0.62 * width/(nbPerso), (graph1Y + 0.02) * height, i * (0.62 * width/(nbPerso)) + graph1X * width, (graph1Y + 0.02) * height);
        }
      }
    } 
  }
  
  // Echelle Graphe1
  strokeWeight(3);
  stroke(0, 0, 0);
  fill(255, 255, 255);

  line(graph1X * width - 4, graph1Y * height, (graph1X + 0.65) * width, graph1Y * height); // Horizontale
  //line((graph1X + 0.637) * width, (graph1Y+0.01) * height, (graph1X + 0.65) * width, graph1Y * height); // Fleche H
  line(graph1X * width, graph1Y * height, graph1X * width, (graph1Y - 0.6) * height); // Vertical
  line((graph1X - 0.0045) * width, (graph1Y - 0.575) * height, graph1X * width, (graph1Y - 0.6) * height); // Fleche V
  line(graph1X * width - 4, (graph1Y-0.3) * height, graph1X * width, (graph1Y-0.3) * height); // 1O
  line(graph1X * width - 4, (graph1Y-0.54) * height, graph1X * width, (graph1Y-0.54) * height); // 18
  
  fill(0, 0, 0);
  textAlign(RIGHT, CENTER);
  text("0", (graph1X - 0.005) * width, graph1Y * height-2);
  text("10", (graph1X - 0.005) * width, (graph1Y-0.3) * height-2);
  text("18", (graph1X - 0.005) * width, (graph1Y-0.54) * height-2);
  textAlign(LEFT, CENTER);
  leaningText(graph1X * width, (graph1Y - 0.6) * height -15, -HALF_PI, "Characters score");
  text("Characters", (graph1X + 0.65) * width +5, graph1Y * height-2);
  
  
  // GRAPHE MAISON
  // Ligne en pointillé
  for(float i = graph2Y * height; i< (graph2Y + 0.8) * height; i+=10){
    line((graph2X + 0.1) * width, i, (graph2X + 0.1) * width, i+2);
  }
  
  // Affichage des différentes maisons
  for(int j=0; j < tabHouse.size(); j++){
    if(hover > -1 && tabPerso.get(hover).house == tabHouse.get(j)){
      stroke(255, 0, 0);
    }else{
      stroke(0, 0, 0);
    }
    
    // On vérifie si la souris survolle le bloc de la maison
    if(mouseX > graph2X * width && mouseX < graph2X * width + 0.1 * width * (tabHouse.get(j).sumScore/tabHouse.get(j).nbPerso) && mouseY > graph2Y * height + 0.8 * height/(2 * tabHouse.size() + 1) * (j*2+1) && mouseY < 0.8 * height/(2 * tabHouse.size() + 1) + graph2Y * height + 0.8 * height/(2 * tabHouse.size() + 1) * (j*2+1)){
          if(sortedParameter1 == true){ // Si le Graph1 est trié par maison, on surligne en rouge la maison survollée
            for(int i=0; i < tabPerso.size(); i++){
              if(tabHouse.get(j).name == tabPerso.get(i).house.name){
                if(i == 0 || tabPerso.get(i).house.name != tabPerso.get(i-1).house.name){
                  stroke(255, 0, 0);
                  fill(255, 0, 0);
                  line(i * (0.62 * width/(nbPerso)) + graph1X * width, (graph1Y + 0.02) * height -3, i * (0.62 * width/(nbPerso)) + graph1X * width, (graph1Y + 0.02) * height +3); // Début de la maison
                  leaningText(i * (0.62 * width/(nbPerso)) + graph1X * width + 0.62 * width/(nbPerso) * 0.5, (graph1Y + 0.02) * height +5, 0.5 *HALF_PI, tabPerso.get(i).house.name);
                }
                if(i == tabPerso.size()-1 || tabPerso.get(i).house.name != tabPerso.get(i+1).house.name){ 
                  stroke(255, 0, 0);
                  fill(255, 0, 0);
                  line(i * (0.62 * width/(nbPerso)) + graph1X * width + 0.62 * width/(nbPerso), (graph1Y + 0.02) * height -3, i * (0.62 * width/(nbPerso)) + graph1X * width + 0.62 * width/(nbPerso), (graph1Y + 0.02) * height +3); // Fin de la maison
                }
                line(i * (0.62 * width/(nbPerso)) + graph1X * width + 0.62 * width/(nbPerso), (graph1Y + 0.02) * height, i * (0.62 * width/(nbPerso)) + graph1X * width, (graph1Y + 0.02) * height); // Contenu de la maison
              }
            }
          }
          
      // Ligne pointillée avec le score moyen de la Maison
      stroke(255, 0, 0);
      for(float i = graph1X * width - 4; i< (graph1X + 0.65) * width; i+=10){
        line(i, graph1Y * height - (0.30 * height * tabHouse.get(j).sumScore/tabHouse.get(j).nbPerso), i+2 ,graph1Y * height - (0.30 * height * tabHouse.get(j).sumScore/tabHouse.get(j).nbPerso));
      }
      fill(255, 0, 0);
      textAlign(RIGHT, CENTER);
      text(tabHouse.get(j).sumScore/tabHouse.get(j).nbPerso *10, (graph1X - 0.005) * width, graph1Y * height - (0.30 * height * tabHouse.get(j).sumScore/tabHouse.get(j).nbPerso) -2); // Score moyen de la maison
      textAlign(LEFT, CENTER);
      text("Average score", (graph1X + 0.65) * width +4, graph1Y * height - (0.30 * height * tabHouse.get(j).sumScore/tabHouse.get(j).nbPerso) -2);
    }else if(hover > -1 && tabPerso.get(hover).house == tabHouse.get(j)){
      stroke(255, 0, 0);
    }else{
      stroke(0, 0, 0);
    }
    
    fill(tabHouse.get(j).colorFill[0], tabHouse.get(j).colorFill[1], tabHouse.get(j).colorFill[2]);
    rect(graph2X * width, graph2Y * height + 0.8 * height/(2 * tabHouse.size() + 1) * (j*2+1), 0.1 * width * (tabHouse.get(j).sumScore/tabHouse.get(j).nbPerso), 0.8 * height/(2 * tabHouse.size() + 1)); // Bloc de la maison
    fill(tabHouse.get(j).colorText[0], tabHouse.get(j).colorText[1], tabHouse.get(j).colorText[2]);
    textAlign(LEFT, CENTER);
    text(tabHouse.get(j).name, (graph2X + 0.005) * width, graph2Y * height + 0.8 * height/(2 * tabHouse.size() + 1) * (j*2+1.5));
  }
  
  // Abcisse et ordonné Graphe2
  strokeWeight(3);
  stroke(0, 0, 0);
  textAlign(CENTER, CENTER);
  text("Average House score", (graph2X + 0.05) * width, graph2Y * height - 35);
  line(graph2X * width, (graph2Y + 0.8) * height, graph2X * width, graph2Y * height); // Vertical
  textAlign(CENTER, CENTER);
  text("0", graph2X * width, graph2Y * height -10);
  text("10", (graph2X + 0.1) * width, graph2Y * height -10);
  fill(255, 255, 255);
  
  // Legendes Graph2
  rect((graph2X - 0.04) * width, graph2Y * height, 50, 250); // Bloc légende nuances de couleurs
  // Graduation couleur
  float x = (graph2X - 0.04) * width +3;
  float y = graph2Y * height +3;
  int h = 244;
  int w = 44;
  color c1 = color(30, 30, 30);
  color c2 = color(220, 220, 220);
  for (float i = y; i <= y+h; i++) {
    float inter = map(i, y, y+h, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, x+w, i);
  }
  
  stroke(0, 0, 0);
  line((graph2X - 0.04) * width, graph2Y * height, (graph2X - 0.04) * width-4, graph2Y * height); // Legende MAX
  line((graph2X - 0.04) * width, graph2Y * height + 250, (graph2X - 0.04) * width-4, graph2Y * height+250); // Legende MIN
  textAlign(RIGHT, CENTER);
  fill(0, 0, 0);
  text(min, (graph2X - 0.04) * width-10, graph2Y * height+250);
  text(max, (graph2X - 0.04) * width-10, graph2Y * height);
  textAlign(CENTER, CENTER);
  leaningText((graph2X - 0.04) * width -14, graph2Y * height +125, -HALF_PI, "Number of House's members");
  
  // Bouttons de tri Graph2, par score ou par nombre de membres
  fill(255, 255, 255);
  if(sortedParameter2 == true){
    stroke(255, 0, 0);
    rect((graph2X - 0.04) * width, graph2Y * height + 300, 50, 50); // Button Score
    stroke(0, 0, 0);
    rect((graph2X - 0.04) * width, graph2Y * height + 400, 50, 50); // Button Membres
  }else{
    stroke(0, 0, 0);
    rect((graph2X - 0.04) * width, graph2Y * height + 300, 50, 50); // Button Score
    stroke(255, 0, 0);
    rect((graph2X - 0.04) * width, graph2Y * height + 400, 50, 50); // Button Membres
  }
  fill(0, 0, 0);
  textAlign(CENTER, CENTER);
  text("Score", (graph2X - 0.04) * width+25, graph2Y * height + 325);
  text("Member", (graph2X - 0.04) * width+25, graph2Y * height + 425);
  
  // Bouttons de tri Graph1, par score, ou par maisons
  fill(255, 255, 255);  
  if(sortedParameter1 == false){
    stroke(255, 0, 0);
    rect(0.16 * width, 0.86 * height, 0.16 * width, 0.07 * height); // Button Score
    stroke(0, 0, 0);
    rect(0.48 * width, 0.86 * height, 0.16 * width, 0.07 * height); // Button Maisons
  }else{
    stroke(0, 0, 0);
    rect(0.16 * width, 0.86 * height, 0.16 * width, 0.07 * height); // Button Score
    stroke(255, 0, 0);
    rect(0.48 * width, 0.86 * height, 0.16 * width, 0.07 * height); // Button Maisons
  }
  textAlign(CENTER, CENTER);
  fill(0, 0, 0);
  text("Sort by Character score", 0.24 * width, 0.89 * height+2);
  text("Sort by House",  0.56 * width, 0.89 * height+2);
  
}


// Function appelée lorsque on clique avec la souris
void mousePressed() {
  if(mouseX > 0.16 * width && mouseX < 0.32 * width && mouseY > 0.86 * height && mouseY < 0.93 * height){ // Graphe1, tri par maison
    sortedParameter1 = false;
    sorted1 = false;
  }else if(mouseX > 0.48 * width && mouseX < 0.64 * width && mouseY > 0.86 * height && mouseY < 0.93 * height){ // Graphe1, tri par score
    sortedParameter1 = true;
    sorted1 = false;
  }else if(mouseX > 0.78 * width && mouseX < 0.78 * width + 50 && mouseY > 0.1 * height + 300 && mouseY < 0.1 * height + 350){ // Graphe2, tri par Score
    sortedParameter2 = true;
    sorted1 = false;
    sorted2 = false;
  }else if(mouseX > 0.78 * width && mouseX < 0.78 * width + 50 && mouseY > 0.1 * height + 400 && mouseY < 0.1 * height + 450){ // Graphe2, tri par nombre de membres
    sortedParameter2 = false;
    sorted1 = false;
    sorted2 = false;
  }
}
