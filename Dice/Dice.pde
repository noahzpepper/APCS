final int canvasSize = 800;
final int canvasSizeExtra = 20;

int diceSize = 20;
int totalRoll;
int highestRoll = 0;
int lowestRoll = 999999999;
int timesRoll = 0;
boolean autoRoll = false;

void setup()
{
	size(canvasSize,canvasSize+canvasSizeExtra);
	noLoop();
}

void draw()
{
	int counter = 0;
	totalRoll = 0;
	background(235);
	for (int j = 0; j < canvasSize; j+=diceSize){
		for (int i = 0; i < canvasSize; i+=diceSize){
			Die die = new Die(i, j, diceSize);
			die.roll();
			die.show();
			totalRoll += die.getRoll();
			counter++;
		}
	}
	if (totalRoll > highestRoll){
		highestRoll = totalRoll;
	}
	if (totalRoll < lowestRoll){
		lowestRoll = totalRoll;
	}
	timesRoll++;
	//draw text
	int textPos = canvasSize+canvasSizeExtra*3/4;
	fill(235);
	rect(0, canvasSize, canvasSize, canvasSizeExtra);
	fill(0);
	text("Stats", canvasSize/80, textPos);
	text("Total dice: " + counter, canvasSize/9.4, textPos);
	text("Total roll: " + totalRoll, canvasSize/3.4, textPos);
	text("Highest total roll: " + highestRoll, canvasSize/2.2, textPos);
	text("Lowest total roll: " + lowestRoll, canvasSize/1.5, textPos);
	text("Times rolled: " + timesRoll, canvasSize/1.14, textPos);
}

void mousePressed()
{
	redraw();
}

class Die //models one single dice cube
{
	int myX, myY, myNum, mySize;
	//variable declarations here
	Die(int x, int y, int size) //constructor
	{
		myX = x;
		myY = y;
		mySize = size;
		roll();
	}
	void roll()
	{
		myNum = (int) (Math.random()*6)+1;
	}

	int getRoll(){
		return myNum;
	}
	void show()
	{
		//draw rectangle
		fill(255);
		stroke(0);
		rect(myX, myY, mySize, mySize);

		//draw pips
		fill(0);
		int pipSize = mySize/6;
		int pipScale1 = mySize/4;
		int pipScale2 = pipScale1 * 3;
		int pipScale3 = pipScale1 * 2;
		//middle pip draws for 1, 5, and 3
		if (myNum == 1 || myNum == 5 || myNum == 3){
			ellipse(myX+pipScale3, myY+pipScale3, pipSize, pipSize);
		}
		//top left and bottom right pips-draw for all but 1
		if (myNum != 1){
			ellipse(myX+pipScale1, myY+pipScale1, pipSize, pipSize);
			ellipse(myX+pipScale2, myY+pipScale2, pipSize, pipSize);
		}
		//top right and bottom left pips - draw for 4-6
		if (myNum == 4 || myNum == 5 || myNum == 6){
			ellipse(myX+pipScale2, myY+pipScale1, pipSize, pipSize);
			ellipse(myX+pipScale1, myY+pipScale2, pipSize, pipSize);
		}
		//mid pips
		if (myNum == 6){
			ellipse(myX+pipScale1, myY+pipScale3, pipSize, pipSize);
			ellipse(myX+pipScale2, myY+pipScale3, pipSize, pipSize);
		}
	}
}

void keyPressed(){
	if (key == 'w'){
		if (diceSize < 800){
			diceSize += 10;
		}
		redraw();
	}
	if (key == 's'){
		if (diceSize > 20){
			diceSize -= 10;
		} else {

		}
		redraw();
	}
	if (key == 32){
		autoRoll = autoRoll ? false : true;
		if (autoRoll){
			loop();
		} else {
			noLoop();
		}
	}
	if (key == 'r'){

		if (!autoRoll){
			redraw();
		}
		highestRoll = 0;
		lowestRoll = 9999999;
		timesRoll = 0;

	}
}