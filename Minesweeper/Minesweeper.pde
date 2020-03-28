import de.bezier.guido.*;

public static final int CANVAS_WIDTH = 480;
public static final int CANVAS_HEIGHT = 480;

public int numBombs, numCols, numRows, labelTextSize;//variables based on difficulty
public int difficulty = 0; //0=easy, 1=intermediate, 2=expert
public int lastGameDifficulty, lastGameTotalTiles;
public float timer = 0;

public color defaultTileColor = color(100, 100, 100);

public boolean showControls = true;
public int gameState = 0; //0=no game, 1=in middle of game, 2=won game, 3=lost game

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

//to make sure the first click isn't a bomb
public boolean firstClick;

void setup(){
	size(CANVAS_WIDTH, CANVAS_HEIGHT);
	textAlign(CENTER,CENTER);
	//make the manager
	Interactive.make(this);	
	difficultyUpdate();
	frameRate(60);
}

public void newGame(){ //starts up a new game
	difficultyUpdate();
	//cleanup old buttons if they exist
	if (buttons != null && buttons.length > 0){
		for (int r = 0; r < buttons.length; r++){
			for (int c = 0; c < buttons[r].length; c++){
				buttons[r][c].setActive(false);
			}
		}
	}
	//declare and init new buttons
	buttons = new MSButton[numRows][numCols];
	for (int r = 0; r < buttons.length; r++){
		for (int c = 0; c < buttons[r].length; c++){
			buttons[r][c] = new MSButton(r, c);
		}
	}
	//setBombs() happens in the mousePressed() function of the first button clicked
	firstClick = true;
	gameState = 1;
	timer = 0;
	lastGameDifficulty = difficulty;
	lastGameTotalTiles = (numRows*numCols-numBombs);
}

public void difficultyUpdate(){
	if (difficulty == 0){
		numRows = 8;
		numCols = 8;
		numBombs = 10;
		labelTextSize = 20;
	} else if (difficulty == 1){
		numRows = 16;
		numCols = 16;
		numBombs = 40;
		labelTextSize = 15;
	} else if (difficulty == 2){
		numRows = 24;
		numCols = 24;
		numBombs = 99;
		labelTextSize = 10;
	}
}

public void setBombs(MSButton noBombHere){
	//prevent too many bombs
	if (numBombs >= numRows*numCols){
		numBombs = (numRows*numCols)-1;
	}
	while(bombs.size() < numBombs){
		int row = (int)(Math.random()*numRows);
		int col = (int)(Math.random()*numCols);
		if (!bombs.contains(buttons[row][col])){ //if no bomb here
			if (Math.abs(noBombHere.getRow()-row) > 1 || Math.abs(noBombHere.getCol()-col) > 1){ //and not next to starting
				bombs.add(buttons[row][col]); //add bomb
			}
		}
	}
}

