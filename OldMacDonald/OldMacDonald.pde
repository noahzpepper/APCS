void setup() {
	/* Old code
	Cow c = new Cow("cow","moo");
	Chick h = new Chick("chick","cluck");
	Pig p = new Pig("pig","oink");
	System.out.println(c.getType() + " goes " + c.getSound());
	System.out.println(h.getType() + " goes " + h.getSound());
	System.out.println(p.getType() + " goes " + p.getSound());
	*/
	//New code using farm class
	Farm farm = new Farm();
	farm.animalSounds();
}

