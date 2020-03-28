//Constants
public static final int canvasSize = 600; //warning: decreasing below 600 will affect control panel
public static final int MAX_SPEED = 5;
public static final int TOTAL_ASTEROIDS = 8; //default is 8 asteroids
public static final int SHIP_HITBOX = 32;
public static final int BULLET_HITBOX = 8;
public static final int BULLET_DELAY = 4;
public static final float LEVEL_INCREMENT = 0.2;

//Declare the ship
SpaceShip ship;
//Declare and initialize the arrays
Star[] starArray = new Star[(int)(Math.random()*60)+40];
ArrayList<Asteroid> asteroidArray = new ArrayList<Asteroid>();
ArrayList<Bullet> bulletArray = new ArrayList<Bullet>();

float level = 1;
double score = 0;
int highScore = -1;

//stuff for controls
boolean left, right, up, hyperspace;
boolean fire = false;
int hyperspaceTimer = 0;
int bulletTimer = 0;
boolean showControlPanel = true;
String doneButtonText = "Start";
String displayScoreText = "";

//debug
boolean showHitbox = false;

//Flash screen variable
int flashScreen = 0;
//controlNum: wasd, arrows, mouse
int controlNum = 0;
String[][] controlsArray = new String[][]{
	new String[]{"W","A","D","Space","F"},
	new String[]{"Up","Left","Right","Control","Shift"},
	new String[]{"Right click","Mouse","Mouse","Left click","Space"},
};
//Declare panel elements
PanelElement mainPanel, switchControlButton, doneButton;

public void setup(){
	ship = new SpaceShip();
	for (int i = 0; i < starArray.length; i++){
		starArray[i] = new Star();
	}
	for (int i = 0; i < TOTAL_ASTEROIDS; i++){
		asteroidArray.add(new Asteroid());
	}
	size(canvasSize, canvasSize);
}

