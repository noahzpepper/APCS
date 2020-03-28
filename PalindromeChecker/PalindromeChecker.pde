public void setup(){
	String lines[] = loadStrings("palindromes.txt");
	println("there are " + lines.length + " lines");
	for (int i = 0; i < lines.length; i++){
		if(palindrome(lines[i])){
			println(lines[i] + " IS a palidrome.");
		} else {
			println(lines[i] + " is NOT a palidrome.");
		}
	}
}

//Takes a word and returns it without punctuation or capitals, and all lowercase.
public String palindromeCleanUp(String sWord){
	String returnedString = new String("");
	//loop through all characters
	for (int i = 0; i < sWord.length(); i++){
		if (Character.isLetter(sWord.charAt(i))){
			returnedString += sWord.substring(i, i+1).toLowerCase();
		}
	}
	return returnedString;
}

//Returns if given word is a palindrome.
public boolean palindrome(String sWord)
{
	String forwards = palindromeCleanUp(sWord);
	String backwards = new String("");
	for (int i = forwards.length()-1; i >= 0; i--){
		backwards += forwards.substring(i, i+1);
	}
	return (forwards.equals(backwards));
}

