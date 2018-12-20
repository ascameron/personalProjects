/*
ascameron
A java version of the logic bomb created for
a school project, originally written in Python
*/

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

public class logicBomb {

	public static void main(String[] args) {
		 //date
		 SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyy");
	        Date date = new Date();
	        String time = sdf.format(date);
	        System.out.println(time);
        int dates = Integer.parseInt(time);
        //counter
        int count=0;
        //random number generator
        Random ran=new Random();
        int rannumb;
        do
        {
        count=count+1;
        
        //8 digit random number
        rannumb=10000000+ran.nextInt(90000000);
      //  System.out.println(rannumb);
        
        //printing 5 times
        if(rannumb==dates)
        {
            for(int k=0;k<5;k++)
            {
                System.out.println("Today is ["+dates+"]!");
                System.out.println("The count is : ["+count+"]");
                System.out.println();
            }
            break;
        }
      
        }while(true);

	}


	
	
	
}