public void draw(){
	background(150);
	fill(0);
	if (showControls && keyPressed && key == 'a'){
		textSize(36);
		text("About", CANVAS_WIDTH/2, CANVAS_HEIGHT/10);
		textSize(16);
		text("Welcome to Minesweeper, a remake of the classic Windows game. " +
				"The goal is to reveal all the non-bomb tiles. " +
				"Left click reveals a tile, and right click marks it. Center click a revealed number " +
				"when that tile has the required number of bombs marked to autoreveal nearby tiles." +
				"\n\nFeatures:\n" +
				"* 3 difficulty modes: Easy, Intermediate, and Expert\n" + 
				"* Timer and pause system\n" +
				"* 2 different markers for bombs and unknown tiles\n" +
				"* First click will never be a bomb\n" +
				"* Changeable tile colors in game"
			, 15, 30, CANVAS_WIDTH-30, CANVAS_HEIGHT);
	} else if (showControls){
		textSize(36);
		text("Minesweeper", CANVAS_WIDTH/2, CANVAS_HEIGHT/10);
		textSize(16);
		if (gameState == 1){
			text("Your game was paused.\nResume by pressing enter.", CANVAS_WIDTH/2, CANVAS_HEIGHT/4);
			text("Game Stats\nDifficulty: " + difficultyToString(difficulty) + 
				"\nTime elapsed: " + Math.round(100.0*timer/60)/100.0 +
				"\nEmpty tiles uncovered: " + countTilesWithStatus(3) + "/" + (numRows*numCols-numBombs)
				, CANVAS_WIDTH/2, CANVAS_HEIGHT/2);
		} else {
			if (gameState == 2){
				//won game
				text("Congratulations! You won!", CANVAS_WIDTH/2, CANVAS_HEIGHT/4);
				text("Game Stats\nDifficulty: " + difficultyToString(lastGameDifficulty) + 
					"\nTime elapsed: " + Math.round(100.0*timer/60)/100.0 +
					"\n\nNew Game\nDifficulty: " + difficultyToString(difficulty) + 
					"\nBoard size: " + numRows + "x" + numCols +
					"\nBomb count: " + numBombs
					, CANVAS_WIDTH/2, CANVAS_HEIGHT/1.7);
			} else if (gameState == 3){
				text("You lost. Try again?", CANVAS_WIDTH/2, CANVAS_HEIGHT/4);
				text("Game Stats\nDifficulty: " + difficultyToString(lastGameDifficulty) + 
					"\nTime elapsed: " + Math.round(100.0*timer/60)/100.0 +
					"\nEmpty tiles uncovered: " + countTilesWithStatus(3) + "/" + lastGameTotalTiles + 
					"\n\nNew Game\nDifficulty: " + difficultyToString(difficulty) + 
					"\nBoard size: " + numRows + "x" + numCols +
					"\nBomb count: " + numBombs
					, CANVAS_WIDTH/2, CANVAS_HEIGHT/1.7);
			} else if (gameState == 0){
				text("Welcome to Minesweeper!",
					CANVAS_WIDTH/2, CANVAS_HEIGHT/4);
				text("\nChange difficulty with spacebar.\nPress enter to begin.\nPress enter in game to pause." +
					"\n\n\nNew Game\nDifficulty: " + difficultyToString(difficulty) + 
					"\nBoard size: " + numRows + "x" + numCols +
					"\nBomb count: " + numBombs
					, CANVAS_WIDTH/2, CANVAS_HEIGHT/1.7);
			}
		}
	} else {
		if (gameState == 1 && bombs.size() > 0){timer++;}
		if(isWon()){
			winGame();
		}
	}
}

public int countTilesWithStatus(int x){
	int count = 0;
	for (int r = 0; r < buttons.length; r++){
		for (int c = 0; c < buttons[r].length; c++){
			if (buttons[r][c].getStatus() == x){
				count++;
			}
		}
	}
	return count;
}

public String difficultyToString(int d){
	if (d == 0){return "Easy";}
	else if (d == 1){return "Intermediate";}
	else if (d == 2){return "Expert";}
	else {return "ERROR: No difficulty found!";}
}

public void keyPressed(){
	if (key == ENTER){
		if (showControls && gameState != 1){
			//start a new game
			showControls = false;
			bombs.clear();
			newGame();
		} else if (showControls){
			//return to previous game
			showControls = false;
		} else if (!showControls && gameState != 1){
			//show controls
			showControls = true;
			bombs.clear();
		} else { //if (!showControls)
			showControls = true;
		}
	} else if (gameState != 1 && showControls && key == ' '){
		difficulty++;
		if (difficulty > 2){difficulty = 0;}
		difficultyUpdate();
	} else if (!showControls && gameState == 1 && key == ' '){
		defaultTileColor = color(
			(float)((Math.random()*170)+50), (float)((Math.random()*170)+50), (float)((Math.random()*170)+50)
		);
	}
}

public boolean isWon(){
	//checks if all non bomb tiles have been clicked (note: marking not required)
	//loop through every tile
	for (int r = 0; r < buttons.length; r++){
		for (int c = 0; c < buttons[r].length; c++){
			if (!bombs.contains(buttons[r][c])){ //looking at all non bomb tiles
				if (buttons[r][c].getStatus() != 3){ //if not revealed then you didn't win
					return false; //so we return false
				}
			}
		}
	}
	return true;
}

public void loseGame(){
	gameState = 3;
	for (int i = 0; i < bombs.size(); i++){
		bombs.get(i).setStatus(4);
	}
}

