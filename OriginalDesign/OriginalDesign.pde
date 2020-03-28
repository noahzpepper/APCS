//constants for the squares
final int minSquareSize = 50;
final int maxSquareSize = 200;

//variables for the squares
int squareSize = minSquareSize; //squareSize represents size of square drawn at runtime
int sizeIncrease = 1; //amount by which the square increases every time draw function runs
boolean randomColor = false;

//smiley face size
float smileySize = 60;

void setup()
{
	size(400, 400);
}

void draw()
{
	//light background
	background(235);

	//code for the increasing size of squares
	//square size is size of the square to be drawn
	//confusing but it works
	for (int j = 0; j < 800/squareSize; j++){
		for (int i = 0; i < 800/squareSize; i++){
			//for each square determine fill
			if (randomColor){
				fill(createRandomColor());
			} else {
				fill(235);
			}
			rect(i*squareSize, j*squareSize, squareSize, squareSize); //draws the increasing square
			for (int k = 0; k < squareSize; k+=minSquareSize){ //this loop draws the lines inside the square
				line(i*squareSize+k, j*squareSize, i*squareSize+k, j*squareSize+k+squareSize);
				line(i*squareSize, j*squareSize+k, i*squareSize+k+squareSize, j*squareSize+k);
		  	}
		}
	}
	//check current squareSize and adjust accordingly
	if (squareSize >= maxSquareSize){
		squareSize = minSquareSize;
	} else if (squareSize <= minSquareSize) {
		sizeIncrease = 1;
	}

	squareSize += sizeIncrease;

	//draws the smiley face
	//last parameter is depth, how many smileys to draw inside of each other
	makeSmileyFace(mouseX, mouseY, smileySize, 3);

	//draw the text at the bottom
	fill(0);
	textSize(14);
	textAlign(RIGHT);
	text("Speed: " + sizeIncrease, 390, 370);
	int smileySizeInt = (int) smileySize;
	text("Cursor size: " + smileySizeInt, 390, 390);

}

//Draws a yellow smiley face with eyes and a mouth.
//x and y are the center of the smiley face to be drawn.
//size is the size.
//depth is the number of smiley faces to draw inside the current smiley.
void makeSmileyFace(float x, float y, float size, int depth){
	fill(255, 255, 0);
	ellipse(x, y, size, size);
	noFill();
	arc(x, y, size*3/5, size*3/5, PI/8, 7*PI/8);
	if (depth > 0){
	depth--;
	makeSmileyFace(x-size/6.25, y-size/8.3, size/5, depth);
	makeSmileyFace(x+size/6.25, y-size/8.3, size/5, depth);
	} else {
		ellipse(x-size/6.25, y-size/8.3, size/5, size/5);
		ellipse(x+size/6.52, y-size/8.3, size/5, size/5);
	}
}

//Returns random light color (above 127, 127, 127).
color createRandomColor(){
	float r = random(127, 255);
	float g = random(127, 255);
	float b = random(127, 255);
	return color(r, g, b);
}

//Handles key presses.
void  keyPressed(){
	if (key == 'a'){
		randomColor = randomColor ? false : true;
	}
	if (key == 'w'){
		if (sizeIncrease < 10){
			sizeIncrease += 1;
		}
	}
	if (key == 's'){
		if (sizeIncrease > 0){
			sizeIncrease -= 1;
		}
	}
	if (key == 'e'){
		if (smileySize < 2000){
			smileySize += 60;
		}
	}
	if (key == 'd'){
		if (smileySize > 60){
			smileySize -= 60;
		}
	}
	if (key == 'r'){
		sizeIncrease = 1;
		smileySize = 60;
		randomColor = false;
	}
}
