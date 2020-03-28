public static final int canvasSize = 600;
public static final int snowflakeArraySize = 150;

Snowflake[] snowflakeArray = new Snowflake[snowflakeArraySize];

int aPointX = -300;
int aPointY = -300;
boolean showHintLine = false;
int prevMouseX, prevMouseY;

void setup() {
	for (int i = 0; i < snowflakeArray.length; i++){
		snowflakeArray[i] = new Snowflake();
	}
	background(0);
	noStroke();
	size(canvasSize, canvasSize);
}
void draw() {
	//your code here
	for (int i = 0; i < snowflakeArray.length; i++){
		Snowflake s = snowflakeArray[i];
		s.erase();
		s.move();
		s.wrap();
		s.lookDown();
		s.show();
	}
	if (showHintLine){
		strokeWeight(8);
		stroke(0);
		line(aPointX, aPointY, prevMouseX, prevMouseY); //erase old line
		strokeWeight(7);
		stroke(255, 0, 0, 99.9);
		line(aPointX, aPointY, mouseX, mouseY); //draw new line
		noStroke();
	}
	prevMouseX = mouseX;
	prevMouseY = mouseY;
}
void mouseDragged() {
	fill(0, 255, 0);
	ellipse(mouseX, mouseY, 8, 8);
}

class Snowflake {
	int myX, myY;
	boolean isMoving;

	Snowflake() {
		myX = (int)(Math.random()*canvasSize);
		myY = (int)(Math.random()*canvasSize);
		isMoving = true;
	}

	void show() {
		fill(255);
		ellipse(myX, myY, 5, 5);
	}

	void lookDown() {
		if (
			(get(myX, myY+7) == color(0, 255, 0) 
				|| get(myX-7, myY) == color(0, 255, 0) 
				|| get(myX+7, myY) == color(0, 255, 0)
				) && 
			myY > 0 && 
			myY < canvasSize
			){
			isMoving = false;
		} else {
			isMoving = true;
		}
	}

	void erase() {
		fill(0);
		ellipse(myX, myY, 7, 7);
	}

	void move() {
		if (isMoving){
			myY++;
		}
	}

	void wrap() {
		if (myY >= canvasSize-7){
			myY = 0;
			myX = (int)(Math.random()*canvasSize);
		}
	}

}

void keyPressed(){
	if (key == 'r'){
		background(0);
	}
	if (key == 'e'){
		stroke(0, 255, 0);
		strokeWeight(8);
		line(0, canvasSize, canvasSize, 0);
		noStroke();
	}
	if (key == 'q'){
		if (aPointX > 0){
			strokeWeight(8);
			stroke(0);
			line(aPointX, aPointY, mouseX, mouseY);
			showHintLine = false;
			noStroke();
			aPointX = -300;
			aPointY = -300;
		} else {
			showHintLine = true;
			fill(0);
			ellipse(aPointX, aPointY, 8, 8);
			aPointX = mouseX;
			aPointY = mouseY;
			fill(255, 0, 0, 99.9);
			ellipse(aPointX, aPointY, 8, 8);
			fill(0);
		}
	}
	if (key == 'w'){
		if (aPointX > 0){
			showHintLine = false;
			stroke(0, 255, 0);
			strokeWeight(8);
			line(aPointX, aPointY, mouseX, mouseY);
			aPointX = -300;
			aPointY = -300;
			noStroke();
		}
	}
}

void mousePressed(){
	if (aPointX > 0){
		showHintLine = false;
		stroke(0);
		strokeWeight(8);
		line(aPointX, aPointY, prevMouseX, prevMouseY);
		aPointX = -300;
		aPointY = -300;
		noStroke();
	}
}