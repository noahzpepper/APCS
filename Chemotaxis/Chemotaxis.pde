//Declare empty arrays for all three things
Bacteria listOfBacteria[] = new Bacteria[30];
Food listOfFood[] = new Food[30];
Virus listOfViruses[] = new Virus[10];

boolean pressingMouse = false;

int canvasSize = 600; //Size of the canvas

void setup()
{
	size(canvasSize, canvasSize);
	//Initialize all things
	initializeBacteria();
	initializeFood();
	initializeViruses();
}

void draw(){
	background(235);
	//Loop through bacteria array, move and show them
	for (int i = 0; i < listOfBacteria.length; i++){
		Bacteria bac1 = listOfBacteria[i];
		if (bac1.alive){
			bac1.move();
			bac1.show();
			for (int j = 0; j < listOfBacteria.length; j++){
				Bacteria bac2 = listOfBacteria[j];
				if (bac1.eatBacteriaCheck(bac2) &&
					i != j && bac2.alive){
					if (bac1.mySize*5 > bac2.mySize*4){
						bac1.merge(bac2);
					} else if (bac2.mySize*5 > bac1.mySize*4){
						bac2.merge(bac1);
					}
				}
			}
		}
	}
	//Loop through food array and show them
	for (int i = 0; i < listOfFood.length; i++){
			listOfFood[i].show();
	}
	//Loop through the viruses array and show them
	for (int i = 0; i < listOfViruses.length; i++){
		listOfViruses[i].show();
	}

}

//The Bacteria class models one Bacteria.
class Bacteria {
	//Declare variables
	int myX, myY, myColor, mySpeed;
	double mySize;
	boolean alive;
	Food target; //Each bac has a Food target that it always is biased towards
	Bacteria(int x, int y, color theColor){
		myX = x;
		myY = y;
		myColor = theColor;
		mySize = 15;
		alive = true;
		mySpeed = getSpeed(); //gets speed based on size
	}

	void move(){
		touchFood(); //Check if it's touching a food. Will execute code if true.
		touchVirus(); //Check if it's touching a virus. Will execute code if true.
		mySpeed = getSpeed(); //Gets new speed based on current size
		//If target doesn't exist (either because it's not alive or null), get a new target.
		if (target == null || !target.alive){
			target = getNewTarget();
		}
		//Now determine if biased. If biased, set biasX and biasY to where it wants to go.
		int biasX, biasY;
		boolean isBiased;
		if (pressingMouse){
			biasX = mouseX;
			biasY = mouseY;
			isBiased = true;
		} else if (target.alive){
			biasX = target.myX;
			biasY = target.myY;
			isBiased = true;
		} else {
			biasX = canvasSize/2;
			biasY = canvasSize/2;
			isBiased = false;
		}
		//Walk based on if it is biased.
		if (isBiased){
			if (biasX > myX){
				myX = myX + (int)(Math.random()*mySpeed)-(mySpeed/2)+1;
			} else {
				myX = myX + (int)(Math.random()*mySpeed)-(mySpeed/2);
			}
			if (biasY > myY){
				myY = myY + (int)(Math.random()*mySpeed)-(mySpeed/2)+1;
			} else {
				myY = myY + (int)(Math.random()*mySpeed)-(mySpeed/2);
			}
		} else {
			myX = myX + (int)(Math.random()*5)-2;
			myY = myY + (int)(Math.random()*5)-2;
		}
	}
	//Loop through each food and check if touching. If touching, eat food.
	void touchFood(){
		for (int i = 0; i < listOfFood.length; i++){
			if (listOfFood[i] != null &&
				listOfFood[i].alive && eatFoodCheck(listOfFood[i])){
					listOfFood[i].alive = false;
					mySize += (150/mySize);
					target = getNewTarget();
			}
		}
	}
	//Loops through each virus and checks if touching. If touching, split.
	void touchVirus(){
		for (int i = 0; i < listOfViruses.length; i++){
			if (listOfViruses[i] != null &&
				listOfViruses[i].alive && eatVirusCheck(listOfViruses[i])){
					//This code is run when it touches a virus.
					if (mySize > 100){
						//This code is run when it eats a virus.
						listOfViruses[i].alive = false; //Kill virus
						mySize = mySize/2; //Half size
						//Now loop through and find an empty spot in the bac array
						boolean hasNotFoundSpotInArray = true;
						int j = 0;
						while(hasNotFoundSpotInArray){
							if (!listOfBacteria[j].alive){
								//When an empty spot is found,
								listOfBacteria[j].alive = true; //make the bac alive
								listOfBacteria[j].mySize = mySize; //set the size equal
								listOfBacteria[j].myX = myX+(int)mySize; //move new bac away to right
								myX -= (int)mySize; //move current back to left
								listOfBacteria[j].myY = myY; //equal y positions
								listOfBacteria[j].myColor = myColor; //equal colors
								hasNotFoundSpotInArray = false;
							}
							j++;
							if (j > 30){
								//could not find a spot in the array
								hasNotFoundSpotInArray = false;
							}
						}
					}
			}
		}
	}
	//Return a new Food object as a target (random).
	Food getNewTarget(){
		return listOfFood[(int)(Math.random()*listOfFood.length)];
	}
	//Eat another bacteria (should be here instead of elsewhere?)
	void merge(Bacteria partner){
		mySize += 0.6*partner.mySize;
		partner.alive = false;
	}
	//Return a speed based on size.
	int getSpeed(){
		return (mySize > 200) ? 2 : (int)(400/mySize);
	}
	//Draw the bacteria to the screen.
	void show(){
		noStroke();
		fill(myColor);
		ellipse(myX, myY, (int)mySize, (int)mySize);
	}