public void draw(){
	background(flashScreen);
	if (flashScreen > 0 && !showControlPanel) flashScreen -= 1; //flashScreen only changes when not paused
	//Show all the stars
	for (int i = 0; i < starArray.length; i++){
		starArray[i].show();
	}
	//Show and move the bullets
	for (int i = 0; i < bulletArray.size(); i++){
		if (bulletArray.get(i).getIsFired()){
			if (!showControlPanel) bulletArray.get(i).move();
			bulletArray.get(i).show();
		}
	}
	//Show all the asteroids (when playing or paused)
	//pretty messy code
	for (int i = 0; i < asteroidArray.size(); i++){
		Asteroid asteroidTemp = asteroidArray.get(i);
		if (!showControlPanel) asteroidTemp.move();
		if (doneButtonText == "Resume"){
			asteroidTemp.setVisibility(true);
		}
		asteroidTemp.show();
		if (asteroidTemp.getVisibility() && showHitbox){
			stroke(255, 0, 0);
			noFill();
			rect(asteroidTemp.getX()-(asteroidTemp.getHitbox()/2), asteroidTemp.getY()-(asteroidTemp.getHitbox()/2), asteroidTemp.getHitbox(), asteroidTemp.getHitbox());
			rect(ship.getX()-(SHIP_HITBOX/2), ship.getY()-(SHIP_HITBOX/2), SHIP_HITBOX, SHIP_HITBOX);
		}
		if (dist(asteroidTemp.getX(), asteroidTemp.getY(), ship.getX(), ship.getY()) < asteroidTemp.getHitbox()/2+SHIP_HITBOX/2){
			shipAsteroidCollision();
		}
		for (int j = 0; j < bulletArray.size(); j++){
			if (showHitbox){
				stroke(255, 0, 0);
				noFill();
				rect(bulletArray.get(j).getX()-(BULLET_HITBOX/2), bulletArray.get(j).getY()-(BULLET_HITBOX/2), BULLET_HITBOX, BULLET_HITBOX);
			}
			if (dist(asteroidTemp.getX(), asteroidTemp.getY(), bulletArray.get(j).getX(), bulletArray.get(j).getY()) < BULLET_HITBOX/2 + asteroidTemp.getHitbox()/2){
				bulletArray.remove(j);
				if (asteroidTemp.getSize() > 1){
					Asteroid child1 = new Asteroid();
					child1.setSize(asteroidTemp.getSize()-1);
					child1.setX(asteroidTemp.getX());
					child1.setY(asteroidTemp.getY());
					Asteroid child2 = new Asteroid();
					child2.setSize(asteroidTemp.getSize()-1);
					child2.setX(asteroidTemp.getX());
					child2.setY(asteroidTemp.getY());
					asteroidArray.add(child1);
					asteroidArray.add(child2);
				}
				score += asteroidTemp.getSize();
				asteroidArray.remove(i);
			}
		}
	}
	//If paused, show the ship and control panel, else run the game
	if (showControlPanel){
		ship.show();
		drawControlPanel();
	} else {
		if (doneButtonText == "Start" || doneButtonText == "Restart"){
			flashScreen = 255;
			doneButtonText = "Resume";
			score = 0;
		}
		doAction(); //actions based on keyboard presses
		//Hyperspace increases when held down and no flashScreen
		if (hyperspace && flashScreen <= 0){
			hyperspaceTimer++;
		} else {
			hyperspaceTimer = 0;
		}
		//Draw the hyperspace ellipse
		if (hyperspaceTimer > 1 && hyperspaceTimer <= 60){
			fill(0, 0, 0, 0);
			stroke(255);
			ellipse(ship.getX(), ship.getY(), 2*(60-hyperspaceTimer), 2*(60-hyperspaceTimer));
		} else if (hyperspaceTimer > 60){
			doHyperspace();
		}
		//Move and draw the ship
		ship.move();
		ship.show();
		//Rotation for mouse control runs in draw function
		if (controlNum == 2 && (mouseX-ship.getX() != 0)){
			//dont want a division by 0 error
			ship.setPointDirection((int)(
				(180/PI)*(Math.atan2((mouseY-ship.getY()), (mouseX-ship.getX())))
			));
		}
		if (asteroidArray.size() <= 0){
			level += LEVEL_INCREMENT;
			for (int i = 0; i < TOTAL_ASTEROIDS; i++){
				asteroidArray.add(new Asteroid());
			}
		}
	}
}

public void shipAsteroidCollision(){ //reset function
	showControlPanel = true;
	doneButtonText = "Restart";
	ship.setDirectionX(0);
	ship.setDirectionY(0);
	ship.setPointDirection((int)(Math.random() * 360));
	ship.setX(canvasSize/2);
	ship.setY(canvasSize/2);
	int totalAsteroidsInArray = asteroidArray.size();
	for (int i = 0; i < totalAsteroidsInArray; i++){
		asteroidArray.remove(0);
	}
	for (int i = 0; i < TOTAL_ASTEROIDS; i++){
		asteroidArray.add(new Asteroid());
	}
	int totalBulletsInArray = bulletArray.size();
	for (int i = 0; i < totalBulletsInArray; i++){
		bulletArray.remove(0);
	}
	hyperspaceTimer = 0;
	flashScreen = 0;
	//finalize score
	score *= level;
	if (score > highScore){
		highScore = (int) score;
		displayScoreText = "New high score! Score last game: " + (int) score;
	} else {
		displayScoreText = "Score last game: " + (int) score + " (current high score: " + highScore + ")";
	}
}

