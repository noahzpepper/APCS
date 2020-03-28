//Screen size
public static final int HOR_SIZE = 640;
public static final int VERT_SIZE = 480;

//Min and max constants for the tree customization variables
public static final float FRACTION_LENGTH_MAX = 0.8;
public static final float FRACTION_LENGTH_MIN = 0;
public static final float SMALLEST_BRANCH_MAX = 30;
public static final float SMALLEST_BRANCH_MIN = 6;
public static final float BRANCH_ANGLE_MAX = 3.2;
public static final float BRANCH_ANGLE_MIN = 0;

//Tree customization variables
private double fractionLength = 0.8;
private int smallestBranch = 10;
private double branchAngle = 0.2;
private color treeColor = color(0, 255, 0);
private boolean tilted = false;

//Text stuff
public static final String INTRO_TEXT = "(Try pressing r for a random tree!)";
private String logText = "";
private boolean showingIntro = true;

public void setup(){
	size(HOR_SIZE,VERT_SIZE);
	noLoop();
}

public void draw(){
	//Black background
	background(0);
	//Color the tree and line
	stroke(treeColor);
	//Draw the tree and line
	line(HOR_SIZE/2,VERT_SIZE,HOR_SIZE/2,380);
	drawBranches(HOR_SIZE/2, 380, 100, 3*Math.PI/2);
	//Color, align, and draw the text
	stroke(255);
	if (showingIntro){
		textAlign(LEFT);
		text(INTRO_TEXT, 5, VERT_SIZE-10);
	}
	textAlign(RIGHT);
	text(logText, HOR_SIZE-5, VERT_SIZE-10);
}

//Deal with key presses. QA, WS, ED change tree variables. Z changes color. X makes it funky. C resets. R is random.
public void keyPressed(){
	//Reset tilt and logText first
	tilted = false;
	logText = "";
	//Do action based on key
	if (key == 'w'){
		if (fractionLength < FRACTION_LENGTH_MAX){fractionLength += 0.01;}
	} else if (key == 's'){
		if (fractionLength > FRACTION_LENGTH_MIN){fractionLength -= 0.01;}
	} else if (key == 'q'){
		if (smallestBranch > SMALLEST_BRANCH_MIN){smallestBranch -= 1;}
	} else if (key == 'a'){
		if (smallestBranch < SMALLEST_BRANCH_MAX){smallestBranch += 1;}
	} else if (key == 'e'){
		if (branchAngle < BRANCH_ANGLE_MAX){branchAngle += 0.1;}
	} else if (key == 'd'){
		if (branchAngle > BRANCH_ANGLE_MIN){branchAngle -= 0.1;}
	} else if (key == 'z'){
		treeColor = color((float)(Math.random()*255),(float)(Math.random()*255),(float)(Math.random()*255));
		logText = "color change";
	} else if (key == 'x'){
		tilted = true;
		logText = "funky tree";
	} else if (key == 'c'){
		reset();
		logText = "reset";
	} else if (key == 'r'){
		randomTree();
		logText = "random";
		showingIntro = false;
	}
	//Refresh the screen
	redraw();
}

//Recursive function to draw the tree
public void drawBranches(int x,int y, double branchLength, double angle){
	//Determine left and right tilt
	float tiltLeft = tilted ? (float)(Math.random()-0.5) : 0;
	float tiltRight = tilted ? (float)(Math.random()-0.5) : 0;
	//Set angles for each line
	double angle1 = angle+branchAngle+tiltLeft;
	double angle2 = angle-branchAngle+tiltRight;
	branchLength *= fractionLength;
	//Calculate line endpoints
	int endX1 = (int)(branchLength*Math.cos(angle1) + x);
	int endY1 = (int)(branchLength*Math.sin(angle1) + y);
	int endX2 = (int)(branchLength*Math.cos(angle2) + x);
	int endY2 = (int)(branchLength*Math.sin(angle2) + y);
	//Draw the lines
	line(x, y, endX1, endY1);
	line(x, y, endX2, endY2);
	//Recursive part
	if (branchLength > smallestBranch){
		drawBranches(endX1, endY1, branchLength, angle1);
		drawBranches(endX2, endY2, branchLength, angle2);
	}
}

//Resets the tree variables to the original values
public void reset(){
	fractionLength = 0.8;
	smallestBranch = 10;
	branchAngle = 0.2;
	treeColor = color(0, 255, 0);
	tilted = false;
}

//Sets the tree variables to random (reasonable) values
public void randomTree(){
	fractionLength = (float)(Math.random()*0.2-0.1+0.7);
	smallestBranch = (int)(Math.random()*18+6);
	branchAngle = (float)(Math.random());
	treeColor = color((float)(Math.random()*255),(float)(Math.random()*255),(float)(Math.random()*255));
	tilted = (Math.random() > 0.5);
}