	//These functions all call checkCollision() to see if bac is colliding with another object.
	boolean eatBacteriaCheck(Bacteria partner){
		return checkCollision(partner.myX, partner.myY, partner.mySize);
	}
	boolean eatFoodCheck(Food food){
		return checkCollision(food.myX, food.myY, food.mySize);
	}
	boolean eatVirusCheck(Virus virus){
		return checkCollision(virus.myX, virus.myY, virus.mySize);
	}
	//Checks collision of bac + another object.
	boolean checkCollision(int objectX, int objectY, double objectSize){
		double xDif = myX - objectX;
		double yDif = myY - objectY;
		double distanceSquared = xDif * xDif + yDif * yDif;
		boolean collision = (distanceSquared < (mySize/2 + objectSize/2) * (mySize/2 + objectSize/2));
		return collision;
	}
}

class Food {
	//Food attributes.
	int myX, myY, mySize;
	boolean alive;
	Food() {
		reset();
	}
	//Shows the food (a black circle).
	void show() {
		if (alive){
			noStroke();
			fill(0);
			ellipse(myX, myY, mySize, mySize);
		}
	}
	//Resets the piece of food to a new random location and revives it.
	void reset(){
		myX = (int)(Math.random()*(canvasSize-100))+50;
		myY = (int)(Math.random()*(canvasSize-100))+50;
		mySize = 8;
		alive = true;
	}
}

class Virus {
	//Virus attributes.
	int myX, myY, mySize;
	boolean alive;
	Virus(){
		reset();
	}
	//Shows the virus (a green circle).
	void show() {
		if (alive){
			noStroke();
			fill(0, 255, 0);
			ellipse(myX, myY, mySize, mySize);
		}
	}
	//Resets the virus to a new random location and revives it.
	void reset(){
		myX = (int)(Math.random()*(canvasSize-100))+50;
		myY = (int)(Math.random()*(canvasSize-100))+50;
		mySize = 24;
		alive = true;
	}
}

//Key pressed interactions to reset stuff.
void keyPressed(){
	if (key == 'b'){
		initializeBacteria();
	}
	if (key == 'f'){
		initializeFood();
	}
	if (key == 'v'){
		initializeViruses();
	}
	if (key == 'r'){
		initializeBacteria();
		initializeFood();
		initializeViruses();
	}
}
//Mpuse pressed interactions for the biased walk to the mouse.
void mousePressed(){
	pressingMouse = true;
}
void mouseReleased(){
	pressingMouse = false;
}

//The below functions initialize the entire array of things to new ones.
void initializeBacteria(){
	for (int i = 0; i < listOfBacteria.length; i++){
	listOfBacteria[i] = new Bacteria(
		(int)(Math.random()*canvasSize),
		(int)(Math.random()*canvasSize), color(
		(int)(Math.random()*200),
		(int)(Math.random()*200),
		(int)(Math.random()*200)
		));
	}
}
void initializeFood(){
	for (int i = 0; i < listOfFood.length; i++){
		listOfFood[i] = new Food();
	}
}
void initializeViruses(){
	for (int i = 0; i < listOfViruses.length; i++){
		listOfViruses[i] = new Virus();
	}
}