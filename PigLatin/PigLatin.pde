import java.util.*;

//SOURCE is the name of the source file that the program will translate.
//Change this String to change what file is being translated.
//Important note: The referenced file must be in the source-texts folder.
public static final String SOURCE = "words.txt";


public static final String[] UPPERCASE = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
public static final String[] PUNCTUATION = {".",",","?",";",":","!","-","#","@","*","^","%","~","+","=","_","&","^","$"};
public static final String[] END_PUNCTUATION = {".",",","?",";",":","!" };
public static final String[] CLOSED_PUNCTUATION = {"[","]","(",")","\"","{","}","<",">"};
public static final String[] ALL_VOWELS = {"a","e","i","o","u","A","E","I","O","U"};
public static final String[] NUMBERS = {"1","2","3","4","5","6","7","8","9"};
public static final String LINE_BREAK = "--------------------------";

public void setup() {
	String lines[] = loadStrings("source-texts/" + SOURCE);
	//run setup information
	System.out.println();
	System.out.println("Translating " + SOURCE + " to Pig Latin (" + lines.length + " lines)");  
	System.out.println(LINE_BREAK);
	System.out.println();
	//For each line in lines[], separate into an array of words, punctuation, spaces
	for (int i = 0; i < lines.length; i++){
		String[] line = lines[i].split(" ");
		lines[i] = "";
		for (int j = 0; j < line.length; j++){
			lines[i] += pigLatin(line[j]);
			lines[i] += " ";
		}
	}
	//Print the array
	for (int i = 0; i < lines.length; i++){
			System.out.println(lines[i]);
	}
	//Final information
	System.out.println();
	System.out.println(LINE_BREAK);
	System.out.println();
	System.out.println("Translation completed.");
}

public void draw(){}

public int findFirstVowel(String sWord)
//precondition: sWord is a valid String of length greater than 0
//postcondition: returns the position of the first vowel in sWord.  If there are no vowels, returns -1
{
	for (int i = 0; i < sWord.length(); i++){
		String currentChar = sWord.substring(i, i+1);
		for (int j = 0; j < ALL_VOWELS.length; j++){
			if (currentChar.equals(ALL_VOWELS[j])){
	  			return i;
			}
		}
	}
	return -1;
}

public boolean isUpperCase(String sWord)
//precondition: sWord is a valid String of length greater than 0, containing no punctuation
//postcondition: returns if the string is entirely capital letters
{
	for (int i = 0; i < sWord.length(); i++){
		boolean characterCheck = false;
		for (int j = 0; j < UPPERCASE.length; j++){
			if (sWord.substring(i,i+1).equals(UPPERCASE[j])){
				characterCheck = true;
			}
		}
		if (!characterCheck){return false;}
	}
	return true;
}

public String getBeginPunctuation(String sWord)
//precondition: sWord is valid string of length greater than 0
//postcondition: return the begin punctuation of the string. if none, returns ""
{
	String beginPunctuation = "";
	for (int i = 0; i < CLOSED_PUNCTUATION.length; i++){
		if (sWord.substring(0, 1).equals(CLOSED_PUNCTUATION[i])){
			beginPunctuation = CLOSED_PUNCTUATION[i];
		}
	}
	return beginPunctuation;
}

public String[] getEndPunctuation(String sWord)
//precondition: sWord is a valid string of length greater than 0
//postcondition: returns the end punctuation of the string. if none, returns ""
{
	String closedPunctuationAtEnd = "";
	while(true){
		int index = -1;
		boolean needToBreak = true;
		for (int i = 0; i < CLOSED_PUNCTUATION.length; i++){
			//check for special punctuation at the very end
			if (sWord.substring(sWord.length()-1).equals(CLOSED_PUNCTUATION[i])){
				//stop looking back
				needToBreak = false;
				index = i;
			}
		}
		if (needToBreak) break;
		closedPunctuationAtEnd = CLOSED_PUNCTUATION[index] + closedPunctuationAtEnd;
		sWord = sWord.substring(0, sWord.length()-1);
	}
	String endPunctuation = "";
	for (int i = 0; i < END_PUNCTUATION.length; i++){
		if (sWord.substring(sWord.length()-1).equals(END_PUNCTUATION[i])){
			endPunctuation = END_PUNCTUATION[i];
		}
	}
	String[] finalReturn = {endPunctuation, closedPunctuationAtEnd};
	return finalReturn;
}

