//Size of one side of the screen
final int canvasSize = 400;

//Direction of lightning. 0 is right, 90 is down, 180 is left, 270 is up.
int userDirection = 0;

//Lightning to control
myLightning light1 = new myLightning();
myLightning light2, light3, light4;

//An individual bolt.
class myBolt {
	int startX, startY, endX, endY, direction;
	myBolt (int x, int y, int dir) {
		startX = x;
		startY = y;
		direction = dir;
	}
	void draw(){
		stroke(randomColor());
		//while function checks whether to draw based on bolt direction
		while((startX < canvasSize && direction == 0) 
			|| (startX > 0 && direction == 180)
			|| (startY < canvasSize && direction == 90) 
			|| (startY > 0 && direction == 270)){
			//generate random numbers
			int randomForward =  (int)(Math.random()*10);
			int randomVariation = (int)((Math.random()*20)-10);
			//set endX and endY
			endX = startX;
			endY = startY;
			//add based on direction
			switch(direction){
				case 0:
					endX += randomForward;
					endY += randomVariation;
					break;
				case 90:
					endX += randomVariation;
					endY += randomForward;
					break;
				case 180:
					endX -= randomForward;
					endY += randomVariation;
					break;
				case 270:
					endX += randomVariation;
					endY -= randomForward;
					break;
				default:
					//do nothing
			}
			//draw the line
			line(startX, startY, endX, endY);
			//set start points to end points
			startX = endX;
			startY = endY;
		}
	}
	void reset(){
		startX = 0;
		startY = 200;
		endX = 0;
		endY = 0;
	}
}

//A collection of bolts.
class myLightning {

	int startX, startY, boltsToDraw, direction;

	myLightning (int x, int y, int numBolts, int dir) {
		startX = x;
		startY = y;
		boltsToDraw = numBolts;
		direction = dir;
	}
	myLightning(){
		startX = 0;
		startY = canvasSize/2;
	}
	void draw(){
		if (boltsToDraw > 0){
			boltsToDraw--;
			myBolt bolt = new myBolt(startX, startY, direction);
			bolt.draw();
			bolt.reset();
		}
	}
}

void setup()
{
	size(canvasSize, canvasSize);
	strokeWeight(3);
	background(235);
}

void draw()
{
	light1.draw();
	if (light2 != null){
		light2.draw();
		light3.draw();
		light4.draw();
	}
}

//Return random color.
color randomColor(){
	return color(
		(int)(Math.random()*255),
		(int)(Math.random()*255),
		(int)(Math.random()*255)
		);
}

//interactions
void mousePressed(){
	light1 = new myLightning(mouseX, mouseY, 20, userDirection);
}
void keyPressed(){
	if (key == 'r'){
		background(235); //resets to blank background
	}
	//arrow key presses
	if (keyCode == RIGHT){
		userDirection = 0;
	} else if (keyCode == LEFT){
		userDirection = 180;
	} else if (keyCode == UP){
		userDirection = 270;
	} else if (keyCode == DOWN){
		userDirection = 90;
	}
	if (key == 32){ //spacebar
		light1 = new myLightning(mouseX, mouseY, 5, 0);
		light2 = new myLightning(mouseX, mouseY, 5, 90);
		light3 = new myLightning(mouseX, mouseY, 5, 180);
		light4 = new myLightning(mouseX, mouseY, 5, 270);
	}
}