//Just a bunch of code to draw all the rects and texts for the control panel.
public void drawControlPanel(){
	mainPanel = new PanelElement(100, 100, 400, 400);
	switchControlButton = new PanelElement(100+400-1.2*66.6+10, 100+110, 0.5*66.6, 170);
	doneButton = new PanelElement(100+150, 100+328, 100, 30);
	mainPanel.show();
	switchControlButton.show();
	doneButton.show();
	fill(255);
	textAlign(CENTER);
	if (doneButtonText == "Resume"){
		textSize(12);
		makeTextAtIntegerCoordinates("Warning: Game resumes immediately.", 100+200, 100+350+35);
	}
	if (doneButtonText == "Restart"){
		textSize(12);
		makeTextAtIntegerCoordinates(displayScoreText, 100+200, 100+350+35);
	}
	textSize(18);
	makeTextAtIntegerCoordinates("Control Panel", 300, 150);
	makeTextAtIntegerCoordinates(doneButtonText, 100+200, 100+350);
	textAlign(LEFT);
	makeTextAtIntegerCoordinates("Accelerate", 100+66.6, 100+120);
	makeTextAtIntegerCoordinates(controlsArray[controlNum][0], 100+400-(2.8)*66.6, 100+120);
	makeTextAtIntegerCoordinates("Left rotate", 100+66.6, 100+160);
	makeTextAtIntegerCoordinates(controlsArray[controlNum][1], 100+400-(2.8)*66.6, 100+160);
	makeTextAtIntegerCoordinates("Right rotate",100+66.6, 100+200);
	makeTextAtIntegerCoordinates(controlsArray[controlNum][2], 100+400-(2.8)*66.6, 100+200);
	makeTextAtIntegerCoordinates("Fire", 100+66.6, 100+240);
	makeTextAtIntegerCoordinates(controlsArray[controlNum][3], 100+400-(2.8)*66.6, 100+240);
	makeTextAtIntegerCoordinates("Hyperspace", 100+66.6, 100+280);
	makeTextAtIntegerCoordinates(controlsArray[controlNum][4], 100+400-(2.8)*66.6, 100+280);
	makeLineAtIntegerCoordinates(100+400-1.2*66.6+12+0.125*66.6, 100+120, 100+400-1.2*66.6+8+0.125*66.6+0.25*66.6, 100+110+85);
	makeLineAtIntegerCoordinates(100+400-1.2*66.6+12+0.125*66.6, 100+110+170-10, 100+400-1.2*66.6+8+0.125*66.6+0.25*66.6, 100+110+85);
}
public void makeTextAtIntegerCoordinates(String displayText, float x, float y){
	text(displayText, (int)x, (int)y);
}
public void makeLineAtIntegerCoordinates(double x1, double y1, double x2, double y2){
	line((int)x1, (int)y1, (int)x2, (int)y2);
}
class PanelElement {
	float myX, myY, myWidth, myHeight;
	PanelElement(float x, float y, float tWidth, float tHeight){
		myX = x;
		myY = y;
		myWidth = tWidth;
		myHeight = tHeight;
	}
	public int getX(){return (int)myX;}
	public int getY(){return (int)myY;}
	public int getWidth(){return (int)myWidth;}
	public int getHeight(){return (int)myHeight;}
	public void show(){
		stroke(255);
		fill(0);
		rect((int)myX, (int)myY, (int)myWidth, (int)myHeight);
	}
}

//Star class.
class Star {
	private int myX, myY;
	public Star(){
		myX = (int)(Math.random() * canvasSize);
		myY = (int)(Math.random() * canvasSize);
	}
	private void show(){
		fill(255);
		stroke(255);
		ellipse(myX, myY, 3, 3);
	}
}

//Spaceship class. Has a max speed in move() and a getSpeed() function to calculate its current speed.
class SpaceShip extends Floater {
	public SpaceShip(){
		corners = 4;
		int[] xS = {-8, 16, -8, -2};
		int[] yS = {-8, 0, 8, 0};
		xCorners = xS;
		yCorners = yS;
		myColor = color(255);
		myCenterX = myCenterY = canvasSize/2;
		myDirectionX = myDirectionY = 0;
		myPointDirection = 0;
	}
	public void setX(int x){myCenterX = x;}
	public int getX(){return (int)myCenterX;}
	public void setY(int y){myCenterY = y;}
	public int getY(){return (int)myCenterY;}
	public void setDirectionX(double x){myDirectionX = x;}
	public double getDirectionX(){return myDirectionX;}
	public void setDirectionY(double y){myDirectionY = y;}
	public double getDirectionY(){return myDirectionY;}
	public void setPointDirection(int degrees){myPointDirection = degrees;}
	public double getPointDirection(){return myPointDirection;}

