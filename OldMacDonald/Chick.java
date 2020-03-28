class Chick implements Animal {
	private String myType;
	private String mySound, myAltSound;
	public Chick(String type, String sound1, String sound2){
		myType = type;
		mySound = sound1;
		myAltSound = sound2;
	}
	public Chick(String type, String sound){
		myType = type;
		mySound = sound;
		myAltSound = "unknown";
	}
	public Chick(){
		myType = "unknown";
		mySound = "unknown";
		myAltSound = "unknown";
	}
	public String getSound(){
		//if ((has alt sound) and (random decimal less than 0.5)) then
		if ((myAltSound != "unknown") && (Math.random() < 0.5)){
			return myAltSound;
		} else {
			return mySound;
		}
	}
	public String getType(){return myType;}
}