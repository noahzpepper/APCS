//This program searches through the constant e and returns whenever a 10 digit number is prime or adds to 49.
//For Part 1, the answer is 7427466391. (First number that returns as a prime.)
//For Part 2, the answer is 5966290435. (Fifth number that adds to 49.)

//Define e as a String constant
public final static String e = "2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178" +
"525166427427466391932003059921817413596629043572900334295260595630738132328627943490763233829880753195251019011573834187930" +
"7021540891499348841675092447614606680822648001684774118537423454424371075390777449920695517027618386062";

//Program runs here
public void setup(){
	noLoop();
	String firstPrimeDigits = "";
	//Loop through all the digits of e
	for (int i = 2; i < (e.length())-10; i++){
		String digits = e.substring(i, i+10); //Select a 10 digit string
		double dNum = Double.parseDouble(digits); //Turn it into a number
		//Test if the numbers add to 49 and return if true
		if (addsTo49(digits)){
			System.out.println("Adds to 49: " + digits);
		}
		//Test if the number is prime and return if true
		if (isPrime(dNum)){
			System.out.println("Prime: " + digits);
			if (firstPrimeDigits.equals("")){
				firstPrimeDigits = digits;
			}
		}
	}
	//Return done
	System.out.println("Search finished.");
	System.out.println("First prime found: " + firstPrimeDigits);
}

//Unused for this assignment
public void draw(){}

//Part 1: Takes a double and returns if it is prime
public boolean isPrime(double dNum){   
	if (dNum < 2){return false;} //Numbers less than two are not prime
	//Search for factors and return false if one is found
	for (int i = 2; i <= Math.sqrt(dNum); i++){
		if ((dNum % i) == 0){
			return false;
		}
	}
	//If no factors found, it is prime. Return true
	return true;
}

//Part 2: Takes a String and returns if the digits sum to 49
public boolean addsTo49(String sNum){
	double dTotal = 0;
	//Loop through string, turn each char to a number and add to dTotal
	for (int i = 0; i < sNum.length(); i++){
		String sTemp = sNum.substring(i, i+1);
		double dTemp = Double.parseDouble(sTemp);
		dTotal += dTemp;
	}
	//Return true if dTotal is 49
	return (dTotal == 49);
}