	public void move(){ //move the floater in the current direction of travel
		super.move();
		//max speed
		if (getSpeed() > MAX_SPEED){
			myDirectionX *= 0.9;
			myDirectionY *= 0.9;
		}
	}

	public float getSpeed(){
		float xChangeOverTime = (float)(ship.getDirectionX()*ship.getDirectionX());
		float yChangeOverTime = (float)(ship.getDirectionY()*ship.getDirectionY());
		return (sqrt(xChangeOverTime + yChangeOverTime));
	}
}

//Asteroid class.
class Asteroid extends Floater {
	private int rotation;
	private int mySize;
	private int myHitbox;
	private boolean myVisibility;
	public Asteroid(){
		reset();
	}
	public void setX(int x){myCenterX = x;}
	public int getX(){return (int)myCenterX;}
	public void setY(int y){myCenterY = y;}
	public int getY(){return (int)myCenterY;}
	public void setDirectionX(double x){myDirectionX = x;}
	public double getDirectionX(){return myDirectionX;}
	public void setDirectionY(double y){myDirectionY = y;}
	public double getDirectionY(){return myDirectionY;}
	public void setPointDirection(int degrees){myPointDirection = degrees;}
	public double getPointDirection(){return myPointDirection;}
	public void setVisibility(boolean visibility){myVisibility = visibility;}
	public boolean getVisibility(){return myVisibility;}
	public int getSize(){return mySize;}
	public void setSize(int size){mySize = size; setXYCoords(); setHitbox();}
	public int getHitbox(){return myHitbox;}
	private void setHitbox(){
		if (mySize == 3){
			myHitbox = 32;
		} else if (mySize == 2){
			myHitbox = 21;
		} else if (mySize == 1){
			myHitbox = 9;
		}
	}
	public void move(){
		super.move();
		rotate(rotation);
	}
	public void show(){
		if(myVisibility){
			super.show();
		}
	}
	private void setXYCoords(){
		int [][][] asteroidList = { //list of asteroid coords (asteroids have type int[][], coords are int[])
			{{-8, 0, 7, 9, 4, -6, -10} , {-8, -7, -8, 0, 7, 7, 0}},
			{{0, 6, 8, 7, 8, 5, 0, -4, -8, -6} , {-8, -7, -5, -3, 0, 5, 6, 4, -2, -6}},
			{{0, 4, 8, 7, 8, 1, -4, -8, -9, -7}, {-6, -7, -5, 0, 6, 8, 6, 3, -4, -7}},
			{{0, 7, 8, 6, -2, -5, -7, -6, -5, -3}, {-7, -9, -1, 6, 4, 4, 0, -2, -5, -5}},
			{{-4, 5, 8, 6, 1, -7, -10}, {-4, -6, -1, 6, 9, 5, -1}}
		};
		//Pick which asteroid it is from the list.
		int asteroidNum = (int)(Math.random()*(asteroidList.length));
		int[][] selectedAsteroid = asteroidList[asteroidNum];
		// Modify the asteroidList based on mySize.
		for (int i = 0; i < selectedAsteroid.length; i++){
			for (int k = 0; k < selectedAsteroid[i].length; k++){
				selectedAsteroid[i][k] *= mySize;
			}
		}
		//Finally set xCorners and yCorners to selectedAsteroid values. 
		xCorners = selectedAsteroid[0];
		yCorners = selectedAsteroid[1];
		corners = xCorners.length;
	}
	public void reset(){
		mySize = 3;
		myVisibility = false;
		setXYCoords(); //Set x and y coords using mySize
		myColor = color(255);
		if (Math.random() < 0.5){
			myCenterX = (int)(Math.random()*canvasSize);
			myCenterY = (Math.random() < 0.5) ? 0 : canvasSize;
		} else {
			myCenterX = (Math.random() < 0.5) ? 0 : canvasSize;
			myCenterY = (int)(Math.random()*canvasSize);
		}
		myDirectionX = myDirectionY = 0;
		myPointDirection = (int)(Math.random()*360);
		rotation = (int)(Math.random() * 3)+1;
		if (Math.random() < 0.5) rotation *= -1;
		accelerate((Math.random()*(3-mySize))+(Math.random()*0.5)+level*1.2); //acceleration based on size
		setHitbox();
	}
}