public boolean isNotWord(String sWord)
//precondition: sWord is a String
//postcondition: returns true if the first letter is punctuation
{
	//Loop through all possible punctuation
	for (int i = 0; i < PUNCTUATION.length; i++){
		if ((sWord.substring(0,1).equals(PUNCTUATION[i]))){
			//If the punctuation is equal to the first character, then it isn't a word
			return true;
		}
	}
	//Loop through all possible numbers
	for (int i = 0; i < NUMBERS.length; i++){
		if ((sWord.substring(0,1).equals(NUMBERS[i]))){
			//If the number is equal to the first character, then it isn't a word
			return true;
		}
	}
	//If the first character wasn't equal to any punctuation marks, it is a word
	return false;
}

public String pigLatin(String sWord)
//precondition: sWord is a String
//postcondition: returns the pig latin equivalent of sWord
{
	if (sWord.length() == 0){return sWord;} //the empty string case
	String s = new String(""); //to be returned
	if (isNotWord(sWord)){return sWord;} //the non-word case
	//If there's end punctuation, set it to endPunctuation and remove it from the string
	String[] endPunctuationInfo = getEndPunctuation(sWord);
	String beginPunctuationInfo = getBeginPunctuation(sWord);
	if (!endPunctuationInfo[1].equals("")){
		sWord = sWord.substring(0, sWord.length()-endPunctuationInfo[1].length());
	}
	if (!endPunctuationInfo[0].equals("")){
		sWord = sWord.substring(0, sWord.length()-1);
	}
	if (!beginPunctuationInfo.equals("")){
		sWord = sWord.substring(beginPunctuationInfo.length());
	}
	//Get if the first letter is capitalized
	boolean firstLetterCaps = isUpperCase(sWord.substring(0, 1));
	//If first letter is capital and rest of word is not, then set first letter to lowercase
	if (firstLetterCaps && !isUpperCase(sWord)){
		sWord = sWord.substring(0, 1).toLowerCase() + sWord.substring(1);
	}
	//At this point, sWord is fully lower/upper case with no end punctuation
	//Run the pig latin rules
	s = runPigLatinRules(sWord, !isUpperCase(sWord));
	//Resolve first letter capitalization
	if (firstLetterCaps){
		s = s.substring(0, 1).toUpperCase() + s.substring(1);
	}
	//Resolve ending punctuation
	s += endPunctuationInfo[0];
	s += endPunctuationInfo[1];
	//Resolve begin punctuation
	s = beginPunctuationInfo + s;
	//Return the final string
	return s;
}

//Returns word translated to pig latin
public String runPigLatinRules(String sWord, boolean isLowercase){
	String s = new String("");
	if(findFirstVowel(sWord) == -1){
		//Rule 1. If no vowels, then add 'ay'
		s = sWord + (isLowercase ? "ay" : "AY");
	} else if (findFirstVowel(sWord) == 0){
		//Rule 2. If first char is vowel, then add 'way'
		s = sWord + (isLowercase ? "way" : "WAY");
	} else if (sWord.charAt(0) == 'q' || sWord.charAt(0) == 'Q' && sWord.charAt(1) == 'u' || sWord.charAt(1) == 'U'){
		//Rule 3. If starts with qu, move it to end and add 'ay'
		s = sWord.substring(2, sWord.length()) + (sWord.charAt(0) == 'Q' ? "Q" : "q") + (sWord.charAt(1) == 'U' ? "U" : "u") + (isLowercase ? "ay" : "AY");
	} else {
		//Rule 4. If it starts with consonant, move all leading consonants to end and add 'ay'
		s = sWord.substring(findFirstVowel(sWord), sWord.length()) + sWord.substring(0, findFirstVowel(sWord)) + (isLowercase ? "ay" : "AY");
	}
	return s;
}