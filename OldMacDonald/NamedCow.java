class NamedCow extends Cow {
	private String myName;
	public NamedCow(String type, String sound, String name){
		myType = type;
		mySound = sound;
		myName = name;
	}
	public NamedCow(){
		myName = "unknown";
	}
	public String getName(){return myName;}
}