//Bullet class.
class Bullet extends Floater {
	private boolean myIsFired;
	public Bullet(SpaceShip theShip){
		myCenterX = theShip.getX();
		myCenterY = theShip.getY();
		myPointDirection = theShip.getPointDirection() + (Math.random() * 8) - 4;
		double dRadians = myPointDirection*(Math.PI/180);
		myDirectionX = Math.cos(dRadians) + theShip.getDirectionX();
		myDirectionY = Math.sin(dRadians) + theShip.getDirectionY();
		myIsFired = false;
		accelerate(4);
	}
	public void setX(int x){myCenterX = x;}
	public int getX(){return (int)myCenterX;}
	public void setY(int y){myCenterY = y;}
	public int getY(){return (int)myCenterY;}
	public void setDirectionX(double x){myDirectionX = x;}
	public double getDirectionX(){return myDirectionX;}
	public void setDirectionY(double y){myDirectionY = y;}
	public double getDirectionY(){return myDirectionY;}
	public void setPointDirection(int degrees){myPointDirection = degrees;}
	public double getPointDirection(){return myPointDirection;}
	public void setIsFired(boolean isFired){myIsFired = isFired;}
	public boolean getIsFired(){return myIsFired;}
	public void move(){
		myCenterX += myDirectionX;
		myCenterY += myDirectionY;
	}
	public void show(){
		fill(255, flashScreen, flashScreen);
		stroke(255, flashScreen, flashScreen);
		ellipse((float)myCenterX, (float)myCenterY, 5, 5);
	}
}

//All the keyPressed and mousePressed functions that set the control booleans to true and false.
public void keyPressed(){
	if (key == 'p' || key == 'P'){
		showControlPanel = !showControlPanel;
	}
	if ((controlNum == 0 && (key == 'w' || key == 'W')) || (controlNum == 1 && keyCode == UP)){
		up = true;
	} else if ((controlNum == 0 && (key == 'a' || key == 'A')) || (controlNum == 1 && keyCode == LEFT)){
		left = true;
	} else if ((controlNum == 0 && (key == 'd' || key == 'D')) || (controlNum == 1 && keyCode == RIGHT)){
		right = true;
	} else if ((controlNum == 0 && (key == 'f' || key == 'F')) || (controlNum == 1 && keyCode == SHIFT)){
		hyperspace = true;
	} else if (controlNum == 2 && key == ' '){
		hyperspace = true;
	} else if ((controlNum == 0 && key == ' ') || controlNum == 1 && keyCode == CONTROL){
		fire = true;
	}
}
public void keyReleased(){
	if ((controlNum == 0 && (key == 'w' || key == 'W')) || (controlNum == 1 && keyCode == UP)){
		up = false;
	} else if ((controlNum == 0 && (key == 'a' || key == 'A')) || (controlNum == 1 && keyCode == LEFT)){
		left = false;
	} else if ((controlNum == 0 && (key == 'd' || key == 'D')) || (controlNum == 1 && keyCode == RIGHT)){
		right = false;
	} else if ((controlNum == 0 && (key == 'f' || key == 'F')) || (controlNum == 1 && keyCode == SHIFT)){
		hyperspace = false;
	} else if (controlNum == 2 && key == ' '){
		hyperspace = false;
	} else if ((controlNum == 0 && key == ' ') || controlNum == 1 && keyCode == CONTROL){
		fire = false;
	}
	if (key == '\\'){
		showHitbox = !showHitbox;		
	}
}
public void mousePressed(){
	if (showControlPanel){
		if (mouseX > doneButton.getX() && mouseX < doneButton.getX() + doneButton.getWidth() 
		&& mouseY > doneButton.getY() && mouseY < doneButton.getY() + doneButton.getHeight()){
			showControlPanel = false;
		} else if (mouseX > switchControlButton.getX() && mouseX < switchControlButton.getX() + switchControlButton.getWidth() 
		&& mouseY > switchControlButton.getY() && mouseY < switchControlButton.getY() + switchControlButton.getHeight()){
			controlNum++;
			if (controlNum >= 3){controlNum = 0;}
		}
	} else if (controlNum == 2) {
		if (mouseButton == RIGHT){
			up = true;
		} else if (mouseButton == LEFT){
			fire = true;
		}
	}
}
public void mouseReleased(){
	if (controlNum == 2){
		if (mouseButton == RIGHT){
			up = false;
		} else if (mouseButton == LEFT){
			fire = false;
		}
	}
}

