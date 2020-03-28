public static final int CANVAS_SIZE = 600;
public static final int MIN_SIZE = 2;
public static final int MAX_SIZE = 62;

public void setup(){
	size(CANVAS_SIZE, CANVAS_SIZE);
}

boolean running = true;
boolean colors = false;

float position = MIN_SIZE;
float velocity = 0.1;
float direction = 1;

public void draw(){
	background(127);
	fractal(300, 300, 500, color(0, 100, 0));
	if (running){
		position += velocity;
	}
	velocity = direction*(position/62);
	if (position >= MAX_SIZE){
		direction = -1;
	} else if (position <= MIN_SIZE){
		direction = 1;
	}
}

public void keyPressed(){
	if (key == 'w' && position < MAX_SIZE){
		position += (position/62);
		direction = 1;
	} else if (key == 's' && position > MIN_SIZE){
		position -= (position/62);
		direction = -1;
	} else if (key == ' '){
		running = !running;
		position = Math.round(position);
	} else if (key == 'c'){
		colors = !colors;
	}
}

public void fractal(float x, float y, float size, color hue){
	if (colors){
		fill(hue);
		noStroke();
	} else {
		noFill();
		stroke(0);
	}
	ellipse(x, y, size, size);
	float move = (float)(position)/(float)(8);
	float shrink = 0.5;
	if (size > 20) {
		hue += 40;
		fractal(x-move*size, y, shrink*size, hue);
		fractal(x+move*size, y, shrink*size, hue);
		fractal(x, y-move*size, shrink*size, hue);
		fractal(x, y+move*size, shrink*size, hue);
	}
}
