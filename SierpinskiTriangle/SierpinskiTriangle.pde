public static final int CANVAS_SIZE = 600;
public static final int SMALL_TRIANGLE_SIZE = 20;

//Control booleans
boolean left, right, up, down;
//All the possible toggles
boolean useEquilateral = true;
boolean showEquilateral = false;
boolean isChangingLocation = false;
boolean triangleBlack = true;
boolean visible = true;

//variables of the controllable triangle
float vert = 1;
float hor = CANVAS_SIZE;
float xPos = 0;
float yPos = CANVAS_SIZE;

public void setup(){
	size(CANVAS_SIZE, CANVAS_SIZE);
}

public void draw(){
	//do actions if key pressed
	keyAction();
	//set up colors depending on color scheme
	if (triangleBlack){
		background(215);
		fill(0);
	} else {
		background(0);
		fill(215);
	}
	//show the triangle
	if (visible){
		sierpinski(xPos, yPos, hor, vert);
	}
	//show the equilateral triangle
	if (showEquilateral){
		if (triangleBlack){
			fill(255, 0, 255, 80);
		} else {
			fill(0, 255, 0, 80);
		}
		sierpinski(0, CANVAS_SIZE, CANVAS_SIZE, sqrt(3)/2);
	}
}

public void keyAction(){
	if (!showEquilateral) {
		//if not showing equilateral, then allow wasd
		if (isChangingLocation){
			//movement controls
			if (up){
				yPos -= 2;
			}
			if (down){
				yPos += 2;
			}
			if (left){
				xPos -= 2;
			}
			if (right){
				xPos += 2;
			}
		} else {
			//growth controls
			if (up){
				vert += 0.005;
			}
			if (down){
				vert -= 0.005;
			}
			if (left){
				hor -= 2;
			}
			if (right){
				hor += 2;
			}
		}
	}
}

// deal with all key presses, including booleans for wasd and toggles for others
public void keyPressed(){
	if (key == 'w'){
		up = true;
	} else if (key == 's'){
		down = true;
	} else if (key == 'a'){
		left = true;
	} else if (key == 'd'){
		right = true;
	} else if (key == ' '){
		showEquilateral = !showEquilateral;
	} else if (key == 'q'){
		isChangingLocation = !isChangingLocation;
	} else if (key == 'h'){
		visible = !visible;
	}
}

//deal with key releases for wasd
public void keyReleased(){
	if (key == 'w'){
		up = false;
	} else if (key == 's'){
		down = false;
	} else if (key == 'a'){
		left = false;
	} else if (key == 'd'){
		right = false;
	}
}

//toggle color scheme when mouse pressed
public void mousePressed(){
	triangleBlack = !triangleBlack;
}

//Sierpinski Triangle recursive function.
public void sierpinski(float x, float y, float length, float tall) {
	//tall represents the multiplier times the height
	//tall = useEquilateral ? (sqrt(3)/2) : 1;
	if (length <= SMALL_TRIANGLE_SIZE){
		//base case
		//draws a triangle with the bottom corner at x, y
		noStroke();
		triangle(x, y, x+length, y, x+length/2, y-tall*length);

	} else {
		//recursive case
		//draw three new triangles at specified positions
		sierpinski(x, y, length/2, tall);
		sierpinski(x+length/2, y, length/2, tall);
		sierpinski(x+length/4, y-(tall*length)/2, length/2, tall);
	}
}