//Action done in draw() based on user input.
public void doAction(){
	if (up){
		ship.accelerate(0.069);
	}
	if (left){
		ship.rotate(-5);
	}
	if (right){
		ship.rotate(5);
	}
	if (fire){
		if (bulletTimer <= 0){
			Bullet newBullet = new Bullet(ship);
			newBullet.setIsFired(true);
			bulletArray.add(newBullet);
			bulletTimer = BULLET_DELAY;
		} else {
			bulletTimer--;
		}
	} else {
		bulletTimer = BULLET_DELAY;
	}
}

//Hyperspace function.
public void doHyperspace(){
	flashScreen = 255;
	ship.setDirectionX(0);
	ship.setDirectionY(0);
	ship.setX((int)(Math.random() * canvasSize));
	ship.setY((int)(Math.random() * canvasSize));
	ship.setPointDirection((int)(Math.random() * 360));
	hyperspaceTimer = 0;
	hyperspace = false;
}

//Abstract floater class.
abstract class Floater { //Do NOT modify the Floater class! Make changes in the SpaceShip class 
	protected int corners;//the number of corners, a triangular floater has 3
	protected int[] xCorners;
	protected int[] yCorners;
	protected int myColor;
	protected double myCenterX, myCenterY; //holds center coordinates
	protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel
	protected double myPointDirection; //holds current direction the ship is pointing in degrees
	abstract public void setX(int x);
	abstract public int getX();
	abstract public void setY(int y);
	abstract public int getY();
	abstract public void setDirectionX(double x);
	abstract public double getDirectionX();
	abstract public void setDirectionY(double y);
	abstract public double getDirectionY();
	abstract public void setPointDirection(int degrees);
	abstract public double getPointDirection();

	//Accelerates the floater in the direction it is pointing (myPointDirection)
	public void accelerate (double dAmount){
		//convert the current direction the floater is pointing to radians    
		double dRadians =myPointDirection*(Math.PI/180);
		//change coordinates of direction of travel    
		myDirectionX += ((dAmount) * Math.cos(dRadians));
		myDirectionY += ((dAmount) * Math.sin(dRadians));
	}

	public void rotate (int nDegreesOfRotation){
		//rotates the floater by a given number of degrees    
		myPointDirection+=nDegreesOfRotation;
	}

	public void move(){ //move the floater in the current direction of travel      
		//change the x and y coordinates by myDirectionX and myDirectionY       
		myCenterX += myDirectionX;
		myCenterY += myDirectionY;

		//wrap around screen    
		if(myCenterX >width){
			myCenterX = 0;
		} else if (myCenterX<0){
			myCenterX = width;
		}
		if(myCenterY >height){
			myCenterY = 0;
		} else if (myCenterY < 0){
			myCenterY = height;
		}
	}

	public void show(){ //Draws the floater at the current position  
		fill(myColor);
		stroke(myColor);
		//convert degrees to radians for sin and cos
		double dRadians = myPointDirection*(Math.PI/180);
		int xRotatedTranslated, yRotatedTranslated;
		beginShape();
		for(int nI = 0; nI < corners; nI++){
			//rotate and translate the coordinates of the floater using current direction 
			xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
			yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
			vertex(xRotatedTranslated,yRotatedTranslated);    
		}
		endShape(CLOSE);
	}
}
