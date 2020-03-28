public static final int canvasSize = 800;

//Set up explosion array
Explosion[] list = new Explosion[10];
int index = 0; //Will be used to keep track of current explosion array slot to use

boolean nextExpolosionHover = false; //Set up bool for hover variable

void setup() {
	//Init slots in array with default values
	for (int i = 0; i < list.length; i++){
		list[i] = new Explosion(canvasSize/2, canvasSize/2, 0, false, false);
	}
	//Set 10th explosion to start initially
	list[9] = new Explosion(canvasSize/2, canvasSize/2, 0, true, false);
	list[9].exploded = true;
	size(canvasSize, canvasSize);
}

void draw() {
	//Continuously loop through the explosion list and tell each explosion to go()
	background(0);
	for (int i = 0; i < list.length; i++){
		list[i].go();
	}
}

//The explosion class. Has a particle array of 500, and attributes to pass down to the particles.
class Explosion {
	Particle[] exList = new Particle[500];
	boolean exploded = false;
	//Constructor
	Explosion(double x, double y, double rotation, boolean generate, boolean hoverListen){
		for (int i = 0; i < exList.length; i++){
			exList[i] = new NormalParticle(x, y, rotation, generate, hoverListen);
		}
		exList[0] = new OddballParticle(x, y);
		exList[1] = new JumboParticle(x, y, rotation, generate, hoverListen);
	}
	//If explosion is alive, tell the particles to move(), show(), and listenForHover()
	void go(){
		if (exploded){
			for (int i = 0; i < exList.length; i++){
				exList[i].move();
				exList[i].show();
				exList[i].listenForHover();
			}
		}
	}
}

//A normal particle class.
class NormalParticle implements Particle {
	//Declare all the variables
	double myX, myY, mySpeed, myAngle, mySize, myRotation;
	int myColor;
	double myPermanentAngle, myPermanentX, myPermanentY;
	boolean myGeneration, myHoverListen;
	//No arg constructor for Jumbo
	NormalParticle(){
		this((double)canvasSize/2, (double)canvasSize/2, 0, false, false);
	}
	//Default constructor takes x, y, rotate, generate, and hoverListen
	NormalParticle(double x, double y, double rotate, boolean generate, boolean hoverListen){
		//Set permanent X and Y to in case it will generate
		myPermanentX = x;
		myPermanentY = y;
		myX = myPermanentX;
		myY = myPermanentY;
		//Random color.
		myColor = color(
			(int)(Math.random()*255),
			(int)(Math.random()*255),
			(int)(Math.random()*255)
			);
		//Set speed, angle, size
		mySpeed = Math.random()*2;
		myAngle = Math.random() * 2 * Math.PI;
		myPermanentAngle = myAngle;
		mySize = 10;
		//Set attribute variables from constructor
		myRotation = rotate;
		myGeneration = generate;
		myHoverListen = hoverListen;
	}
	public void move(){
		//Move based on speed and angle
		myX += mySpeed * Math.cos(myAngle);
		myY += mySpeed * Math.sin(myAngle);

		myAngle += myRotation; //makes it rotate

		//Constantly generate new dots if myGeneration == true
		if ((myX > canvasSize || myX < 0 || myY > canvasSize || myY < 0) && myGeneration){
			myX = myPermanentX;
			myY = myPermanentY;
			mySpeed = Math.random()*2;
			myAngle = Math.random() * 2 * Math.PI;
			mySize = 10;
		}
	}
	public void show(){
		//Draw a circle of color myColor at myX, myY with size mySize, with no stroke.
		noStroke();
		fill(myColor);
		ellipse((float)myX, (float)myY, (float)mySize, (float)mySize);
	}
	//Increase speed when mouse touches particle.
	public void listenForHover(){
		if (mouseX > myX - mySize/2 && mouseX < myX + mySize/2
			&& mouseY > myY - mySize/2 && mouseY < myY + mySize/2
			&& myHoverListen){
			mySpeed++;
		}
	}
}

//Particle interface. All particles can move, show, and listenForHover.
interface Particle {
	public void move();
	public void show();
	public void listenForHover();
}

//Uses interface.
class OddballParticle implements Particle {
	//Declare variables
	double myX, myY, mySpeed;
	double myAngle;
	int myColor;
	//Constructor
	OddballParticle(double x, double y){
		myX = x;
		myY = y;
		myColor = color(255);
		mySpeed = 10;
		myAngle = Math.random() * 2 * Math.PI;
	}
	//move with random walk
	public void move(){
		myX += mySpeed * (Math.random()-0.5);
		myY += mySpeed * (Math.random()-0.5);
	}
	//Draw a circle of color myColor at myX, myY with size 24, with no stroke.
	public void show(){
		noStroke();
		fill(myColor);
		ellipse((float)myX, (float)myY, 24, 24);
	}
	//Oddball doesn't do anything on hover, but has listenForHover() to implement interface.
	public void listenForHover(){}
}

//Uses inheritance.
class JumboParticle extends NormalParticle {
	JumboParticle(double x, double y, double rotate, boolean generate, boolean hoverListen){
		//Implicit call to NormalParticle()
		mySpeed = 1; //set fixed speed
		myX = x;
		myY = y;
		mySize = 42; //set fixed size
		myRotation = rotate;
		myGeneration = generate;
		myHoverListen = hoverListen;
	}
}

//Loop through all explosions and set them to not explode.
void reset(){
	for (int i = 0; i < list.length; i++){
		list[i].exploded = false;
	}
}

//Key pressed functions.
void keyPressed(){
	//When r pressed, reset.
	if (key == 'r'){
		reset();
	}
	//When h key press, toggle nextExplosionHover.
	if (key == 'h'){
		nextExpolosionHover = !nextExpolosionHover;
	}
	//When number keys pressed, set up my favorite patterns
	if (key == '1'){
		reset();
		list[0] = new Explosion(mouseX, mouseY, 0.03, false, true);
		list[1] = new Explosion(mouseX, mouseY, -0.03, false, true);
		list[0].exploded = true;
		list[1].exploded = true;
		index = 2;
		
	}
}

//Mouse pressed function.
void mousePressed(){
	//Properties
	double rotateNum = 0;
	boolean generate = false;
	boolean hover = false;
	//Set the properties for the explosion based on keypress
	if (keyPressed){
		switch (key){
			case 'a':
				rotateNum = 0.03;
				break;
			case 's':
				rotateNum = -0.03;
				break;
			case 'g':
				generate = true;
				break;
			default:
				//default does nothing
		}
	}
	//Creates a new explosion occupying the next slot.
	list[index] = new Explosion(mouseX, mouseY, rotateNum, generate, nextExpolosionHover);
	//Tell it to explode.
	list[index].exploded = true;
	//Prepare to fill the next slot in the array.
	index++;
	if (index >= list.length){
		index = 0;
	}
	//Set next hover to false regardless of what it is.
	nextExpolosionHover = false;
}