public void winGame(){
	gameState = 2;
	for (int i = 0; i < bombs.size(); i++){
		bombs.get(i).setStatus(5);
	}
}

public class MSButton {
	private boolean active;
	private int r, c;
	private float x, y, width, height;
	private int status; //0=unclicked, 1=marked, 2=question, 3=revealed, 4=bomb, 5=green
	private String label;
	
	public MSButton (int rr, int cc){
		width = CANVAS_WIDTH/numCols;
		height = CANVAS_HEIGHT/numRows;
		r = rr;
		c = cc; 
		x = c*width;
		y = r*height;
		label = "";
		status = 0;
		Interactive.add(this); // register it with the manager
		active = true;
	}

	//necessary getters and setters
	public int getRow(){return r;}
	public int getCol(){return c;}
	public int getStatus(){return status;}
	public void setStatus(int s){status = s;}
	public void setActive(boolean a){active = a;}
	public void setLabel(String newLabel){label = newLabel;}

	// called by manager
	public void mousePressed(){
		if (!active || gameState != 1 || showControls){return;} //cancel mouse if it is inactive, not in game, or showing controls
		if (firstClick){
			firstClick = false;
			setBombs(this);
		}
		if (mouseButton == LEFT && status == 0){
			//clicked an empty square. either it is a bomb or not
			if (bombs.contains(this)){
				status = 4;
				loseGame();
			} else if (countBombs() > 0){
				status = 3;
				setLabel("" + countBombs());
			} else {
				//it is a 0, so recursively click all valid unclicked neighboring buttons
				status = 3;
				leftClickNearbyTiles();
			}
		} else if (mouseButton == RIGHT){
			//marked a square
			if (status == 0){status = 1;} //mark an unclicked square
			else if (status == 1){status = 2;} //cycle to question mark
			else if (status == 2){status = 0;} //cycle back to unclicked
		} else if (mouseButton == CENTER){
			//wants to clear a revealed tile, and has marked already, then left click all tiles
			if (status == 3 && countMarkedTiles() == countBombs()){
				leftClickNearbyTiles();
			}
		}

	}

	//Left click nearby tiles, not including self
	public void leftClickNearbyTiles(){
		mouseButton = LEFT;
		for (int i = -1; i <= 1; i++){
			for (int j = -1; j <= 1; j++){
				if (isValid(r+i, c+j) && buttons[r+i][c+j].getStatus() == 0){
					if (!(i == 0 && j == 0)){ //don't click self
						buttons[r+i][c+j].mousePressed();
					}
				}
			}
		}
	}

	public void draw(){
		if (showControls){return;} //don't draw if showing controls
		if (status == 1){//marked
			fill(0);
		} else if (status == 4){//bomb
			fill(255,0,0);
		} else if (status == 3){//revealed
			fill(200);
		} else if (status == 2){//question mark
			fill(0, 0, 255);
		} else if (status == 5){//bomb after winning
			fill(0, 200, 0);
		} else { //default status == 0
			fill(defaultTileColor);
		}
		rect(x, y, width, height);
		fill(0);
		textSize(labelTextSize);
		text(label,x+width/2,y+height/2);
	}

	public boolean isValid(int row, int col){
		return ((row >= 0 && row < numRows) && (col >= 0 && col < numCols));
	}

	public int countBombs(){
		int numCountedBombs = 0;
		for (int i = -1; i <= 1; i++){
			for (int j = -1; j <= 1; j++){
				if (isValid(r+i, c+j) && bombs.contains(buttons[r+i][c+j])){
					numCountedBombs++;
				}
			}
		}
		if (bombs.contains(buttons[r][c])){numCountedBombs--;} //if it is a bomb, remove itself from numCountedBombs
		return numCountedBombs;
	}

	public int countMarkedTiles(){
		//precondition: this tile is not marked
		int numMarkedTiles = 0;
		for (int i = -1; i <= 1; i++){
			for (int j = -1; j <= 1; j++){
				if (isValid(r+i, c+j) && buttons[r+i][c+j].getStatus() == 1){
					numMarkedTiles++;
				}
			}
		}
		return numMarkedTiles;
	}
}
