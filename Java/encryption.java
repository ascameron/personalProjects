/*
ascameron
a simple block cypher encryption
key: xFFF44FF00F444004
*/

import java.util.Scanner;

public class encryption {

	public static void main(String[] args) {
		Scanner keyboard = new Scanner(System.in);
		//ask user for input to encrypt
		  System.out.println("Enter message to encrypt: "); 
		  String message = keyboard.nextLine();
		// create an array of bytes from the input string
		  byte[] array = message.getBytes(); 
		// send the message(now in byte form) to the encryption method
		  String encryptedMessage = encrypt(array);
		// display the resulting encrypted message to console
		  System.out.println("Encrypted Text : " +  encryptedMessage);
		  
	}

	private static String encrypt(byte[] arr) {
		 byte[] key = {(byte)0xff,(byte)0xf4,(byte)0x4f,(byte)0xf0,(byte)0x0f,(byte)0x44,(byte)0x40,(byte)0x04};
		 System.out.println("key array length: " + key.length); 
		 int n = arr.length%8;
		  int index = arr.length/8;
		  System.out.println(index);
		  byte[] newArr = new byte[arr.length+(8-n)];
		  int ind = 0;

		  for(int i = 0;i<index;i++){
		   for(int j = 0;j<8;j++){
		    newArr[ind] = (byte)((int)(arr[ind])^(int)(key[j]));
		    ind++;
		   }
		  }
		  int ind1 = ind;
		  
// PAdd with zeroes
		  byte zero = 0x00;
		  for(int j = 0;j<(8-n);j++){
		   newArr[ind] = (byte)((int)(zero)^(int)(key[j]));
		   ind++;
		  }
		  for(int j = 0;j<n;j++){
		   newArr[ind] = (byte)((int)(arr[ind1])^(int)(key[j]));
		   System.out.print("");
		   ind++;
		   ind1++;
		  }

		  return new String(newArr);
	}

}
